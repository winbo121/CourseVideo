package egovframework.config;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.common.component.rest.logging.LoggingRequestInterceptor;
import egovframework.common.constrant.Constrants;
import egovframework.config.provider.ApplicationContextProvider;

@Configuration
public class EtcConfig {


	/** Message Source **/
	@Bean
	public MessageSource messageSource() {
		ReloadableResourceBundleMessageSource messageSource  = new ReloadableResourceBundleMessageSource();
		messageSource.setBasenames( Constrants.ERROR_MESSAGE_SOURCE, Constrants.MESSAGE_SOURCE );
	    messageSource.setDefaultEncoding( StandardCharsets.UTF_8.name() );
	    return messageSource;
	}


	/** Rest Template  **/
	@Bean
    @Primary
	public RestTemplate restTemplate() {

		RestTemplate template = new RestTemplate();
			template.setMessageConverters( Arrays.asList( new MappingJackson2HttpMessageConverter( new ObjectMapper()  )) );
			template.setInterceptors( Arrays.asList(  new LoggingRequestInterceptor() )  );
 		return template;
	}

    @Autowired
	private ApplicationContext applicationContext;

	@Bean
	public ApplicationContextProvider applicationContextProvider() {

    	ApplicationContextProvider applicationContextProvider = new ApplicationContextProvider();
		applicationContextProvider.setApplicationContext( this.applicationContext );
		return applicationContextProvider;
	}




}
