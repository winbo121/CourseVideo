package egovframework.work.course.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;
import com.nhncorp.lucy.security.xss.XssPreventer;

import egovframework.common.base.BaseController;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.common.util.YoutubeApiUtil;
import egovframework.work.course.model.Contents;
import egovframework.work.course.model.ContentsSearch;
import egovframework.work.course.model.Course;
import egovframework.work.course.model.CourseSearch;
import egovframework.work.course.service.ContentsManageService;
import egovframework.work.course.service.CourseManageService;

@Controller
@RequestMapping(value = "/conage")
public class CourseManageController extends BaseController {
	
	@Autowired
	CourseManageService courseManageService;
	
	@Autowired
	ContentsManageService contentsManageService;
	
	@Autowired
	YoutubeApiUtil youtubeApiUtil;
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;
	
	/**
	 * 강좌등록 메인화면을 조회한다.
	 */
	@GetMapping(value = "/courseEnrollMain/index.do")
	public String selectCourseEnrollMain(@ModelAttribute("search") CourseSearch search, Model model) {
		
		/** range size **/
		//search.setPageSize( 12 );
		search.setRangeSize( 5 ); 
		
		model.addAttribute("search", search);
		model.addAttribute("rootPath",img_server_root_path);
		return "conage/courseEnrollMain";
	}
	
	/**
	 * 강좌등록 메인화면 목록을 조회한다.
	 */
	@PostMapping(value = "/courseEnrollMain/index.do")
	@ResponseBody
	public Map<String,Object> selectCourseEnrollMainAjax(@ModelAttribute CourseSearch search) {
		
		/** range size **/
		//search.setPageSize( 12 );
		search.setRangeSize( 5 );
		
		Map<String,Object> result = Maps.newHashMap();
		JspPagingResult<Map<String, Object>> list = courseManageService.courseJspPaging( search );
		result.put("list", list);
		result.put("search", search);
		return result;
	}
	
	/**
	 * 강좌등록 운영강좌 목록을 조회한다.(검색)
	 */
	@GetMapping(value = "/modal/courseEnrollCourse.do")
	public String selectCourseEnrollCourse(@ModelAttribute("search") CourseSearch search, Model model) {

		return "conage/modal/courseSearch";
	}
	
	
	
