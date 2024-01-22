package egovframework.work.test.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.work.test.model.datatable.TestDtPagingSearch;
import egovframework.work.test.model.jsp.TestJspPagingSearch;


@Mapper
public interface TestMapper {

	public List<Map<String,Object>> getTestHelloList();

	public int addTestHello( 	@Param("var1") String var1
									,@Param("var2") String var2
									,@Param("var3") String var3 );

	/** DATATABLE 페이징  **/
	public Integer getTestDtTotalCount( TestDtPagingSearch search );
	public List<Map<String, Object>> getTestDtPagedList( TestDtPagingSearch search );


	/** JSP 페이징  **/
	public Integer getTestJspTotalCount( TestJspPagingSearch search );
	public List<Map<String, Object>> getTestJspPagedList( TestJspPagingSearch search );


}
