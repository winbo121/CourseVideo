package egovframework.config.filter.xss.servletfilter;

import java.io.IOException;
import java.util.Objects;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import egovframework.config.filter.xss.CustomXssEscapeFilter;
import egovframework.config.filter.xss.CustomXssEscapeServletFilterWrapper;


/**
 * com.navercorp.lucy.security.xss.servletfilter.XssEscapeServletFilter 확장구현
 * @author yoon
 *
 */
public class CustomXssEscapeServletFilter implements Filter {

	CustomXssEscapeFilter xssEscapeFilter = null;

	public CustomXssEscapeServletFilter( String config_path ) {
		Objects.requireNonNull( config_path );
		this.xssEscapeFilter =  CustomXssEscapeFilter.getInstance( config_path );
		
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}


	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		chain.doFilter( new CustomXssEscapeServletFilterWrapper(request, this.xssEscapeFilter ), response);
	}


	@Override
	public void destroy() {
	}


}
