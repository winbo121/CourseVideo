package egovframework.work.oauth.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.config.security.attribute.SecurityAttribute;
import egovframework.config.security.secured.SecuredService;
import egovframework.config.security.user.CustomUserDetails;
import egovframework.config.security.user.CustomUserDetailsManager;
import egovframework.work.oauth.mapper.OAuthMapper;
import egovframework.work.oauth.model.OAuthUniversalUser;

@Service
public class OAuthService extends BaseService {

	@Autowired
	private OAuthMapper oAuthMapper;
	
	@Autowired
	private SecurityAttribute securityAttribute;
	
	@Autowired
	private SecuredService securedService;

	/* 소셜 로그인 */
	public String signIn(String userId, HttpSession session) throws Exception {
		
		if(userId == null) {
			return "E";
		} else {
			/** WebSecurityConfig.java의 securedService()와 userDetailService() 객체정보 참조. **/
			
			securedService.setRequestMatcherType( securityAttribute.getRequest_matcher_type() );
			CustomUserDetailsManager userDetailsService = new CustomUserDetailsManager( securedService );
			
			CustomUserDetails ckUserDetails = userDetailsService.loadUserByUsername( userId );
			
			Authentication authentication = new UsernamePasswordAuthenticationToken(ckUserDetails,"USER_PASSWORD", ckUserDetails.getAuthorities());
			
			SecurityContext securityContext = SecurityContextHolder.getContext();
			securityContext.setAuthentication(authentication);
			session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);
			
			/** force_login 참조 **/
			/*
			List<UserDetails> list = securedService.loadUsersByUsername( user_id );

			List<GrantedAuthority> loadUserAuthorities = securedService.loadUserAuthorities( user_id );

			UserDetails ckUserDetails = list.stream()
											.findFirst().orElseThrow( () -> new ErrorMessageException("com.none.data", "아이디") );

			String hierarchicalRoles = securedService.getHierarchicalRoles();
			RoleHierarchyImpl roleHierarchy = new RoleHierarchyImpl();
								roleHierarchy.setHierarchy(hierarchicalRoles);
								
			//권한 계층 구조에 의한 최종 권한 세팅 
			Collection<? extends GrantedAuthority> authorities = roleHierarchy.getReachableGrantedAuthorities(loadUserAuthorities);

			Authentication authentication = new UsernamePasswordAuthenticationToken(ckUserDetails,
					"USER_PASSWORD", authorities);
			SecurityContext securityContext = SecurityContextHolder.getContext();
			securityContext.setAuthentication(authentication);
			session = request.getSession(true);
			session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);
			*/
		}
		
		return "L";
	}

	/* 소셜 정보 등록 여부 체크 */
	public String checkSocialUser(OAuthUniversalUser oauthUser) {
		return oAuthMapper.checkSocialUser(oauthUser);

	}

	/* 소셜 연동 정도 등록 */
	public int insertSocialUser(String userId, String serviceName, String idntfNo, String connId) {
		return oAuthMapper.insertSocialUser(userId, serviceName, idntfNo, connId);
	}

	/* 소셜 연동 정보 취소(삭제)*/
	public int deleteSocialuser(String userId, String serviceName) {
		return oAuthMapper.deleteSocialUser(userId, serviceName);
	}
	
	/* 소셜 연동 정보 조회 */
	public List<Map<String, Object>> getSocialInfoList(){
		return oAuthMapper.getSocialInfoList();
	}

	
}