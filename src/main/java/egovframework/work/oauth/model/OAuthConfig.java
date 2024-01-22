package egovframework.work.oauth.model;

/***
 * 사이트별 OAuth 관련 정보 등록(SERVICE_NAME, PROFILE_URL, ACCESS_TOKEN, AUTH_URL)
 * @author KOTECH
 *
 */
public interface OAuthConfig {
	
	/* KAKAO */
	static final String KAKAO_SERVICE_NAME = "kakao";
	static final String KAKAO_PROFILE_URL = "https://kapi.kakao.com/v2/user/me";
	static final String KAKAO_ACCESS_TOKEN = "https://kauth.kakao.com/oauth/token?client_id=";
	/** https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api url + bearer access_token **/
	static final String KAKAO_ACCESS_TOKEN_REVOKE = "https://kapi.kakao.com/v1/user/unlink";
	static final String KAKAO_AUTH = "https://kauth.kakao.com/oauth/authorize";
	static final String KAKAO_CLIENT_ID = "9d5450d7709f64ee170581bc85a11b74";
	static final String KAKAO_CLIENT_SECRET = "izTpMb2bWwKaOqkKxYp77xJxEefd5ytP";
	static final String KAKAO_REDIRECT_URI = "/oauth/kakao/callback.do";
	static final String KAKAO_SCOPE = "public_profile";
	
	/* NAVER */
	static final String NAVER_SERVICE_NAME = "naver";
	static final String NAVER_PROFILE_URL = "https://openapi.naver.com/v1/nid/me";
	static final String NAVER_ACCESS_TOKEN = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
	/** grant_type=delete &client_id={클라이언트ID}&client_secret={클라이언트 Secret} &access_token={액세스토큰}&service_provider=NAVER **/
	static final String NAVER_ACCESS_TOKEN_REVOKE = "https://nid.naver.com/oauth2.0/token?grant_type=delete";
	static final String NAVER_AUTH = "https://nid.naver.com/oauth2.0/authorize";
	static final String NAVER_CLIENT_ID = "NguI3LGf7G151yGa8Uon";
	static final String NAVER_CLIENT_SECRET = "MrDCBKL1Bn";
	static final String NAVER_REDIRECT_URI = "/oauth/naver/callback.do";
	static final String NAVER_SCOPE = "public_profile";
	
	/* FACEBOOK */
	static final String FACEBOOK_SERVICE_NAME = "facebook";
	static final String FACEBOOK_PROFILE_URL = "https://graph.facebook.com/v3.2/me";
	static final String FACEBOOK_ACCESS_TOKEN = "https://graph.facebook.com/v3.2/oauth/access_token";
	/** https://developers.facebook.com/docs/facebook-login/guides/permissions/request-revoke ( 토큰 같이 ) **/
	static final String FACEBOOK_ACCESS_TOKEN_REVOKE = "https://graph.facebook.com/v3.2/{user-id}/permissions";
	static final String FACEBOOK_AUTH = "https://www.facebook.com/v3.2/dialog/oauth";
	static final String FACEBOOK_CLIENT_ID = "600616231929894";
	static final String FACEBOOK_CLIENT_SECRET = "d69b0d6305ad3c422566b06d648edad7";
	static final String FACEBOOK_REDIRECT_URI = "/oauth/facebook/callback.do";
	static final String FACEBOOK_SCOPE = "user_profile";
	
	/* TWITTER */
	static final String TWITTER_SERVICE_NAME = "twitter";
	static final String TWITTER_PROFILE_URL = "https://api.twitter.com/1.1/account/verify_credentials.json";
	static final String TWITTER_ACCESS_TOKEN = "https://api.twitter.com/oauth2/token?grant_type=client_credentials";
	static final String TWITTER_ACCESS_TOKEN_REVOKE = "https://api.twitter.com/1.1/oauth/invalidate_token";
	static final String TWITTER_AUTH = "https://api.twitter.com/oauth/authorize";
	static final String TWITTER_CLIENT_ID = "";
	static final String TWITTER_CLIENT_SECRET = "";
	static final String TWITTER_REDIRECT_URI = "/oauth/twitter/callback.do";
	static final String TWITTER_SCOPE = "";

	/* INSTAGRAM */
	static final String INSTAGRAM_SERVICE_NAME = "instagram";
	static final String INSTAGRAM_PROFILE_URL = "https://graph.instagram.com/me";
	static final String INSTAGRAM_ACCESS_TOKEN = "https://api.instagram.com/oauth/access_token";
	static final String INSTAGRAM_ACCESS_TOKEN_REVOKE = "자동으로 끊김";
	static final String INSTAGRAM_AUTH = "https://api.instagram.com/oauth/authorize";
	static final String INSTAGRAM_CLIENT_ID = "539262851525715";
	static final String INSTAGRAM_CLIENT_SECRET = "b0ab7849055d4e4e8be1b061aa57e3e6";
	static final String INSTAGRAM_REDIRECT_URI = "/oauth/instagram/callback.do";
	static final String INSTAGRAM_SCOPE = "user_profile";
	
	/* GOOGLE */
	static final String GOOGLE_SERVICE_NAME = "google";
	static final String GOOGLE_PROFILE_URL = "https://www.googleapis.com/oauth2/v3/userinfo?alt=json";
	static final String GOOGLE_ACCESS_TOKEN = "https://accounts.google.com/o/oauth2/v2/auth";
	static final String GOOGLE_ACCESS_TOKEN_REVOKE = "https://oauth2.googleapis.com/revoke";
	static final String GOOGLE_AUTH = "https://oauth2.googleapis.com/token";
	static final String GOOGLE_CLIENT_ID = "928161232270-n7ldsnnrsgvaf03h9u3e73dpsqhq5rfb.apps.googleusercontent.com";
	static final String GOOGLE_CLIENT_SECRET = "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";
	static final String GOOGLE_REDIRECT_URI = "/oauth/google/callback.do";
	static final String GOOGLE_SCOPE = "email profile openid";
	
}
