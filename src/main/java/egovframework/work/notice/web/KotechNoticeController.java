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
package egovframework.work.notice.web;

import java.util.Base64;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.nhncorp.lucy.security.xss.XssPreventer;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.work.notice.model.Notice;
import egovframework.work.notice.service.KotechNoticeService;

@Controller
@RequestMapping(value = "/notice")
public class KotechNoticeController {

	@Autowired
	private FileComponent fileComponent;

	@Autowired
	private KotechNoticeService noticeService;

	/**
	 * 공지사항 메인화면을 조회한다.
	 */
	@GetMapping(value = "/noticeMain/index.do")
	public String selectNoticeMain(@ModelAttribute Notice notice, Model model) {

		JspPagingResult<Notice> result = noticeService.noticePaging(notice);
		List<Map<String, Object>> getNoticeGb = noticeService.getNoticeGb(notice);
		List<Notice> sideNotice = noticeService.getFixedNoticeList2(notice.getNotice_seq());
		List<Notice> sideNoticeList = noticeService.getSideNoticeList(notice.getNotice_seq());
		notice.setContents(XssPreventer.unescape(notice.getContents()));

		for (int i = 0; i < sideNotice.size(); i++) {
			sideNotice.get(i).setContents(XssPreventer.unescape(sideNotice.get(i).getContents()));
			sideNotice.get(i).setTitle(XssPreventer.unescape(sideNotice.get(i).getTitle()));
		}

		for (int i = 0; i < sideNoticeList.size(); i++) {
			sideNoticeList.get(i).setContents(XssPreventer.unescape(sideNoticeList.get(i).getContents()));
			sideNoticeList.get(i).setTitle(XssPreventer.unescape(sideNoticeList.get(i).getTitle()));
		}

		for (int i = 0; i < result.getData().size(); i++) {
			notice.setContents(XssPreventer.unescape(result.getData().get(i).getContents()));
			result.getData().get(i).setContents(XssPreventer.unescape(notice.getContents()));
			notice.setTitle(XssPreventer.unescape(result.getData().get(i).getTitle()));
			result.getData().get(i).setTitle(XssPreventer.unescape(notice.getTitle()));
		}

		model.addAttribute("Notice", result.getData());
		model.addAttribute("length", result.getData().size());
		model.addAttribute("search", notice);
		model.addAttribute("sideList", sideNotice);
		model.addAttribute("sideNoticeList", sideNoticeList);
		model.addAttribute("noticeGb", getNoticeGb);

		Map<String, Object> temp = new HashMap<>();
		return "notice/noticeMain";
	}

	/**
	 * 공지사항 상세화면을 조회한다.
	 */
	@GetMapping(value = "/noticeDetail.do")
	public String selectNoticeMainDetail(Model model, @RequestParam Integer notice_seq, @ModelAttribute Notice notice) {

		Notice notice_detail = noticeService.selectNoticeDetail(notice_seq);
		Integer maxSeq = noticeService.maxNoticeSeq(notice_seq);
		Integer minSeq = noticeService.minNoticeSeq(notice_seq);
		List<Notice> sideNotice = noticeService.getFixedNoticeList2(notice_seq);
		List<Map<String, Object>> getNoticeGb = noticeService.getNoticeGb(notice);

		notice_detail.setContents(XssPreventer.unescape(notice_detail.getContents()));
		notice_detail.setTitle(XssPreventer.unescape(notice_detail.getTitle()));
		for (int i = 0; i < sideNotice.size(); i++) {
			sideNotice.get(i).setContents(XssPreventer.unescape(sideNotice.get(i).getContents()));
			sideNotice.get(i).setTitle(XssPreventer.unescape(sideNotice.get(i).getTitle()));
		}

		model.addAttribute("notice_detail", notice_detail);
		model.addAttribute("max", maxSeq);
		model.addAttribute("min", minSeq);
		model.addAttribute("Notice", notice);
		model.addAttribute("sideList", sideNotice);
		model.addAttribute("noticeGb", getNoticeGb);

		return "notice/noticeDetail";
	}

	/**
	 * 공지사항 등록화면을 조회한다.
	 */
	@GetMapping(value = "/noticeEnrollDetail.do")
	public String selectNoticeEnrollDetail(Model model) {

		Notice notice = new Notice();
		notice.setContents(XssPreventer.escape(notice.getContents()));
		notice.setTitle(XssPreventer.escape(notice.getTitle()));
		int fixCnt = noticeService.fixCnt();
		model.addAttribute("fixCnt", fixCnt);
		model.addAttribute("notice", notice);
		model.addAttribute("bbs_gb", "N");
		model.addAttribute("paramVal", "I");
		return "notice/noticeEnrollDetail";
	}

	/**
	 * 공지사항 등록.
	 */
	@PutMapping(value = "/noticeInsert.do")
	@ResponseBody
	public Map<String, Object> notice_put_insert(@ModelAttribute Notice notice, BindingResult bindingResult,
			Model model) {

		Map<String, Object> result = Maps.newHashMap();
		Map<String, Object> temp = Maps.newHashMap();

		notice.setReg_user(LocalThread.getLoginId());

		try {
			noticeService.insertNotice(notice);
			notice.setContents(XssPreventer.escape(notice.getContents()));
			result.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "오류가 발생했습니다. 관리자에게 문의해주세요.");
		}

