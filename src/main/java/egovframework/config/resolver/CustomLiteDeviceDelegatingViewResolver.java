package egovframework.config.resolver;

import java.net.URL;
import java.util.Locale;
import javax.servlet.ServletContext;
import org.springframework.mobile.device.view.LiteDeviceDelegatingViewResolver;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;

import egovframework.common.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;

/**
 * LiteDeviceDelegatingViewResolver 의 enableFallback 이 동작하지 않아서 재구현함.
 * @author yoon
 */
@Slf4j
public class CustomLiteDeviceDelegatingViewResolver extends LiteDeviceDelegatingViewResolver {

	private ViewResolver delegate;

	public CustomLiteDeviceDelegatingViewResolver(ViewResolver delegate) {
		super(delegate);
		this.delegate = delegate;
	}

	/**
	 * MOBILE 용 JSP 가 존재하는지 확인한다.
	 * @param original_view_name
	 * @return
	 */
	private boolean hasMobileJsp( String original_view_name  ) {
		boolean result = false;

		try {
			ServletContext servlet_context = getServletContext();
			String url = "/WEB-INF/jsp/" + original_view_name + "_mobile.jsp";
			URL resource_url =  servlet_context.getResource( url );
			if( resource_url == null  ) {
				result = false;
			}else {
				result = true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}


	@Override
	public View resolveViewName(String viewName, Locale locale) throws Exception {
		if( CommonUtils.isDeviceMobile() || CommonUtils.isDeviceTablet() ) {
			/** 모바일 이거나 태블릿인경우  **/

			if( hasMobileJsp( viewName ) ) {
				viewName = this.getDeviceViewName( viewName );
			}
		}

		View view = delegate.resolveViewName( viewName, locale );
		
		log.debug("Resolved View: " + view.toString());
		return view;
	}


}
