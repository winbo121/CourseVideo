package egovframework.config;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.vote.AbstractAccessDecisionManager;
import org.springframework.security.access.vote.AffirmativeBased;
import org.springframework.security.access.vote.AuthenticatedVoter;
import org.springframework.security.access.vote.RoleVoter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity.IgnoredRequestConfigurer;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.security.web.authentication.session.CompositeSessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.ConcurrentSessionControlAuthenticationStrategy;
import org.springframework.security.web.authentication.session.RegisterSessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.SessionFixationProtectionStrategy;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.security.web.session.ConcurrentSessionFilter;
import org.springframework.security.web.session.SessionInformationExpiredStrategy;

import egovframework.config.encoder.Aes256Encoder;
import egovframework.config.security.attribute.SecurityAttribute;
import egovframework.config.security.attribute.SecurityIgnore;
import egovframework.config.security.configurer.ClientErrorLoggingConfigurer;
import egovframework.config.security.entry.CustomAuthenticationEntryPoint;
import egovframework.config.security.filter.AjaxLoginProcessingFilter;
import egovframework.config.security.filter.CustomExceptionTranslationFilter;
import egovframework.config.security.filter.CustomFilterSecurityInterceptor;
import egovframework.config.security.filter.CustomUsernamePasswordAuthenticationFilter;
import egovframework.config.security.handler.AjaxAuthenticationFailureHandler;
import egovframework.config.security.handler.AjaxAuthenticationSuccessHandler;
import egovframework.config.security.handler.CustomAccessDeniedHandler;
import egovframework.config.security.handler.CustomAuthenticationFailureHandler;
import egovframework.config.security.handler.CustomAuthenticationSuccessHandler;
import egovframework.config.security.handler.CustomLogoutSuccessHandler;
import egovframework.config.security.meta.ReloadableFilterInvocationSecurityMetadataSource;
import egovframework.config.security.provider.AjaxAuthenticationProvider;
import egovframework.config.security.provider.CustomDaoAuthenticationProvider;
import egovframework.config.security.secured.SecuredMapper;
import egovframework.config.security.secured.SecuredService;
import egovframework.config.security.strategy.CustomSessionExpiredStrategy;
import egovframework.config.security.user.CustomUserDetailsManager;
import egovframework.config.security.util.SecurityUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity( securedEnabled = true, proxyTargetClass = true )
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	private SecurityAttribute securityAttribute;


	/** SECURITY ROLE 을 무시하는 URL 규칙 세팅 **/
	@Override
	public void configure(WebSecurity web) throws Exception {
	    log.info("## Configuring Spring Security WebSecurity... ##");

        /** SPRING SECURITY 예외 리스트 **/
        List<SecurityIgnore> ignore_list = securityAttribute.getIgnore_list();
        if( CollectionUtils.isEmpty( ignore_list )  ) {
        	log.info("NONE SPRING SECURITY IGNORE LIST");
        	return ;
        }

        log.info("SPRING SECURITY IGNORE LIST ={}",ignore_list);
    	IgnoredRequestConfigurer ignoredConfig = web.ignoring();

    	for (SecurityIgnore ignore_attr : ignore_list) {
    		HttpMethod http_method = ignore_attr.getMethod();
    		String pattern = ignore_attr.getPattern();

    		if( BooleanUtils.isTrue( ignore_attr.isAnt() ) ) {
    			/** ANT MATCHER 인 경우  **/
    			SecurityUtils.ignoreAntMatcher( ignoredConfig, http_method, pattern);
    		}else if( BooleanUtils.isTrue( ignore_attr.isRegex() ) ) {
    			/** REGEX MATCHER 인경우  **/
    			SecurityUtils.ignoreRegexMatcher(ignoredConfig, http_method, pattern);
    		}else if( BooleanUtils.isTrue( ignore_attr.isMvc() ) ) {
    			/** MVC MATCHER 인 경우 **/
    			SecurityUtils.ignoreMvcMatcher(ignoredConfig, http_method, pattern);
    		}
    	}

        /**
                     * 내부적으로 PRIVATE CLASS 가 존재해서 REQUEST MATCHER 를 주입해주기 어려움.
         * <security:http pattern="/resources/**" security="none"/>
        web.ignoring()
					.antMatchers("/resources/**")
					.antMatchers("/css/**")
					.antMatchers("/js/**")
					.antMatchers("/img/**");
		**/

	}

	/** SPRING SECURITY CONTEXT REPOSITORY **/
	@Bean
	public SecurityContextRepository securityContextRepository() {
		return new HttpSessionSecurityContextRepository();
	}

	/** SPRING BOOT SECURITY 설정   **/
    @Override
    public void configure(HttpSecurity http) throws Exception {
    	/** 참조: https://coding-start.tistory.com/153 **/
    	 log.info("## Configuring Spring Security HttpSecurity... ##");


        /** 인증정보를 Http Session 에 세팅 [SECURITY 기본 설정] **/
        http.securityContext()
        	.securityContextRepository( securityContextRepository() );

        http.authenticationProvider( authenticationProvider() );
        http.userDetailsService( userDetailsService() );

        /** 로그인 인증 필터 추가
        http.formLogin().failureHandler( authenticationFailureHandler() )
        				.successHandler( authenticationSuccessHandler() ); **/
        http.addFilterAt( authenticationFilter() , UsernamePasswordAuthenticationFilter.class );

        /** 로그아웃 필터 추가 **/
        http.logout().logoutUrl( securityAttribute.getLogout_url() )
        			 .logoutSuccessHandler( logoutSuccessHandler() );

        
        /** Ajax 로그인 인증 필터 추가 **/
        http.addFilterBefore(ajaxLoginProcessingFilter(),UsernamePasswordAuthenticationFilter.class);

        /** 인증 오류, 권한 오류  필터
        http.exceptionHandling()
								.accessDeniedHandler( accessDeniedHandler() )
								.authenticationEntryPoint( authenticationEntryPoint() ); **/
        /** 기존  ExceptionTranslationFilter disable 이후에 신규 ExceptionTranslationFilter 를 추가한다. **/
        http.exceptionHandling().disable();
        http.addFilterAt( exceptionTranslationFilter() , ExceptionTranslationFilter.class );


        /** CONFIG ACL 설정과 DB 접근 ACL 설정을 동시에 하기는 힘듬. **/
//      http.authorizeRequests()
//    	.antMatchers("/login*/**").permitAll()
//    	.antMatchers("/logout*/**").permitAll()
//    	.anyRequest().authenticated();

        /** ACL 필터 추가  **/
        http.addFilterAt( filterSecurityInterceptor() , FilterSecurityInterceptor.class );

        /** 세션 체크 필터 추가 **/
        http.addFilterAt( concurrentSessionFilter() , ConcurrentSessionFilter.class );

        /** 익명 사용자 사용 설정 **/
        http.anonymous();

        /** 세션 인증 전략 설정 **/
        http.sessionManagement().sessionAuthenticationStrategy( sessionAuthenticationStrategy() );
        
        /** 세션 공격에 대비하기 위하여 고정 세션키를 방지 **/
        http.sessionManagement().sessionFixation().none();

        /** SNIFF 활성화 여부  **/
        if( BooleanUtils.isNotTrue( securityAttribute.getUse_sniff() ) ) {
        	http.headers().defaultsDisabled();
        }

        /** HEADER FRAME 설정  **/
        if( StringUtils.equals( securityAttribute.getX_frame_option() , "SAMEORIGIN") ) {
        	http.headers().frameOptions().sameOrigin();
        }else if( StringUtils.equals( securityAttribute.getX_frame_option() , "DENY") ) {
        	 http.headers().frameOptions().deny();
        }

        /** XSS 사용여부 **/
        if( BooleanUtils.isTrue( securityAttribute.getUse_xss_protection() ) ) {
        	/** enable = true & block = true**/
        	http.headers().xssProtection().block(true);
        }

        /** CSRF 사용 여부 **/
        if( BooleanUtils.isNotTrue( securityAttribute.getUse_csrf() ) ) {
        	 http.csrf().disable();
        }
        /** 로그인, 로그아웃 url 에 대해서 csrf 무시 **/
        http.csrf().ignoringAntMatchers( securityAttribute.getCsrfIgnores() );

        /** 클라이언트 에러로깅 필터 추가 **/
        http.apply( clientErrorLoggingConfigurer() ).disable();


    }


    /** 클라이언트 오류로깅 설정  **/
    @Bean
    public ClientErrorLoggingConfigurer clientErrorLoggingConfigurer() {
    	ClientErrorLoggingConfigurer clientErrorLoggingConfigurer = new ClientErrorLoggingConfigurer();
    	clientErrorLoggingConfigurer.setErrorCodes( Arrays.asList(HttpStatus.NOT_FOUND, HttpStatus.UNAUTHORIZED , HttpStatus.BAD_REQUEST) );

    	return clientErrorLoggingConfigurer;
    }

    /** SECURITY Form Login 시에 동작하는 필터 객체   **/
    @Bean
    public UsernamePasswordAuthenticationFilter authenticationFilter() throws Exception {

    	CustomUsernamePasswordAuthenticationFilter authenticationFilter
    	= new CustomUsernamePasswordAuthenticationFilter( authenticationManager() );

    	authenticationFilter.setPostOnly( true );
    	authenticationFilter.setFilterProcessesUrl( securityAttribute.getLogin_form_url() );
    	authenticationFilter.setUsernameParameter( securityAttribute.getLogin_username() );
    	authenticationFilter.setPasswordParameter( securityAttribute.getLogin_password() );

    	authenticationFilter.setAuthenticationSuccessHandler( authenticationSuccessHandler() );
    	authenticationFilter.setAuthenticationFailureHandler( authenticationFailureHandler() );

    	authenticationFilter.afterPropertiesSet();

    	return authenticationFilter;
    }
    
    /** SECURITY Ajax Login 만들어준 필터를 빈으로 등록 **/
    @Bean
    public AjaxLoginProcessingFilter ajaxLoginProcessingFilter() throws Exception {
    
        AjaxLoginProcessingFilter ajaxLoginProcessingFilter = new AjaxLoginProcessingFilter();
       //필터를 만들때 매니저도 설정을 해줘야한다.
       ajaxLoginProcessingFilter.setAuthenticationManager(authenticationManagerBean());
       ajaxLoginProcessingFilter.setAuthenticationSuccessHandler( ajaxAuthenticationSuccessHandler() );
       ajaxLoginProcessingFilter.setAuthenticationFailureHandler( ajaxAuthenticationFailureHandler() );
       ajaxLoginProcessingFilter.afterPropertiesSet();

        return ajaxLoginProcessingFilter;
    }

    /** SECURITY 권한없음, 비인증 에대한 예외 처리 필터 객체  **/
    @Bean
    public ExceptionTranslationFilter exceptionTranslationFilter() {
    	CustomExceptionTranslationFilter exceptionTranslationFilter
    			= new CustomExceptionTranslationFilter( authenticationEntryPoint() );
    	exceptionTranslationFilter.setAccessDeniedHandler( accessDeniedHandler() );

    	exceptionTranslationFilter.afterPropertiesSet();

    	return exceptionTranslationFilter;
    }

    /** SECURITY 인증되지 않은 사용자가 접근했을경우 동작하는 객체  **/
    @Bean
    public AuthenticationEntryPoint authenticationEntryPoint() {

		AuthenticationEntryPoint authenticationEntryPoint
			= new CustomAuthenticationEntryPoint( securityAttribute.getLogin_form_url() );

		return authenticationEntryPoint;
    }

    /** SECURITY 인증된 사용자가 권한이 없을경우 동작하는 객체 **/
    @Bean
    public AccessDeniedHandler accessDeniedHandler() {

    	CustomAccessDeniedHandler accessDeniedHandler = new CustomAccessDeniedHandler();
		accessDeniedHandler.setErrorPage( securityAttribute.getAccess_denied_url() );

		return accessDeniedHandler;
    }


    @Value(value="${aes.attribute.aes_256_key}")
    private String aes_256_key;

    @Bean
    public Aes256Encoder aes256Encoder() {
    	Aes256Encoder aseAes256Encoder = new Aes256Encoder();
    	aseAes256Encoder.setAes_256_key(aes_256_key);
    	return aseAes256Encoder;
    }



	/** SECURITY DAO 인증 확인 객체 **/
	@Bean
	public DaoAuthenticationProvider authenticationProvider() throws Exception  {
		CustomDaoAuthenticationProvider daoAuthenticationProvider = new CustomDaoAuthenticationProvider();

		daoAuthenticationProvider.setHideUserNotFoundExceptions(false);
		/** 비밀번호 인코더  **/
		daoAuthenticationProvider.setAes256Encoder( aes256Encoder() );

		/** SPRING SECURITY 5 부터 암호화 객체가 바뀜.  EGOV 의 비밀번호 인코더는 사용하지 못함. **/
		daoAuthenticationProvider.setUserDetailsService( userDetailsService() );

		daoAuthenticationProvider.afterPropertiesSet();
		return daoAuthenticationProvider;
	}
	
	/** SECURITY AJAX 인증 확인 객체 **/
	@Bean
	public AjaxAuthenticationProvider AjaxAuthenticationProvider() throws Exception  {
		AjaxAuthenticationProvider AjaxAuthenticationProvider = new AjaxAuthenticationProvider();
		
		/** 비밀번호 인코더  **/
		AjaxAuthenticationProvider.setAes256Encoder( aes256Encoder() );
		/** SPRING SECURITY 5 부터 암호화 객체가 바뀜.  EGOV 의 비밀번호 인코더는 사용하지 못함. **/
		AjaxAuthenticationProvider.setUserDetailsService( userDetailsService() );

		return AjaxAuthenticationProvider;
	}
	


	/** SECURITY DAO 인증 확인 객체 **/
	@Bean
	public LogoutSuccessHandler logoutSuccessHandler() {

		CustomLogoutSuccessHandler logoutSuccessHandler = new CustomLogoutSuccessHandler();
		logoutSuccessHandler.setDefaultTargetUrl( securityAttribute.getLogout_default_target_url() );

		return logoutSuccessHandler;
	}



	/** SECURITY 필터 메타소스  객체 **/
	@Bean
	public ReloadableFilterInvocationSecurityMetadataSource securityMetadataSource() throws Exception {

		ReloadableFilterInvocationSecurityMetadataSource filterInvocationSecurityMetadataSource
			= new ReloadableFilterInvocationSecurityMetadataSource( securedService()   );

		return filterInvocationSecurityMetadataSource;
	}


	/** SPRING SECURITY 에서 DB 접근 하기위한 객체 **/
	@Autowired  private SecuredMapper securedMapper;

	/** SECURITY 보호객체 관리를 지원하는 객체 **/
	@Bean
	public SecuredService securedService( ) {

		SecuredService securedService = new SecuredService(  this.securedMapper );
		securedService.setRequestMatcherType( securityAttribute.getRequest_matcher_type() );
		return securedService;
	}


	/** SECURITY 인증 관리 객체  WebSecurityConfigurerAdapter.authenticationManager() 확장구현 **/
	@Bean
	@Override
	public AuthenticationManager authenticationManager() throws Exception {
		/** 기본값  ProviderManager AuthenticationProvider 의 구현체들을 providers 로 주입가능하다.
		 * [org.springframework.security.authentication.dao.DaoAuthenticationProvider@26c5ce5a]
		 **/
		List<AuthenticationProvider> providers = new ArrayList<AuthenticationProvider>();
		providers.add( authenticationProvider() );
		providers.add( AjaxAuthenticationProvider() );
		ProviderManager authenticationManager = new ProviderManager( providers );

		return authenticationManager;
	}


	/** SECURITY USER 인증 객체 조회 WebSecurityConfigurerAdapter.userDetailsService() 확장구현  **/
	@Bean
	@Override
	public UserDetailsService userDetailsService() {
		CustomUserDetailsManager userDetailsService = new CustomUserDetailsManager( securedService() );
		return userDetailsService;
	}


	/** SECURITY 비밀번호 인코더
	@Bean
	public PasswordEncoder passwordEncoder() {

		EgovShaPasswordEncoder passwordEncoder = new EgovShaPasswordEncoder(256, true);

		return passwordEncoder;
	}
	 **/


	/** SECURITY 필터 인터셉터 **/
	@Bean
	public CustomFilterSecurityInterceptor filterSecurityInterceptor() throws Exception {
		CustomFilterSecurityInterceptor filterSecurityInterceptor = new CustomFilterSecurityInterceptor();

		filterSecurityInterceptor.setAuthenticationManager( authenticationManager());
		filterSecurityInterceptor.setAccessDecisionManager( accessDecisionManager() );
		filterSecurityInterceptor.setSecurityMetadataSource( securityMetadataSource() );

		return filterSecurityInterceptor;
	}


	/** SECURITY 인증 성공시 동작하는 핸들러  **/
	@Bean
	public AuthenticationSuccessHandler authenticationSuccessHandler() {

	    CustomAuthenticationSuccessHandler successHandler = new CustomAuthenticationSuccessHandler();

	    successHandler.setDefaultTargetUrl( securityAttribute.getLogin_default_target_url() );
	    /** 로그인 성공 이후에 로그를 남기기 위해서 추가 **/
	    successHandler.setSecuredService( securedService() );
	    /** 세션 최대 유지 시간 설정 **/
	    successHandler.setLoginMaxInactiveInterval( securityAttribute.getLogin_max_inactive_interval() );


	    return successHandler;
	}

	/** SECURITY 인증 실패시 동작하는 핸들러 **/
	@Bean
	public AuthenticationFailureHandler authenticationFailureHandler() {

	    CustomAuthenticationFailureHandler failureHandler = new CustomAuthenticationFailureHandler();
	    failureHandler.setDefaultFailureUrl( securityAttribute.getLogin_default_fail_url() );
	    return failureHandler;
	}
	
	/** SECURITY Ajax 인증 성공시 동작하는 핸들러  **/
	@Bean
	public AjaxAuthenticationSuccessHandler ajaxAuthenticationSuccessHandler() {

		AjaxAuthenticationSuccessHandler successHandler = new AjaxAuthenticationSuccessHandler();

	    successHandler.setDefaultTargetUrl( securityAttribute.getLogin_default_target_url() );
	    /** 로그인 성공 이후에 로그를 남기기 위해서 추가 **/
	    successHandler.setSecuredService( securedService() );
	    /** 세션 최대 유지 시간 설정 **/
	    successHandler.setLoginMaxInactiveInterval( securityAttribute.getLogin_max_inactive_interval() );

	    return successHandler;
	}

	/** SECURITY Ajax 인증 실패시 동작하는 핸들러 **/
	@Bean
	public AjaxAuthenticationFailureHandler ajaxAuthenticationFailureHandler() {

		AjaxAuthenticationFailureHandler failureHandler = new AjaxAuthenticationFailureHandler();
		
	    return failureHandler;
	}

	/** SECURITY 접근 제어 관리자  **/
	@Bean
	public AccessDecisionManager accessDecisionManager() {

		List<AccessDecisionVoter<? extends Object>> decisionVoters = new ArrayList<AccessDecisionVoter<? extends Object> >();
			/** ROLE VOTER **/
			RoleVoter role_voter = new RoleVoter();
			role_voter.setRolePrefix("");

			/** AUTHENTICATE VOTER **/
			AuthenticatedVoter authenticated_voter = new AuthenticatedVoter();

		decisionVoters.add(role_voter);
		decisionVoters.add(authenticated_voter);

		AbstractAccessDecisionManager accessDecisionManager = new AffirmativeBased(decisionVoters);

		/** 기권 voter 통과 여부 (기본값 true)  **/
		accessDecisionManager.setAllowIfAllAbstainDecisions( false );
		return accessDecisionManager;
	}









	/** SECURITY 내부 메모리에 세션에 대한 관리를 처리하는 객체  (DB or REDIS 접근 가능하게 확장 구현시에 이중화장비에 대해서 처리 가능함) **/
	@Bean
	public SessionRegistry sessionRegistry() {
		SessionRegistryImpl sessionRegistry = new SessionRegistryImpl();
		return sessionRegistry;
	}

	/** SECURITY 동시 로그인 인증 관리 객채  (이중화 장비에서는 동작하지않음) **/
	@Bean
	public SessionAuthenticationStrategy sessionAuthenticationStrategy() {

		List<SessionAuthenticationStrategy> delegateStrategies = new ArrayList<SessionAuthenticationStrategy>();

			/** 한 사용자의 유지가능한 세션의 수량 체크 sessionRegistry 에서 메모리에서 체크하기 때문에 현재 서버에서만 체크가능한다. (이중화 장비 체크 안됨) **/
			ConcurrentSessionControlAuthenticationStrategy strategy_0 = new ConcurrentSessionControlAuthenticationStrategy( sessionRegistry() );
			strategy_0.setMaximumSessions( securityAttribute.getMaximum_sessions() );
			strategy_0.setExceptionIfMaximumExceeded( false );

			/** HTTP 세션에 대한  보호 를 처리한다. alwaysCreateSession=true 로 설정할 경우 요청마다 HTTP 세션을 마이그레이션 처리한다. (jsessionid 에 대한 보호 처리) **/
			SessionFixationProtectionStrategy strategy_1 = new SessionFixationProtectionStrategy();

			/** sessionRegistry key:jsessionId value:principal 객체를 등록 동시 로그인 접근에 대한 메타데이터를 관리함 메모리에 등록하기때문에 현재서버에서만 사용가능하다 (이중화 장비 체크 안됨) **/
			RegisterSessionAuthenticationStrategy strategy_2 = new RegisterSessionAuthenticationStrategy( sessionRegistry() );

		delegateStrategies.add( strategy_0 );
		delegateStrategies.add( strategy_1 );
		delegateStrategies.add( strategy_2 );

		CompositeSessionAuthenticationStrategy sessionAuthenticationStrategy  = new CompositeSessionAuthenticationStrategy(delegateStrategies);

		return sessionAuthenticationStrategy;
	}


	/** SECURITY SESSION 체크 필터
	 *   HTTP 세션이 존재하고 sessionRegistry 에 해당 세션에 대한 정보가 존재할경우 동작하는 필터. 해당 세션의 expire 되었을때 강제 logout 처리한다. (spring security Authentication 포함)
	 **/
	@Bean
	public ConcurrentSessionFilter concurrentSessionFilter() {

		/** 세션 만료시 이동 페이지 세팅 **/
		SessionInformationExpiredStrategy sessionExpiredStrategy = new CustomSessionExpiredStrategy( securityAttribute.getSession_expired_url() );
		ConcurrentSessionFilter concurrentSessionFilter = new ConcurrentSessionFilter( sessionRegistry() ,sessionExpiredStrategy);
		return concurrentSessionFilter;
	}


}
