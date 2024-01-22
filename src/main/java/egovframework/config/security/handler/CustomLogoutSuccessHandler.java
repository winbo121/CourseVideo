package egovframework.config.security.handler;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

/** 로그아웃 성공시 행동을 재정의할 클래스  **/
@Slf4j
public class CustomLogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {
	
	@Override
	public void onLogoutSuccess(HttpServletRequest request,
								HttpServletResponse response,
								Authentication authentication) throws IOException, ServletException {

		log.debug("CustomLogoutSuccessHandler.onLogoutSuccess ::::");

		if( CommonUtils.isResponseJsp( request ) ) {
			/** 응답을 JSP 로 보내는 경우 **/
			super.onLogoutSuccess(request, response, authentication);
		}else {
			/** 응답을 JSP 로 보내지 않는 경우  **/
			response.setStatus( HttpStatus.OK.value() );
		}

	}



}
