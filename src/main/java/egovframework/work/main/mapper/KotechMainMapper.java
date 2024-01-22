package egovframework.work.main.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface KotechMainMapper {


	/** 메인 강좌 리스트 조회쿼리  **/
	public List<Map<String, Object>> getCourseList(Map<String, Object>param);

	/** 메인 하단 통계 카운트 조회쿼리  **/
	public Integer getObjectCntList();
	public Integer getStuCntList();
	public Integer getHisCntList();
	
	
	
	
	
}
