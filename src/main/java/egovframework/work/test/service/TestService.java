package egovframework.work.test.service;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.common.aop.annotation.AopBefore;
import egovframework.common.base.BaseService;
import egovframework.common.error.util.datatable.paging.DtPagingResult;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.CacheUtils;
import egovframework.work.test.mapper.TestMapper;
import egovframework.work.test.model.datatable.TestDtPagingSearch;
import egovframework.work.test.model.jsp.TestJspPagingSearch;

@Service
public class TestService extends BaseService {

	@Autowired
	private TestMapper testMapper;

	/** 데이터 테이블 페이징 리스트 조회  **/
	public DtPagingResult<Map<String, Object>> dtPaging(TestDtPagingSearch search) {
		Integer totalCount = testMapper.getTestDtTotalCount( search );
		List<Map<String,Object>> pagedList = testMapper.getTestDtPagedList( search );
		return super.convertDtPaging(search, pagedList, totalCount);
	}
	/** 데이터 테이블 엑셀 다운로드 **/
	public List<Map<String, Object>> dtExcel( TestDtPagingSearch search ){
		return testMapper.getTestDtPagedList(search);
	}


	/** JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> jspPaging( TestJspPagingSearch search ){
		Integer totalCount = testMapper.getTestJspTotalCount( search );
		List<Map<String,Object>> pagedList = testMapper.getTestJspPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	/** JSP 엑셀 다운로드 **/
	public List<Map<String, Object>> jspExcel( TestJspPagingSearch search ){
		return testMapper.getTestJspPagedList(search);
	}


	@AopBefore
	@Cacheable( key=CacheUtils.CACHE_KEY_GENERATE , value=CacheUtils.CACHE_NAME ) /** CACHE 설정 **/
	public List<Map<String,Object>> getTestHelloList(){
		List<Map<String,Object>> result = testMapper.getTestHelloList();

		return result;
	}



	@Transactional
	public void doTransactionTest()  {

		testMapper.addTestHello(UUID.randomUUID().toString(), "1", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "2", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "3", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "4", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "5", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "6", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "7", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "8", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "9", null);
		testMapper.addTestHello(UUID.randomUUID().toString(), "10", null);

		if( true ) {
			throw new RuntimeException();
		}

	}






}
