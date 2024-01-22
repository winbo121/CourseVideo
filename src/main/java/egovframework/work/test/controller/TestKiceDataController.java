package egovframework.work.test.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.base.BaseController;
import egovframework.work.test.model.kicedata.RegistKiceData;
import egovframework.work.test.model.kicedata.SearchKiceContents;
import egovframework.work.test.service.TestKiceDataService;
import lombok.extern.slf4j.Slf4j;


/** TS_KOTECH_DATA 작업 프로그램 컨트롤러 **/
@Slf4j
@Controller
public class TestKiceDataController extends BaseController {
	
	@Autowired
	private TestKiceDataService testKiceDataService;
	
	
	/** 뷰 이동 **/
	@RequestMapping( value="/test/kice/data.do" ,method= RequestMethod.GET  )
	public String index() {
		
		return "test/kice_data";
	}
	
	
	/** 도서목록순번 검색 **/
	@RequestMapping( value="/test/kice/search.do" ,method= RequestMethod.POST  )
	@ResponseBody
	public ArrayList<String> search( @ModelAttribute SearchKiceContents input ) {
		
		log.info( "input={}", input );
		
		/** 유효성 검사 **/
		super.doValid( input );
		
		ArrayList<String> book_seqs = testKiceDataService.search(input);
		
		return book_seqs;

	}
	
	/** KOTECH DATA 등록 **/
	@RequestMapping( value="/test/kice/regist.do" ,method= RequestMethod.POST  )
	@ResponseBody
	public void regist( @ModelAttribute RegistKiceData input ) {
		super.doValid( input );
		
		testKiceDataService.regist(input);
	}
}
