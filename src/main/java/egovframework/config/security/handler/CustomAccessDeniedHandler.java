package egovframework.config.security.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.access.AccessDeniedHandler;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * 로그인한 사용자가 권한이 존재하지 않는 페이지를 호출했을시 사용된다.
 * 요청이 AJAX 인경우 응답값을 JSON 으로 응답하기위한 객체
 * SPRING SECURITY 접근제어 권한 문제 발생시 사용함
 * 원본: org.springframework.security.web.access.AccessDeniedHandlerImpl
 */
@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler  {

	private String errorPage;
	private final RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();

	public void setErrorPage(String errorPage) {
		if ((errorPage != null) && !errorPage.startsWith("/")) {
			throw new IllegalArgumentException("errorPage must begin with '/'");
		}
		this.errorPage = errorPage;
	}

	@Override
	public void handle(HttpServletRequest request
				,HttpServletResponse response
				,AccessDeniedException accessDeniedException) throws IOException, ServletException {

		log.debug("CustomAuthenticationEntryPoint.handle :::: {}",request.getRequestURI());
		if( CommonUtils.isResponseJsp( request ) ) {
			if ( !response.isCommitted() ) {
				/** request forward 일 경우에 sitemesh 를 호출하지 못해서 redirect 로 재구현함 **/
				redirectStrategy.sendRedirect(request, response, this.errorPage );
			}
		}else {
			/** 응답을 JSP 로 보내지 않는 경우  **/

			/** 인증된 사용자가 권한이 없는 요청을 했기 때문에 403 으로 처리한다.  **/
			response.sendError( HttpServletResponse.SC_FORBIDDEN );
		}
	}


}
