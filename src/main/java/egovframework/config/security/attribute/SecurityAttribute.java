package egovframework.config.security.attribute;

import java.util.ArrayList;
import java.util.List;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.Assert;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * SPRING BOOT SECURITY 사용 설정
 * @author yoon
 */
@Getter @Setter @ToString
public class SecurityAttribute  implements InitializingBean {

	/** 인증 성공 이후 이동 URL **/
	private String login_default_target_url;

	/** 인증 성공이후 세션 최대 유지시간 (SECOND) **/
	private Integer login_max_inactive_interval;

	/** 인증 실패 이후 이동 URL **/
	private String login_default_fail_url;

	/** 인증 처리 URL  **/
	private String login_form_url;
	
	/** Ajax 인증 처리 URL **/
	private String ajax_login_url;

	/** 인증시 로그인 아이디 (파라미터) **/
	private String login_username;

	/** 인증시 로그인 비밀번호 (파라미터)  **/
	private String login_password;

	/** 로그아웃 URL **/
	private String logout_url;

	/** 로그아웃 성공 이후 이동 URL **/
	private String logout_default_target_url;

	/** 권한 없음 URL  **/
	private String access_denied_url;

	/** 세션 만료 URL **/
	private String session_expired_url;

	/** 한 사용자당 최대 허용 세션 수량 **/
	private Integer maximum_sessions;

	/** URL ACL 동작시에 REQUEST MATCHER 유형  regex, ciRegex, ant **/
	private String request_matcher_type;

	/** SNIFF 사용 여부  **/
	private Boolean use_sniff;

	/** XSS 보호 사용 여부  **/
	private Boolean use_xss_protection;

	/** SAMEORIGIN , DENY  **/
	private String x_frame_option;

	/** CSRF 사용 여부  **/
	private Boolean use_csrf;

	/** SPRING SECURITY 제외 리스트  **/
	private List<SecurityIgnore> ignore_list = new ArrayList<>();

	/** 생성자 default 초기값 설정 **/
	public SecurityAttribute() {}

	/** SPRING SECURITY CSRF 제외 **/
	public String[] getCsrfIgnores() {
		String[] csrf_ignore = new String[]{ this.login_form_url ,this.logout_url, this.ajax_login_url };
		return csrf_ignore;
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		/** SPRING BEANS 생성이후에 해당 설정을 체크하는 메서드 **/
		Assert.hasLength(this.login_default_target_url, "[login_default_target_url IS EMPTY]");

		Assert.notNull( this.login_max_inactive_interval , "[login_max_inactive_interval IS NULL]");

		Assert.hasLength(this.login_default_fail_url, "[login_default_fail_url IS EMPTY]");
		Assert.hasLength(this.login_form_url, "[login_form_url IS EMPTY]");

		Assert.hasLength(this.login_username, "[login_username IS EMPTY]");
		Assert.hasLength(this.login_password, "[login_password IS EMPTY]");
		Assert.hasLength(this.logout_url, "[logout_url IS EMPTY]");

		Assert.hasLength(this.logout_default_target_url, "[logout_default_target_url IS EMPTY]");
		Assert.hasLength(this.access_denied_url, "[access_denied_url IS EMPTY]");
		Assert.hasLength(this.session_expired_url, "[session_expired_url IS EMPTY]");
		Assert.notNull(this.maximum_sessions, "[maximum_sessions IS NULL]");


		if( !StringUtils.equalsAnyIgnoreCase(this.request_matcher_type, "regex", "ciRegex", "ant"  ) ) {
			throw new IllegalArgumentException("[request_matcher_type ONLY USE (regex, ciRegex, ant) ]");
		}

		Assert.notNull(this.use_sniff, "[use_sniff IS NULL]");
		Assert.notNull(this.use_xss_protection, "[use_xss_protection IS NULL]");

		if( !StringUtils.equalsAnyIgnoreCase(this.x_frame_option, "SAMEORIGIN", "DENY") ) {
			throw new IllegalArgumentException("[x_frame_option ONLY USE (SAMEORIGIN, DENY)]");
		}
		Assert.notNull(this.use_csrf, "[use_csrf IS NULL]");


		if( CollectionUtils.isNotEmpty( this.ignore_list ) ) {
			for ( SecurityIgnore ignore : this.ignore_list) {
				ignore.isValid();
			}
		}
	}



}
