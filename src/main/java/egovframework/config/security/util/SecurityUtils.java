package egovframework.config.security.util;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.WebSecurity.IgnoredRequestConfigurer;

public class SecurityUtils {

	private SecurityUtils() {}


	/** SPRING SECURITY IGNORE ANT **/
	public static IgnoredRequestConfigurer ignoreAntMatcher( IgnoredRequestConfigurer ignoredConfig, HttpMethod http_method, String pattern ) {
		if( http_method != null && StringUtils.isNotEmpty( pattern )  ) {
			return ignoredConfig.antMatchers(http_method, pattern );
		}else if( http_method == null && StringUtils.isNotEmpty( pattern ) ) {
			return ignoredConfig.antMatchers(pattern);
		}else if( http_method != null && StringUtils.isEmpty( pattern ) ) {
			return ignoredConfig.antMatchers(http_method);
		}
		return ignoredConfig;
	}


	/** SPRING SECURITY IGNORE REGEX **/
	public static IgnoredRequestConfigurer ignoreRegexMatcher( IgnoredRequestConfigurer ignoredConfig, HttpMethod http_method, String pattern ) {
		if( http_method != null && StringUtils.isNotEmpty( pattern )  ) {
			return ignoredConfig.regexMatchers(http_method, pattern);
		}else if( http_method == null && StringUtils.isNotEmpty( pattern ) ) {
			return ignoredConfig.regexMatchers(pattern);
		}
		return ignoredConfig;
	}

	/** SPRING SECURITY IGNORE MVC **/
	public static IgnoredRequestConfigurer ignoreMvcMatcher( IgnoredRequestConfigurer ignoredConfig, HttpMethod http_method, String pattern ) {
		if( http_method != null && StringUtils.isNotEmpty( pattern )  ) {
			return ignoredConfig.mvcMatchers(http_method, pattern);
		}else if( http_method == null && StringUtils.isNotEmpty( pattern ) ) {
			return ignoredConfig.mvcMatchers(pattern);
		}
		return ignoredConfig;
	}


}
