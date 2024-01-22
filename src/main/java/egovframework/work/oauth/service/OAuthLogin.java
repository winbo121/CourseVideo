package egovframework.work.oauth.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

import egovframework.work.oauth.model.OAuthConfig;
import egovframework.work.oauth.model.OAuthUniversalUser;
import egovframework.work.oauth.model.OAuthVO;


public class OAuthLogin {
	private OAuth20Service oauthService;
	private OAuthVO oauthVO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(OAuthLogin.class);
	
	public OAuthLogin(OAuthVO oauthVO) {
		
		this.oauthVO = oauthVO;
		
		// 구글,인스타그램 defaultScope 지정
		if(oauthVO.isGoogle() || oauthVO.isInstagram()) {
			this.oauthService = new ServiceBuilder(oauthVO.getClientId())
					.apiSecret(oauthVO.getClientSecret())
					.defaultScope(oauthVO.getScope_data())
					.callback(oauthVO.getRedirectUrl())
					.build(oauthVO.getApi20Instance());
		} else {
			this.oauthService = new ServiceBuilder(oauthVO.getClientId())
					.apiSecret(oauthVO.getClientSecret())
					.callback(oauthVO.getRedirectUrl())
					.build(oauthVO.getApi20Instance());	
		}
		
		
	}
	
	public String getOAuthURL() {
		return this.oauthService.getAuthorizationUrl();
	}

	
	public OAuthUniversalUser getUserProfile(String code) throws Exception {
		LOGGER.debug("===>>> oauthService.getApiKey() = "+oauthService.getApiKey());
		LOGGER.debug("===>>> oauthService.getApiSecret() = "+oauthService.getApiSecret());
		
		OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
		LOGGER.debug("===>>> token = " + accessToken.getAccessToken());
		
		OAuthRequest request = new OAuthRequest(Verb.GET, this.oauthVO.getProfileUrl());
		
		// 페이스북, 인스타그램 query String 추가(facebook graph API)
		if(oauthVO.isFacebook()) {
			request.addQuerystringParameter("fields", "birthday,education,email,first_name,gender");	
		} else if(oauthVO.isInstagram()) {
			request.addQuerystringParameter("fields", "id,username,account_type");
		}
		
		oauthService.signRequest(accessToken, request);
		
		Response response = oauthService.execute(request);
		if(response.isSuccessful()) {
			OAuthUniversalUser userInfo = parseJson(response.getBody());
			LOGGER.debug("===>>> {} REVOKE ACTION = {}, {}",oauthVO.getService(),accessToken.getAccessToken(),oauthVO.getRevokeUrl());
			/** 연동해제 **/
			if(oauthVO.isKakao()) {
				OAuthRequest req = new OAuthRequest(Verb.POST,this.oauthVO.getRevokeUrl());
				//req.addQuerystringParameter("scopes", "public_profile");
				LOGGER.debug(" ===>>> Complete URL = {}",req.getCompleteUrl());
				oauthService.signRequest(accessToken, req);
				oauthService.execute(req);
				
			}
			if(oauthVO.isNaver()) {
				OAuthRequest req = new OAuthRequest(Verb.POST,this.oauthVO.getRevokeUrl());
				req.addQuerystringParameter("client_id", oauthVO.getClientId());
				req.addQuerystringParameter("client_secret", oauthVO.getClientSecret());
				req.addQuerystringParameter("access_token", accessToken.getAccessToken());
				req.addQuerystringParameter("service_provider", "NAVER");
				LOGGER.debug(" ===>>> Complete URL = {}",req.getCompleteUrl());
				oauthService.signRequest(accessToken, req);
				oauthService.execute(req);				
			}
			
			if(oauthVO.isFacebook()) {
				String url = oauthVO.getRevokeUrl().replace("{user-id}", userInfo.getEmail());
				OAuthRequest req = new OAuthRequest(Verb.DELETE,url);
				LOGGER.debug(" ===>>> Complete URL = {}",req.getCompleteUrl());
				oauthService.signRequest(accessToken, req);
				oauthService.execute(req);	
				
				
			}
			
			if(oauthVO.isInstagram()) {
				// 사용안함
			}
			
			if(oauthVO.isTwitter()) {
				OAuthRequest req = new OAuthRequest(Verb.DELETE,oauthVO.getRevokeUrl());
				LOGGER.debug(" ===>>> Complete URL = {}",req.getCompleteUrl());
				oauthService.signRequest(accessToken, req);
				oauthService.execute(req);	
			}
			
			if(oauthVO.isGoogle()) {
				OAuthRequest req = new OAuthRequest(Verb.POST,this.oauthVO.getRevokeUrl());
				req.addQuerystringParameter("token", accessToken.getAccessToken());
				LOGGER.debug(" ===>>> Complete URL = {}",req.getCompleteUrl());
				oauthService.signRequest(accessToken, req);
				oauthService.execute(req);
			}
			
			
			return userInfo;			
		}
		return null;
		
	}

