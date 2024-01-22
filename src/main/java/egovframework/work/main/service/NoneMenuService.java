package egovframework.work.main.service;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.base.BaseService;
import egovframework.common.component.member.MemberComponent;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.component.member.model.TsUserInfo;
import egovframework.common.constrant.Constrants;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.DurationUtils;
import egovframework.common.util.StreamUtils;
import egovframework.work.main.model.signup.FindIdPassword;
import egovframework.work.main.model.signup.SignUp;
import egovframework.work.oauth.service.OAuthService;
import egovframework.work.statistics.service.KotechStaticsService;

@Service
public class NoneMenuService extends BaseService {


	@Autowired
	private MemberComponent memberComponent;
	
	@Autowired
	private OAuthService oAuthService;
	
	@Autowired
	protected KotechStaticsService KotechStaticsService;

	/** 회원 가입 **/
	@Transactional
	public void signup( SignUp signup ) {

		String user_id = signup.getUser_id();
		String chk_id = signup.getUser_id();
		String user_pw = signup.getUser_pw();
		String user_name = signup.getUser_name();
		String role_type = signup.getRole_type();
		String user_email = signup.getEmail();
		String gender = signup.getGender();
		String at_code = signup.getAt_code();
		
		String year_cd = "";

		/** 올해날짜( 3월 미만은 작년도 ) **/
		String month_cd = DurationUtils.getDateString( LocalDate.now() , Constrants.MM );
		Integer month = Integer.parseInt( month_cd );

		if( month < 3 ) {
			year_cd = DurationUtils.getDateString( LocalDate.now().minusYears(1) , Constrants.YYYY  );
		} else {
			year_cd = DurationUtils.getDateString( LocalDate.now() , Constrants.YYYY  );
		}

		
		/** 사용자 아이디 유무 확인 **/
		boolean is_already_id = this.idDuplicateCheck( user_id, chk_id  );
		if( BooleanUtils.isTrue( is_already_id ) ) {
			/** 이미 존재하는 사용자 아이디 입니다. **/
//			is_already_id = memberComponent.isAlreadyId(user_id);
			throw new ErrorMessageException("already.user.id");

		}
		
		boolean is_already_id_stu = this.idDuplicateCheckStu( user_id );
		if( BooleanUtils.isTrue( is_already_id_stu ) ) {
			/** 이미 존재하는 사용자 아이디 입니다. **/
//			is_already_id = memberComponent.isAlreadyId(user_id);
			throw new ErrorMessageException("already.user.id");
			
		}
		
		/** 사용자 이메일 유무 확인 **/
		boolean is_already_email = memberComponent.isAlreadyUserEmail( user_email );
		if( BooleanUtils.isTrue( is_already_email ) ) {
			/** 이미 존재하는 사용자 이메일 입니다. **/
			throw new ErrorMessageException("already.user.email");

		}
		
		
		
		/** 회원정보 등록 **/
		TsUserInfo ts_user_info = TsUserInfo.builder( user_id )
													 .user_name( user_name )
													 .role_type( role_type )
													 .badge_grade( "1" ) /** 뱃지등급 초기값 1 **/
													 .user_pw( memberComponent.encodePassword( user_pw ) )
													 .user_email( user_email )
													 .gender( gender )
													 .zip_code(signup.getZip_code())
													 .user_addr(signup.getUser_addr())
													 .user_dtl_addr(signup.getUser_dtl_addr())
													 .sigungu_code(signup.getSigungu_code())
													 .sido_code(signup.getSido_code())
													 .age(signup.getAge())
													 .job_code(signup.getJob_code())
													 .phone(signup.getPhone())
													 .build();
		memberComponent.addTsUserInfo( ts_user_info );
		
		
		/** 소셜 연동 정보 등록 **/
		// 소셜로그인 처리
		if(signup.getKakao_connected().equalsIgnoreCase("Y")) {
			// 카카오
			oAuthService.insertSocialUser(user_id, "kakao", signup.getKakao_id(),signup.getKakao_conn_id());
		} 
		if(signup.getNaver_connected().equalsIgnoreCase("Y")) {
			// 네이버
			oAuthService.insertSocialUser(user_id, "naver", signup.getNaver_id(),signup.getNaver_conn_id());
		} 
		if(signup.getFacebook_connected().equalsIgnoreCase("Y")) {
			// 페이스북
			oAuthService.insertSocialUser(user_id, "facebook", signup.getFacebook_id(),signup.getFacebook_conn_id());
		} 
		if(signup.getTwitter_connected().equalsIgnoreCase("Y")) {
			// 트위터
			//oAuthService.insertSocialUser(user_id, "twitter", signup.getTwitter_id(),signup.getTwitter_conn_id());
		} 
		if(signup.getInstagram_connected().equalsIgnoreCase("Y")) {
			// 인스타그램
			oAuthService.insertSocialUser(user_id, "instagram", signup.getInstagram_id(),signup.getInstagram_conn_id());
		} 
		if(signup.getGoogle_connected().equalsIgnoreCase("Y")) {
			// 구글
			oAuthService.insertSocialUser(user_id, "google", signup.getGoogle_id(),signup.getGoogle_conn_id());
		} 


	}
	
	
	/** 이메일 중복 체크 **/
	public Boolean emailDuplicateCheck( String email ) {
		return memberComponent.isAlreadyUserEmail( email );
	}
	
	
	
