package egovframework.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.http.client.BufferingClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.mobile.device.DeviceHandlerMethodArgumentResolver;
import org.springframework.mobile.device.DeviceResolverHandlerInterceptor;
import org.springframework.mobile.device.site.SitePreferenceHandlerInterceptor;
import org.springframework.mobile.device.site.SitePreferenceHandlerMethodArgumentResolver;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;
import org.yaml.snakeyaml.Yaml;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Iterables;

import egovframework.common.component.rest.logging.LoggingRequestInterceptor;
import egovframework.common.constrant.Constrants;
import egovframework.common.menu.attribute.MenuAttribute;
import egovframework.common.view.excel.XlsView;
import egovframework.config.interceptor.MenuInterceptor;
import egovframework.config.interceptor.WebLogInterceptor;
import egovframework.config.resolver.CustomCommonsMultipartResolver;
import egovframework.config.resolver.CustomLiteDeviceDelegatingViewResolver;
import egovframework.config.security.attribute.SecurityAttribute;
import egovframework.config.util.ConfigUtils;
import egovframework.work.main.model.main.SendMail;

@Configuration
@EnableAspectJAutoProxy
@EnableWebMvc
@ComponentScan(basePackages = { Constrants.COMMON_PACKAGE, Constrants.BUSINESS_PACKAGE, Constrants.CONFIG_PACKAGE, Constrants.SCHEDULER_PACKAGE } )
@PropertySource( Constrants.CONFIG_LOCATION )
public class WebMvcConfig extends WebMvcConfigurerAdapter {

	/** STATIC RESOURCE **/
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		/** STATIC 경로 설정 **/
		registry.addResourceHandler( "/js/**"   ).addResourceLocations( "classpath:/static/js/"   );
		registry.addResourceHandler( "/assets/**"   ).addResourceLocations( "classpath:/static/assets/"   );
		registry.addResourceHandler( "/images/**"   ).addResourceLocations( "classpath:/static/images/"   );
		registry.addResourceHandler( "/css/**"   ).addResourceLocations( "classpath:/static/css/"   );
		registry.addResourceHandler( "/common/**"   ).addResourceLocations( "classpath:/static/common/"   );
		registry.addResourceHandler( "/styles/**"   ).addResourceLocations( "classpath:/static/styles/"   );
	}


	private static final String ADD_PATH_PATTERNS =  "/**/*.do";
	private static final String[] EXCLUDE_PATH_PATTERNS = {"/**/jsp_paging.do"					//paging ajax
															, "/**/**/jsp_paging.do"			//paging ajax
															, "/*duplicate_check.do"			//중복체크
															, "/conage/contentEnroll/insert.do", "/conage/contentEnroll/delete.do"											//콘텐츠 관련 ajax
															, "/conage/courseEnroll/insert.do" , "/conage/courseEnroll/delete.do" , "/conage/courseEnroll/change.do"		//강좌 관련 ajax
															, "/course/checkVideoTime.do"		//플레이어 시간 체크 ajax
															, "/course/starReviewInsert.do"		//별점 ajax
															, "/oauth/*/callback.do"			//oauth
															, "/notice/noticeListAjax.do"
															, "/course/coursePlay.do"
															, "/course/jwplayerVideo.do"
															, "/search/saveData.do"				//검색 로그 저장(공통)
															};

	@Bean
    public WebLogInterceptor webLogInterceptor(){
        return new WebLogInterceptor();
    }

	/** INTERCEPTOR **/
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		
	
		
		/** MENU INTERCEPTOR **/
		registry.addInterceptor( new MenuInterceptor() )
				 .addPathPatterns( ADD_PATH_PATTERNS );
		
		/** LOG INTERCEPTOR **/
		registry.addInterceptor( webLogInterceptor() )
				 .addPathPatterns( ADD_PATH_PATTERNS )
				 .excludePathPatterns(EXCLUDE_PATH_PATTERNS);

		/** MOBILE DEVICE INTERCEPTOR **/
		registry.addInterceptor( new DeviceResolverHandlerInterceptor() )
				 .addPathPatterns( ADD_PATH_PATTERNS );
		registry.addInterceptor( new SitePreferenceHandlerInterceptor() )
				 .addPathPatterns( ADD_PATH_PATTERNS );
	}
	
	
	
	/** ARGUMENT RESOLVER 	**/
	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		/** MOBILE DEVICE ARGUMENT RESOLVER **/
		argumentResolvers.add( new DeviceHandlerMethodArgumentResolver() );
		argumentResolvers.add( new SitePreferenceHandlerMethodArgumentResolver() );
	}





	/** TILES 설정 **/
	@Bean
	public TilesConfigurer tilesConfigurer() {
	     final TilesConfigurer configurer = new TilesConfigurer();
        //타일즈 설정파일이 위치하는 디렉토리+파일명
        configurer.setDefinitions( Iterables.toArray(Constrants.TILES_CONFIG_LOCATIONS, String.class ) );
        configurer.setCheckRefresh( true );
        return configurer;
	}




	/** VIEW RESOLVER **/
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		/** BEAN NAME VIEW RESOLVER **/
		registry.viewResolver( new BeanNameViewResolver() );



		/** TILES VIEW RESOLVER **/
		UrlBasedViewResolver tilesViewResolver = new UrlBasedViewResolver();
		tilesViewResolver.setViewClass( TilesView.class );
		tilesViewResolver.setPrefix("/");

		CustomLiteDeviceDelegatingViewResolver liteDeviceDelegatingViewResolver = new CustomLiteDeviceDelegatingViewResolver( tilesViewResolver );
		liteDeviceDelegatingViewResolver.setMobileSuffix("/_mobile");
		liteDeviceDelegatingViewResolver.setTabletSuffix("/_mobile");
		liteDeviceDelegatingViewResolver.setEnableFallback( true );


		registry.viewResolver( liteDeviceDelegatingViewResolver );



