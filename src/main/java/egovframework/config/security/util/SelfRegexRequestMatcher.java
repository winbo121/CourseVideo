package egovframework.config.security.util;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.web.util.matcher.RegexRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;

public class SelfRegexRequestMatcher implements RequestMatcher {

	private String pattern = null;
	private String httpMethod = null;
	private RegexRequestMatcher requestMatcher = null;

	public SelfRegexRequestMatcher(String pattern, String httpMethod) {
		this( pattern, httpMethod, false );
	}

	public SelfRegexRequestMatcher(String pattern, String httpMethod, boolean caseInsensitive) {
		this.requestMatcher = new RegexRequestMatcher(pattern, httpMethod, caseInsensitive);

		this.pattern = pattern;
		this.httpMethod = httpMethod;
	}

	@Override
	public boolean matches(HttpServletRequest request) {
		return requestMatcher.matches(request);
	}

	@Override
	public boolean equals(Object obj) {
		if (!(obj instanceof SelfRegexRequestMatcher)) {
			return false;
		}

		SelfRegexRequestMatcher key = (SelfRegexRequestMatcher) obj;

		if (!pattern.equals(key.pattern)) {
			return false;
		}

		if (httpMethod == null) {
			return key.httpMethod == null;
		}

		return httpMethod.equals(key.httpMethod);

	}

	@Override
	public int hashCode() {
		// CHECKSTYLE:OFF
		int code = 31 ^ pattern.hashCode();
        // CHECKSTYLE:ON

		if (httpMethod != null) {
            code ^= httpMethod.hashCode();
        }

        return code;
    }
}