	/**
	 * 강좌등록 운영강좌 목록을 조회한다.
	 */
	@PostMapping(value = "/modal/courseEnrollCourse.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollCourseAjax(@ModelAttribute("search") CourseSearch search) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			/** 응답 값 **/

			JspPagingResult<Map<String, Object>> jsp_paging = courseManageService.courseJspPaging(search);
			
			result.put("paging", jsp_paging);
			result.put("search", search);

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 강좌등록 운영강좌 정보를 조회한다.
	 */
	@PutMapping(value = "/modal/courseEnrollCourse.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollCourseInsertAjax(@RequestParam int course_seq, @ModelAttribute("course") Course course) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			/** 응답 값 **/
			result.put("course", courseManageService.getCourse(course_seq));
			result.put("contents", courseManageService.getContents(course_seq));

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 강좌등록 콘텐츠 목록을 조회한다.(검색)
	 */
	@GetMapping(value = "/modal/courseEnrollContents.do")
	public String selectCourseEnrollContents(@ModelAttribute("search") ContentsSearch search, Model model) {

		return "conage/modal/contentsSearch";
	}
	
	/**
	 * 강좌등록 콘텐츠 목록을 조회한다.
	 */
	@PostMapping(value = "/modal/courseEnrollContents.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollContentsAjax(@ModelAttribute("search") ContentsSearch search) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			/** 응답 값 **/

			JspPagingResult<Map<String, Object>> jsp_paging = courseManageService.contentsJspPaging(search);
			
			result.put("paging", jsp_paging);
			result.put("search", search);

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return result;
	}
	
	/**
	 * 강좌등록 콘텐츠 수정 화면을 조회한다.(팝업)
	 */
	@GetMapping(value = "/popup/contentDetailPop.do")
	public String selectContentEnrollDetailPop(@RequestParam int contents_seq, @ModelAttribute ContentsSearch search, Model model) {
		
		selectContentEnrollDetailUpdate(contents_seq,search,model);
		
		return "conage/popup/contentDetail";
	}
	
	/**
	 * 강좌등록 등록화면을 조회한다.
	 */
	@GetMapping(value = "/courseEnroll/insert.do")
	public String selectCourseEnrollDetail(@ModelAttribute("course") Course course, Model model) {
		
		model.addAttribute("mode", "I");
		model.addAttribute("course", course);
		model.addAttribute("typeCode",courseManageService.getTypeCode());
		model.addAttribute("categoryCode",courseManageService.getCategoryCode());
		
		return "conage/courseEnrollDetail";
	}
	
	/**
	 * 강좌등록 강좌를 등록한다.
	 */
	@PostMapping(value = "/courseEnroll/insert.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollInsert(@ModelAttribute("course") Course course) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			
			//Login User setting
			String loginId = LocalThread.getLoginId();
			course.setReg_user(loginId);
			course.setUpd_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			boolean isInsert = courseManageService.upsertCourse(course,"I");
			
			if(isInsert) {
				result.put("result", "success");
			} else {
				result.put("result", "failed");
				result.put("msg", "등록에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "등록에 실패하였습니다.");
		}
		
		return result;
	}
	
	/**
	 * 강좌등록 수정화면을 조회한다.
	 */
	@GetMapping(value = "/courseEnroll/update.do")
	public String selectCourseEnrollUpdate(@RequestParam int course_seq, Model model) {
		
		Course course = courseManageService.getCourse(course_seq);
		
		List<Contents> contents = courseManageService.getContents(course_seq);
		
		model.addAttribute("mode", "U");
		model.addAttribute("course",course);
		model.addAttribute("contents",contents);
		model.addAttribute("typeCode",courseManageService.getTypeCode());
		model.addAttribute("categoryCode",courseManageService.getCategoryCode());
		model.addAttribute("thumbnailFiles",courseManageService.getFilesThumbnail(course));
		
		return "conage/courseEnrollDetail";
	}
	
	/**
	 * 강좌등록 강좌를 수정한다.
	 */
	@PutMapping(value = "/courseEnroll/update.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollUpdate(@ModelAttribute("course") Course course) {
		Map<String, Object> result = Maps.newHashMap();		
		
		try {
			
			//Login User setting
			String loginId = LocalThread.getLoginId();
			course.setReg_user(loginId);
			course.setUpd_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			boolean isInsert = courseManageService.upsertCourse(course,"U");
			
			if(isInsert) {
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
	 * 강좌등록 운영화면을 조회한다.
	 */
	@GetMapping(value = "/courseEnroll/view.do")
	public String selectCourseEnrollView(@RequestParam int course_seq, Model model) {
		
		selectCourseEnrollUpdate(course_seq,model);
		
		model.addAttribute("mode", "V");
		
		return "conage/courseEnrollDetail";
	}
	
	/**
	 * 강좌등록 강좌 정보를 변경한다.
	 */
	@PutMapping(value = "/courseEnroll/change.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollChange(@ModelAttribute("course") Course course) {
		Map<String, Object> result = Maps.newHashMap();

		try {
			
			//Login User setting
			String loginId = LocalThread.getLoginId();
			course.setReg_user(loginId);
			course.setUpd_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			boolean isInsert = courseManageService.changeCourse(course);
			
			if(isInsert) {
				result.put("result", "success");
			} else {
				result.put("result", "failed");
				result.put("msg", "전환에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "전환에 실패하였습니다.");
		}
		
		return result;
	}
	
	/**
	 * 강좌등록 강좌를 삭제한다.
	 */
	@DeleteMapping(value = "/courseEnroll/delete.do")
	@ResponseBody
	public Map<String, Object> selectCourseEnrollDelete(@ModelAttribute("course") Course course) {
		Map<String, Object> result = Maps.newHashMap();

		try {
			
			//Login User setting
			String loginId = LocalThread.getLoginId();
			course.setReg_user(loginId);
			course.setUpd_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			boolean isInsert = courseManageService.deleteCourse(course);
			
			if(isInsert) {
				result.put("result", "success");
			} else {
				result.put("result", "failed");
				result.put("msg", "삭제에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "삭제에 실패하였습니다.");
		}
		
		return result;
	}

	/**
	 * 콘텐츠등록 메인화면을 조회한다.
	 */
	@GetMapping(value = "/contentEnrollMain/index.do")
	public String selectContentEnrollMain(@ModelAttribute ContentsSearch search, Model model) {
		model.addAttribute("search", search);
		return "conage/contentEnrollMain";
	}
	
	/**
	 * 콘텐츠등록 메인화면 목록을 조회한다.
	 */
	@PostMapping(value = "/contentEnrollMain/index.do")
	@ResponseBody
	public Map<String,Object> selectContentEnrollMainAjax(@ModelAttribute ContentsSearch search) {
		Map<String,Object> result = Maps.newHashMap();
		
		JspPagingResult<Map<String, Object>> list = contentsManageService.contentsJspPaging( search );
		
		result.put("list", list);
		result.put("search", search);
		
		return result;
	}
	
	/**
	 * 콘텐츠등록 등록화면을 조회한다.
	 */
	@GetMapping(value = "/contentEnroll/detail.do")
	public String selectContentEnrollDetail(@ModelAttribute ContentsSearch search, Model model) {
		Contents contents = new Contents();
		
		model.addAttribute("mode", "I");
		model.addAttribute("contents", contents);
		model.addAttribute("search", search);
		return "conage/contentEnrollDetail";
	}
	
	/**
	 * 콘텐츠등록 콘텐츠를 등록한다.
	 */
	@PostMapping(value = "/contentEnroll/insert.do")
	@ResponseBody
	public Map<String, Object> selectContentEnrollInsert(@ModelAttribute Contents contents) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			
			//Login User setting
			String loginId = LocalThread.getLoginId();
			contents.setReg_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			//23.04.28 영상구분 '동영상'일 때 영상첨부 필수로 변경
			if(contents.getVod_gb().equals("M") && contents.getUpload_files()[0].isEmpty()) {
				result.put("result", "failed");
				result.put("msg", "영상을 첨부해주세요.");
				return result;
			}
			
			//23.05.02 영상구분 '유튜브'일 때 영상 시간초 API로 setting
			if(contents.getVod_gb().equals("Y")) {
				contents.setVod_time_sec(youtubeApiUtil.getVideoDuration(contents.getVod_url()));
			}
			
			int cnt = contentsManageService.insertContents(contents);
			
			/** 응답값 **/
			if (cnt > 0) {
				if(!contents.getUpload_subs()[0].isEmpty()) {
					contentsManageService.addSubFileupload(contents);
				}
				
				if(!contents.getUpload_files()[0].isEmpty()) {
					int fileCnt = contentsManageService.checkVodFile(contents);
					boolean isUploaded = false;
					if(fileCnt < 1) {
						isUploaded = contentsManageService.addVodFileupload(contents);
					} else {
						result.put("result", "failed");
						result.put("msg", "이미 vod 파일이 존재합니다.");
						return result;
					}
					
					if(isUploaded) {
						result.put("result", "success");
					} else {
						result.put("result", "failed");
						result.put("msg", "파일 업로드에 실패하였습니다.");
					}
				} else {
					result.put("result", "success");
				}
			} else {
				result.put("result", "failed");
				result.put("msg", "등록에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "등록에 실패하였습니다.");
		}
		
		return result;
	}
	
	/**
	 * 콘텐츠등록 수정화면을 조회한다.
	 */
	@GetMapping(value = "/contentEnroll/update.do")
	public String selectContentEnrollDetailUpdate(@RequestParam int contents_seq, @ModelAttribute ContentsSearch search, Model model) {
		Contents contents = contentsManageService.getContents(contents_seq);
		
		// input type=text는 XSS 필터 해제
		contents.setContents_nm(XssPreventer.unescape(contents.getContents_nm()));
		
		// Editor는 XSS 필터 해제
		contents.setContents_descr(XssPreventer.unescape(contents.getContents_descr()));
		
		int mappedCnt = contentsManageService.getMappedCourseList(contents_seq);
		if(mappedCnt > 0) {
			// 연결된 강좌 존재시 영상구분 변경 불가
			model.addAttribute("mode", "N");
		} else {
			// 연결된 강좌 존재시 영상구분 변경 가능
			model.addAttribute("mode", "U");
		}
		
		model.addAttribute("search", search);
		model.addAttribute("contents", contents);
		model.addAttribute("vodFiles", contentsManageService.getFilesVod(Integer.toString(contents_seq)));
		model.addAttribute("subFiles", contentsManageService.getFilesSub(Integer.toString(contents_seq)));
		
		return "conage/contentEnrollDetail";
	}
	
	/**
	 * 콘텐츠등록 콘텐츠를 수정한다.
	 */
	@PutMapping(value = "/contentEnroll/update.do")
	@ResponseBody
	public Map<String, Object> selectContentEnrollUpdate(@ModelAttribute Contents contents) {
		Map<String, Object> result = Maps.newHashMap();
		
		try {
			//Login User setting
			String loginId = LocalThread.getLoginId();
			contents.setUpd_user(loginId);
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			//23.04.28 영상구분 '동영상'일 때 영상첨부 필수로 변경
			if(contents.getVod_gb().equals("M") && contents.getUpload_files()[0].isEmpty()
					&& (contents.getDel_vod_file_seqs() != null && contents.getDel_vod_file_seqs().size() > 0)) {
				result.put("result", "failed");
				result.put("msg", "영상을 첨부해주세요.");
				return result;
			}
			
			//23.05.02 영상구분 '유튜브'일 때 영상 시간초 API로 setting
			if(contents.getVod_gb().equals("Y")) {
				contents.setVod_time_sec(youtubeApiUtil.getVideoDuration(contents.getVod_url()));
			}
			
			int cnt = contentsManageService.updateContents(contents);
			
			/** 응답값 **/
			if (cnt > 0) {
				contentsManageService.removeFileupload(contents);
				
				if(!contents.getUpload_subs()[0].isEmpty()) {
					contentsManageService.addSubFileupload(contents);
				}
				
				if(!contents.getUpload_files()[0].isEmpty()) {
					int fileCnt = contentsManageService.checkVodFile(contents);
					boolean isUploaded = false;
					if(fileCnt < 1) {
						isUploaded = contentsManageService.addVodFileupload(contents);
					} else {
						result.put("result", "failed");
						result.put("msg", "이미 vod 파일이 존재합니다.");
						return result;
					}
					
					if(isUploaded) {
						result.put("result", "success");
					} else {
						result.put("result", "failed");
						result.put("msg", "파일 업로드에 실패하였습니다.");
					}
				} else {
					result.put("result", "success");
				}
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
	 * 콘텐츠등록 콘텐츠를 삭제한다.
	 */
	@DeleteMapping(value = "/contentEnroll/delete.do")
	@ResponseBody
	public Map<String, Object> selectContentEnrollDelete(@RequestParam List<Integer> del_seqs) {
		Map<String, Object> result = Maps.newHashMap();
		List<Map<String, Object>> checkList = new ArrayList<Map<String,Object>>();
		
		try {
			
			if(!LocalThread.isAdmin()) {
				result.put("result", "failed");
				result.put("msg", "권한이 없습니다.");
				return result;
			}
			
			for(int seq : del_seqs) {
				checkList = contentsManageService.getActivatedCourseList(seq);
				if(!checkList.isEmpty()) {
					result.put("result", "checked");
					result.put("course", checkList);
					return result;
				}
			}
			
			boolean isDeleted = contentsManageService.deleteContents(del_seqs);
			
			if(isDeleted) {
				result.put("result", "success");
			} else {
				result.put("result", "failed");
				result.put("msg", "삭제에 실패하였습니다.");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", "failed");
			result.put("msg", "삭제에 실패하였습니다.");
		}
		
		return result;
	}
	
}
