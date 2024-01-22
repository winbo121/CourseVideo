package egovframework.work.main.model.signup;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;

import egovframework.common.base.BaseController.ALL;
import egovframework.common.constrant.EnumCodes.ROLE_TYPE;
import egovframework.common.valid.annotation.Password;
import egovframework.work.main.web.NoneMenuController.EMAIL_AUTHENTIFICATION;
import egovframework.work.main.web.NoneMenuController.SIGN_UP;
import egovframework.work.main.web.NoneMenuController.USER_SIGN_UP;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter @Setter @ToString
public class SignUp {

	/** 사용자 권한 구분 **/
	@NotEmpty( groups = { ALL.class } )
	@Pattern( groups = { ALL.class },regexp = "ROLE_ADMIN|ROLE_USER|")
	private String role_type;

	/** 이용약관 Y,N **/
	@NotEmpty( groups = { SIGN_UP.class } )
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|")
	private String terms_yn;

	/** 개인정보 수집 및 이용 동의 Y,N **/
	@NotEmpty
	@NotEmpty( groups = { SIGN_UP.class } )
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String consent_yn;


	/** 이메일 **/
	@NotEmpty( groups = { EMAIL_AUTHENTIFICATION.class } )
	private String email;

	/** 이메일 인증 여부 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	@Pattern( groups = {  USER_SIGN_UP.class },regexp = "Y|")
	private String is_certification_email;
	
	
	/** 아이디 중복체크 여부 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	@Pattern( groups = {  USER_SIGN_UP.class },regexp = "Y|")
	private String is_id_duplicate_check;
	
	
	/** 이메일 인증코드 확인 여부 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	@Pattern( groups = {  USER_SIGN_UP.class },regexp = "Y|")
	private String is_code_duplicate_check;
	
	
	/** 사용자 아이디 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	private String user_id;
	
	/** 이메일 인증코드 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	private String at_code;
	

	/** 사용자 명 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	private String user_name;

	/** 사용자 비밀번호 **/
	@NotEmpty( groups = {  USER_SIGN_UP.class } )
	@Password( groups = {  USER_SIGN_UP.class } )
	private String user_pw;
	private String user_pw_confirm;
	
	/** 사용자 휴대폰번호 **/
	@Pattern( regexp="^(?:01[0179][0-9]{7,8}|)$", groups = { USER_SIGN_UP.class }, message = "유효하지 않은 휴대폰번호입니다." )
	private String phone;
	
	/** 우편번호 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String zip_code;
	
	/** 시도 코드 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String sido_code;
	
	/** 시군구 코드 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String sigungu_code;


	/** 사용자 기본주소 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String user_addr;
	
	/** 사용자 상세주소 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String user_dtl_addr;
	

	
	/** 성별 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	@Pattern( regexp="1|2|", groups = { USER_SIGN_UP.class } )
	private String gender;
	
	/** 만 나이 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String age;
	
	/** 직업분류 **/
	@NotEmpty( groups = { USER_SIGN_UP.class } )
	private String job_code;
	
	
	///// 소셜 로그인 관련(시작) /////
	/** 카카오 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String kakao_connected = "N";
	private String kakao_id;
	private String kakao_conn_id;
	
	/** 네이버 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String naver_connected = "N";
	private String naver_id;
	private String naver_conn_id;
	
	/** 페이스북 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String facebook_connected = "N";
	private String facebook_id;
	private String facebook_conn_id;
	
	/** 트위터 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String twitter_connected = "N";
	private String twitter_id;
	private String twitter_conn_id;
	
	/** 인스타그램 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String instagram_connected = "N";
	private String instagram_id;
	private String instagram_conn_id;
	
	/** 구글 **/
	@Pattern( groups = { SIGN_UP.class },regexp = "Y|N|")
	private String google_connected = "N";
	private String google_id;
	private String google_conn_id;
	
	///// 소셜 로그인 관련(끝) /////

	public boolean getIsUser() {
		return ROLE_TYPE.ROLE_USER.eq( this.role_type );
	}
	
	public boolean getIsStudent() {
		return ROLE_TYPE.ROLE_STUDENT.eq( this.role_type );
	}
	public boolean getIsTeacher() {
		return ROLE_TYPE.ROLE_TEACHER.eq( this.role_type );
	}
	/* 개발환경 (local, dev, prod) */
	public String profile;
}
