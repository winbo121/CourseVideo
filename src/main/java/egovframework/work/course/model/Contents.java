package egovframework.work.course.model;

import java.io.File;
import java.util.List;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;

import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseController.DELETE;
import egovframework.common.base.BaseController.POST;
import egovframework.common.base.BaseController.PUT;
import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import egovframework.common.valid.annotation.FileExtension;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class Contents extends JspPagingSearch{
	
	/** 강좌 순차번호 **/
	private Integer contents_seq;  
	
	/** 강좌명 **/
	private String contents_nm;
	
	/** 강좌 설명 **/
	private String contents_descr;
	
	/** 영상 구분 **/
	private String vod_gb;
	
	/** 영상 URL **/
	private String vod_url;
	
	/** 가로 사이즈 **/
	private Integer width_size;
	
	/** 세로 사이즈 **/
	private Integer height_size;
	
	/** 영상 시간 초 **/
	private Integer vod_time_sec;
	
	/** 콘텐츠 사용여부 **/
	private String use_yn;
	
	/** 콘텐츠 삭제여부 **/
	private String del_yn;
	
	/** 콘텐츠 등록일시 **/
	private String reg_dts;
	
	/** 콘텐츠 등록자 **/
	private String reg_user;
	
	/** 콘텐츠 수정일시 **/
	private String upd_dts;
	
	/** 콘텐츠 수정자 **/
	private String upd_user;
	
	private List<Integer> del_vod_file_seqs;
	
	private List<Integer> del_sub_file_seqs;

	/** 등록 수정할 파일 시퀀스 리스트 **/
	private List<String> file_seqs;

	private MultipartFile[] upload_files;
	
	private MultipartFile[] upload_subs;
	
	private MultipartFile[] upload_images;
	
}
