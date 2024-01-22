package egovframework.config.security.handler;

import java.io.IOException;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;

import egovframework.common.constrant.Constrants;
import egovframework.common.util.CommonUtils;
import egovframework.common.util.LocalThread;
import egovframework.config.security.secured.SecuredService;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/** 로그인 성공시 행동을 재정의할 클래스 **/
@Slf4j
public class CustomAuthenticationSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {

	/** 로그인 성공이후 세션의 최대 활동 시간 SECOND  **/
	@Setter
	private Integer loginMaxInactiveInterval;

	@Setter
	private SecuredService securedService;


	/** 인증 성공시 호출되는 메서드 **/
	@Override
    public void onAuthenticationSuccess(HttpServletRequest request,
						    			HttpServletResponse response,
						    			Authentication authentication) throws ServletException, IOException {

		log.debug("CustomAuthenticationSuccessHandler.onAuthenticationSuccess ::::");
		/** 세션 유지 시간 설정 **/
		this.setMaxInactiveInterval(request);

		try {
			/** 로그인 성공시에 로그를 남긴다. **/
			 String username = 	authentication.getName();
			 String remoteAddr = CommonUtils.getClientIp( request );
			 securedService.addLoginLog( username, remoteAddr  );
			 
			 /** 아이디 저장 쿠키를 저장한다. **/
			 this.setRememberIdCooKie( request,response );
			 
		}catch (Exception e) {
		}

		if( CommonUtils.isResponseJsp( request ) ) {
			/** 응답을 JSP 로 보내는 경우 **/
			super.onAuthenticationSuccess(request, response, authentication);
		}else {
			/** 응답을 JSP 로 보내지 않는 경우  **/
			response.setStatus( HttpStatus.OK.value() );
		}

	}

	/** 인증 성공이후에 세션의 최대허용시간을 설정한다. **/
	private void setMaxInactiveInterval( HttpServletRequest request ) {
		if( request != null && this.loginMaxInactiveInterval != null ) {
			/** SESSION 에 대한  최대 허용시간 설정  second **/
			request.getSession().setMaxInactiveInterval( this.loginMaxInactiveInterval );
		}
	}
	
	
	/** 아이디 저장 쿠키를 저장한다. **/
	private void setRememberIdCooKie( HttpServletRequest request, HttpServletResponse response ) {
		
		Cookie cookie = new Cookie( Constrants.REMEMBER_USER_ID_KEY, LocalThread.getLoginId() );
				cookie.setPath( "/" );
				cookie.setMaxAge( Optional.ofNullable( request.getParameter( "remember_id" ) )
							 				.map( obj -> 60  * 60 * 24 * Constrants.REMEMBER_ID_MAX_AGE )
							 				.orElse( 0 ) );
				response.addCookie( cookie );
	}
	

}