		return result;
	}

	@PostMapping(value = "/noticeListAjax.do")
	@ResponseBody
	public Map<String, Object> noticeSearchAjax(Notice notice, Model model) throws UnsupportedEncodingException {

		Map<String, Object> temp = Maps.newHashMap();

		JspPagingResult<Notice> result = noticeService.noticePaging(notice);
		
		for (int i = 0; i < result.getData().size(); i++) {
				
			notice.setContents(XssPreventer.unescape(result.getData().get(i).getContents()));
			result.getData().get(i).setContents(XssPreventer.unescape(notice.getContents()));
			notice.setTitle(XssPreventer.unescape(result.getData().get(i).getTitle()));
			result.getData().get(i).setTitle(XssPreventer.unescape(notice.getTitle()));
		}
		
		
		Map<String, Object> param = new HashMap<>();

		for (int i = 0; i < result.getData().size(); i++) {
			FileData thumb = fileComponent.getFirstFile(FILE_REG_GB.TS_NOTICE_THUMB,
					String.valueOf(result.getData().get(i).getNotice_seq()));
			param.put("thumb", thumb);
			result.getData().get(i).setThumb(thumb);
		}

		temp.put("result", result.getData());
		temp.put("paging", notice);
		
		System.out.println(temp.get("result"));

		model.addAttribute("paging", result);
		model.addAttribute("search", notice);

		return temp;
	}

	@GetMapping(value = "/noticeModify.do")
	public String notice_get_modify(Model model, @RequestParam Integer notice_seq, HttpServletRequest req) {

		Map<String, Object> param = new HashMap<String, Object>();
		param.put("notice_seq", req.getParameter("notice_seq"));

		Notice notice = noticeService.getNotice(param);
		notice.setContents(XssPreventer.unescape(notice.getContents()));
		int fixCnt = noticeService.fixCnt();
		model.addAttribute("fixCnt", fixCnt);
		model.addAttribute("notice", notice);
		model.addAttribute("bbs_gb", "N");
		model.addAttribute("paramVal", "U");
		String noticeSeq = req.getParameter("notice_seq").toString();
		List<FileData> files = fileComponent.getFiles(FILE_REG_GB.TS_NOTICE, noticeSeq);
		List<FileData> thumb_files = fileComponent.getFiles(FILE_REG_GB.TS_NOTICE_THUMB, noticeSeq);
		model.addAttribute("files", files);
		model.addAttribute("thumb_files", thumb_files);

		return "notice/noticeEnrollDetail";
	}

	@PutMapping(value = "/noticeModify.do")
	@ResponseBody
	public Map<String, Object> notice_put_modify(@ModelAttribute Notice notice, Model model,
			HttpServletRequest request) {

		Map<String, Object> result = Maps.newHashMap();
		notice.setUpd_user(LocalThread.getLoginId());

		try {
			noticeService.modifyNotice(notice);

			result.put("result", "success");

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "오류가 발생했습니다. 관리자에게 문의해주세요.");
		}

		return result;
	}

	/** 공지사항 삭제 */
	@DeleteMapping(value = "/noticeDelete.do")
	@ResponseBody
	public Map<String, Object> notice_delete(@ModelAttribute Notice notice, Model model, HttpServletRequest request) {

		Map<String, Object> result = Maps.newHashMap();
		notice.setUpd_user(LocalThread.getLoginId());

		try {
			Integer del_row_cnt = noticeService.deleteNotice(notice, request);

			if (del_row_cnt > 0) {
				result.put("result", "success");
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			result.put("result", "fail");
			result.put("message", "오류가 발생했습니다. 관리자에게 문의해주세요.");
		}

		return result;

	}

	/** 공지사항 개별 파일삭제 **/
	@DeleteMapping(value = "/noticeDeletefile.do")
	@ResponseBody
	public Map<String, Object> deleteClassNoticeFile(@ModelAttribute Notice notice, Model model) {

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		// 공지사항 파일만 삭제
		noticeService.deleteNoticeFile(notice);

		return result;
	}

	/** 고정 공지사항 관리 AJAX **/
	@PostMapping(value = "/noticeFixSortAjax.do")
	@ResponseBody
	public Map<String, Object> noticeFixSortAjax(@RequestParam Map<String, Object> param, @ModelAttribute Notice notice,
			Model model) {

		// ModelAndView mv = new ModelAndView();
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		notice.setUpd_user(LocalThread.getLoginId());

		String sortNum = param.get("sortNum").toString();
		String[] num = sortNum.split(",");
		String seqNum = param.get("seq").toString();
		String[] seq = seqNum.split(",");

		List<String> sortList = new ArrayList<String>();
		List<String> seqList = new ArrayList<String>();

		for (int i = 0; i < num.length; i++) {
			sortList.add(num[i]);
			seqList.add(seq[i]);
		}

		result.put("num", sortList);
		result.put("seq", seqList);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("fixContent", result);

		
		//noticeService.sortInit();
		notice.setFix_sort_no(sortList);
		notice.setSeq(seqList);

		System.out.println(notice);
		for (int i = 0; i < sortList.size(); i++) {
			notice.setSort(sortList.get(i));
			notice.setNotice_seq(Integer.parseInt(seqList.get(i)));
			noticeService.updateSort(notice);
		}

		return paramMap;
	}

	/** 고정 공지사항 수정 AJAX **/
	@DeleteMapping(value = "/noticeFixDelAjax.do")
	@ResponseBody
	public Map<String, Object> noticeFixDel(@ModelAttribute Notice notice, Model model) {

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		notice.setUpd_user(LocalThread.getLoginId());
		System.out.println(notice);
		noticeService.deleteFixNotice(notice);

		return result;
	}

}
