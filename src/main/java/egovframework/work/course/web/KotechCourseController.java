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
package egovframework.work.course.web;

import java.io.UnsupportedEncodingException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.nhncorp.lucy.security.xss.XssPreventer;

import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.work.course.model.KotechCourseModel;
import egovframework.work.course.service.KotechCourseService;
import egovframework.work.main.model.Login;
import egovframework.work.test.model.jsp.TestJspPagingSearch;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(value = "/course")
public class KotechCourseController {

	@Autowired
	protected KotechCourseService kotechCourseService;

	
	@Autowired
	private FileComponent fileComponent;
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;
	
	/**
	 * 강좌찾기 메인화면을 조회한다.
	 */
	@GetMapping(value = "/courseFind/index.do")
	public String selectCourseFindMain(@ModelAttribute TestJspPagingSearch search, @RequestParam Map<String, Object> param, HttpServletRequest request, Model model) {
		
		
		try {
		
		List<Map<String, Object>> courseGubun = kotechCourseService.courseGubun();
		List<Map<String, Object>> courseUser = kotechCourseService.getRegUserList();
		List<Map<String, Object>> courseLatest = kotechCourseService.getLatestList();
		
		String codeGubunVal = param.get("codeGubun") != null ? param.get("codeGubun").toString() : "" ;
		
		String searchTxt = param.get("searchTxt") != null ? param.get("searchTxt").toString() : "" ;
		
		System.out.println(courseUser);
		
		model.addAttribute("searchTxt", searchTxt);
		model.addAttribute("codeInitVal", codeGubunVal);
		model.addAttribute("courseGubun", courseGubun);
		model.addAttribute("courseUser", courseUser);
		model.addAttribute("courseLatest", courseLatest);
		model.addAttribute("rootPath",img_server_root_path);
		
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return "course/courseFindMain";
	}
	


	/**
	 * 강좌찾기 리스트 목록을 조회한다.
	 */
	@PostMapping(value = "/courseFindList/jsp_paging.do")
	@ResponseBody
	public Map<String, Object> jsp_paging_post(@ModelAttribute TestJspPagingSearch search, HttpServletRequest request,
			Model model) {

		Map<String, Object> result = Maps.newHashMap();
		try {
			/** 응답 값 **/
			Boolean isLogin = LocalThread.isLogin();
			String user_id = "";
			
			if (isLogin) {
				user_id = LocalThread.getLoginId();
				/** 검색어 **/
			}
			
			search.setUser_id(user_id);
			
			JspPagingResult<Map<String, Object>> jsp_paging = kotechCourseService.jspPaging(search);

			List<Map<String, Object>> courseGubun = kotechCourseService.courseGubun();

			result.put("paging", jsp_paging);
			result.put("search", search);
			result.put("courseGubun", courseGubun);

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 강좌찾기 상세화면을 조회한다.
	 * @throws UnsupportedEncodingException 
	 */
	@PostMapping(value = "/courseFindDetail.do")
	public String selectCourseFindMainDetail(HttpServletRequest request,KotechCourseModel searchVO , Model model) throws UnsupportedEncodingException {
		
		
//		Map<String, Object> courseInfo = kotechCourseService.getCourseInfo(searchVO);
		KotechCourseModel courseInfo = kotechCourseService.getCourseInfo(searchVO);
		Integer outerCompleteCnt = kotechCourseService.outerCompleteCnt(searchVO);
		Integer youtubeCompleteCnt = kotechCourseService.youtubeCompleteCnt(searchVO);
		List<Map<String,Object>> courseContentsList = kotechCourseService.getCourseContentsList(searchVO);
		
		// Editor는 XSS 필터 해제
		courseInfo.setCourse_descr(XssPreventer.unescape(courseInfo.getCourse_descr()));

		Map<String, Object> avgStar = kotechCourseService.getReviewHist(searchVO);
		
		if (avgStar.get("avg") != null) {
			double a = Double.parseDouble(avgStar.get("avg").toString());
			avgStar.put("avg", (Math.round(a * 100) / 100.0));
		}
		
		
		
		model.addAttribute("courseInfo", courseInfo);
		model.addAttribute("avgStar", avgStar);
		model.addAttribute("firstcourseContents", courseContentsList.get(0));
		model.addAttribute("searchVO", searchVO);
		model.addAttribute("urlComplete", outerCompleteCnt);
		model.addAttribute("youtubeComplete", youtubeCompleteCnt);
		return "course/courseFindDetail";
	}
	
	/**
	 * 컨텐츠 영상을 조회한다 (공통).
	 */
	@ResponseBody
	@GetMapping(value = "/jwplayerVideo.do")
	public Map<String,Object> jwplayerShow(HttpServletRequest request,KotechCourseModel searchVO , Model model) {
		
		Map<String,Object> map =new HashMap<String,Object>();
			
		List<FileData>  videoFileList = fileComponent.getFiles(FILE_REG_GB.TB_CONTENS_VIDEO, searchVO.getContents_seq());
		
		List<FileData>  subtitleFileList = fileComponent.getFiles(FILE_REG_GB.TB_CONTENS_SUBTITLE, searchVO.getContents_seq());
		
		List<FileData>  thumbnailFileList = fileComponent.getFiles(FILE_REG_GB.TB_CONTENS_THUMBNAIL, searchVO.getContents_seq());

		Map<String, Object>  contentsVideo = kotechCourseService.getContentsVideo(searchVO);
		
		log.info("{}", videoFileList);
		log.info("{}", subtitleFileList);
		log.info("{}", thumbnailFileList);
		
		map.put("contentsVideo", contentsVideo);
		map.put("videoFileList", videoFileList);
		map.put("subtitleFileList", subtitleFileList);
		map.put("thumbnailFileList", thumbnailFileList);
		
		return map;
	}
	
	
	/**
	 * 강좌플레이 영상을 플레이한다.
	 */
	@ResponseBody
	@GetMapping(value = "/coursePlay.do")
	public Map<String,Object> doCoursePlay(HttpServletRequest request,KotechCourseModel searchVO , Model model) {
		
		Map<String,Object> map =new HashMap<String,Object>();
			
		Map<String, Object>  courseVideoInfo = kotechCourseService.getCourseVideoInfo(searchVO);
		
//		Map<String, Object> courseInfo = kotechCourseService.getCourseInfo(searchVO);
		KotechCourseModel courseInfo = kotechCourseService.getCourseInfo(searchVO);
		
		List<Map<String,Object>> courseContentsList = kotechCourseService.getCourseContentsList(searchVO);

		Map<String, Object> avgStar = kotechCourseService.getReviewHist(searchVO);
		
		Integer outerCompleteCnt = kotechCourseService.outerCompleteCnt(searchVO);
		/*
		 * double a = (double) avgStar.get("avg"); avgStar.put("avg", (Math.round(a *
		 * 100) / 100.0));
		 */
		map.put("courseVideoInfo", courseVideoInfo);
		map.put("courseInfo", courseInfo);
		map.put("courseContentsList", courseContentsList);
		map.put("avgStar", avgStar);
		map.put("complete", outerCompleteCnt);
		return map;
	}
	
	

	
	/**
	 * 강좌 시청 시간체크 
	 */
	@ResponseBody
	@PostMapping(value="/checkVideoTime.do" )
	public Map<String,Object> checkVideoTime(HttpServletRequest request,KotechCourseModel searchVO) throws Exception {	
		 
		log.info("{}", searchVO);
		
		kotechCourseService.updateVideoTime(searchVO);
		
		Map<String,Object> map =new HashMap<String,Object>();
		
		map.put("result", "Success");
		
		return map;
	}
	
	/**
	 * 강좌 시청 처음들을때
	 */
	@ResponseBody
	@PostMapping(value="/insertFirstVideoTime.do" )
	public Map<String,Object> insertFirstVideoTime(HttpServletRequest request,KotechCourseModel searchVO) throws Exception {	
		 
		log.info("{}", searchVO);
		
		kotechCourseService.insertVideoTime(searchVO);
		
		Map<String,Object> map =new HashMap<String,Object>();
		
		map.put("result", "Success");
		
		return map;
	}
	
	/**
	 * 강좌 별점 리뷰
	 */
	@ResponseBody
	@PostMapping(value="/starReviewInsert.do" )
	public Map<String,Object> starReviewInsert(@RequestParam Map<String, Object> param ,HttpServletRequest request,KotechCourseModel searchVO) throws Exception {	
		
		param.put("reg_user", LocalThread.getLoginId());
		
		String courseSeq = param.get("course_seq").toString();
		String starPoint = param.get("star_point").toString();
		String Memo = param.get("star_point").toString();
		
		//Map<String, Object> map = kotechCourseService.getReviewHist(param);
		kotechCourseService.insertReviewScore(param);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", "Success");
		
		return map;
	}
	
	/** 좋아요 등록 **/
	@PostMapping(value = "/saveLike.do")
	@ResponseBody
	public Map<String, Object> kotechMain(ModelMap model, @ModelAttribute Login login,
			@RequestParam Map<String, Object> param) {
		Map<String, Object> result = Maps.newHashMap();
		String result_message = "";
		try {
			
			Boolean isLogin = LocalThread.isLogin();
			String user_id = "";
			if (isLogin) {
				user_id = LocalThread.getLoginId();
				param.put("user_id", user_id);
				String courseId = param.get("courseId").toString();
				param.put("course_id", courseId);
				kotechCourseService.insertLike(param);
				result_message = "SUCCESS";	
			} else {
				
				result_message = "NO_USERID";
			}
			
				result.put("result_code", result_message);

		} catch (Exception e) {
			e.printStackTrace();
			result_message = "FAIL";
			result.put("result_code", result_message);
		}

		return result;
	}


}



