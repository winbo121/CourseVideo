package egovframework.common.component.scheduler.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/** scheduler MAPPER **/
@Mapper
public interface WebLogSchedulerMapper {
	
	public Map<String,Object> getScheduler (@Param("scheduler_seq") int scheduler_seq); 

	public void callActiveLog(Map<String, Object> param);
	
	public int addSchedulerLog(Map<String, Object> param);
	
	public int addSchedulerActiveLog(Map<String, Object> param);
	
	public void addSchedulerFailLog(Map<String, Object> param);
	
	public void updateSchedulerLog(Map<String, Object> param);
	
	public void updateSchedulerActiveLog(Map<String, Object> param);
	
	
	
}
