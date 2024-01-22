package egovframework.config.security.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

/** LOGIN 시에 동작하는 필터객체를 재구현함. **/
@Slf4j
public class CustomUsernamePasswordAuthenticationFilter extends UsernamePasswordAuthenticationFilter  {

	@Setter
	private boolean postOnly = true;


	public CustomUsernamePasswordAuthenticationFilter( AuthenticationManager authenticationManager ) {
		super.setAuthenticationManager( authenticationManager );
	}


	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		log.debug("CustomUsernamePasswordAuthenticationFilter.doFilter ::::");
		super.doFilter(req, res, chain);
	}


}
