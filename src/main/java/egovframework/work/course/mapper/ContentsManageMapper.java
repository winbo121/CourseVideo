package egovframework.work.course.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.work.course.model.Contents;
import egovframework.work.course.model.ContentsSearch;

@Mapper
public interface ContentsManageMapper {
	
	/** JSP 페이징  **/
	public Integer getContentsTotalCount( ContentsSearch search );
	public List<Map<String, Object>> getContentsJspPagedList( ContentsSearch search );
	
	/** 콘텐츠 등록 **/
	public Integer insertContents(Contents contents);
	
	/** 콘텐츠 조회 **/
	public Contents getContents(int contents_seq);
	
	/** 콘텐츠 수정 **/
	public Integer updateContents(Contents contents);
	
	/** 콘텐츠 삭제 **/
	public Integer deleteContents(Contents contents);
	
	/** 기존 파일 여부 확인 **/
	public Integer checkFile(Map<String, Object> param);
	
	/** 콘텐츠 운영중 강좌 list **/
	public List<Map<String, Object>> getActivatedCourseList(int contents_seq);
	
	/** 삭제용 강좌 list **/
	public List<Map<String, Object>> getDeleteCourseList(int contents_seq);
	
	/** 콘텐츠 연결된 강좌 list **/
	public Integer getMappedCourseList(int contents_seq);
	
	/** 콘텐츠 매핑 삭제 **/
	public Integer deleteContentsMapped(Map<String, Object> param);
	
	/** 강좌 삭제  **/
	public Integer deleteCourse(Map<String, Object> param);
	
	/** 강좌 차시 개수 수정  **/
	public Integer updateCourseRound(Map<String, Object> param);
	
}
