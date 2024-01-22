package egovframework.work.course.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.nhncorp.lucy.security.xss.XssPreventer;

import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.work.course.mapper.CourseManageMapper;
import egovframework.work.course.model.Contents;
import egovframework.work.course.model.ContentsSearch;
import egovframework.work.course.model.Course;
import egovframework.work.course.model.CourseSearch;

@Service
public class CourseManageService extends BaseService {

	@Autowired
	CourseManageMapper courseManageMapper;
	
	/** 대상 파일 유형  **/
	private static final FILE_REG_GB TARGET_FILE_REG_GB = FILE_REG_GB.TB_COURSE_THUMBNAIL;

	@Autowired
	private FileComponent fileComponent;
	
	/** 전체 강좌 데이터 테이블 페이징 리스트 조회  **/
	public JspPagingResult<Map<String, Object>> courseJspPaging(CourseSearch search) {
		Integer totalCount = courseManageMapper.getCourseTotalCount(search);
		List<Map<String,Object>> pagedList = courseManageMapper.getCourseJspPagedList(search);
		for(int i = 0 ; i < pagedList.size() ; i++) {
			pagedList.get(i).put("courseNm",XssPreventer.unescape(pagedList.get(i).get("courseNm").toString()));
			pagedList.get(i).put("instructorNm",XssPreventer.unescape(pagedList.get(i).get("instructorNm").toString()));
			pagedList.get(i).put("regInstNm",XssPreventer.unescape(pagedList.get(i).get("regInstNm").toString()));
			pagedList.get(i).put("courseDescr",XssPreventer.unescape(pagedList.get(i).get("courseDescr").toString()));
		}
		
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** 강좌 데이터 테이블 엑셀 다운로드 **/
	public List<Map<String, Object>> courseJspExcel(CourseSearch search){
		return courseManageMapper.getCourseJspPagedList(search);
	}
	
	/** 콘텐츠 테이블 페이징 리스트 조회  **/
	public JspPagingResult<Map<String, Object>> contentsJspPaging(ContentsSearch search) {
		Integer totalCount = courseManageMapper.getContentsTotalCount(search);
		List<Map<String,Object>> pagedList = courseManageMapper.getContentsJspPagedList(search);
		for(int i = 0 ; i < pagedList.size() ; i++) {
			pagedList.get(i).put("contents_nm",XssPreventer.unescape(pagedList.get(i).get("contents_nm").toString()));
			pagedList.get(i).put("contents_descr",XssPreventer.unescape(pagedList.get(i).get("contents_descr").toString()));
		}
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** 카테고리 코드 목록 **/
	public List<Map<String, Object>> getCategoryCode(){
		return courseManageMapper.getCategoryCode();
	}
	
	/** 강좌 유형 코드 목록 **/
	public List<Map<String, Object>> getTypeCode(){
		return courseManageMapper.getTypeCode();
	};
	
	/** 강좌 등록/수정 **/
	@Transactional
	public boolean upsertCourse(Course course, String type) {
		boolean result = false;
		int cnt = 0;
		int cnt2 = 0;
		
		// 강좌 등록 // 수정
		if (type.equals("I")) {
			cnt = insertCourse(course);	
		} else {
			cnt = updateCourse(course);
		}
		
		if(cnt > 0) {
			
			int size = course.getCourse_round();
			int courseSeq = course.getCourse_seq();
			
			// 강좌-콘텐츠 매핑정보 삭제
			deleteCourseContentsMapped(course);
			
			for(int i = 0 ; i < size ; i++) {
				int chk = 0;
				
				Integer roundSortNo = i+1;
				Integer contentsSeq = course.getGet_contents_seqs().get(i);
				// 강좌-콘텐츠 매핑정보 존재 유무 조회
				int mapped = selectCourseContentsMapped(courseSeq, contentsSeq);
				
				if(mapped > 0) {
					// 강좌-콘텐츠 매핑정보 수정
					chk = updateCourseContentsMapped(courseSeq, contentsSeq, roundSortNo);
				} else {
					// 강좌-콘텐츠 매핑정보 등록
					chk = insertCourseContentsMapped(courseSeq, contentsSeq, roundSortNo); 
				}
				
				if(chk > 0) {
					cnt2 += chk;
				} else {
					new Exception("fail");
				}
				
				
			}
			
			if(cnt2 == size) {
				if(course.getDel_files_seqs() != null && course.getDel_files_seqs().size() > 0) {
					// 첨부파일(섬네일) 삭제
					removeFileupload(course);	
				}
				
				// 첨부파일(섬네일) 등록
				result = addFileupload(course);
				return result;
			} else {
				new Exception("fail");
			}
		} 
		
		return result;
	}
	
	/** 강좌 등록 **/
	public Integer insertCourse(Course course) {
		course.setCourse_round(course.getGet_contents_seqs().size());
		return courseManageMapper.insertCourse(course); 
	}
	
	/** 강좌 수정 **/
	public Integer updateCourse(Course course) {
		course.setCourse_round(course.getGet_contents_seqs().size());
		return courseManageMapper.updateCourse(course);
	}
	
	/** 강좌-콘텐츠 매핑 정보 조회 **/
	public Integer selectCourseContentsMapped(Integer courseSeq, Integer contentsSeq) {
		return courseManageMapper.selectCourseContentsMapped(courseSeq, contentsSeq);
	}
	
	/** 강좌-콘텐츠 매핑 정보 등록 **/
	public Integer insertCourseContentsMapped(Integer courseSeq, Integer contentsSeq, Integer roundSortNo) {
		return courseManageMapper.insertCourseContentsMapped(courseSeq, contentsSeq, roundSortNo);
	}
	
	/** 강좌-콘텐츠 매핑 정보 수정 **/
	public Integer updateCourseContentsMapped(Integer courseSeq, Integer contentsSeq, Integer roundSortNo) {
		return courseManageMapper.updateCourseContentsMapped(courseSeq, contentsSeq, roundSortNo);
	}
	
	/** 강좌-콘텐츠 매핑 정보 삭제 **/
	public Integer deleteCourseContentsMapped(Course course) {
		return courseManageMapper.deleteCourseContentsMapped(course);
	}
	
	/** 콘텐츠 조회 **/
	public List<Contents> getContents(int course_seq){
		List<Contents> contents = courseManageMapper.getContents(course_seq);
		
		for(int i = 0 ; i < contents.size() ; i++) {
			contents.get(i).setContents_nm(XssPreventer.unescape(contents.get(i).getContents_nm()));
			// Editor는 XSS 필터 해제
			contents.get(i).setContents_descr(XssPreventer.unescape(contents.get(i).getContents_descr()));
		}
		
		return contents;
	}
	
	/** 강좌 조회 **/
	public Course getCourse(int course_seq) {
		Course course = courseManageMapper.getCourse(course_seq);;
		// input type=text는 XSS 필터 해제
		course.setCourse_nm(XssPreventer.unescape(course.getCourse_nm()));
		course.setCourse_subject(XssPreventer.unescape(course.getCourse_subject()));
		course.setInstructor_nm(XssPreventer.unescape(course.getInstructor_nm()));
		course.setReg_inst_nm(XssPreventer.unescape(course.getReg_inst_nm()));
		
		// Editor는 XSS 필터 해제
		course.setCourse_descr(XssPreventer.unescape(course.getCourse_descr()));
		

		return course;
	}
	/** 강좌 정보 변경(use_yn) **/
	@Transactional
	public boolean changeCourse(Course course) {
		boolean result = false;
		int cnt = 0;
		cnt = courseManageMapper.changeCourse(course);
		if(cnt > 0) {
			result = true;
		}
		
		return result;
	}
	
	/** 강좌 삭제 **/
	@Transactional
	public boolean deleteCourse(Course course) {
		boolean result = false;
		int cnt = 0;
		
		//Login User setting
		String loginId = LocalThread.getLoginId();
		course.setUpd_user(loginId);
		cnt = courseManageMapper.deleteCourse(course);		
		if(cnt > 0) {
			// 첨부파일(섬네일) 삭제
			removeFileupload(course);	
			result = true;
		}
		
		return result;
	}
	
	/** 파일 리스트 조회 **/
	public  List<FileData> getFilesThumbnail( Course course ) {
		return fileComponent.getFiles(TARGET_FILE_REG_GB, course.getCourse_seq().toString());
	}


	/** 파일 등록  **/
	@Transactional
	public boolean addFileupload( Course course ) {
		boolean result = false;
		MultipartFile[] upload_files = course.getUpload_files();

		try {
			/** 글등록시에 아래와 같이 파일업로드 **/
			fileComponent.addFiles(TARGET_FILE_REG_GB, course.getCourse_seq().toString(), Arrays.asList( upload_files ) );
			result = true;
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
			
		return result;

	}

	/** 파일 삭제  **/
	@Transactional
	public void removeFileupload( Course course ) {
		List<Integer> file_seq_list = course.getDel_files_seqs();
		fileComponent.removeFile( TARGET_FILE_REG_GB, course.getCourse_seq().toString(), file_seq_list );
		fileComponent.deleteRealFiles(file_seq_list);
	}
	
}