	/***
	 * 각 각 소셜 로그인에서 가져올 데이터 파싱 
	 * (scope 및 fields 값 지정에 따라 데이터가 다름)
	 * id 데이터는 필수
	 * json data parsing
	 * @param body
	 * @return
	 * @throws Exception
	 */
	private OAuthUniversalUser parseJson(String body) throws Exception {
		LOGGER.debug("============================\n" + body + "\n============================");
		OAuthUniversalUser user = new OAuthUniversalUser();
		
		ObjectMapper mapper = new ObjectMapper();
		JsonNode rootNode = mapper.readTree(body);
		
		// 카카오 rootNode{id,connected_at,kakao_account:{has_email,is_email_valid,is_email_verified,email}
		if (this.oauthVO.isKakao()) {
			user.setServiceName(OAuthConfig.KAKAO_SERVICE_NAME);
			JsonNode resNode = rootNode.get("kakao_account");
			user.setUid(rootNode.get("id").asText());
			user.setEmail(resNode.get("email").asText());
			
		// 네이버 rootNode{resultcode,message,response:{id,nickname,email,name}}
		} else if (this.oauthVO.isNaver()) {
			user.setServiceName(OAuthConfig.NAVER_SERVICE_NAME);
			JsonNode resNode = rootNode.get("response");
			user.setUid(resNode.get("id").asText());
			user.setNickName(resNode.get("nickname").asText());
			user.setEmail(resNode.get("email").asText());
			user.setUserName(resNode.get("name").asText());
			
		// 페이스북 rootNode{birthday, email, first_name, id}
		} else if (this.oauthVO.isFacebook()) {
			user.setServiceName(OAuthConfig.FACEBOOK_SERVICE_NAME);
			user.setUid(rootNode.get("id").asText());
			user.setEmail(rootNode.get("email").asText());
		
		// 트위터
		} else if (this.oauthVO.isTwitter()) {
			user.setServiceName(OAuthConfig.TWITTER_SERVICE_NAME);
			
		// 인스타그램 rootNode{id,username,account_type}
		} else if (this.oauthVO.isInstagram()) {
			user.setServiceName(OAuthConfig.INSTAGRAM_SERVICE_NAME);
			user.setUid(rootNode.get("id").asText());
			user.setUserName(rootNode.get("username").asText());
			user.setEmail(rootNode.get("username").asText());
		
		// 구글 rootNode{sub,name,given_name,family_name,picture,email,email_verified,locale}
		} else if (this.oauthVO.isGoogle()) {
			user.setServiceName(OAuthConfig.GOOGLE_SERVICE_NAME);
			user.setUid(rootNode.get("sub").asText());
			user.setUserName(rootNode.get("name").asText());
			user.setEmail(rootNode.get("email").asText());
			
		}
		
		return user;
	}
	
}
