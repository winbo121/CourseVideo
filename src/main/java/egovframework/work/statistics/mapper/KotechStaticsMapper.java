package egovframework.work.statistics.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.work.statistics.model.StaticsPagingSearch;
import egovframework.work.test.model.jsp.TestJspPagingSearch;


@Mapper
public interface KotechStaticsMapper {


	/** JSP 페이징  **/
	public Integer getJspTotalCount( TestJspPagingSearch search );
	public List<Map<String, Object>> getJspPagedList( TestJspPagingSearch search );
	
	/** activeRecordMain JSP 그래프**/
	public List<Map<String, Object>> getActiveRecordChart( StaticsPagingSearch search );
	
	/** activeRecordMain JSP 페이징  **/
	public Integer getActiveRecordTotalCount( StaticsPagingSearch search );
	public List<Map<String, Object>> getActiveRecordPagedList( StaticsPagingSearch search );
	/** 로그인 사용자 통계 페이징  **/
	public Integer getActiveLoginUserRecordTotalCount( StaticsPagingSearch search );
	public List<Map<String, Object>> getActiveLoginUserRecordPagedList( StaticsPagingSearch search );
	/** 강좌 통계 페이징  **/
	public Integer getCourseRecordTotalCount( StaticsPagingSearch search );
	public List<Map<String, Object>> getCourseRecordPagedList( StaticsPagingSearch search );
	

	public List<EgovMap>  getSelectSearchCal1();
	public List<EgovMap>  getSelectSearchCal2();
	public List<EgovMap>  getSelectSearchCal3();
	public List<EgovMap>  getSelectSearchCal4();

	/** 총 강좌 수, 총 회원 수, 총 리뷰 수 **/
	public Map<String,Object> getTotalStatistic();

	/** 시도 코드 **/
	public List<Map<String, Object>> getAgeCode();
	
}
