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
package egovframework.work.mystudy.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.component.file.FileComponent;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.work.mystudy.model.KotechMyStudyJspPagingSearch;
import egovframework.work.mystudy.service.KotechMyStudyService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(value = "/mystudy")
public class KotechMyStudyController {
	
	@Autowired
	private KotechMyStudyService myStudyService;
	
	@Autowired
	private FileComponent fileComponent;
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;
	
	/**
	 * 나의 학습이력 화면을 조회한다.
	 */
	@GetMapping(value = "/myStudyHistory/index.do")
	public String selectStudyMain( @ModelAttribute("search") KotechMyStudyJspPagingSearch search , Model model ) {
		log.info("paging: 검색어:::: {}", search.getSearch_text());
		log.info("paging: 검색유형:::: {}", search.getSearch_type());
		
		LocalThread.getLoginUser()
		.ifPresent( usr -> log.info("{}", usr ) );
		
		/** page size , range size **/
		search.setPageSize( 12 );
		search.setRangeSize( 5 ); 
		
		model.addAttribute("rootPath",img_server_root_path);
		model.addAttribute("search", search);
		model.addAttribute("tab","study");
		
		
		return "mystudy/studyHistory";
	}
	
	/**
	 * 나의 학습이력 화면을 조회한다.
	 */
	@PostMapping(value = "/myStudyHistory/index.do")
	@ResponseBody
	public Map<String,Object> selectStudyMainAjax( @ModelAttribute("search") KotechMyStudyJspPagingSearch search , Model model ) {
		log.info("paging: 검색어:::: {}", search.getSearch_text());
		log.info("paging: 검색유형:::: {}", search.getSearch_type());
		
		LocalThread.getLoginUser()
		.ifPresent( usr -> log.info("{}", usr ) );
		
		/** page size , range size **/
		search.setPageSize( 12 );
		search.setRangeSize( 5 ); 
		
		Map<String,Object> result = Maps.newHashMap();
		JspPagingResult<Map<String, Object>> list =  myStudyService.jspPaging( search );
		result.put("list",list);
		result.put("search", search);
		
		
		return result;
	}
	
	
	
	
	
	

}
