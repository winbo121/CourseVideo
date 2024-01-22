package egovframework.config.security.handler;

import java.io.IOException;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

import egovframework.common.util.CommonUtils;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/** 인증 실패시  **/
@Slf4j
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

	/** 확장 재구현함 **/
	@Setter
	private String defaultFailureUrl;


    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
							    		HttpServletResponse response,
							    		AuthenticationException exception) throws IOException, ServletException {
        log.debug("CustomAuthenticationFailureHandler.onAuthenticationFailure ::::");

        if( !CommonUtils.isResponseJsp( request ) ) {
        	/** 로그인하지 않은 사용자 이기 때문에 STATUS 401 로 처리한다.  **/
        	response.sendError( HttpServletResponse.SC_UNAUTHORIZED );
        	return;
        }

        String redirect_url = this.defaultFailureUrl;

        Optional<String> error_name = Optional.ofNullable( exception )
										        			.map( AuthenticationException::getClass )
										        			.map( Class::getSimpleName );
        if( error_name.isPresent() ) {
        	redirect_url += error_name.get();
        }

        RedirectStrategy redirectStrategy = this.getRedirectStrategy();
        redirectStrategy.sendRedirect( request, response, redirect_url );
    }



}
