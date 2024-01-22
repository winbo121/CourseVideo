package egovframework.work.course.model;

import java.util.List;

import javax.validation.constraints.NotEmpty;

import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseController.POST;
import egovframework.common.base.BaseController.PUT;
import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import egovframework.common.valid.annotation.FileExtension;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class Course extends JspPagingSearch{
	
	/** 강좌 순차번호 **/
	private Integer course_seq;
	
	/** 강좌명 **/
	private String course_nm;
	
	/** 강좌주제 **/
	private String course_subject;
	
	/** 강좌유형 **/
	private String type_seq;
	
	/** 강좌 설명 **/
	private String course_descr;
	
	/** 강좌 구분 **/
	private Integer category_seq;
	
	/** 강좌 회차 **/
	private Integer course_round;
	
	/** 강좌 노출여부 **/
	private String display_yn;
	
	/** 강좌 사용여부(운영여부) **/
	private String use_yn;
	
	/** 강좌 삭제여부 **/
	private String del_yn;
	
	/** 강좌 등록일시 **/
	private String reg_dts;
	
	/** 강좌 등록자 **/
	private String reg_user;
	
	/** 강좌 수정일시 **/
	private String upd_dts;
	
	/** 강좌 수정자 **/
	private String upd_user;
	
	/** 강좌 강사명 **/
	private String instructor_nm;
	
	/** 강사 기관명 **/
	private String reg_inst_nm;
	
	
	//private String category_seq;
	private String category_lvl;
	private String category_gb;
	private String searchText;
	private String parnt_category_seq;
	
	//default ordering
	private String order = "1";
	private String login_seq;
	
	private String mobile_yn;
	
	private String start_dts;
	private String end_dts;
	
	private List<Integer> del_contents_seqs;
	private List<Integer> get_contents_seqs;
	
	private List<Integer> del_files_seqs;
	
	@NotEmpty( groups = { POST.class  } )
	@FileExtension( groups = { POST.class, PUT.class }
						,extensions={ "gif", "jpg", "jpeg", "tif", "tiff", "png", "bmp" }
						,message = "이미지파일만 등록할수있습니다." )
	private MultipartFile[] upload_files;

}
