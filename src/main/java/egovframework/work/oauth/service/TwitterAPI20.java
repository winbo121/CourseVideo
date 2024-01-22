package egovframework.work.oauth.service;

import java.util.Map;

import com.github.scribejava.core.builder.api.DefaultApi20;
import com.github.scribejava.core.model.OAuthConstants;
import com.github.scribejava.core.model.ParameterList;

import egovframework.work.oauth.model.OAuthConfig;
/***
 * 트위터는 oAuth2.0 클래스가 아직 없어서 직접 구현
 * @author KOTECH
 *
 */
public class TwitterAPI20 extends DefaultApi20 implements OAuthConfig {
	private TwitterAPI20() {
	}
	
	private static class InstanceHolder {
		private static final TwitterAPI20 INSTANCE = new TwitterAPI20();
	}
	
	public static TwitterAPI20 instance() {
		return InstanceHolder.INSTANCE;
	}

	@Override
	public String getAccessTokenEndpoint() {
		return TWITTER_ACCESS_TOKEN;
	}

	@Override
	protected String getAuthorizationBaseUrl() {
		return TWITTER_AUTH;
	}
	
    public String getAuthorizationUrl(String responseType, String apiKey, String callback, String scope, String state,
            Map<String, String> additionalParams) {
        final ParameterList parameters = new ParameterList(additionalParams);
        parameters.add(OAuthConstants.RESPONSE_TYPE, responseType);
        parameters.add(OAuthConstants.CLIENT_ID, apiKey);

        if (callback != null) {
            parameters.add(OAuthConstants.REDIRECT_URI, callback);
        }

        if (scope != null) {
            parameters.add(OAuthConstants.SCOPE, scope);
        }

        if (state != null) {
            parameters.add(OAuthConstants.STATE, state);
        }
        //System.out.println("===>>> "+parameters.appendTo(""));
        return parameters.appendTo(getAuthorizationBaseUrl());
    }
}
