/*
 * eGovFrame OAuth
 * Copyright The eGovFrame Open Community (http://open.egovframe.go.kr)).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @author 이기하(슈퍼개발자K3)
 */
package egovframework.work.oauth.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import egovframework.common.util.LocalThread;
import egovframework.work.oauth.model.OAuthConfig;
import egovframework.work.oauth.model.OAuthUniversalUser;
import egovframework.work.oauth.model.OAuthVO;
import egovframework.work.oauth.service.OAuthLogin;
import egovframework.work.oauth.service.OAuthService;

/**
 * 소셜 계정으로 로그인 및 계정 연동 처리하는 API 컨트롤러 클래스
 *
 * @author  KOTECH
 * @since 2023.03.14
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2023.03.14        KOTECH          최초 생성
 *
 * </pre>
 */
@Controller
public class OAuthAPIController {

	private static final Logger LOGGER = LoggerFactory.getLogger(OAuthAPIController.class);

	private OAuthVO kakaoAuthVO;
	
	private OAuthVO naverAuthVO;
	
	private OAuthVO facebookAuthVO;
	
	private OAuthVO twitterAuthVO;
	
	private OAuthVO instagramAuthVO;
	
	private OAuthVO googleAuthVO;
	
	public OAuthAPIController(@Value(value="${oauth.http.url}") String httpHost, @Value(value="${oauth.https.url}") String httpsHost) {
		this.kakaoAuthVO = new OAuthVO("kakao",httpHost);
		this.naverAuthVO = new OAuthVO("naver",httpHost);
		this.facebookAuthVO = new OAuthVO("facebook",httpsHost);
		this.twitterAuthVO = new OAuthVO("twitter",httpHost);
		this.instagramAuthVO = new OAuthVO("instagram",httpsHost);
		this.googleAuthVO = new OAuthVO("google",httpHost);
	}
	
	/** EgovSampleService */
	@Autowired
	private OAuthService oAuthService;
	
