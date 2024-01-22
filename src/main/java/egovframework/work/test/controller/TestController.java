package egovframework.work.test.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.base.BaseController;
import egovframework.common.error.util.datatable.paging.DtPagingResult;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.util.LocalThread;
import egovframework.common.view.excel.template.SheetTemplate;
import egovframework.work.test.model.datatable.TestDtPagingSearch;
import egovframework.work.test.model.hello.TestHello;
import egovframework.work.test.model.jsp.TestJspPagingSearch;
import egovframework.work.test.model.modal.TestSampleJsonModal;
import egovframework.work.test.model.validator.JqueryValidator;
import egovframework.work.test.service.TestService;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Controller
@RequestMapping("/test/")
public class TestController extends BaseController  {

	@Autowired
	private TestService testService;

	@RequestMapping( value = "exception.do", method = RequestMethod.GET )
	public String exception() {

		super.throwMessageException("exception");
		return null;
	}

	@RequestMapping( value = "hello.do", method = RequestMethod.GET )
	public String hello( Model model, @ModelAttribute TestHello input ) {


		LocalThread.getLoginUser()
						.ifPresent( usr -> log.info("{}", usr ) );

		super.doValid( input );

		log.info("###################################");
		log.info("# XSS 처리 ");
		log.info("{}",input.toString());
		log.info("###################################");


		List<Map<String,Object>> list = testService.getTestHelloList();
		model.addAttribute("name", "XXX");
		model.addAttribute("list", list);
		return "test/hello";
	}

	@RequestMapping( value = "transaction.do", method = RequestMethod.GET )
	public String transaction() {
		testService.doTransactionTest();
		return "test/hello";
	}

	/** SWEET ALERT 샘플 **/
	@RequestMapping( value = "sweet_alert.do", method = RequestMethod.GET )
	public String sweat_alert() {
		return "test/sweet_alert";
	}

	/** JQUERY VALIDATOR 샘플 **/
	@RequestMapping( value = "jquery_validator.do", method = RequestMethod.GET )
	public String jquery_validator( JqueryValidator jqueryValidator ) {

		jqueryValidator.setParam1("param1");
		jqueryValidator.setParam2("abc@nav.com");
		jqueryValidator.setParam3("http://naver.com");
		jqueryValidator.setParam4("2020-04-29");
		jqueryValidator.setParam5("-10000.1234");
		jqueryValidator.setParam6("20000");
		jqueryValidator.setParam7("max");
		jqueryValidator.setParam8("min");
		jqueryValidator.setParam9("12345");
		jqueryValidator.setParam10("9");
		jqueryValidator.setParam11("2");
		jqueryValidator.setParam12("10");

		jqueryValidator.setEqual1("equals");
		jqueryValidator.setEqual2("equals");

		jqueryValidator.setStartDate("2020-04-01");
		jqueryValidator.setEndDate("2020-04-05");


		jqueryValidator.setStartDateTime("2020-04-29 00:00");
		jqueryValidator.setEndDateTime("2020-04-30 23:59");

		return "test/jquery_validator";
	}



	/** MODAL SAMPLE  **/
	@RequestMapping( value = "modal.do", method = RequestMethod.GET )
	public String modal() {
		return "test/sample_modal";
	}
	/** MODAL OPEN **/
	@RequestMapping( value = "/modal/modal.do", method = RequestMethod.POST )
	public String modal2( Model model ,@RequestParam("modal_id") String modal_id
												,@ModelAttribute TestSampleJsonModal  params  ) {
		log.info("{}", params);

		return "test/modal/modal";
	}


	/** DATA TABLE 페이지 조회 **/
	@RequestMapping( value = "datatable_paging.do", method = RequestMethod.GET )
	public String datatable_paging( @ModelAttribute("search") TestDtPagingSearch search ) {
		return "test/datatable_paging";
	}
	/** DATA TABLE 페이징 데이터 조회 **/
	@RequestMapping( value = "datatable_paging.do", method = RequestMethod.POST )
	@ResponseBody
	public DtPagingResult<Map<String, Object>> datatable_paging_data( @ModelAttribute TestDtPagingSearch search ) {
		return testService.dtPaging( search );
	}
	/** DATA TABLE 엑셀 다운로드 **/
	@RequestMapping( value = "datatable_excel.do", method = RequestMethod.POST )
	public String datatable_excel( @ModelAttribute TestDtPagingSearch search , Model model ) {

		/** 페이징 처리를 않게 설정 **/
		search.doNotPaging();

		List<Map<String,Object>> list = testService.dtExcel( search );

		/** 다운로드할 엑셀 파일명 **/
		String fileName = "dataTableExcel.xls";

		/** Sheet 생성 **/
		SheetTemplate sheet = SheetTemplate.of( "시트명", "시트제목", list );

		/** SHEET HEADER 세팅 **/
		sheet.addSheetHeader("테스트키", "test_key")
				.addSheetHeader("VAR1", "var1")
				.addSheetHeader("VAR2", "var2")
				.addSheetHeader("VAR3", "var3");

		return super.excelDown(fileName, sheet, model);

	}


	@RequestMapping( value = "jsp_paging.do", method = RequestMethod.POST )
	@ResponseBody
	public Map<String,Object> jsp_paging2( @ModelAttribute TestJspPagingSearch search , Model model ) {
		Map<String,Object> result = Maps.newHashMap();

		result.put("search_text", search.getSearch_text())
		;


		return result;
	}


	/** JSP 페이징 **/
	@RequestMapping( value = "jsp_paging.do", method = RequestMethod.GET )
	public String jsp_paging( @ModelAttribute TestJspPagingSearch search , Model model ) {

		log.info("paging: 한글:::: {}", search.getSearch_text());
		/** page size , range size
		search.setPageSize( 7 );
		search.setRangeSize( 5 ); **/

		JspPagingResult<Map<String, Object>> result =  testService.jspPaging( search );
		model.addAttribute("paging", result);
		model.addAttribute("search", search);

		return "test/jsp_paging";
	}

	/** JSP 엑셀 다운로드 **/
	@RequestMapping( value = "jsp_excel.do", method = RequestMethod.POST )
	public String jsp_excel( @ModelAttribute TestJspPagingSearch search , Model model ) {


		String text = search.getSearch_text();
		log.info("excel: 한글:::: {}", text );

		/** 페이징 처리를 않게 설정 **/
		search.doNotPaging();

		List<Map<String,Object>> list = testService.jspExcel( search );

		/** 다운로드할 엑셀 파일명 **/
		String fileName = "jspExcel.xls";

		/** Sheet 생성 **/
		SheetTemplate sheet = SheetTemplate.of( "시트명", "시트제목", list );

		/** SHEET HEADER 세팅 **/
		sheet.addSheetHeader("테스트키", "test_key")
				.addSheetHeader("VAR1", "var1")
				.addSheetHeader("VAR2", "var2")
				.addSheetHeader("VAR3", "var3");

		return super.excelDown(fileName, sheet, model);
	}



	
}
