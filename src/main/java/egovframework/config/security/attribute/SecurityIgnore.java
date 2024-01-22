package egovframework.config.security.attribute;

import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpMethod;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
public class SecurityIgnore {

	/** SPRING SECURITY 제외 MATCHER 유형  regex, ant, mvc **/
	@Setter @Getter
	private String matcher_type;

	/** SPRING SECURITY 제외 HTTP METHOD **/
	@Setter @Getter
	private String http_method;

	/** SPRING SECURITY 제외 URL 패턴  **/
	@Setter @Getter
	private String pattern;

	/** HTTP METHOD **/
	public HttpMethod getMethod() {
		HttpMethod httpMethod = HttpMethod.resolve( StringUtils.upperCase( this.http_method ) );
		return httpMethod;
	}

	/** 유효성 체크 **/
	public Boolean isValid() {
		if( !StringUtils.equalsAny( this.matcher_type, "regex", "ant", "mvc" ) ) {
			throw new IllegalArgumentException("[matcher_type ONLY USE (regex, ant, mvc)]");
		}

		if( StringUtils.isEmpty(this.http_method) && StringUtils.isEmpty(this.pattern)  ) {
			throw new IllegalArgumentException("[http_method and pattern is EMPTY]");
		}

		if( StringUtils.isNotEmpty( this.http_method ) ) {
			HttpMethod httpMethod = HttpMethod.resolve( StringUtils.upperCase( this.http_method ) );
			if( httpMethod == null ) {
				throw new IllegalArgumentException("[http_method is not valid]" + http_method );
			}
		}
		return true;
	}


	/** REGEX MATCHER 인지 확인  **/
	public Boolean isRegex() {
		return StringUtils.equals(this.matcher_type , "regex");
	}
	/** ANT MATCHER 인지 확인  **/
	public Boolean isAnt() {
		return StringUtils.equals(this.matcher_type , "ant");
	}
	/** MVC MATCHER 인지 확인  **/
	public Boolean isMvc() {
		return StringUtils.equals(this.matcher_type , "mvc");
	}

}
