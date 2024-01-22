package egovframework.work.oauth.model;

import org.apache.commons.lang3.StringUtils;

import com.github.scribejava.apis.FacebookApi;
import com.github.scribejava.apis.GoogleApi20;
import com.github.scribejava.apis.InstagramApi;
import com.github.scribejava.apis.KakaoApi;
import com.github.scribejava.apis.NaverApi;
import com.github.scribejava.core.builder.api.DefaultApi20;

import egovframework.work.oauth.service.TwitterAPI20;

public class OAuthVO implements OAuthConfig {
	
	public String getService() {
		return serviceName;
	}

	public void setService(String service) {
		this.serviceName = service;
	}

	public String getClientId() {
		return clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	public String getClientSecret() {
		return clientSecret;
	}

	public void setClientSecret(String clientSecret) {
		this.clientSecret = clientSecret;
	}

	public String getRedirectUrl() {
		return redirectUrl;
	}

	public void setRedirectUrl(String redirectUrl) {
		this.redirectUrl = redirectUrl;
	}
	
	public String getRevokeUrl() {
		return revokeUrl;
	}

	public void setRevokeUrl(String revokeUrl) {
		this.revokeUrl = revokeUrl;
	}

	public DefaultApi20 getApi20Instance() {
		return api20Instance;
	}

	public void setApi20Instance(DefaultApi20 api20Instance) {
		this.api20Instance = api20Instance;
	}

	public String getProfileUrl() {
		return profileUrl;
	}

	public void setProfileUrl(String profileUrl) {
		this.profileUrl = profileUrl;
	}

	public String getScope_data() {
		return scope_data;
	}

	public void setScope_data(String scope_data) {
		this.scope_data = scope_data;
	}

	
	public boolean isKakao() {
		return isKakao;
	}
	
	public boolean isNaver() {
		return isNaver;
	}
	
	public boolean isFacebook() {
		return isFacebook;
	}
	
	public boolean isTwitter() {
		return isTwitter;
	}
	
	public boolean isGoogle() {
		return isGoogle;
	}
	
	public boolean isInstagram() {
		return isInstagram;
	}


	
	public void setGoogle(boolean isGoogle) {
		this.isGoogle = isGoogle;
	}

	public void setNaver(boolean isNaver) {
		this.isNaver = isNaver;
	}
	
	public void setFacebook(boolean isFacebook) {
		this.isFacebook = isFacebook;
	}

	public void setTwitter(boolean isTwitter) {
		this.isTwitter = isTwitter;
	}

	public void setInstagram(boolean isInstagram) {
		this.isInstagram = isInstagram;
	}

	public void setKakao(boolean isKakao) {
		this.isKakao = isKakao;
	}

	private String serviceName;
	private String clientId;
	private String clientSecret;
	private String redirectUrl;
	private String revokeUrl;
	private DefaultApi20 api20Instance;
	private String profileUrl;
	private String scope_data;
	
	private boolean isKakao;
	private boolean isNaver;
	private boolean isFacebook;
	private boolean isTwitter;
	private boolean isInstagram;
	private boolean isGoogle;
	
	
	public OAuthVO(String serviceName, String host) {
		this.serviceName = serviceName;
		
		this.isKakao = StringUtils.equalsIgnoreCase(KAKAO_SERVICE_NAME, serviceName);
		this.isNaver = StringUtils.equalsIgnoreCase(NAVER_SERVICE_NAME, serviceName);
		this.isFacebook = StringUtils.equalsIgnoreCase(FACEBOOK_SERVICE_NAME, serviceName);
		this.isTwitter = StringUtils.equalsIgnoreCase(TWITTER_SERVICE_NAME, serviceName);
		this.isInstagram = StringUtils.equalsIgnoreCase(INSTAGRAM_SERVICE_NAME, serviceName);
		this.isGoogle = StringUtils.equalsIgnoreCase(GOOGLE_SERVICE_NAME, serviceName);
		
		
		if (isKakao) {
			this.api20Instance = KakaoApi.instance();
			this.profileUrl = KAKAO_PROFILE_URL;
			this.clientId = KAKAO_CLIENT_ID;
			this.clientSecret = KAKAO_CLIENT_SECRET;
			this.redirectUrl = host + KAKAO_REDIRECT_URI;
			this.revokeUrl =KAKAO_ACCESS_TOKEN_REVOKE;
			this.scope_data = KAKAO_SCOPE;
			
		} else if (isNaver) {
			this.api20Instance = NaverApi.instance();
			this.profileUrl = NAVER_PROFILE_URL;
			this.clientId = NAVER_CLIENT_ID;
			this.clientSecret = NAVER_CLIENT_SECRET;
			this.redirectUrl = host + NAVER_REDIRECT_URI;
			this.revokeUrl =NAVER_ACCESS_TOKEN_REVOKE;
			this.scope_data = NAVER_SCOPE;
			
		} else if (isFacebook) {
			this.api20Instance = FacebookApi.instance();
			this.profileUrl = FACEBOOK_PROFILE_URL;
			this.clientId = FACEBOOK_CLIENT_ID;
			this.clientSecret = FACEBOOK_CLIENT_SECRET;
			this.redirectUrl = host + FACEBOOK_REDIRECT_URI;
			this.revokeUrl =FACEBOOK_ACCESS_TOKEN_REVOKE;
			this.scope_data = FACEBOOK_SCOPE;
			
		} else if (isTwitter) {
			this.api20Instance = TwitterAPI20.instance();	// 임시
			this.profileUrl = TWITTER_PROFILE_URL;
			this.clientId = TWITTER_CLIENT_ID;
			this.clientSecret = TWITTER_CLIENT_SECRET;
			this.redirectUrl = host + TWITTER_REDIRECT_URI;
			this.revokeUrl =TWITTER_ACCESS_TOKEN_REVOKE;
			this.scope_data = TWITTER_SCOPE;
			
		} else if (isInstagram) {
			this.api20Instance = InstagramApi.instance();
			this.profileUrl = INSTAGRAM_PROFILE_URL;
			this.clientId = INSTAGRAM_CLIENT_ID;
			this.clientSecret = INSTAGRAM_CLIENT_SECRET;
			this.redirectUrl = host + INSTAGRAM_REDIRECT_URI;
			this.revokeUrl =INSTAGRAM_ACCESS_TOKEN_REVOKE;
			this.scope_data = INSTAGRAM_SCOPE;
			
		} else if (isGoogle) {
			this.api20Instance = GoogleApi20.instance();
			this.profileUrl = GOOGLE_PROFILE_URL;
			this.clientId = GOOGLE_CLIENT_ID;
			this.clientSecret = GOOGLE_CLIENT_SECRET;
			this.redirectUrl = host + GOOGLE_REDIRECT_URI;
			this.revokeUrl =GOOGLE_ACCESS_TOKEN_REVOKE;
			this.scope_data = GOOGLE_SCOPE;
			
		}
	}

}
