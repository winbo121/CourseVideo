package egovframework.work.account.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.component.member.MemberComponent;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.component.member.model.TsUserInfo;
import egovframework.common.component.member.model.TsUserYear;
import egovframework.common.constrant.Constrants;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.constrant.EnumCodes.ROLE_TYPE;
import egovframework.common.constrant.EnumCodes.YN_CD;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.DurationUtils;
import egovframework.common.util.LocalThread;
import egovframework.work.account.model.ModifyAccount;
import egovframework.work.account.model.ProfileImage;


/** 계정, 로그인 사용자 정보 **/
@Service
public class AccountService extends BaseService {

	@Autowired
	private FileComponent fileComponent;

	@Autowired
	private MemberComponent memberComponent;



	/** 회원정보 상세 조회 **/
	public MemberDetail getDetail( String user_id ) {
		/** 사용자 상세 정보 **/
		MemberDetail detail = memberComponent.getMember( user_id )
										.orElseThrow( () -> new ErrorMessageException("com.none.data", "회원정보") );
		
		
		return detail;

	}

	/** 회원정보 수정 **/
	@Transactional
	public void modifyAccount( ModifyAccount input ) {
		
		/** TS_USER_INFO update **/
		String user_id = LocalThread.getLoginId();
		String sch_cd = 	input.getSch_cd();
		String sch_grade = input.getSch_grade();
		String sch_class = input.getSch_class();
		String user_name = input.getUser_name();
		String user_pw = input.getUser_pw();
		String gender = input.getGender();
		String email = input.getUser_email();
		String role_type = input.getRole_type();
		
		
		
		/** 이메일 중복 체크 **/
		boolean isAlreadyUserEmail = memberComponent.isAlreadyUserEmail( email );
		
		if( isAlreadyUserEmail ) {
			throw new ErrorMessageException("already.user.email");
		}
		
		
		if( StringUtils.isNotEmpty( user_pw ) ) {
			/** 비밀번호 변경 **/
			TsUserInfo ts_user_info = TsUserInfo.builder( user_id )
					.user_name( user_name )
					.user_pw( memberComponent.encodePassword( user_pw ) )
					.gender( gender )
					.user_email( email )
					.role_type( role_type )
					.build();
			memberComponent.modifyTsUserInfo( ts_user_info );
		}
		
		if( StringUtils.isEmpty( user_pw ) ) {
			/** 비밀번호 미변경 **/
			TsUserInfo ts_user_info = TsUserInfo.builder( user_id )
					.user_name( user_name )
					.gender( gender )
					.user_email( email )
					.role_type( role_type )
					.build();
			memberComponent.modifyTsUserInfo( ts_user_info );
		}
		
		/** TS_USER_YEAR update/insert **/
		
		String year_cd = "";
		
		Boolean is_new_grade = input.isCheck_new_grade();
		
		/** 새학년 생성일 경우 **/
		if( is_new_grade ) {
			/** 올해날짜( 3월 미만은 작년도 ) **/
			String month_cd = DurationUtils.getDateString( LocalDate.now() , Constrants.MM );
			Integer month = Integer.parseInt( month_cd );
			
			if( month < 3 ) {
				year_cd = DurationUtils.getDateString( LocalDate.now().minusYears(1) , Constrants.YYYY  );
			} else {
				year_cd = DurationUtils.getDateString( LocalDate.now() , Constrants.YYYY  );
			}
			
			/** 연도별 회원정보 등록 **/
			TsUserYear ts_user_year = TsUserYear.builder( year_cd, user_id, sch_cd )
					.sch_grade( sch_grade )
					.sch_class( sch_class )
					.transfer_yn( YN_CD.Y.code() )
					.build();
			
			memberComponent.addTsUserYear( ts_user_year );
			
		}
		
		/** 현재 계정 수정일 경우 **/
		if( ! is_new_grade ) {
			year_cd = LocalThread.getYearCd();
			
			
			/** 학교 전학 여부 **/
			boolean is_change_sch =	LocalThread.getLoginUser()
					.filter( login ->  login.isNeedTransfer( sch_cd ) )
					.map( login -> Boolean.TRUE )
					.orElseGet( () -> Boolean.FALSE );
			
			if( is_change_sch ) {
				
				/** 연도별 회원정보 등록 **/
				TsUserYear ts_user_year = TsUserYear.builder( year_cd, user_id, sch_cd )
						.sch_grade( sch_grade )
						.sch_class( sch_class )
						.transfer_yn( YN_CD.Y.code() )
						.build();
				
				/** 기존의 연도별 회원정보 transfer_yn 수정 **/
				memberComponent.modifyTsUserYear( ts_user_year );
				
				memberComponent.addTsUserYear( ts_user_year );
			}
			
			/** 학년/반 정보가 변경되었는지 여부 **/
			boolean is_change_grade_class =	LocalThread.getLoginUser()
					.filter( login ->  login.isNeedModify( sch_cd, sch_grade, sch_class ) )
					.map( login -> Boolean.TRUE )
					.orElseGet( () -> Boolean.FALSE );
			if( is_change_grade_class ) {
				
				/** 연도별 회원정보 수정 **/
				TsUserYear ts_user_year = TsUserYear.builder( year_cd, user_id, sch_cd )
						.sch_grade( sch_grade )
						.sch_class( sch_class )
						.transfer_yn( YN_CD.N.code() )
						.build();
				
				memberComponent.modifyTsUserYear( ts_user_year );
			}
		}
		
	}

