package egovframework.common.view.excel;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.http.HttpHeaders;
import org.springframework.web.servlet.view.document.AbstractXlsView;

import egovframework.common.constrant.Constrants;
import egovframework.common.view.excel.model.ExcelResult;
import egovframework.common.view.excel.template.SheetTemplate;

/** XLS DOWNLOAD VIEW **/
public class XlsView extends AbstractXlsView  {

	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request, HttpServletResponse response) throws Exception {
		ExcelResult excel_result = (ExcelResult) model.get( Constrants.EXCEL_ATTRIBUTE );
		/** 다운로드 파일명 **/
		String file_name = excel_result.getFileName();
		/** SHEET 정보 조회  **/
		SheetTemplate sheetTemplate = excel_result.getSheet();

		LocalDateTime now = LocalDateTime.now();
		String now_time = now.format( DateTimeFormatter.ofPattern( Constrants.YYYYMMDDHHMMSS ) );
		StringBuilder file_full_name = new StringBuilder();

		String[] file_names = StringUtils.split(file_name,".");

		file_full_name.append( file_names[0] );
		file_full_name.append("_");
		file_full_name.append( now_time );
		file_full_name.append(".");
		file_full_name.append( file_names[1] );

		String user_agent = request.getHeader(HttpHeaders.USER_AGENT);


		StringBuilder result = new StringBuilder();
		try {
			if( StringUtils.containsAny( user_agent , "MSIE", "Trident" ) ) {
				result.append( "attachment;filename=" );
				result.append( URLEncoder.encode( file_full_name.toString(),  StandardCharsets.UTF_8.name()  ).replaceAll("\\+", "%20") );
				result.append( ";" );
			}else {
				result.append( "attachment; filename=\"" );
				result.append( new String( StringUtils.getBytes( file_full_name.toString() ,  StandardCharsets.UTF_8 ) , StandardCharsets.ISO_8859_1 ) );
				result.append( "\"" );
			}
		}catch( Exception e ) {
			result.append( "attachment; filename=\"" );
			result.append( file_full_name.toString() );
			result.append( "\"" );
		}


		response.setHeader(HttpHeaders.CONTENT_TYPE, "application/octet-stream; charset=utf-8" );
		response.setHeader(HttpHeaders.CONTENT_DISPOSITION, result.toString() );

		/** 엑셀 생성 **/
		sheetTemplate.createExcel(workbook, now_time );
	}


}
