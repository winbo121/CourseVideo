package egovframework.work.file.controller;

import java.time.Duration;
import java.util.Optional;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.common.base.BaseController;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_DOWN_TYPE;
import egovframework.common.constrant.EnumCodes.RESOURCE_DOWNLOAD;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.CommonUtils;
import egovframework.work.file.model.FileDownload;

@Controller
@RequestMapping("/file/")
public class FileController extends BaseController {

	@Autowired
	private FileComponent fileComponent;

	@RequestMapping( value="/download.do" ,method= RequestMethod.POST  )
	public ResponseEntity<Resource> download(  @ModelAttribute FileDownload input  ) {

		/** 유효성 체크  **/
		super.doValid( input );

		/** 파일 시퀀스  **/
		Integer file_seq = input.getFile_seq();

		/** FILE 상세 정보 조회  **/
		Optional<FileData> file_data = fileComponent.getFile( file_seq );

		if( ! file_data.isPresent()  ) {
			/**존재하지않는 파일 정보입니다 **/
			throw new ErrorMessageException( "file.none" );
		}
		
		/** 파일 다운로드시 down_type 파라미터가 존재할 시 다운로드에 대한 로그를 남긴다. **/
		if( StringUtils.isNotBlank( input.getDown_type() ) ) {
			String down_type = input.getDown_type();
			fileComponent.addFileDownloadLog( FILE_DOWN_TYPE.valueOf( down_type ) );
		}

		ResponseEntity<Resource> result = fileComponent.downloadOnce( file_data.get() );
		CommonUtils.addCookie("fileDownload", "true", Duration.ofMinutes(1) );

		return result;
	}

	@RequestMapping( value="/resource_download.do" ,method= RequestMethod.POST  )
	public ResponseEntity<Resource> resource_download( @RequestParam("type") String type ){
		ResponseEntity<Resource> result = fileComponent.downloadResourceFile( RESOURCE_DOWNLOAD.valueOf( type ) );
		CommonUtils.addCookie("fileDownload", "true", Duration.ofMinutes(1) );
		return result;
	}

}
