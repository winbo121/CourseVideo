package egovframework.config.security.strategy;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.session.SessionInformationExpiredEvent;
import org.springframework.security.web.session.SessionInformationExpiredStrategy;
import org.springframework.security.web.util.UrlUtils;
import org.springframework.util.Assert;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;


/** SECURITY 세션 만료후 동작 객체 **/
@Slf4j
public class CustomSessionExpiredStrategy implements SessionInformationExpiredStrategy  {

	private final String expiredUrl;
	private final RedirectStrategy redirectStrategy;

	public CustomSessionExpiredStrategy( String expiredUrl ) {

		Assert.isTrue(expiredUrl == null || UrlUtils.isValidRedirectUrl(expiredUrl),
						expiredUrl + " isn't a valid redirect URL");
		this.expiredUrl = expiredUrl;
		this.redirectStrategy = new DefaultRedirectStrategy();
	}


	/** 세션 만료 처리기 **/
	@Override
	public void onExpiredSessionDetected(SessionInformationExpiredEvent event) throws IOException, ServletException {
		HttpServletRequest request = event.getRequest();
		HttpServletResponse response = event.getResponse();
		log.debug("CustomSessionExpiredStrategy.onExpiredSessionDetected :::: {}",request.getRequestURI());

		if( CommonUtils.isResponseJsp( request ) ) {
			/** 응답을 JSP 로 보내는 경우 **/
			redirectStrategy.sendRedirect(request, response, this.expiredUrl );
		}else {
			/** 응답을 JSP 로 보내지 않는 경우  **/

			/** 인증된 사용자가 인증이 만료되었기 때문에 401 처리한다.  **/
			response.sendError( HttpServletResponse.SC_UNAUTHORIZED );
		}
	}




}
