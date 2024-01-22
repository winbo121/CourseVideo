package egovframework.work.account.controller;


import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.ObjectUtils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.google.common.collect.Maps;

import egovframework.common.base.BaseController;
import egovframework.common.component.file.model.FileData;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.constrant.Constrants;
import egovframework.common.util.LocalThread;
import egovframework.config.security.functions.SecurityFunctions;
import egovframework.work.account.model.ModifyAccount;
import egovframework.work.account.model.ProfileImage;
import egovframework.work.account.service.AccountService;


/** 계정, 로그인 사용자 정보
  	/account/**
**/
@Controller
public class AccountController extends BaseController {

	@Autowired
	protected AccountService accountService;
	


	/**  로그인한 사용자 정보 인덱스 페이지 **/
	@RequestMapping( value= "/account/index.do" , method=RequestMethod.GET )
	public String index( ModelMap  model  ) {

		String user_id = LocalThread.getLoginId();
		MemberDetail detail = accountService.getDetail( user_id );
		model.addAttribute("detail", detail);


		if( LocalThread.isStudent() ) {
			return "account/account_index_student";
		}

		return "account/account_index_teacher";
	}

	/**  로그인한 사용자 정보 수정 페이지 **/
	@RequestMapping( value= "/account/detail.do" , method=RequestMethod.GET )
	public String detail( HttpSession session
							, HttpServletResponse response
							, ModelMap  model  ) {
		
		Object isLoginAuthentification = session.getAttribute( Constrants.RE_LOGIN_AUTHENTIFICATION_KEY );
		
		if( ObjectUtils.isEmpty( isLoginAuthentification ) ) {
			try {
				/** 인증되지 않은 상태로 접근 했으므로 403 으로 처리한다.  **/
				response.sendError( HttpServletResponse.SC_FORBIDDEN );
			} catch( Exception e ) {}
		}

		String user_id = LocalThread.getLoginId();
		MemberDetail detail = accountService.getDetail( user_id );
		model.addAttribute("detail", detail);

		return "account/account_modify";
	}

	
	public interface PUT_ROLE_STUDENT extends PUT {}
	public interface PUT_ROLE_TEACHER extends PUT {}
	public interface PUT_ROLE_INSTRUCTOR extends PUT {}
	public interface POST_ROLE_STUDENT extends POST {}
	public interface POST_ROLE_TEACHER extends POST {}
	public interface POST_ROLE_INSTRUCTOR extends POST {}
	public interface NEW_GRADE extends ALL{}
	/** 로그인한 사용자 정보 변경하기  **/
	@RequestMapping( value= "/account/detail.do" , method=RequestMethod.PUT )
	@ResponseBody
	public Map<String, Object> modify_detail( HttpServletRequest request, HttpServletResponse response,
															@ModelAttribute ModifyAccount input ) {
		
		Boolean isStudent = LocalThread.isStudent();
		
		/** 교사 **/
		if( ! isStudent ) {
			if(!input.isCheck_role()) {
				if( input.isCheck() ) {
					/** 비밀번호 수정시 유효성 체크 **/
					super.doValidted( input, PUT_ROLE_TEACHER.class );
				}else {
					/** 비밀번호 비 수정시 유효성 체크 **/
					super.doValidted( input, POST_ROLE_TEACHER.class );
				}
				input.setRole_type("ROLE_TEACHER");
			} else {
				if( input.isCheck() ) {
					/** 비밀번호 수정시 유효성 체크 **/
					super.doValidted( input, PUT_ROLE_INSTRUCTOR.class );
				}else {
					/** 비밀번호 비 수정시 유효성 체크 **/
					super.doValidted( input, POST_ROLE_INSTRUCTOR.class );
				}
				input.setRole_type("ROLE_INSTRUCTOR");
			}
		}
		/** 학생 **/
		if( isStudent ) {
			if( input.isCheck() ) {
				/** 비밀번호 수정시 유효성 체크 **/
				super.doValidted( input, PUT_ROLE_STUDENT.class );
			}else {
				/** 비밀번호 비 수정시 유효성 체크 **/
				super.doValidted( input, POST_ROLE_STUDENT.class );
			}
			
			if( input.isCheck_new_grade() ) {
				/** 새학년정보 생성시 유효성 체크 **/
				super.doValidted( input, NEW_GRADE.class );
			
			}else {
				/** 기존 학년 파라미터 세팅 **/
				input.setSch_grade( String.valueOf(LocalThread.getSchGrade()) );
			}
		}

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		accountService.modifyAccount( input );

		/** 강제 로그아웃 처리 **/
		SecurityFunctions.FORCED_LOGOUT.accept( request, response );
		return result;
	}

	/** 로그인한 사용자 탈퇴 **/
	@ResponseBody
	@RequestMapping( value= "/account/detail.do" , method=RequestMethod.DELETE )
	public Map<String, Object> remove_detail( HttpServletRequest request, HttpServletResponse response ){
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		accountService.removeAccount( LocalThread.getLoginId() );

		/** 강제 로그아웃 처리 **/
		SecurityFunctions.FORCED_LOGOUT.accept( request, response );

		return result;
	}






	@RequestMapping( value= "/account/profile.do" , method=RequestMethod.DELETE )
	@ResponseBody
	public Map<String, Object> remove_profile( @ModelAttribute ProfileImage input ){
		/** 유효성 체크 **/
		input.setUser_id( LocalThread.getLoginId() );
		super.doValidted( input, DELETE.class );

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		accountService.removeProfile( input );

		return result;
	}


	@ResponseBody
	@RequestMapping( value= "/account/profile.do" , method=RequestMethod.PUT )
	public Map<String, Object> modify_profile( @ModelAttribute ProfileImage input ){
		/** 유효성 체크 **/
		input.setUser_id( LocalThread.getLoginId() );
		super.doValidted( input, PUT.class );

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		FileData file_data = accountService.modifyProfile(input);
		String img_url = file_data.getImg_url();

		result.put("img_url", img_url);

		return result;
	}
	
	
	/** 정보 수정 전 재 로그인 인증 **/
	@ResponseBody
	@RequestMapping( value= "/account/relogin.do" , method=RequestMethod.POST )
	public Map<String, Object> modify_profile( HttpSession session
											,@RequestParam( "user_pw" ) String user_pw ){

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		boolean isSuccess = accountService.reLogin( user_pw );
		result.put( "result", isSuccess );
		
		/** 세션에 재로그인 성공 정보를 넣는다. **/
		session.setAttribute( Constrants.RE_LOGIN_AUTHENTIFICATION_KEY, true );
		
		return result;
	}


	/** 정보 수정 전 재 로그인 인증 **/
	@ResponseBody
	@RequestMapping( value= "/account/goWordGameSiteCheck.do" , method=RequestMethod.POST )
	public Map<String, Object> goWordGameSiteCheck( HttpSession session
										 ){

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		
		String schCd = LocalThread.getSchCd();
		
		int cnt = accountService.goWordGameSiteCheck( );
		if(cnt > 0) {
			result.put( "result", "pass" );
		} else if(schCd.equals("9999999999")) {
			result.put( "result", "pass" );		//20220921 - 평가원(9999999999) 낱말퀴즈 풀지 않아도 낱말게임을 할수 있도록
		}
		else {
			result.put( "result", "fail" );
		}

		
		return result;
	}

	




}
