package egovframework.work.course.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.work.course.model.KotechCourseModel;
import egovframework.work.test.model.jsp.TestJspPagingSearch;


@Mapper
public interface KotechCourseMapper {


	/** JSP 페이징  **/
	public Integer getJspTotalCount( TestJspPagingSearch search );
	public List<Map<String, Object>> getJspPagedList( TestJspPagingSearch search );
	public List<Map<String, Object>> getCourseGubunList();

	
	/**
	 * 강좌 영상 컨텐츠 리스트 조회
	 */
	public List<Map<String,Object>> getCourseContentsList (KotechCourseModel model);
	
	/**
	 * 강좌 조회
	 */
	public KotechCourseModel getCourseInfo (KotechCourseModel model);
	
	
	/**
	 * 좋아요 등록
	 */
	
	void insertLike(Map<String, Object> param);
	
	/**
	 * 강좌 영상 컨텐츠 상세조회
	 */
	public Map<String,Object> getCourseVideoInfo (KotechCourseModel model);
	
	/**
	 * 강좌 영상 컨텐츠 상세조회
	 */
	public Map<String,Object> getContentsVideo (KotechCourseModel model);

	/**
	 * 강좌 조회수 증가
	 */
	public void inserAddtViewCnt( KotechCourseModel model );
	
	
	/**
	 * 강좌 영상 시간 최초등록
	 */
	public void insertVideoTime( KotechCourseModel model );
	
	/**
	 * 강좌 영상 시간 수정
	 */
	public void updateVideoTime( KotechCourseModel model );
	
	/**
	 * 유저별 등록 강좌 검색 
	 */
	public List<Map<String, Object>> getRegUserList();
	
	/**
	 * 최신 강좌 검색 
	 */
	public List<Map<String, Object>> getLatestList();
	
	/**
	 * 강좌 리뷰 점수등록 
	 */
	public void insertReviewScore(Map<String, Object> param);
	
	/**
	 * 강좌 리뷰 점수등록 확인
	 * @return 
	 */
	public Map<String, Object> getReviewHist(KotechCourseModel searchVO);
	
	/**
	 * 외부링크 강좌 수강여부 
	 */
	public Integer outerCompleteCnt(KotechCourseModel searchVO);
	
	/**
	 * 유튜브 강좌 수강여부 
	 */
	public Integer youtubeCompleteCnt(KotechCourseModel searchVO);
	
}
