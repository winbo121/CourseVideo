package egovframework.config.security.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import lombok.extern.slf4j.Slf4j;

/** SECURITY 인증오류, 권한 오류 처리 FILTER **/
@Slf4j
public class CustomExceptionTranslationFilter extends ExceptionTranslationFilter {

	public CustomExceptionTranslationFilter(AuthenticationEntryPoint authenticationEntryPoint) {
		super(authenticationEntryPoint);
	}

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		log.debug("CustomExceptionTranslationFilter.doFilter ::::");
		super.doFilter(req, res, chain);
	}

}
