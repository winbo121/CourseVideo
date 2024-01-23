package egovframework.common.constrant;

import java.util.List;
import com.google.common.collect.Lists;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE )
public class Constrants {

	/** COMPONENT SCAN 대상 PACKAGE **/
	public static final String COMMON_PACKAGE = "egovframework.common";
	public static final String BUSINESS_PACKAGE = "egovframework.work";
	public static final String CONFIG_PACKAGE = "egovframework.config";
	public static final String SCHEDULER_PACKAGE = "egovframework.scheduler";
	
	/** 다국어메세지 경로 **/
	public static final String MESSAGE_PROPERTIES = "classpath:/message/message-common.properties";
	public static final String MESSAGE_SOURCE = "classpath:/message/message-common"; 

	/** 에러메시지 경로 **/
	public static final String ERROR_MESSAGE_PROPERTIES = "classpath:/messages/error_message.properties";
	public static final String ERROR_MESSAGE_SOURCE = "classpath:/messages/error_message";

	/** 에러페이지 경로 **/
	public static final String ERROR_PAGE_VIEW_NAME = "error_500";

	/** DATE FORMAT  **/
	public static final String YYYY_MM = "yyyy-MM";
	public static final String YYYY_MM_DD = "yyyy-MM-dd";
	public static final String YYYY_MM_DD_HH_MM = "yyyy-MM-dd HH:mm";
	public static final String YYYYMMDDHHMMSS = "yyyyMMddHHmmss";


	public static final String YYYY = "yyyy";
	public static final String YYYYMMDD  = "yyyyMMdd";
	public static final String MM = "MM";
	public static final String HHMMSS = "HHmmss";



	/** 파일 약속어  **/
	public static final String X_FILE_PROMISE = "X_FILE_PROMISE";
	/** 엑셀 다운로드 ATTRIBUTE NAME  **/
	public static final String EXCEL_ATTRIBUTE = "X_EXCEL_ATTRIBUTE";
	/** 엑셀 다운로드 VIEW NAME **/
	public static final String XLS_VIEW_NAME = "XLS_VIEW_NAME";
	/** JSON VIEW NAME **/
	public static final String JSON_VIEW_NAME = "JSON_VIEW_NAME";


	/** 프레임 워크 기본 설정 **/
	public static final String CONFIG_LOCATION = "classpath:config/initialize/config-local.properties";
	/** SPRING SECURITY 설정 경로 **/
	public static final String SECURITY_LOCATION = "classpath:config/security/security.yml";

	/** 탑메뉴 설정 경로 **/
	public static final String TOP_MENU_LOCATION = "classpath:config/menu/top_menu.yml";


	/** MYBATIS 설정 경로 **/
	public static final String MYBATIS_CONFIG_LOCATION = "classpath:config/mybatis-config.xml";
	/** MYBATIS MAPPER 경로 **/
	public static final String MYBATIS_MAPPER_LOCATIONS = "classpath:mapper/**/**/*.xml";


	/** TILES 설정 경로 **/
	public static final List<String> TILES_CONFIG_LOCATIONS = Lists.newArrayList( "classpath:config/tiles/templates.xml");

	/** LOG4J2 설정 경로 **/
	public static final String LOG4J2_CONFIG_LOCATION = "classpath:config/logging/log4j2-local.xml";

	/** SITE MESH 설정 경로 **/
	@Deprecated
	public static final String SITEMESH_CONFIG_LOCATION= "classpath:config/sitemesh/sitemesh3.xml";

	/** EH CACHE 설정 경로 **/
	public static final String EHCACHE_CONFIG_LOCATION = "classpath:config/ehcache3.xml";

	/** LUCY XSS FILTER 설정경로 **/
	public static final String LUCY_XSS_FILTER_CONFIG_LOCATION = "/config/xss/lucy-xss-servlet-filter-rule.xml";


	/** HTTP SESSION 최대 유지 시간 (초) **/
	public static final Integer SESSION_MAX_INACTIVE_INTERVAL = ( 60 * 60 );
	/** FILTER TARGET URLS **/
	public static final String[] FILTER_TARGET_URLS = { "/", "*.do" };


	/** MOBILE JSP SUFFIX **/
	public static final String MOBILE_VIEW_SUFFIX = "_mobile";

	/** REQUEST URI NAME **/
	public static final String REQUEST_URI_NAME = "_KB_REQUEST_URI_";

	/** 회원 정보 변경 필요 여부 **/
	public static final String NEED_MODIFY_USER = "_NEED_MODIFY_USER_";

	@Deprecated
	public static final String META_NAME = "_KOTECHLMS_META_";

	/** MAIL_HOST **/
	public static final String MAIL_HOST = "smtp.naver.com";
	/** MAIL_USER_NAME **/
	public static final String MAIL_USER_ID = "ghgurwls";
	/** MAIL_PASSWORD **/
	public static final String MAIL_PASSWORD = "kotech1234!";
	/** MAIL_TAIL **/
	public static final String MAIL_TAIL = "@naver.com";
	
	
	
	/** 회원 인증된 이메일 세션 보관용 키값 **/
	public static final String AUTHENTIFICATION_USEREMAIL_KEY = "_AUTHENTIFICATION_USEREMAIL_";
	
	/** 재 로그인 여부 키값 **/
	public static final String RE_LOGIN_AUTHENTIFICATION_KEY = "_IS_RE_LOGIN_AUTHENTIFICATION_";
	
	
	/** 쿠키에 담을 아이디 키값 **/
	public static final String REMEMBER_USER_ID_KEY = "_KOTECHLMS_REMEMBER_ID_";
	
	/** 쿠키가 유지되는 일 **/
	public static final int REMEMBER_ID_MAX_AGE = 30;
	
	
}
