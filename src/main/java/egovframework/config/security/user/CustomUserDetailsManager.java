package egovframework.config.security.user;

import java.util.Collection;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.context.ApplicationContextException;
import org.springframework.security.access.hierarchicalroles.RoleHierarchy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

import egovframework.common.util.StreamUtils;
import egovframework.config.security.secured.SecuredService;


/** 인증 확인 객체 **/
public class CustomUserDetailsManager extends JdbcUserDetailsManager {

	private SecuredService securedService;

	public CustomUserDetailsManager( SecuredService securedService ) {
		this.securedService = Objects.requireNonNull( securedService , "securedService is null");
	}


	/** 권한의 계층구조 조회  **/
	private RoleHierarchy getRoleHierarchy() {
		return securedService.getRoleHierarchy();
	}


	@Override
	protected void checkDaoConfig() {
		/** jdbcTemplate 를 체크하지 않는다.  **/
	}
	@Override
	protected void initDao() throws ApplicationContextException {
		/** jdbcTemplate 를 체크하지 않는다.  **/
	}

	/** DB 에서 사용자의 기본 권한 조회 **/
	@Override
	protected List<GrantedAuthority> loadUserAuthorities(String username) {
		return securedService.loadUserAuthorities(username);
	}

	/** DB 에서 사용자 데이터 조회 **/
	@Override
    protected List<UserDetails> loadUsersByUsername(String username) {
		List<UserDetails> list =  securedService.loadUsersByUsername(username);
		return list;
    }


	/** 인증 후 객체 생성 **/
    @Override
    public CustomUserDetails loadUserByUsername( String username ) throws UsernameNotFoundException  {

    	 List<UserDetails> users = this.loadUsersByUsername( username );

    	 CustomUserDetails user_detail =
    			 StreamUtils.toStream( users )
	    	 				.filter( ObjectUtils::isNotEmpty )
	    	 				.map( usr -> (CustomUserDetails) usr )
	    	 				.findFirst()
	    	 				.orElseThrow( () ->  new UsernameNotFoundException( "Username not found") );

    	 /** 사용자의  기본 권한 세팅 **/
    	 List<GrantedAuthority> dbAuths = this.loadUserAuthorities( username );

    	 /** 추가 사용자 권한 세팅 **/
    	 addCustomAuthorities( username, dbAuths );

    	 if( CollectionUtils.isEmpty( dbAuths ) ) {
    		 throw new UsernameNotFoundException("User has no GrantedAuthority");
    	 }

    	 /** 권한의 계층구조 조회 **/
    	 RoleHierarchy roleHierarchy = this.getRoleHierarchy();

    	 /** 권한 계층 구조에 의한 최종 권한 세팅 **/
    	 Collection<? extends GrantedAuthority> authorities =  roleHierarchy.getReachableGrantedAuthorities( dbAuths );
    	 user_detail.setAuthorities(authorities);

    	

    	 return user_detail;

    }



}
