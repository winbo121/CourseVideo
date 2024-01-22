package egovframework.config.security.entry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * Spring Security에서 로그인 페이지로 리다이렉트 시켜줄 Entrypoint객체이다.
 * 만약 권한이 없는 사용자가 페이지에 접근하였을 때, 해당 객체가 로그인 페이지로
 * 리다이렉트 시켜주는 역할을 담당한다.
 */
@Slf4j
public class CustomAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {

	public CustomAuthenticationEntryPoint(String loginFormUrl) {
		super(loginFormUrl);
	}


	@Override
    public void commence(HttpServletRequest request, HttpServletResponse response,
            			AuthenticationException authException) throws IOException, ServletException {

        log.debug("CustomAuthenticationEntryPoint.commence :::: {}",request.getRequestURI());
        if( CommonUtils.isResponseJsp( request ) ) {
        	/** 응답을 JSP 로 보내는 경우 **/
        	super.commence(request, response, authException);
        }else {
        	/** 응답을 JSP 로 보내지 않는 경우  **/

        	/** 로그인하지 않은 사용자 이기 때문에 STATUS 401 로 처리한다.  **/
        	response.sendError( HttpServletResponse.SC_UNAUTHORIZED );
        }


    }

}
