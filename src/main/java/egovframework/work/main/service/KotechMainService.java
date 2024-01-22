package egovframework.work.main.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.work.main.mapper.KotechMainMapper;

@Service
public class KotechMainService extends BaseService {

	@Autowired
	private KotechMainMapper kotechMainMapper;

	
	/** 메인 페이지 강좌 리스트 조회 **/
	public List<Map<String, Object>> courseList(Map<String, Object>param){
		List<Map<String, Object>> courseList = kotechMainMapper.getCourseList(param);
		
		return courseList;
	}
	
	/** 메인 하단 통계 카운트 조회쿼리 **/
	public Map<String, Object> objectCntList(){
		Integer course_totcnt = kotechMainMapper.getObjectCntList();
		Integer stu_totcnt = kotechMainMapper.getStuCntList();
		Integer his_totcnt = kotechMainMapper.getHisCntList();
		
		
		
		Map<String, Object> rParm = new HashMap<String, Object>(); 
		rParm.put("course_totcnt", course_totcnt);
		rParm.put("stu_totcnt", stu_totcnt);
		rParm.put("his_totcnt", his_totcnt);
		
		
		return rParm;
	}
	
	
	
	
	
	
}
