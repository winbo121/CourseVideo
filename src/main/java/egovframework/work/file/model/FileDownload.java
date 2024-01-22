package egovframework.work.file.model;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class FileDownload {

	/** 다운로드 파일 시퀀스  **/
	@NotNull
	@Min(1) /** Long, Integer 최소값 **/
	private  Integer file_seq ;
	
	/** 다운로드 구분 [선택] **/
	private  String down_type ;


}
