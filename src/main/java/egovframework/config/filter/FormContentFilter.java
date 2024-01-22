package egovframework.config.filter;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpInputMessage;
import org.springframework.http.MediaType;
import org.springframework.http.converter.FormHttpMessageConverter;
import org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.util.MultiValueMap;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;


/**
 * SPRING 4.X 에는 없어서, SPRING 5.X 에서 복사해왔음.
 * "PUT", "PATCH", "DELETE" METHOD 전문에 대해서도 @ModelAttribute 로 처리할수있게한다.
 * @author yoon
 */
public class FormContentFilter extends OncePerRequestFilter {

	private static final List<String> HTTP_METHODS = Arrays.asList("PUT", "PATCH", "DELETE");

	private FormHttpMessageConverter formConverter = new AllEncompassingFormHttpMessageConverter();


	/**
	 * Set the converter to use for parsing form content.
	 * <p>By default this is an instance of {@link AllEncompassingFormHttpMessageConverter}.
	 */
	public void setFormConverter(FormHttpMessageConverter converter) {
		Assert.notNull(converter, "FormHttpMessageConverter is required");
		this.formConverter = converter;
	}

	/**
	 * The default character set to use for reading form data.
	 * This is a shortcut for:<br>
	 * {@code getFormConverter.setCharset(charset)}.
	 */
	public void setCharset(Charset charset) {
		this.formConverter.setCharset(charset);
	}


	@Override
	protected void doFilterInternal(
			HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		MultiValueMap<String, String> params = parseIfNecessary(request);
		if (!CollectionUtils.isEmpty(params)) {
			filterChain.doFilter(new FormContentRequestWrapper(request, params), response);
		}
		else {
			filterChain.doFilter(request, response);
		}
	}


	private MultiValueMap<String, String> parseIfNecessary(HttpServletRequest request) throws IOException {
		if (!shouldParse(request)) {
			return null;
		}

		HttpInputMessage inputMessage = new ServletServerHttpRequest(request) {
			@Override
			public InputStream getBody() throws IOException {
				return request.getInputStream();
			}
		};
		return this.formConverter.read(null, inputMessage);
	}

	private boolean shouldParse(HttpServletRequest request) {
		String contentType = request.getContentType();
		String method = request.getMethod();
		if (StringUtils.hasLength(contentType) && HTTP_METHODS.contains(method)) {
			try {
				MediaType mediaType = MediaType.parseMediaType(contentType);
				return MediaType.APPLICATION_FORM_URLENCODED.includes(mediaType);
			}
			catch (IllegalArgumentException ex) {
			}
		}
		return false;
	}


	private static class FormContentRequestWrapper extends HttpServletRequestWrapper {

		private MultiValueMap<String, String> formParams;

		public FormContentRequestWrapper(HttpServletRequest request, MultiValueMap<String, String> params) {
			super(request);
			this.formParams = params;
		}

		@Override
		public String getParameter(String name) {
			String queryStringValue = super.getParameter(name);
			String formValue = this.formParams.getFirst(name);
			return (queryStringValue != null ? queryStringValue : formValue);
		}

		@Override
		public Map<String, String[]> getParameterMap() {
			Map<String, String[]> result = new LinkedHashMap<>();
			Enumeration<String> names = getParameterNames();
			while (names.hasMoreElements()) {
				String name = names.nextElement();
				result.put(name, getParameterValues(name));
			}
			return result;
		}

		@Override
		public Enumeration<String> getParameterNames() {
			Set<String> names = new LinkedHashSet<>();
			names.addAll(Collections.list(super.getParameterNames()));
			names.addAll(this.formParams.keySet());
			return Collections.enumeration(names);
		}

		@Override
		public String[] getParameterValues(String name) {
			String[] parameterValues = super.getParameterValues(name);
			List<String> formParam = this.formParams.get(name);
			if (formParam == null) {
				return parameterValues;
			}
			if (parameterValues == null || getQueryString() == null) {
				return StringUtils.toStringArray(formParam);
			}
			else {
				List<String> result = new ArrayList<>(parameterValues.length + formParam.size());
				result.addAll(Arrays.asList(parameterValues));
				result.addAll(formParam);
				return StringUtils.toStringArray(result);
			}
		}
	}

}
