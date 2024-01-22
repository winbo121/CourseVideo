package egovframework.work.search.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.work.search.mapper.CommonSearchMapper;

@Service
public class CommonSearchService extends BaseService {

	@Autowired
	private CommonSearchMapper commonSearchMapper;

	public void insertSearchLog(Map<String, Object> param) {
		commonSearchMapper.insertSearchLog(param);
		
	}
	
	
	
	
	
	
}
