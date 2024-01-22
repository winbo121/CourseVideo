package egovframework.config.filter.xss;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.navercorp.lucy.security.xss.servletfilter.XssEscapeFilter;
import com.navercorp.lucy.security.xss.servletfilter.XssEscapeFilterConfig;
import com.navercorp.lucy.security.xss.servletfilter.XssEscapeFilterRule;

/**
 * com.navercorp.lucy.security.xss.servletfilter.XssEscapeFilter 재구현
 * @author yoon
 */
public final class CustomXssEscapeFilter  {
	private static final Log LOG = LogFactory.getLog(XssEscapeFilter.class);

	private static CustomXssEscapeFilter xssEscapeFilter;
	private static XssEscapeFilterConfig config;


	private CustomXssEscapeFilter() {}

	/**
	 * @return XssEscapeFilter
	 */
	public static CustomXssEscapeFilter getInstance( String config_path ) {
		try {
			xssEscapeFilter = new CustomXssEscapeFilter();
			config = new XssEscapeFilterConfig( config_path );
		} catch (Exception e) {
			throw new ExceptionInInitializerError(e);
		}
		return xssEscapeFilter;
	}

	/**
	 * @param url String
	 * @param paramName String
	 * @param value String
	 * @return String
	 */
	public String doFilter(String url, String paramName, String value) {
		if (StringUtils.isBlank(value)) {
			return value;
		}

		XssEscapeFilterRule urlRule = config.getUrlParamRule(url, paramName);
		if (urlRule == null) {
			// Default defender 적용
			return config.getDefaultDefender().doFilter(value);
		}
		
		if (!urlRule.isUseDefender()) {
			log(url, paramName, value);
			return value;
		}

		return urlRule.getDefender().doFilter(value);
	}

	/**
	 * @param url String
	 * @param paramName String
	 * @param value String
	 * @return void
	 */
	private void log(String url, String paramName, String value) {
		if (LOG.isDebugEnabled()) {
			LOG.debug("Do not filtered Parameter. Request url: " + url + ", Parameter name: " + paramName + ", Parameter value: " + value);
		}
	}
}
