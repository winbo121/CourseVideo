package egovframework.work.test.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import egovframework.common.base.BaseController;
import egovframework.common.component.file.attribute.ReAlignFileList;
import egovframework.common.component.file.model.FileData;
import egovframework.common.view.excel.template.SheetTemplate;
import egovframework.work.test.model.file.TestFile;
import egovframework.work.test.service.TestFileService;
import lombok.extern.slf4j.Slf4j;


/** 테스트 파일 업로드 컨트롤러 **/
@Slf4j
@Controller
@RequestMapping( value="/testfile" )
public class TestFileController extends BaseController {

	@Autowired
	private TestFileService testFileService;

	/** 파일업로드 샘플 **/
	@RequestMapping( value="/sample_file.do" ,method=RequestMethod.GET )
	public String sampleFilepload( ) {

		log.info("TestFileController=========================");
		return "test/sample_file";
	}

	/**  파일 리스트 조회 **/
	@RequestMapping( value="/sample_file.do" ,method=RequestMethod.POST )
	@ResponseBody
	public Map<String, Object> getFileList( ) {
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		List<FileData> file_list = testFileService.getFiles();
		result.put("file_list", file_list);

		return result;
	}


	/** 파일업로드 등록 **/
	@RequestMapping( value="/fileupload.do" ,method=RequestMethod.POST  )
	@ResponseBody
	public Map<String, Object> addFileupload(  @ModelAttribute TestFile sampleFile  ){
		/** 유효성 체크  **/
		super.doValidted( sampleFile , POST.class );

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		testFileService.addFileupload(sampleFile);

		return result;
	}


	/** 파일업로드 수정 **/
	@RequestMapping( value="/fileupload.do" ,method=RequestMethod.PUT  )
	@ResponseBody
	public Map<String, Object> modifyFileupload(  @ModelAttribute TestFile sampleFile  ){
		/** 유효성 체크  **/
//		super.doValidted(sampleFile, PUT.class );


		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		/** 기존 파일 일련번호 **/
		List<String> file_seqs = sampleFile.getFile_seqs();
		/** 수정시에 추가된 파일 들 **/
		MultipartFile[] upload_files = sampleFile.getUpload_files();
		/** 파일 재정렬 객체 생성 **/
		ReAlignFileList re_align_file_list = ReAlignFileList.of( file_seqs, upload_files );


		testFileService.modifyFileupload(re_align_file_list);

		return result;
	}

	/** 파일업로드 삭제 **/
	@RequestMapping( value="/fileupload.do" ,method=RequestMethod.DELETE  )
	@ResponseBody
	public Map<String, Object> removeFileupload(  @ModelAttribute TestFile sampleFile  ){
		/** 유효성 체크  **/
		super.doValidted( sampleFile, DELETE.class );
		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();

		testFileService.removeFileupload( sampleFile );
		return result;
	}


	@RequestMapping( value="/excel.do" ,method=RequestMethod.POST  )
	public String excel( Model model  ) {


		List<Map<String,Object>> list = Lists.newArrayList();
		list.add( ImmutableMap.of("test_key", "1111") );
		list.add( ImmutableMap.of("test_key", "1111") );
		list.add( ImmutableMap.of("test_key", "1111") );
		list.add( ImmutableMap.of("test_key", "1111") );

		/** 다운로드할 엑셀 파일명 **/
		String fileName = "한글엑셀.xls";

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
