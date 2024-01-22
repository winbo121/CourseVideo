package egovframework.config;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.EnumSet;

import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRegistration;
import javax.servlet.SessionTrackingMode;

import org.apache.commons.lang.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.LoggerContext;
import org.springframework.core.io.Resource;
import org.springframework.mobile.device.DeviceResolverRequestFilter;
import org.springframework.web.WebApplicationInitializer;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.filter.DelegatingFilterProxy;
import org.springframework.web.multipart.support.MultipartFilter;
import org.springframework.web.servlet.DispatcherServlet;

import com.google.common.collect.Sets;

import egovframework.common.constrant.Constrants;
import egovframework.config.filter.FormContentFilter;
import egovframework.config.filter.SiteMeshFilter;
import egovframework.config.filter.xss.servletfilter.CustomXssEscapeServletFilter;
import egovframework.config.listener.SessionListener;
import egovframework.config.util.ConfigUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class WebInitializer implements WebApplicationInitializer  {

	private WebApplicationContext applicationContext( ServletContext servletContext ) {
		/** XML 설정
		XmlWebApplicationContext context = new XmlWebApplicationContext();
		context.setConfigLocation( APPLICATIOIN_CONTEXT_XML );
		context.setServletContext( servletContext );
		return context;
		 **/

		/** ANNOTATION 설정 **/
		AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
		context.register( WebMvcConfig.class );
		return context;
	}

	@Override
	public void onStartup( ServletContext servletContext ) throws ServletException {

		String active_profile = servletContext.getInitParameter("spring.profiles.active");
		System.out.println( " ##### LOG4J2 SET CONFIGLOCATION" );
		this.log4j2Configlocation( active_profile );

		log.info(" SPRING ACTIVE PROFILE ##########################");
		log.info(" PROFILE={}" ,active_profile);
		log.info(" #############################################");


		log.info(" SESSION TACKING MODES ########################");
		log.info(" {}" ,SessionTrackingMode.COOKIE);
		log.info(" #############################################");
		/** URL JSESSION ID REMOVE **/
		servletContext.setSessionTrackingModes( Sets.newHashSet( SessionTrackingMode.COOKIE ) );


		log.info( " WebInitializer START ===============================" );
		/** APPLICATION CONTEXT **/
		log.info( " APPLICATION CONTEXT" );
		WebApplicationContext applicationContext = this.applicationContext( servletContext );

		/** DISPATCHER SERVLET **/
		log.info( " DISPATCHER SERVLET" );
		this.dispatcherServlet( servletContext, applicationContext );

		log.info( " CONTEXT LOADER LISTENER" );
		servletContext.addListener( new ContextLoaderListener( applicationContext )  );

		/** SESSION LISTENER
		 	SPRING SECURITY AuthenticationSuccessHandler 에서 처리하기때문에 주석처리
		log.info( " SESSION LISTENER" );
		this.sessionListener( servletContext ); **/

		/** CHARACTER ENCODING FILTER **/
		log.info( " CHARACTER ENCODING FILTER" );
		this.characterEncodingFilter( servletContext );

		/** SPRING SECURITY FILTER **/
		log.info( " SPRING SECURITY FILTER" );
		this.springSecurityFilterChain( servletContext );

		/** FORM CONTENT FILTER **/
		log.info( " FORM CONTENT FILTER" );
		this.formContentFilter( servletContext );

		/** SITE MESH FILTER
		 	TILES 로 변경함
		log.info( " SITE MESH FILTER" );
		this.siteMeshFilter( servletContext ); **/

		/** MOBILE DEVICE FILTER **/
		log.info( " MOBILE DEVICE FILTER" );
		this.deviceResolverRequestFilter( servletContext );


		/** MULTI PART FILTER **/
		log.info( " MULTI PART FILTER" );
		multipartFilter(servletContext);


		/** LUCY XSS FILTER **/
		log.info( " LUCY XSS FILTER" );
		lucyXssFilter(servletContext);

		log.info( " WebInitializer E N D ===============================" );
	}




	private void dispatcherServlet( ServletContext servletContext, WebApplicationContext applicationContext ) {
		DispatcherServlet dispatcher_servlet = new DispatcherServlet( applicationContext );
		dispatcher_servlet.setThrowExceptionIfNoHandlerFound( true );
		ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher", dispatcher_servlet );
		dispatcher.setLoadOnStartup( 0 );
		dispatcher.addMapping( Constrants.FILTER_TARGET_URLS );
	}


	@SuppressWarnings("unused")
	private void sessionListener( ServletContext  servletContext ) {
		servletContext.addListener( new SessionListener( Constrants.SESSION_MAX_INACTIVE_INTERVAL ) );
	}

    private void characterEncodingFilter( ServletContext  servletContext ) {
        FilterRegistration.Dynamic filter = servletContext.addFilter("characterEncodingFilter", new CharacterEncodingFilter());
	        filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true, Constrants.FILTER_TARGET_URLS );
	        filter.setInitParameter("encoding",  StandardCharsets.UTF_8.name() );
	        filter.setInitParameter("forceEncoding", "true");
    }

	private void springSecurityFilterChain( ServletContext  servletContext ) {
		FilterRegistration.Dynamic filter = servletContext.addFilter("springSecurityFilterChain", new DelegatingFilterProxy("springSecurityFilterChain"));
			filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class) , true, Constrants.FILTER_TARGET_URLS );
	}

    private void formContentFilter( ServletContext  servletContext ) {
    	FilterRegistration.Dynamic filter = servletContext.addFilter("formContentFilter", new FormContentFilter() );
    	   	filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true,  Constrants.FILTER_TARGET_URLS );
	}


    @SuppressWarnings("unused")
	private void siteMeshFilter( ServletContext  servletContext ) {
    	@SuppressWarnings("deprecation")
		Resource config_resource = ConfigUtils.getResource( Constrants.SITEMESH_CONFIG_LOCATION );
    	FilterRegistration.Dynamic filter = servletContext.addFilter("siteMeshFilter", SiteMeshFilter.of( config_resource ) );
    	   	filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true, Constrants.FILTER_TARGET_URLS );
	}

	private void deviceResolverRequestFilter(ServletContext servletContext) {
		DeviceResolverRequestFilter deviceResolverRequestFilter = new DeviceResolverRequestFilter();
		FilterRegistration.Dynamic filter = servletContext.addFilter("deviceResolverRequestFilter", deviceResolverRequestFilter);
	   	filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true,  Constrants.FILTER_TARGET_URLS );
	}


	private void multipartFilter(ServletContext servletContext) {
		MultipartFilter multipartFilter = new MultipartFilter();
		FilterRegistration.Dynamic filter = servletContext.addFilter("multipartFilter", multipartFilter);
		filter.setInitParameter("multipartResolverBeanName", "multipartResolver");
		filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true,  Constrants.FILTER_TARGET_URLS );
	}


	private void lucyXssFilter(ServletContext servletContext) {
		CustomXssEscapeServletFilter lucyXssFilter = new CustomXssEscapeServletFilter( Constrants.LUCY_XSS_FILTER_CONFIG_LOCATION );
		FilterRegistration.Dynamic filter = servletContext.addFilter("lucyXssFilter", lucyXssFilter);
		filter.addMappingForUrlPatterns( EnumSet.allOf(DispatcherType.class), true,  Constrants.FILTER_TARGET_URLS );
	}


	private void log4j2Configlocation( String active_profile ) {
		try {
			String location = StringUtils.replaceOnce(  Constrants.LOG4J2_CONFIG_LOCATION, "${spring.profiles.active}", active_profile);
			System.out.println( " ##### LOG4J2 CONFIG FILE: "+ location );

			Resource resource = ConfigUtils.getResource( location );
			URI uri = resource.getURI();
			System.out.println( " ##### LOG4J2 CONFIG URI: "+ uri );

			LoggerContext context = (LoggerContext) LogManager.getContext( false );
			context.setConfigLocation( uri  );
		}catch( Exception e ) {
			e.printStackTrace();
		}
	}

}
