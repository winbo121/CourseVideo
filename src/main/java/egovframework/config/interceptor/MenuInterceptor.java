package egovframework.config.interceptor;

import java.util.Optional;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.constrant.Constrants;
import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class MenuInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		/** SERVER SIDE URI 를 세팅한다. 추후 VIEW 에서 사용된다. **/
		String context_path = request.getContextPath();
		String uri = request.getRequestURI();
		if( !StringUtils.equals(context_path, "/") ){
			uri = StringUtils.replaceOnce( uri, context_path, "" );
		}
		request.setAttribute( Constrants.REQUEST_URI_NAME ,  uri );

		/** 응답 요청이 JSP VIEW 가 아닌경우 아래 로직은 필요하지 않다. **/
		if( !CommonUtils.isResponseJsp( request ) ) {
			return true;
		}

		
		return true;
	}




	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

	}

}
