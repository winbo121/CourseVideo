package egovframework.work.test.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.common.base.BaseService;
import egovframework.work.test.mapper.TestKiceDataMapper;
import egovframework.work.test.model.kicedata.RegistKiceData;
import egovframework.work.test.model.kicedata.SearchKiceContents;

/** TS_KOTECH_DATA 작업 프로그램 서비스 **/
@Service
public class TestKiceDataService extends BaseService {

	@Autowired
	private TestKiceDataMapper testKiceDataMapper;

	public ArrayList<String> search(SearchKiceContents input) {
		return testKiceDataMapper.getKiceProgramBookSeqs( input );
	}
	
	public void regist( RegistKiceData input ) {
		testKiceDataMapper.registKiceData( input );
	}
	
}
