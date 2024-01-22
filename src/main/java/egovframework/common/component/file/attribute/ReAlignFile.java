package egovframework.common.component.file.attribute;

import org.springframework.web.multipart.MultipartFile;
import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor( staticName = "of" )
public class ReAlignFile {

	@Getter
	private Integer file_seq;

	@Getter
	private MultipartFile file;


}
