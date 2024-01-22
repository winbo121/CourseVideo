package egovframework.work.mystudy.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.work.mystudy.model.KotechMyStudyDtPagingSearch;
import egovframework.work.mystudy.model.KotechMyStudyJspPagingSearch;


@Mapper
public interface KotechMyStudyMapper {

	/** JSP 페이징  **/
	public Integer getKotechMyStudyJspTotalCount( KotechMyStudyJspPagingSearch search );
	public List<Map<String, Object>> getKotechMyStudyJspPagedList( KotechMyStudyJspPagingSearch search );


}