	/***
	 * 인증 페이지 URL 정보 조회
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/oauth.do", method = RequestMethod.POST)
	@ResponseBody
	public String oAuthLogin(Model model, HttpServletRequest request) throws Exception {
		String type = request.getParameter("social").toString();
		String cmmd = request.getParameter("cmmd").toString();
		LOGGER.debug("===>>> OAuth Login .....{},{}",type,cmmd);
		OAuthLogin oAuthLogin = null;
		
		if(type.equalsIgnoreCase("kakao")) {
			oAuthLogin = new OAuthLogin(kakaoAuthVO);
		} else if (type.equalsIgnoreCase("naver")) {
			oAuthLogin = new OAuthLogin(naverAuthVO);
		} else if (type.equalsIgnoreCase("facebook")) {
			oAuthLogin = new OAuthLogin(facebookAuthVO);
		} else if (type.equalsIgnoreCase("twitter")) {
			oAuthLogin = new OAuthLogin(twitterAuthVO);
		} else if (type.equalsIgnoreCase("instagram")) {
			oAuthLogin = new OAuthLogin(instagramAuthVO);
		} else if (type.equalsIgnoreCase("google")) {
			oAuthLogin = new OAuthLogin(googleAuthVO);
		}
		
		
		LOGGER.debug("oAuthLogin.getOAuthURL() = "+oAuthLogin.getOAuthURL());
		
		// 어떤 작업을 할건지 구분 값 처리 (로그인,연동하기)
		if(cmmd.equals("L")) {	// 로그인
			request.getSession().setAttribute("AUTH_TYPE", "L");
		} else if (cmmd.equals("I")) {	// 연동하기
			request.getSession().setAttribute("AUTH_TYPE", "I");
			System.out.println(request.getSession().getAttribute("AUTH_TYPE").toString());
		} else {
			request.getSession().setAttribute("AUTH_TYPE", "E");
		}
		

		return oAuthLogin.getOAuthURL();
	}

	/***
	 * 인증 CALLBACK
	 * @param oauthService
	 * @param model
	 * @param code
	 * @param session
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/oauth/{oauthService}/callback.do", 
			method = { RequestMethod.GET, RequestMethod.POST})
	public String oauthLoginCallback(@PathVariable String oauthService,
			Model model, @RequestParam String code, HttpSession session, HttpServletRequest request) throws Exception {
		try {
			LOGGER.debug("oauthLoginCallback: service={}", oauthService);
			LOGGER.debug("===>>> code = "+ code);
			OAuthVO oauthVO = null;
			String resultDBInfo = ""; // 체크 결과
			int count = 0;
			String message = "";
			
			if(StringUtils.equalsIgnoreCase(OAuthConfig.KAKAO_SERVICE_NAME, oauthService)) {
				oauthVO = kakaoAuthVO;
			} else if(StringUtils.equalsIgnoreCase(OAuthConfig.NAVER_SERVICE_NAME, oauthService)) {
				oauthVO = naverAuthVO;
			} else if(StringUtils.equalsIgnoreCase(OAuthConfig.FACEBOOK_SERVICE_NAME, oauthService)) {
				oauthVO = facebookAuthVO;
			} else if(StringUtils.equalsIgnoreCase(OAuthConfig.TWITTER_SERVICE_NAME, oauthService)) {
				oauthVO = twitterAuthVO;
			} else if(StringUtils.equalsIgnoreCase(OAuthConfig.INSTAGRAM_SERVICE_NAME, oauthService)) {
				oauthVO = instagramAuthVO;
			} else if(StringUtils.equalsIgnoreCase(OAuthConfig.GOOGLE_SERVICE_NAME, oauthService)) {
				oauthVO = googleAuthVO;
			} 
			
			// 1. code를 이용해서 Access Token 받기
			// 2. Access Token을 이용해서 사용자 제공정보 가져오기
			OAuthLogin oauthLogin = new OAuthLogin(oauthVO);
			OAuthUniversalUser oauthUser = oauthLogin.getUserProfile(code); // 1,2번 동시
			LOGGER.debug("AUTH INFO ===>>" + oauthUser);
			
			// ========================================================================
			// 3. 커스텀 코드 작성
			
			// a.요청 사항 확인
			System.out.println(request.getSession().getAttribute("AUTH_TYPE"));
			String cmmd = request.getSession().getAttribute("AUTH_TYPE").toString();
			
			// a. 세션 존재 유무 체크
			String loginId = null;
			boolean logined = LocalThread.isLogin();
			try {
				loginId =  LocalThread.getLoginId();	
			} catch (Exception e) {
			}
			
			// b. 해당 서비스 연동 유무 확인
			String userId = oAuthService.checkSocialUser(oauthUser);
			
			/** PROCESS 절차
			 * 1. 소셜 계쩡 유무 확인
			 * 2. 서비스별 처리 타입 확인
			 * 3. 세션 유무 확인
			 * 4. 연동 계정 유무 확인
			 */
			LOGGER.debug(cmmd,loginId,userId);
			if (oauthUser == null) {	// 소셜 제공 정보 없는 경우
				message = oauthService + "의 계정을 확인 바랍니다.";
				resultDBInfo = "E";
			} else {
				// c. 서비스 요청별 처리
				if(cmmd.equals("L")) {	// 로그인
					if (!logined) { // 세션 유무 확인
						if(userId == null) {
							message = oauthService + "와 연동된 계정이 없습니다.";
							resultDBInfo = "E";
						} else {
							message = "로그인 성공했습니다.";
							resultDBInfo = oAuthService.signIn(userId, session);
						}
					} else {	// 이미 로그인 되어 있음
						message = "이미 로그인되어 있습니다.";
						resultDBInfo = "E";
					}
					
				} else if(cmmd.equals("I")) {	// 연동 등록
					if(!logined) {	// 세션 유무 확인
						if(userId == null) {	// 연동 이력 확인
							message = "연동하기 성공했습니다.";
							resultDBInfo = "I";	
						} else {
							message = "이미 다른 계정과 연동된 이력이 있습니다.";
							resultDBInfo = "E";
						}
					} else {
						if(userId == null) {	// 연동 이력 확인
							// d. 서비스 연동하기
							count = oAuthService.insertSocialUser(loginId,oauthService,oauthUser.getUid(),oauthUser.getEmail());
							if(count > 0) {
								message = "연동하기 성공했습니다.";
								resultDBInfo = "I";
								
							} else {
								message = "연동하기 실패했습니다";
								resultDBInfo = "E";
							}
						} else {
							message = "잘못된 접근입니다.";
							resultDBInfo = "E";
						}

					}

					
				} else {
					message = "잘못된 접근입니다.";
					resultDBInfo = "E";
				}	
		
			}

			// 존재시 로그인 처리
			model.addAttribute("service",oauthService);
			model.addAttribute("message", message);
			
			model.addAttribute("oAuthUser", oauthUser);
			
			model.addAttribute("result",resultDBInfo);
			
		} catch (Exception e) {
			model.addAttribute("message",e.toString());
			e.printStackTrace();
		}

		return "oAuth/loginOauthResult";
	}
	
	/***
	 * 연동해제
	 * @param model
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/oauth/disconnect.do", method = RequestMethod.DELETE)
	@ResponseBody
	public Map<String, Object> oAuthDisconnect(Model model, HttpServletRequest request) throws Exception {
		String type = request.getParameter("social").toString();
		String cmmd = request.getParameter("cmmd").toString();
		LOGGER.debug("===>>> OAuth Login ....." + type);
		
		String resultDBInfo = ""; // 체크 결과
		int count = 0;
		String message = "";
		
		try {
			if(cmmd.equals("D")) {
				String user_id = LocalThread.getLoginId();
				
				// e. 서비스 연동해제
				count = oAuthService.deleteSocialuser(user_id,type);
				if(count > 0) {
					message = "연동해제 성공했습니다.";
					resultDBInfo = "D";
				} else {
					message = "연동해제 실패했습니다.";
					resultDBInfo = "E";
				}
			} else {
				message = "연동해제 실패했습니다.";
				resultDBInfo = "E";
			}

		} catch (Exception e) {
			message = "연동해제 실패했습니다.";
			resultDBInfo = "E";
		}
		
		Map<String,Object> result = Maps.newHashMap();
		result.put("service",type);
		result.put("message", message);
		result.put("result",resultDBInfo);
		

		return result;
	}
	
}
