package egovframework.work.account.model;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseController.DELETE;
import egovframework.common.base.BaseController.PUT;
import egovframework.common.valid.annotation.FileExtension;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class ProfileImage {

	@NotEmpty( groups = { PUT.class, DELETE.class  } )
	private String user_id;


	@NotNull( groups = { PUT.class  } )
	@FileExtension( groups = { PUT.class }
						,extensions={ "gif", "jpg", "jpeg", "tif", "tiff", "png", "bmp" }
						,message = "이미지파일만 등록할수있습니다." )
	private MultipartFile profile_image;

}
