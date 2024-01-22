package egovframework.config.security.secured;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Objects;
import static java.util.stream.Collectors.*;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.hierarchicalroles.RoleHierarchy;
import org.springframework.security.access.hierarchicalroles.RoleHierarchyImpl;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

import egovframework.common.util.StreamUtils;
import egovframework.config.security.secured.model.SecurityHierarch;
import egovframework.config.security.secured.model.SecurityRole;
import egovframework.config.security.secured.model.SecurityUser;
import egovframework.config.security.util.SelfRegexRequestMatcher;
import lombok.Setter;


public class SecuredService {

	@Setter
	private String requestMatcherType = "ant";


	private SecuredMapper springSecurityMapper;

	public SecuredService ( SecuredMapper springSecurityMapper ) {
    	this.springSecurityMapper = Objects.requireNonNull( springSecurityMapper , "SpringSecurityMapper IS NULL" );
	}



	private RequestMatcher requestMatcher( SecurityRole role ) {
		String target = role.getTarget();
		if( StringUtils.equalsIgnoreCase( this.requestMatcherType , "REGEX") ) {
			return new SelfRegexRequestMatcher( target, null);
		}else if( StringUtils.equalsIgnoreCase( this.requestMatcherType, "CIREGEX") ) {
			return new SelfRegexRequestMatcher( target, null, true);
		}else {
			return new AntPathRequestMatcher( target );
		}
	}


	/**
	 * URL 에 대한 ROLE 권한을 조회한다.
	 * @return
	 * @throws Exception
	 */
	public LinkedHashMap<RequestMatcher, List<ConfigAttribute>> getRolesAndUrl()  {
		/** URL 에 대한 ROLE 리스트 조회 **/
		List<SecurityRole> list_role = this.springSecurityMapper.listSecurityRole("url");

		LinkedHashMap<RequestMatcher, List<ConfigAttribute>> result =
				StreamUtils.toStream( list_role )
							  .collect( groupingBy(   role -> this.requestMatcher( role )
										 				 ,LinkedHashMap::new
										 				 ,mapping(  SecurityRole::newSecurityConfig
										 						 	   ,toCollection(  LinkedList::new ) ) ) );

		return result;
	}

	/**
	 * METHOD 에 대한 ROLE 권한을 조회한다.
	 * @return
	 * @throws Exception
	 */
	public LinkedHashMap<String, List<ConfigAttribute>> getRolesAndMethod() throws Exception {
		/** METHOD 에 대한 ROLE 리스트 조회 **/
		List<SecurityRole> list_role = this.springSecurityMapper.listSecurityRole("method");

		LinkedHashMap<String, List<ConfigAttribute>> result =
			StreamUtils.toStream( list_role )
						  .collect( groupingBy( SecurityRole::getTarget
								  					,LinkedHashMap::new
								  					,mapping( SecurityRole::newSecurityConfig
								  								 ,toCollection( LinkedList::new )  ) ) );
		return result;
	}



	/**
	 * METHOD 에 대한 ROLE 권한을 조회한다.
	 * @return
	 * @throws Exception
	 */
	public LinkedHashMap<String, List<ConfigAttribute>> getRolesAndPointcut() throws Exception {
		/** POINTCUT 에 대한 ROLE 리스트 조회 **/
		List<SecurityRole> list_role = this.springSecurityMapper.listSecurityRole("pointcut");

		LinkedHashMap<String, List<ConfigAttribute>> result =
			StreamUtils.toStream( list_role )
						.collect( groupingBy( SecurityRole::getTarget
												, LinkedHashMap::new
												, mapping( SecurityRole::newSecurityConfig
															  ,toCollection( LinkedList::new ) ) ));
		return result;
	}


	/** 사용자 정보 조회 **/
	public List<UserDetails> loadUsersByUsername( String username ) {

		/** 년도 조회
		 * 3월 이전이면 현재 년도 -1
		 * 3월 이후 이면 현재 년도
		 *  **/

		/** DB 에서 사용자 데이터 조회 **/
		List<SecurityUser> list = this.springSecurityMapper.userByUsername( username );

		return  StreamUtils.toStream( list )
					 .filter( ObjectUtils::isNotEmpty )
					 .map( SecurityUser::makeUserDetails )
					 .collect( toList() );
	}

	/** 사용자 권한 조회 **/
	public List<GrantedAuthority> loadUserAuthorities( String username ){
		/** DB 조회 **/
		List<String> list = this.springSecurityMapper.authoritiesByUsername( username );

		return StreamUtils.toStream( list )
							 .filter( StringUtils::isNotEmpty )
							 .map( SimpleGrantedAuthority::new )
							 .collect( toList() );
	}


	/** 권한에 대한 계층 구조 조회 **/
	public RoleHierarchy getRoleHierarchy()  {
		RoleHierarchyImpl roleHierarchy = new RoleHierarchyImpl();

		try {
			String hierarchicalRoles =  this.getHierarchicalRoles();
			roleHierarchy.setHierarchy( hierarchicalRoles );
		}catch(Exception e) {
			throw new RuntimeException("SecuredObjectService.getRoleHierarchy", e);
		}

		return roleHierarchy;
	}



	/**
	 * SPRING SECURITY ROLE 계층 구조 조회
	 * @return
	 * @throws Exception
	 */
	public String getHierarchicalRoles() throws Exception {
		List<SecurityHierarch> list = this.springSecurityMapper.hierarchicalRoles();

		String result = StreamUtils.toStream( list )
										.map( SecurityHierarch::getHierarch )
										.collect( joining( "\n" )  );
		return result;
	}


	/** 로그인 로그 추가 **/
	public void addLoginLog( String username, String remote_addr ) {
		/** 첫 로그인 시간 갱신 **/
		this.springSecurityMapper.modifyFirstLoginDt( username );

		/** 마지막 로그인 시간 갱신 **/
		this.springSecurityMapper.modifyLastLoginDt( username );

		/** 로그인 로그 추가 **/
		this.springSecurityMapper.addLoginLog( username, remote_addr );


	}



}
