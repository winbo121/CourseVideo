package egovframework.common.component.member.model;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;

import egovframework.work.main.web.NoneMenuController.USER_SIGN_UP;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;

@Builder
@AllArgsConstructor( access = AccessLevel.PRIVATE )
@Getter
public class TsUserInfo {

	/** 사용자 아이디 **/
	@NonNull
	private String user_id;

	/** 사용자 명 **/
	private String user_name;

	/** 사용자 권한 구분 **/
	private String role_type;

	/** 사용자 비밀번호 **/
	private String user_pw;

	/** 사용자 이메일 주소 **/
	private String user_email;

	/** 뱃지 등급 **/
	private String badge_grade;
	
	/** 성별 **/
	private String gender;
	
	
	/** 만 나이 **/
	private String age;
	
	/** 직업분류 **/
	private String job_code;
	
	/** 사용자 휴대폰번호 **/
	private String phone;
	
	/** 우편번호 **/
	private String zip_code;
	
	/** 시도 코드 **/
	private String sido_code;
	
	/** 시군구 코드 **/
	private String sigungu_code;


	/** 사용자 기본주소 **/
	private String user_addr;
	
	/** 사용자 상세주소 **/
	private String user_dtl_addr;
	
	public static TsUserInfoBuilder builder( String user_id  ) {
			return new TsUserInfoBuilder()
							.user_id(user_id);
	}

}
