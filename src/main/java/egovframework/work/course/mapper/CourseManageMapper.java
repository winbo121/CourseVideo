package egovframework.work.course.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.work.course.model.Contents;
import egovframework.work.course.model.ContentsSearch;
import egovframework.work.course.model.Course;
import egovframework.work.course.model.CourseSearch;

@Mapper
public interface CourseManageMapper {
	
	/** 전체 강좌 DATATABLE 페이징  **/
	public Integer getCourseTotalCount(CourseSearch search);
	public List<Map<String, Object>> getCourseJspPagedList(CourseSearch search);
	
	/** 콘텐츠 DATATABLE 페이징  **/
	public Integer getContentsTotalCount(ContentsSearch search);
	public List<Map<String, Object>> getContentsJspPagedList(ContentsSearch search);
	
	/** 카테고리 코드 목록 **/
	public List<Map<String, Object>> getCategoryCode();
	
	/** 강좌 유형 코드 목록 **/
	public List<Map<String, Object>> getTypeCode();
	
	/** 강좌 CRUD **/
	public Integer insertCourse(Course course);
	public Course getCourse(int course_seq);
	public Integer updateCourse(Course course);
	public int deleteCourse(Course course);
	public int changeCourse(Course course);
	
	/** 콘텐츠 CRUD **/
	public List<Contents> getContents(int course_seq);
	
	/** 강좌-콘텐츠 매핑 CRUD **/
	public Integer selectCourseContentsMapped(@Param("course_seq") Integer course_seq
			, @Param("contents_seq") Integer contents_seq);
	public Integer insertCourseContentsMapped(@Param("course_seq") Integer course_seq
			, @Param("contents_seq") Integer contents_seq
			, @Param("round_sort_no") Integer round_sort_no);
	public Integer updateCourseContentsMapped(@Param("course_seq") Integer course_seq
			, @Param("contents_seq") Integer contents_seq
			, @Param("round_sort_no") Integer round_sort_no);
	public Integer deleteCourseContentsMapped(Course course);

}
