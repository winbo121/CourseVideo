package egovframework.config.security.user;

import java.util.Collection;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.CredentialsContainer;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import egovframework.common.constrant.EnumCodes.ROLE_TYPE;
import egovframework.common.util.LocalThread;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;
import lombok.ToString;

/** SECURITY 사용자 상세 객체 **/
@Getter @Setter
@AllArgsConstructor( access = AccessLevel.PUBLIC )
@ToString
public class CustomUserDetails implements UserDetails, CredentialsContainer {

	private static final long serialVersionUID = 3876085799832115815L;

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
	/** 전학 여부 **/
	private String transfer_yn;
	/** 성별 **/
	private String gender;
	
	public boolean getIs_student() {
		return ROLE_TYPE.ROLE_STUDENT.eq( this.role_type );
	}
	public boolean getIs_teacher() {
		return ROLE_TYPE.ROLE_TEACHER.eq( this.role_type );
	}



	@NonNull //@Setter
	private Collection<? extends GrantedAuthority> authorities;

	private boolean accountNonExpired;
	private boolean accountNonLocked;
	private boolean credentialsNonExpired;
	private boolean enabled;

	/** yyyyMMddHHmmss 형식의 로그인 시간 **/
	private String login_time;



//	public static CustomUserDetailsBuilder builder( 	 String user_id
//																,String user_pw
//																,boolean enabled
//																,boolean accountNonExpired
//																,boolean credentialsNonExpired
//																,boolean accountNonLocked ) {
//		return new CustomUserDetailsBuilder()
//							.user_id( user_id )
//							.user_pw( user_pw )
//							.enabled( enabled )
//							.accountNonExpired( accountNonExpired )
//							.credentialsNonExpired( credentialsNonExpired )
//							.accountNonLocked( accountNonLocked )
//							.authorities( AuthorityUtils.NO_AUTHORITIES );
//	}


	@Override
	public void eraseCredentials() {
		this.user_pw = null;
	}

	@Override
	public String getUsername() {
		return this.user_id;
	}

	@Override
	public String getPassword() {
		return this.user_pw;
	}
	
	/** 현재 로그인 정보와 수정하려는 학교 정보가 변경되었는지 여부 [전학용] **/
	public boolean isNeedTransfer( String sch_cd ) {
		
		/** 교사의 경우 학교도 CHECK **/
		if( LocalThread.isStudent() ) {
			if( !StringUtils.equals( this.sch_cd, sch_cd ) ) {
				return true;
			}
		}
		
		return false;
	}
	

	/** 현재 로그인 정보와 수정하려는 학교 정보가 변경되었는지 여부 [학년.반 수정용] **/
	public boolean isNeedModify( String sch_cd, String sch_grade, String sch_class ) {
		
		/** 교사의 경우 학교도 CHECK **/
		if( LocalThread.isTeacher() ) {
			if( !StringUtils.equals( this.sch_cd, sch_cd ) ) {
				return true;
			}
		}
		if( !StringUtils.equals( this.sch_grade, sch_grade ) ) {
			return true;
		}
		if( !StringUtils.equals( this.sch_class, sch_class ) ) {
			return true;
		}
		return false;
	}


}
