package egovframework.work.statistics.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.work.statistics.mapper.KotechStaticsMapper;
import egovframework.work.statistics.model.StaticsPagingSearch;
import egovframework.work.test.model.jsp.TestJspPagingSearch;

@Service
public class KotechStaticsService extends BaseService {

	@Autowired
	private KotechStaticsMapper kotechStatMapper;

	/** JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> jspPaging(TestJspPagingSearch search) {
		Integer totalCount = kotechStatMapper.getJspTotalCount(search);
		List<Map<String, Object>> pagedList = kotechStatMapper.getJspPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** activeRecordMain JSP 차트 **/
	public List<Map<String, Object>> activeRecordChart(StaticsPagingSearch search) {
		List<Map<String, Object>> activeRecordChart = kotechStatMapper.getActiveRecordChart(search);
		return activeRecordChart;
	}
	
	/** activeRecordMain JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> activeRecord_paging(StaticsPagingSearch search) {
		Integer totalCount = kotechStatMapper.getActiveRecordTotalCount(search);
		List<Map<String, Object>> pagedList = kotechStatMapper.getActiveRecordPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** activeRecordMain JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> activeLoginUserRecord_paging(StaticsPagingSearch search) {
		Integer totalCount = kotechStatMapper.getActiveLoginUserRecordTotalCount(search);
		List<Map<String, Object>> pagedList = kotechStatMapper.getActiveLoginUserRecordPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** 강좌 통계 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> courseRecord_paging(StaticsPagingSearch search) {
		Integer totalCount = kotechStatMapper.getCourseRecordTotalCount(search);
		List<Map<String, Object>> pagedList = kotechStatMapper.getCourseRecordPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}

	public List<EgovMap>  selectSearchCal1(){
		return kotechStatMapper.getSelectSearchCal1();
	}
	
	public List<EgovMap>  selectSearchCal2(){
		return kotechStatMapper.getSelectSearchCal2();
	}
	
	public List<EgovMap>  selectSearchCal3(){
		return kotechStatMapper.getSelectSearchCal3();
	}
	
	public List<EgovMap>  selectSearchCal4(){
		return kotechStatMapper.getSelectSearchCal4();
	}

	/** 총 강좌 수, 총 회원 수, 총 리뷰 수 **/
	public Map<String,Object> getTotalStatistic(){
		return kotechStatMapper.getTotalStatistic();
	}

	/** 시도 코드 **/
	public List<Map<String, Object>> getAgeCode() {
		return kotechStatMapper.getAgeCode();
	}
}
