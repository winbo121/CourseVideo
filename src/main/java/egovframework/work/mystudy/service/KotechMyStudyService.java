package egovframework.work.mystudy.service;

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
import egovframework.work.mystudy.mapper.KotechMyStudyMapper;
import egovframework.work.mystudy.model.KotechMyStudyDtPagingSearch;
import egovframework.work.mystudy.model.KotechMyStudyJspPagingSearch;

@Service
public class KotechMyStudyService extends BaseService {

	@Autowired
	private KotechMyStudyMapper myStudyMapper;

	/** JSP 페이징 리스트 조회 **/
	public JspPagingResult<Map<String, Object>> jspPaging( KotechMyStudyJspPagingSearch search ){
		Integer totalCount = myStudyMapper.getKotechMyStudyJspTotalCount( search );
		List<Map<String,Object>> pagedList = myStudyMapper.getKotechMyStudyJspPagedList(search);
		return super.convertJspPaging(search, pagedList, totalCount);
	}
	
	/** JSP 엑셀 다운로드 **/
	public List<Map<String, Object>> jspExcel( KotechMyStudyJspPagingSearch search ){
		return myStudyMapper.getKotechMyStudyJspPagedList(search);
	}



}
