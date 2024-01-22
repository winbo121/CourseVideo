package egovframework.common.util;

import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import java.util.stream.Stream;


import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;

import com.google.common.base.Predicates;


import egovframework.common.constrant.Constrants;
import egovframework.common.constrant.EnumCodes.ROLE_TYPE;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.config.security.user.CustomUserDetails;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class LocalThread {

	private static final Supplier< Optional<Authentication> > GET_AUTHENTICATION = () -> {
		return Optional.ofNullable( SecurityContextHolder.getContext() )
					.map( SecurityContext::getAuthentication );
    };

	private static boolean hasRole( ROLE_TYPE target_role ) {
		String role = target_role.code();
		Stream< ? extends GrantedAuthority>
			authorities = GET_AUTHENTICATION.get()
														.map( Authentication::getAuthorities )
														.map( StreamUtils::toStream )
														.orElseGet( () -> Stream.empty() );

		return authorities.map( GrantedAuthority::getAuthority )
							.filter( Predicates.equalTo( role) )
							.findFirst()
							.isPresent();
    }


	/** 로그인 사용자의 학년을 조회한다.**/
	public static int getSchGrade() {
		return getLoginUser()
			.map( CustomUserDetails::getSch_grade )
			.filter( StringUtils::isNumeric )
			.map( Integer::valueOf )
			.orElseThrow( () -> new ErrorMessageException( "login.schgrade.fail" ) );
	}


	/** 로그인 사용자 정보 **/
	public static Optional<CustomUserDetails> getLoginUser() {
		return GET_AUTHENTICATION.get()
					.map( Authentication::getPrincipal )
					.filter( principal -> principal instanceof CustomUserDetails )
					.map( principal -> (CustomUserDetails) principal );
	}

	/** 로그인 사용자 아이디 조회 **/
	public static String getLoginId() {
		return getLoginUser()
					.map( CustomUserDetails::getUser_id )
					.orElseThrow( () -> new AuthenticationCredentialsNotFoundException("[LocalThread.getLoginId]") );
	}

	/** 년도 코드 조회 **/
	public static String getYearCd() {
		return getLoginUser()
				.map( CustomUserDetails::getYear_cd )
				.orElseThrow( () -> new AuthenticationCredentialsNotFoundException("[LocalThread.getYear_cd]") );
	}
	
	
	/** 회원 이메일 조회 **/
	public static String getUserEmail() {
		return getLoginUser()
				.map( CustomUserDetails::getUser_email )
				.orElse( "" );
	}
	
	
	/** 학생 전학 여부 **/
	public static String getTransferYn() {
		return getLoginUser()
				.map( CustomUserDetails::getTransfer_yn )
				.orElse( "N" );
	}
	
	
	/** 로그인 사용자 학교 코드 **/
	public static String getSchCd() {
		return getLoginUser()
				.map( CustomUserDetails::getSch_cd )
				.orElse( "" );
	}
	
	/** 로그인 사용자 반 코드 **/
	public static String getSchClass() {
		return getLoginUser()
				.map( CustomUserDetails::getSch_class )
				.orElse( "" );
	}
	

	
	

	/** 로그인 여부  **/
	public static boolean isLogin() {
		return hasRole( ROLE_TYPE.ROLE_USER );
	}
	/** 로그인 여부  **/
	public static boolean isAdmin() {
		return hasRole( ROLE_TYPE.ROLE_ADMIN );
	}
	
	/** 학생 여부 **/
	public static boolean isStudent() {
		return hasRole( ROLE_TYPE.ROLE_STUDENT );
	}
	/** 선생님 여부 **/
	public static boolean isTeacher() {
		return hasRole( ROLE_TYPE.ROLE_TEACHER );
	}
	/** 비담임 선생님 여부 **/
	public static boolean isInstructor() {
		return hasRole( ROLE_TYPE.ROLE_INSTRUCTOR );
	}


	/** 현재사용자의 전체 권한 리스트를 조회한다. **/
	public static List<String> getRoles(){
		Optional<Authentication> optional = GET_AUTHENTICATION.get();
		if( !optional.isPresent() ) {
			return Collections.emptyList();
		}
		Authentication authentication = optional.get();
		return StreamUtils.toStream( authentication.getAuthorities() )
						.map( GrantedAuthority::getAuthority )
						.filter( role -> StringUtils.startsWith(role, "ROLE_") )
						.collect( Collectors.toList() );
	}

	/** GET REMOTE ADDR  **/
	public static String getRemoteAddr() {
		return Optional.ofNullable( CommonUtils.getRequest() )
							.map( CommonUtils::getClientIp )
							.orElse( null );
	}



}
