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
package egovframework.work.statistics.web;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.work.main.service.NoneMenuService;
import egovframework.work.statistics.model.StaticsPagingSearch;
import egovframework.work.statistics.service.KotechStaticsService;
import egovframework.work.test.model.jsp.TestJspPagingSearch;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class KotechStaticsController {
	
	@Autowired
	protected KotechStaticsService KotechStaticsService;
	
	@Autowired
	private NoneMenuService noneMenuService;
	
	/**
	 * 회원접속 통계 메인화면을 조회한다.
	 */
	@GetMapping(value = "/statics/accessRecordMain/index.do")
	public String selectAccessRecordMain() {
		return "statics/accessRecordMain";
	}
	
	
	
	@PostMapping(value="/accessRecordMain/jsp_paging.do" )
	@ResponseBody
	public Map<String,Object> jsp_paging_post( @ModelAttribute TestJspPagingSearch search ,HttpServletRequest request , Model model ) {
		
		Map<String, Object> result = Maps.newHashMap();
		try {
		/** 응답 값 **/

		JspPagingResult<Map<String, Object>> jsp_paging =  KotechStaticsService.jspPaging( search );
		
		model.addAttribute("paging", jsp_paging);
		model.addAttribute("search", search);
		
		result.put( "paging", jsp_paging );
		result.put( "search", search );
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
			

		return result;
	}
	
	/**
	 * 활동 통계 메인화면을 조회한다.
	 */
	@GetMapping(value = "/statics/activeRecordMain/index.do")
	public String selectActiveRecordMain(Model model) {
		
		model.addAttribute("sido_code", noneMenuService.getSidoCode());
		model.addAttribute("job_code", noneMenuService.getJobCode());
		model.addAttribute("age_code", KotechStaticsService.getAgeCode());
		
		
		return "statics/activeRecordMain";
	}
	
	@PostMapping(value="/statics/activeRecordMain/jsp_paging.do" )
	@ResponseBody
	public Map<String,Object> activeRecord_paging_post( @ModelAttribute StaticsPagingSearch search ,HttpServletRequest request , Model model ) {
		
		Map<String, Object> result = Maps.newHashMap();
		try {
		/** 응답 값 **/

			JspPagingResult<Map<String, Object>> jsp_paging =  KotechStaticsService.activeRecord_paging( search );
			
			List<Map<String, Object>> activeRecordChart = KotechStaticsService.activeRecordChart( search );
			
			model.addAttribute("paging", jsp_paging);
			model.addAttribute("search", search);
			
			result.put( "paging", jsp_paging );
			result.put( "search", search );
			result.put( "activeRecordChart", activeRecordChart );
			
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
			

		return result;
	}
	
	//로그인 사용자 통계 (성별 정보)
	@PostMapping(value="/statics/activeLoginUserRecord/jsp_paging.do" )
	@ResponseBody
	public Map<String,Object> activeLoginUserRecord_paging_post( @ModelAttribute StaticsPagingSearch search ,HttpServletRequest request , Model model ) {
		
		Map<String, Object> result = Maps.newHashMap();
		try {
		/** 응답 값 **/

			JspPagingResult<Map<String, Object>> activeLoginUserRecord_jsp_paging =  KotechStaticsService.activeLoginUserRecord_paging( search );
			model.addAttribute("paging", activeLoginUserRecord_jsp_paging);
			model.addAttribute("search", search);
			
			result.put( "paging", activeLoginUserRecord_jsp_paging );
			result.put( "search", search );
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	//강좌통계
	@PostMapping(value="/statics/courseRecord/jsp_paging.do" )
	@ResponseBody
	public Map<String,Object> courseRecord_paging_post( @ModelAttribute StaticsPagingSearch search ,HttpServletRequest request , Model model  ) {
		
		Map<String, Object> result = Maps.newHashMap();
		try {
		/** 응답 값 **/

			JspPagingResult<Map<String, Object>> activeLoginUserRecord_jsp_paging =  KotechStaticsService.courseRecord_paging( search );
			model.addAttribute("paging", activeLoginUserRecord_jsp_paging);
			model.addAttribute("search", search);
			
			result.put( "paging", activeLoginUserRecord_jsp_paging );
			result.put( "search", search );
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	
	/**
	 * 검색 통계 메인화면을 조회한다.
	 */
	@GetMapping(value = "/statics/searchRecordMain/index.do")
	public String selectSearchRecordMain(Model model) {
		
		
		List<EgovMap> egovMap1 = KotechStaticsService.selectSearchCal1();
		List<EgovMap> egovMap2 = KotechStaticsService.selectSearchCal2();
		List<EgovMap> egovMap3 = KotechStaticsService.selectSearchCal3();
		List<EgovMap> egovMap4 = KotechStaticsService.selectSearchCal4();
		
		model.addAttribute("search_list_1", egovMap1);
		model.addAttribute("search_list_2", egovMap2);
		model.addAttribute("search_list_3", egovMap3);
		model.addAttribute("search_list_4", egovMap4);
		
		return "statics/searchRecordMain";
	}
	
	

}
