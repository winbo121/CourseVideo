package egovframework.common.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.Duration;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.jetty.http.HttpCookie;
import org.springframework.mobile.device.Device;
import org.springframework.mobile.device.DeviceUtils;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class CommonUtils {


	/** 응답을 JSP 로 보내는지 확인한다. **/
	public static boolean isResponseJsp( HttpServletRequest request ) {
		return Optional.ofNullable( request )
							.map(  req -> {
								if( StringUtils.equalsIgnoreCase( req.getHeader("X-Ajax-Yn"), "Y" ) ) { return false; }
								if( StringUtils.equalsIgnoreCase(  req.getParameter("X-Ajax-Yn"), "Y" ) ) { return false; }
								if( StringUtils.equalsIgnoreCase( req.getHeader("X-Requested-With")  , "XMLHttpRequest")) { return false; }
								return  true;
							})
							.orElse( true );
	}

	/** CLIENT IP 조회 **/
	public static String getClientIp( HttpServletRequest request ) {
		return Optional.ofNullable( request )
				.map( req -> {
					String client_ip = req.getHeader("X-Forwarded-For");
					if( ! StringUtils.isBlank( client_ip ) ) {
						return client_ip;
					}else {
						return req.getRemoteAddr();
					}
				})
				.orElse( null );
	}

	/**
	 * COOKIE 를 추가한다.
	 */
	public static void addCookie( String name, String value,  Duration duration  ) {

		Integer maxAge = Long.valueOf( duration.getSeconds() ).intValue();
			Cookie cookie = new Cookie(name, value);
			cookie.setPath("/");
			cookie.setSecure(false);
			cookie.setMaxAge( maxAge );
			cookie.setComment( HttpCookie.SAME_SITE_STRICT_COMMENT );
		getResponse().addCookie(cookie);


//		ResponseCookie response_cookie
//			= ResponseCookie.from(name, value)
//				.sameSite("Strict") /** Strict, Lax, None **/
//				.secure(false)
//				.path("/")
//				.maxAge( duration )
//				.build();
//		getResponse().addHeader(HttpHeaders.SET_COOKIE, cookie.toString() );

	}


	public static HttpServletRequest getRequest() {
		return getOptionalRequest()
					.orElseThrow( () -> new RuntimeException("Cannot access Http Request.") );
	}

	public static HttpServletResponse getResponse() {
		return getOptionalResponse()
					.orElseThrow( () -> new RuntimeException("Cannot access Http Response.") );
	}

	public static Optional< HttpServletRequest > getOptionalRequest() {
		return Optional.ofNullable(  RequestContextHolder.getRequestAttributes() )
							.map( attr -> { return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes() ).getRequest(); } );
	}

	public static  Optional< HttpServletResponse > getOptionalResponse() {
		return Optional.ofNullable(  RequestContextHolder.getRequestAttributes() )
				.map( attr -> { return ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes() ).getResponse(); } );
	}


	private static Device getDevice() {
		return DeviceUtils.getCurrentDevice( getRequest() );
	}
	/** HTTP REQUEST 가 PC 인지 확인  **/
	public static boolean isDeviceNormal() {
		return Optional.ofNullable( getDevice() )
					.map( Device::isNormal )
					.orElseGet( () -> false );
	}
	/** HTTP REQUEST 가 TABLET 인지 확인  **/
	public static boolean isDeviceTablet() {
		return Optional.ofNullable( getDevice() )
					.map( Device::isTablet )
					.orElseGet( () -> false );
	}
	/** HTTP REQUEST 가 MOBILE 인지 확인  **/
	public static boolean isDeviceMobile() {
		return Optional.ofNullable( getDevice() )
					.map( Device::isMobile )
					.orElseGet( () -> false );
	}

	private static final ObjectMapper JSON_OBJECT_MAPPER = new ObjectMapper();


	public static final	Function<Object, String> TO_JSON = object -> {
		try {
			return JSON_OBJECT_MAPPER.writeValueAsString( object );
		}catch( JsonProcessingException e) {
			return null;
		}
	};
	
	
	public static final	BiFunction<String, Class<?>, ?> TO_OBJECT = ( json, cl ) -> {
		try {
			return JSON_OBJECT_MAPPER.readValue( json, cl );
		}catch( JsonProcessingException e) {
			return null;
		} catch (IOException e) {
			return null;
		}
	};

	public static boolean isBlackWords(List<String> blackWords, String word) {
		Set<String> filteredBlackWords = getFiteredBlackWords(blackWords, word);
		return (filteredBlackWords.size() > 0) ? true : false;
	}
	
	public static Set<String> getFiteredBlackWords(List<String> blackWords, String word) {
		if(word == null) {
			return new HashSet<>();
		}
		
		String blackWordsRegEx = "";
		for(String bWord : blackWords) {
			blackWordsRegEx +=  bWord + "|";
		}

		if(blackWordsRegEx.length() > 0) {
			blackWordsRegEx = blackWordsRegEx.substring(0, blackWordsRegEx.length() - 1);
		}
		
		Set<String> fiteredBlackWords = new HashSet<>();
		Pattern p = Pattern.compile(blackWordsRegEx, Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(word);
		while(m.find()) {
			fiteredBlackWords.add(m.group());
		 }
		
		String match = "[^\uAC00-\uD7A30-9a-zA-Z]";
		String reWord = word.replaceAll(match, "");
		Pattern p2 = Pattern.compile(blackWordsRegEx, Pattern.CASE_INSENSITIVE);
		Matcher m2= p2.matcher(reWord);
		while(m2.find()) {
			fiteredBlackWords.add(m2.group());
		 }
		
		return fiteredBlackWords;
	}
	
	/** Filter에서 Json Result 결과값을 Out 처리해주는 메서드 **/
	public static void writerJsonResponse(HttpServletResponse response, String result, String msg) {
		
		try {
			
        response.setContentType("application/json");
        response.setCharacterEncoding("utf-8");

        String data = StringUtils.join(new String[] {
             " {",
             " \"result\" : \"" , result , "\", ",
             " \"msg\" : \"", msg , "\" ",
             "} "
        });

        	PrintWriter out;
			out = response.getWriter();
			out.print(data);
			out.flush();
			out.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
