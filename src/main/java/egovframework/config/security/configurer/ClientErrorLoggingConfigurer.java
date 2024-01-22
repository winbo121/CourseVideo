package egovframework.config.security.configurer;

import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.access.intercept.FilterSecurityInterceptor;

import egovframework.config.security.filter.ClientErrorLoggingFilter;
import lombok.Setter;

public class ClientErrorLoggingConfigurer extends AbstractHttpConfigurer<ClientErrorLoggingConfigurer, HttpSecurity> {

	@Setter
	private List<HttpStatus> errorCodes;

	 @Override
	 public void init(HttpSecurity http) throws Exception {
		 /** 초기화 **/
	 }


	 @Override
	 public void configure(HttpSecurity http) throws Exception {

		 /** 제대로 동작시키려면 ExceptionTranslationFilter before 에 주입시켜야할것 같음.  **/
		 http.addFilterAfter( new ClientErrorLoggingFilter( this.errorCodes), FilterSecurityInterceptor.class);
	 }

}
