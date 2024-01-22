package egovframework.work.course.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.work.course.mapper.KotechCourseMapper;
import egovframework.work.course.model.KotechCourseModel;
import egovframework.work.test.model.jsp.TestJspPagingSearch;

@Service
public class KotechCourseService extends BaseService {

	@Autowired
	private KotechCourseMapper kotechCourseMapper;

	/** JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> jspPaging(TestJspPagingSearch search) {
		Integer totalCount = kotechCourseMapper.getJspTotalCount(search);
		List<Map<String, Object>> pagedList = kotechCourseMapper.getJspPagedList(search);
		
		
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	
	
	public List<Map<String, Object>> courseGubun(){
		List<Map<String, Object>> courseGubun = kotechCourseMapper.getCourseGubunList();
		
		return courseGubun;
	}
	
	
	
	/**
	 * 강좌 조회 수 증가 
	 */
	public void inserAddtViewCnt( KotechCourseModel model ) {
		kotechCourseMapper.inserAddtViewCnt(model);
	}
	
	/**
	 * 좋아요 등록 
	 */
	public void insertLike( Map<String, Object> param ) {
		kotechCourseMapper.insertLike(param);
	}
	
	
	/**
	 * 강좌 영상 컨텐츠 리스트 조회
	 */
	public List<Map<String,Object>> getCourseContentsList (KotechCourseModel model){
		return kotechCourseMapper.getCourseContentsList(model);
	}
	
	/**
	 * 강좌 조회
	 */
	public KotechCourseModel getCourseInfo (KotechCourseModel model){
		return kotechCourseMapper.getCourseInfo(model);
	}
	
	/**
	 * 강좌 영상 컨텐츠 상세조회
	 */
	public Map<String,Object> getCourseVideoInfo (KotechCourseModel model){
		return kotechCourseMapper.getCourseVideoInfo(model);
	}
	/**
	 * 컨텐츠 영상조회
	 */
	public Map<String,Object> getContentsVideo (KotechCourseModel model){
		return kotechCourseMapper.getContentsVideo(model);
	}
	/**
	 * 강좌 시청 시간체크 
	 */
	public void insertVideoTime( KotechCourseModel model ) {
		kotechCourseMapper.insertVideoTime(model);
	
	}
	
	/**
	 * 강좌 시청 시간체크 
	 */
	public void updateVideoTime( KotechCourseModel model ) {
		kotechCourseMapper.updateVideoTime(model);
	}

	
	/**
	 * 유저별 등록 강좌 검색 
	 */
	public List<Map<String, Object>> getRegUserList() {
		
		return kotechCourseMapper.getRegUserList();
	}


	/**
	 * 최신 강좌 검색 
	 */
	public List<Map<String, Object>> getLatestList() {
		// TODO Auto-generated method stub
		return kotechCourseMapper.getLatestList();
	}



	public void insertReviewScore(Map<String, Object> param) {
		kotechCourseMapper.insertReviewScore(param);
	}



	public Map<String, Object> getReviewHist(KotechCourseModel searchVO) {
		Map<String, Object> map =  kotechCourseMapper.getReviewHist(searchVO);
		return map;
	}



	public Integer outerCompleteCnt(KotechCourseModel searchVO) {
		return kotechCourseMapper.outerCompleteCnt(searchVO);
	}



	public Integer youtubeCompleteCnt(KotechCourseModel searchVO) {
		return kotechCourseMapper.youtubeCompleteCnt(searchVO);
	}
	
}