//		/** URL BASED VIEW RESOLVER **/
//		UrlBasedViewResolver delegate = new UrlBasedViewResolver();
//		delegate.setViewClass(JstlView.class);
//		delegate.setPrefix("/WEB-INF/jsp/");
//		delegate.setSuffix(".jsp");
//
//		/** PC, MOBILE, TABLET 에 따라서 VIEW가 달려져야 하는경우 	 **/
//		CustomLiteDeviceDelegatingViewResolver liteDeviceDelegatingViewResolver = new CustomLiteDeviceDelegatingViewResolver( delegate );
//		liteDeviceDelegatingViewResolver.setMobileSuffix( Constrants.MOBILE_VIEW_SUFFIX );
//		liteDeviceDelegatingViewResolver.setTabletSuffix( Constrants.MOBILE_VIEW_SUFFIX );
//		liteDeviceDelegatingViewResolver.setEnableFallback( true );
//
//		registry.viewResolver( liteDeviceDelegatingViewResolver );
	}




	/** TILES VIEW **/
    @Bean
    public TilesViewResolver tilesViewResolver() {
        final TilesViewResolver tilesViewResolver = new TilesViewResolver();
        tilesViewResolver.setViewClass(TilesView.class);
        return tilesViewResolver;
    }



	/** JSON RESPONSE VIEW  **/
	@Bean(name=Constrants.JSON_VIEW_NAME )
	public MappingJackson2JsonView jsonView() {
		MappingJackson2JsonView view = new MappingJackson2JsonView();
		view.setContentType("text/html;charset=UTF-8");
		return view;
	}
	/** XLS DOWNLOAD VIEW  **/
	@Bean(name=Constrants.XLS_VIEW_NAME)
	public XlsView xlsView() {
		return new XlsView();
	}




	/** 최대 파일 사이즈 **/
	@Value(value="${spring.servlet.multipart.max-file-size}")
	private String max_file_size;
	/** 최대 요청 사이즈 **/
	@Value(value="${spring.servlet.multipart.max-request-size}")
	private String max_request_size;

	/** MB 를 BYTE 로 변환한다. **/
	private static final Function< String, Integer > MB_TO_BYTE = ( mb ) -> Optional.ofNullable( mb )
																							 			.map( str -> str.replace("MB", "") )
																							 			.filter( StringUtils::isNumeric )
																							 			.map( Integer::parseInt )
																							 			.map( integer -> integer  *1024 * 1024  )
																							 			.orElseGet( () ->  10 * 1024 * 1024 );
	/** MULTIPART RESOLVER **/
	@Bean
	public MultipartResolver multipartResolver() {
		CustomCommonsMultipartResolver multipartResolver = new CustomCommonsMultipartResolver();
		      multipartResolver.setMaxUploadSize( MB_TO_BYTE.apply( this.max_file_size ) -1);
		      multipartResolver.setMaxUploadSizePerFile( MB_TO_BYTE.apply( this.max_request_size ) -1   );
		      multipartResolver.setMaxInMemorySize(0);
		      multipartResolver.setDefaultEncoding( StandardCharsets.UTF_8.name() );
	      return multipartResolver;
	}


	/** SPRING BEAN VALIDATOR **/
	@Bean
	public LocalValidatorFactoryBean validator() {
		return new LocalValidatorFactoryBean();
	}

	/** YAML  **/
	@Bean
	public Yaml yaml() {
		return new Yaml();
	}

	/** SPRING SECURITY 설정 **/
	@Bean
	public SecurityAttribute securityAttribute() {

		Resource resource =  ConfigUtils.getResource( Constrants.SECURITY_LOCATION );

		try( InputStream inputStream = resource.getInputStream();  ){
			SecurityAttribute result = yaml().loadAs( inputStream, SecurityAttribute.class);
			return result;
		}catch( Exception  e ) {
			e.printStackTrace();
			/** 데이터가 세팅되지 않은 SecurityAttribute 던짐으로써 오류가 발생된다. **/
			return new SecurityAttribute();
		}
	}

	

	/** 메뉴 설정 **/
	@Bean
	public MenuAttribute menuAttribute()  throws IOException {
		Resource resource =  ConfigUtils.getResource( Constrants.TOP_MENU_LOCATION );

		try( InputStream inputStream = resource.getInputStream();  ){
			MenuAttribute attribute =  yaml().loadAs(inputStream, MenuAttribute.class);
			return attribute;
		}

	}


	/** 메일 발송 **/
	@Bean
	public SendMail sendMail() {
		SendMail sendMail = new SendMail();
				sendMail.setHost( Constrants.MAIL_HOST );
				sendMail.setUser_id( Constrants.MAIL_USER_ID );
				sendMail.setPassword( Constrants.MAIL_PASSWORD );
				sendMail.setEmail_tail( Constrants.MAIL_TAIL );
		return sendMail;
	}


	/** REST TEMPLATE **/
	@Bean
    @Primary
	public RestTemplate restTemplate() {

        SimpleClientHttpRequestFactory simple = new SimpleClientHttpRequestFactory();
        simple.setReadTimeout(1000*60*5);
        simple.setConnectTimeout(1000*60*5);

        ClientHttpRequestFactory factory = new BufferingClientHttpRequestFactory(simple);

        List<ClientHttpRequestInterceptor> interceptors = new ArrayList<>();
        	interceptors.add(new LoggingRequestInterceptor());


        MappingJackson2HttpMessageConverter jackson2HttpMessageConverter = new MappingJackson2HttpMessageConverter();
	        jackson2HttpMessageConverter.setSupportedMediaTypes(  Arrays.asList(  MediaType.APPLICATION_JSON ,  MediaType.TEXT_HTML , MediaType.APPLICATION_FORM_URLENCODED)  );
	        jackson2HttpMessageConverter.setObjectMapper(new ObjectMapper());

	    FormHttpMessageConverter formHttpMessageConverter = new FormHttpMessageConverter();

	    List<HttpMessageConverter<?>> messageConverters = Arrays.asList( jackson2HttpMessageConverter
	    																, formHttpMessageConverter);

        RestTemplate template =  new RestTemplate( factory );
        			template.setInterceptors(interceptors);
        			template.setMessageConverters(messageConverters);

 		return template;
	}
	
	


}
