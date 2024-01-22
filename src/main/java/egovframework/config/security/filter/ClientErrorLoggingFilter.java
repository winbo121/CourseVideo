package egovframework.config.security.filter;

import java.io.IOException;
import java.util.List;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections4.CollectionUtils;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.GenericFilterBean;
import lombok.extern.slf4j.Slf4j;


@Slf4j
public class ClientErrorLoggingFilter extends GenericFilterBean {

	private List<HttpStatus> errorCodes;

	public ClientErrorLoggingFilter( List<HttpStatus> errorCodes ) {
		this.errorCodes = errorCodes;
	}


	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();

		if (auth == null) {
		    chain.doFilter(request, response);
		    return;
		}

		int status = ((HttpServletResponse) response).getStatus();
		/** STATUS 가 300 대 이하인 경우는 오류 로그를 남기지 않는다.  **/
		if ( status < 400 ) {
		    chain.doFilter(request, response);
		    return;
		}

		if ( CollectionUtils.isEmpty( this.errorCodes ) ) {
			log.debug("[ALL STATUS] USER:{}  RESPONSE STATUS ERROR:{}" , auth.getName(), status );
		} else {
		    if ( errorCodes.stream().anyMatch(s -> s.value() == status)) {
				log.debug("[MATCHED STATUS] USER:{}  RESPONSE STATUS ERROR:{}" , auth.getName(), status );
		    }
		}
		chain.doFilter(request, response);
	}

}
