/*
 * Copyright 2008-2009 the original author or authors.
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
 */
package egovframework.work.myprofile.web;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.component.file.FileComponent;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.util.LocalThread;
import egovframework.config.security.functions.SecurityFunctions;
import egovframework.work.myprofile.service.KotechMyProfileService;
import egovframework.work.oauth.service.OAuthService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(value = "/myprofile")
public class KotechMyProfileController {
	
	@Autowired
	private KotechMyProfileService myProfileService;
	
	@Autowired
	private OAuthService oAuthService;
	
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;
	
	/**
	 * 내 프로파일 정보를 조회한다.
	 */
	@GetMapping(value = "/profileMain/index.do")
	public String selectProfileMain( Model model ) {
		
		LocalThread.getLoginUser()
		.ifPresent( usr -> log.info("{}", usr ) );
		
		model.addAttribute("job_code", myProfileService.getJobCode());
		model.addAttribute("userInfo", myProfileService.getUserInfo());
		model.addAttribute("social",oAuthService.getSocialInfoList());
		model.addAttribute("rootPath",img_server_root_path);

		model.addAttribute("tab","profile");	// 메뉴 이동
		
		
		return "myprofile/profileMain";
	}
	
	/**
	 * 내 회원정보를 수정한다.
	 */
	@PutMapping(value = "/profileMain/update.do")
	@ResponseBody
	public Map<String, Object> selectProfileMainUpdateInfo( @ModelAttribute("userInfo") MemberDetail userInfo , Model model ) {
		
		/** 응답값 **/
		Map<String,Object> result = Maps.newHashMap();
		
		try {
			boolean isUpdated = myProfileService.updateUserInfo(userInfo);
			
			if(isUpdated) {
				result.put("result", "success");
			} else {
				result.put("result", "failed");
				result.put("msg", "수정에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "수정에 실패하였습니다.");
		}
		
		return result;
	}
	
	/**
	 * 회원 탈퇴 화면으로 이동한다.
	 */
	@GetMapping(value = "/profileDelete/index.do")
	public String selectProfileDeleteMain( Model model ) {
		
		model.addAttribute("tab","delete");		// 메뉴 이동
		
		
		return "myprofile/profileDelete";
	}
	
	/**
	 * 회원 탈퇴 처리한다.
	 */
	@DeleteMapping(value = "/profileDelete/delete.do")
	@ResponseBody
	public Map<String,Object> selectStudyMainAjax( HttpServletRequest request, HttpServletResponse response, Model model ) {		
		/** 응답값 **/
		Map<String,Object> result = Maps.newHashMap();
		
		try {
			boolean isUpdated = myProfileService.deleteUser();;
			
			if(isUpdated) {
				result.put("result", "success");
				/** 강제 로그아웃 처리 **/
				SecurityFunctions.FORCED_LOGOUT.accept( request, response );
			} else {
				result.put("result", "failed");
				result.put("msg", "탈퇴에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "탈퇴에 실패하였습니다.");
		}
		
		return result;
	}
	
	
	
	
	
	

}
