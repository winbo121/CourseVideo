package egovframework.common.component.file.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter @Setter
@ToString
public class FileData {

	/** 파일 순차번호 **/
	private Integer file_seq;

	/** 파일등록구분 **/
	private String file_reg_gb;

	/** 대상정보PK **/
	private String tar_info_pk;

	/** 노출 순서 **/
	private Integer expo_sort;

	/** 원본 파일명 **/
	private String orgin_filenm;

	/** 저장 파일명 **/
	private String save_filenm;

	/** 파일저장 경로 **/
	private String file_save_path;

	/** 파일 확장자 **/
	private String file_ext;

	/** 파일 사이즈 **/
	private Long file_size;

	/** 다운로드 횟수 **/
	private String dwld_cnt;

	/** 삭제여부**/
	private String del_yn;

	/** 이미지 URL **/
	private String img_url;
	
	/** 이미지 URL **/
	private String file_url;

	/** 이미지 서버 사용 여부 **/
	private boolean use_img_server = false;
	
	/** 파일 서버 사용 여부 **/
	private boolean use_file_server = false;
	
	@JsonIgnore
	public FileData injectImgUrl( String img_server_root_path ) {
		this.img_url = new StringBuilder()
							 .append( img_server_root_path )
							 .append( this.file_save_path )
							 .append( this.save_filenm ).toString();

		this.use_img_server = true;

		 return this;
	}
	
	public FileData injectfileUrl(String file_server_root_path) {
		this.file_url = new StringBuilder()
								.append(file_server_root_path)
								.append(this.file_save_path)
								.append(this.save_filenm).toString();
		this.use_file_server = true;
		
			return this;
	}



}
