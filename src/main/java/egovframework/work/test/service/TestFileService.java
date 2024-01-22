package egovframework.work.test.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.attribute.ReAlignFileList;
import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.work.test.model.file.TestFile;


@Service
public class TestFileService extends BaseService {

	/** 대상 파일 유형  **/
	private static final FILE_REG_GB TARGET_FILE_REG_GB = FILE_REG_GB.FILE_TYPE_TEST;

	private static final String TAR_INFO_PK = "TEST_SAMPLE_FILE_PK";

	@Autowired
	private FileComponent fileComponent;


	/** 파일 리스트 조회 **/
	public  List<FileData> getFiles() {
		return fileComponent.getFiles(TARGET_FILE_REG_GB, TAR_INFO_PK);
	}


	/** 파일 등록  **/
	@Transactional
	public void addFileupload( TestFile sampleFile ) {

		MultipartFile[] upload_files = sampleFile.getUpload_files();

		/** 글등록시에 아래와 같이 파일업로드 **/
		fileComponent.addFiles(TARGET_FILE_REG_GB, TAR_INFO_PK, Arrays.asList( upload_files ) );

	}

	/** 파일 수정 **/
	@Transactional
	public void modifyFileupload( ReAlignFileList re_align_file_list ) {

		/** 글수정시에 아래와 같이 파일업로드 **/
		fileComponent.modifyFiles(TARGET_FILE_REG_GB, TAR_INFO_PK, re_align_file_list);

		/** 글삭제시에 아래와 같이 파일 삭제  **/
//		fileComponent.removeFile( TARGET_FILE_REG_GB, TAR_INFO_PK );

	}


	/** 파일 삭제  **/
	@Transactional
	public void removeFileupload( TestFile sampleFile ) {
		Integer file_seq = sampleFile.getFile_seq();
		List<Integer> file_seq_list = Arrays.asList( file_seq );
		fileComponent.removeFile( TARGET_FILE_REG_GB, TAR_INFO_PK, file_seq_list );
	}

}
