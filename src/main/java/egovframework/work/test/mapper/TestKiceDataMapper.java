package egovframework.work.test.mapper;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;

import egovframework.work.test.model.kicedata.RegistKiceData;
import egovframework.work.test.model.kicedata.SearchKiceContents;

/** TS_KOTECH_DATA 작업 프로그램 맵퍼 **/
@Mapper
public interface TestKiceDataMapper {
	
	/** book_seq 조회 **/
	public ArrayList<String> getKiceProgramBookSeqs(SearchKiceContents input);
	
	public void registKiceData( RegistKiceData input );
}