	/** 회원 정보 삭제 **/
	@Transactional
	public void removeAccount(String user_id) {
		 
		/** 사용자 연도별 정보 삭제 **/
		memberComponent.removeTsUserYear( user_id );
		/** 사용자 정보 삭제  **/
		memberComponent.removeTsUserInfo( user_id) ;

		/** 프로필 이미지 삭제 **/
		fileComponent.removeFile( FILE_REG_GB.TS_USER_INFO  , user_id );
		
		/** 권한 **/
		String role_type = 
				LocalThread.isLogin() ? ROLE_TYPE.ROLE_USER.code() :
				LocalThread.isAdmin() ? ROLE_TYPE.ROLE_ADMIN.code() :
				LocalThread.isStudent() ? ROLE_TYPE.ROLE_STUDENT.code() :
			 				LocalThread.isTeacher() ? ROLE_TYPE.ROLE_TEACHER.code() : ""; 
		/** 회원 탈퇴 이력 추가 **/
		memberComponent.addWithdrawalHistoryLog( user_id, role_type );
	}
	
	
	
	/** 학급관리 -> 학생정보 등록삭제  **/
	@Transactional
	public void removeAccounts(List<String> list) {
		 
		/** 사용자 연도별 정보 삭제 **/
		memberComponent.removeTsUserYears( list );
		/** 사용자 정보 삭제  **/
		memberComponent.removeTsUserInfos( list) ;

		/** 프로필 이미지 삭제 **/
		fileComponent.removeFiless( FILE_REG_GB.TS_USER_INFO  , list );

			
	}



	/** 회원 프로필 이미지 삭제 **/
	@Transactional
	public void removeProfile( ProfileImage input ) {
		String user_id = input.getUser_id();
		fileComponent.removeFile( FILE_REG_GB.TS_USER_INFO , user_id );
	}

	/** 회원 프로필 이미지 변경 **/
	@Transactional
	public FileData modifyProfile( ProfileImage input ) {
		String user_id = input.getUser_id();
		MultipartFile profile_image = input.getProfile_image();

		/** 기존파일 전체 삭제 **/
		fileComponent.removeFile( FILE_REG_GB.TS_USER_INFO , user_id );
		/** 신규 파일 추가 **/
		fileComponent.addFiles( FILE_REG_GB.TS_USER_INFO, user_id, Arrays.asList( profile_image ) );

		/** 신규 파일 상세 조회 **/
		return fileComponent.getFirstFile( FILE_REG_GB.TS_USER_INFO, user_id );
	}
	
	
	/** 회원 비밀번호 초기화 **/
	@Transactional
	public void password_reset( String user_id ) {
		
		/** 아이디와 동일한 비밀번호로 암호화 **/
		String encode_password = memberComponent.encodePassword( user_id );
		
		TsUserInfo input = TsUserInfo.builder(user_id)
											.user_pw(encode_password)
											.build();
		
		/** 회원 정보 수정 **/
		memberComponent.modifyTsUserInfo( input );
		
	}
	
	
	/** 회원 재로그인 **/
	public boolean reLogin( String user_pw ) {
		
		String encode_pw = memberComponent.encodePassword( user_pw );
		return memberComponent.reLogin( encode_pw );
		
	}
	
	/**낱말 게임 사이트이동 체크**/
	public int goWordGameSiteCheck (){
		
		return memberComponent.goWordGameSiteCheck();
	}
	
	
	/** 낱말게임 외부 API **/
	public MemberDetail wordGameApi (MemberDetail member){
		return memberComponent.wordGameApi(member);
	}











}
