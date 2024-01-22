package egovframework.config.security.secured.model;

import java.time.LocalDateTime;

import org.springframework.security.core.authority.AuthorityUtils;

import egovframework.common.constrant.Constrants;
import egovframework.common.util.DurationUtils;
import egovframework.config.security.user.CustomUserDetails;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

/** DB 사용자 데이터  **/
@Getter @Setter
public class SecurityUser {

	/** 사용자 ID **/
	@NonNull
	private String user_id;
	/** 성명 **/
	private String user_name;
	/** 권한 **/
	private String role_type;

	/** 비밀번호 **/
	@NonNull
	private String user_pw;
	/** 회원 상태 여부 **/
	private String user_state_cd;

	/** 뱃지 등급 **/
	private String badge_grade;
	/** 리워드 포인트 **/
	private String reward_point;

	/** 사용자 이메일 **/
	private String user_email;

	/** 프로필이미지 **/
	private String user_profile;

	/** 연도 **/
	private String year_cd;
	/** 학교코드 **/
	private String sch_cd;
	/** 학년 **/
	private String sch_grade;
	/** 반 **/
	private String sch_class;
	/** 학교명 **/
	private String sch_name;
	/** 전학 상태 **/
	private String transfer_yn;
	/** 성별 **/
	private String gender;

	private boolean enabled;

	/** SPRING SECURITY USER DETAILS 객체 생성 **/
	public CustomUserDetails makeUserDetails() {
		return new CustomUserDetails(
						 this.user_id
						,this.user_name
						,this.role_type
						,this.user_pw
						,this.user_state_cd
						,this.badge_grade
						,this.reward_point
						,this.user_email
						,this.user_profile
						,this.year_cd
						,this.sch_cd
						,this.sch_grade
						,this.sch_class
						,this.sch_name
						,this.transfer_yn
						,this.gender
						,AuthorityUtils.NO_AUTHORITIES
						,true
						,true
						,true
						,this.enabled
						,DurationUtils.getTimeString( LocalDateTime.now(), Constrants.YYYYMMDDHHMMSS ) );

		/**
		return CustomUserDetails.builder( this.user_id, this.user_pw, enabled, true, true, true)
										.user_name( this.user_name )
										.role_type( this.role_type )
										.user_state_cd( this.user_state_cd )
										.badge_grade( this.badge_grade )
										.user_email( this.user_email )
										.user_profile( this.user_profile )
										.year_cd( this.year_cd )
										.sch_cd( this.sch_cd )
										.sch_grade( this.sch_grade )
										.sch_class( this.sch_class )
										.sch_name( this.sch_name )
										.build();
			**/

	}

}