package egovframework.work.test.model.file;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.springframework.web.multipart.MultipartFile;
import egovframework.common.base.BaseController.DELETE;
import egovframework.common.base.BaseController.POST;
import egovframework.common.base.BaseController.PUT;
import egovframework.common.valid.annotation.FileExtension;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class TestFile implements Serializable {

	private static final long serialVersionUID = -2590426714879761919L;

	@NotNull( groups = { DELETE.class  } )
	private Integer file_seq;

	/** 등록 수정할 파일 시퀀스 리스트 **/
	private List<String> file_seqs;


	@NotEmpty( groups = { POST.class  } )
	@FileExtension( groups = { POST.class, PUT.class }
						,extensions={ "gif", "jpg", "jpeg", "tif", "tiff", "png", "bmp" }
						,message = "이미지파일만 등록할수있습니다." )
	private MultipartFile[] upload_files;
	

}
