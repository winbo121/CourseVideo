package egovframework.config.security.filter;

import java.io.IOException;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;
import lombok.extern.slf4j.Slf4j;

/** SECURITY Access Control List 기능을 담당하는 필터 객체  **/
@Slf4j
public class CustomFilterSecurityInterceptor extends FilterSecurityInterceptor {


	public void doFilter(ServletRequest request,
						ServletResponse response,
						FilterChain chain) throws IOException, ServletException {

		log.debug("CustomFilterSecurityInterceptor.doFilter ::::");
		super.doFilter(request, response, chain);
	}


}