	public String updateEmailTempCode(HashMap<String, Object> map) {
		String result_message= "";
		
		try {
		memberComponent.addTempEmailCode( map );
		result_message= "SUCCESS";
		}catch(Exception e) {
			result_message= "FAIL";	
		}
		
		return result_message;
	}
	
	
	
	/** 아이디 중복 체크 **/
	public Boolean idDuplicateCheck( String user_id, String chk_id ) {
		return memberComponent.isAlreadyUserId( user_id, chk_id );
	}
	
	/** 이메일 인증코드 확인 **/
	
	public Boolean codeDuplicateCheck( String email, String at_code ) {
		return memberComponent.isCodeYn( email, at_code );
	}

	
	
	/** 회원 아이디 찾기 **/
	public String findUserId( String email ) {
		String user_id = memberComponent.findUserId( email );
		
		if( StringUtils.isBlank( user_id ) ) {
			throw new ErrorMessageException("com.none.data", "아이디");
		}
		
		return user_id;
	}
	
	
	/** 회원 비밀번호 재설정 **/
	@Transactional
	public String resetPassWord( FindIdPassword findIdPassword ) {
		
		/** USER_ID, EMAIL 로 유저정보 조회 **/
		MemberDetail memberDetail = memberComponent.getMember( findIdPassword.getUser_id() )
													.orElseThrow( () -> new ErrorMessageException("com.none.data", "아이디") );
		
		
		/** 유저 이메일 정보가 다른 경우 **/
		if( ! StringUtils.equals( memberDetail.getUser_email() , findIdPassword.getEmail() ) ) {
			throw new ErrorMessageException("com.not.match.email");
		}

		/** 임시비밀번호 생성 **/
		String new_user_password = this.createTempPassword();
		
		/** 임시비밀번호로 업데이트 **/
		TsUserInfo ts_user_info = TsUserInfo.builder( findIdPassword.getUser_id() )
											 .user_pw( memberComponent.encodePassword( new_user_password ) )
											 .build();
		
		memberComponent.modifyTsUserInfo( ts_user_info );

		
		/** 임시비밀번호 리턴 **/
		return new_user_password;
	}
	
	
	private static final List<String> strs = Arrays.asList("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q",
	        "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q",
	        "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "@", "#", "$", "%", "^", "&", "*");

	/** 임시비밀번호 생성 **/
	private String createTempPassword() {
		String new_password = "";
		
		for( Integer i = new_password.length(); i < 6; i ++  ) {
			new_password += strs.stream()
								.collect( StreamUtils.toRandom() )
								.orElseGet( () -> "" );
		}
		
		return new_password;
	}


	public Boolean idDuplicateCheckStu(String user_id) {
		return memberComponent.isAlreadyUserIdStu( user_id );
	}
	
	
	/** 시도 코드 **/
	public List<Map<String, Object>> getSidoCode() {
		return memberComponent.getSidoCode();
	}
	
	/** 직업 분류 코드 **/
	public List<Map<String, Object>> getJobCode(){
		return memberComponent.getJobCode();
	} 
	
	/** 총 강좌 수, 총 회원 수, 총 리뷰 수 **/
	public Map<String, Object> getTotalStatistic() {
		return KotechStaticsService.getTotalStatistic();
	}
	
}
