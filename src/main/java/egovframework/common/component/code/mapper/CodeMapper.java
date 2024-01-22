package egovframework.common.component.code.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.common.component.code.model.CommCd;
import egovframework.common.component.code.model.SchCd;


/** 코드 접근 MAPPER **/
@Mapper
public interface CodeMapper {

	/** 학교 코드 리스트 조회 **/
	public List<SchCd> getSchCds(  @Param("sch_cd") String sch_cd
											,@Param("sch_name")  String sch_name  );

	/** 공통 코드 리스트 조회 **/
	public List<CommCd> getCommCds( @Param("leader_cd") String leader_cd
												 ,@Param("comm_cd") String comm_cd );

	/** 금칙어 리스트 조회 **/
	public List<String> getProhibitedList();
	
}
