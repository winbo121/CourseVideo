package egovframework.work.notice.model;

import egovframework.common.component.file.model.FileData;
import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import com.fasterxml.jackson.annotation.JsonIgnore;
import java.util.List;

import org.apache.commons.lang3.ObjectUtils;
import org.springframework.web.multipart.MultipartFile;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter	@Setter @ToString(callSuper = true)
public class Notice extends JspPagingSearch {
	
	/** 공지 순차번호 **/
	private Integer notice_seq;
	
	/** 공지 구분 [043] **/
	private String notice_gb;
	
	/** 과정 순차번호  **/
	private Integer course_seq;
	
	/** 과정 개설 순차번호  **/
	private Integer course_open_seq;
	
	/** 제목 **/
	private String title;
	
	/** 내용 **/
	private String contents;
	
	/** 썸네일 파일 **/
	private String file;
	
	/** 상단고정 여부 **/
	private String top_fixed_yn;
	
	/** 자료실 상태 **/
	private String information_state;
	
	/** 노출 여부 **/
	private String display_yn;
	
	/** 노출 기간 여부 **/
	private String display_period_yn;
	
	/** 노출 기간 시작일 **/
	private String display_period_start_dt;
	
	/** 노출 기간 시작시간 **/
	private String display_period_start_time;
	
	/** 노출 기간 종료일 **/
	private String display_period_end_dt;
	
	/** 노출 기간 종료시간 **/
	private String display_period_end_time;
	
	/** 노출 종료 미정 여부 **/
	private String display_end_udf_yn;
	
	/** 삭제 여부 **/
	private String del_yn;
	
	/** 조회수 **/
	private String hits;
	
	/** 등록 일시 **/
	private String reg_dts;
	
	/** 등록자 **/
	private String reg_user;
	
	/** 수정 일시 **/
	private String upd_dts;
	
	/** 수정자 **/
	private String upd_user;

	/** 삭제 Item **/
	private List<Integer> del_items;
	
	/** 검색 정보 **/
	private String search_text;
	
	private String search_condition;
	
	private String sort;
	
	private String sort_asc;
	
	private String notice_sort;
	
	private List<String> fix_sort_no;
	private List<String> seq;
	
    private String prev_seq;
    private String prev_title;
    private String next_seq;
    private String next_title;
    private Integer max;
    private Integer min;
	
	/** 다운로드시 paging 셋팅  **/
	@JsonIgnore
	public void excelDownSetting() {
		this.setPageNo(null);
		this.setPageSize(null);
	}
	
	/** 파일 업로드 **/
	private MultipartFile[] files;
	
	/** 썸네일 업로드 **/
	private MultipartFile[] thumb_files;
	
	private Integer[] delete_files;

	private Integer[] image_seqs;
	
	/** 교육과정 개별 공지사항  **/
	private String open_term;

	private String course_term;
	
	/** 권한 구분 **/
	private String role_type;
	
	/** 등록 수정할 파일 시퀀스 리스트 **/
	private List<String> file_seqs;
	
    /** 공지사항 첨부 파일 리스트 **/
    private List<FileData> fileList;
    
    private String file_save_path;
    
    /** 공지사항 첨부 파일 리스트 **/
    private FileData thumb;
	
	//파일 seq
	private Integer file_seq;
	
	
	/** 검색어 여부 **/
	@JsonIgnore
	public boolean getIsSearch() {
		if( ObjectUtils.isNotEmpty( this.search_condition ) && ObjectUtils.isNotEmpty( this.search_text )   ) {
			return true;
		}
		return false;
	}
}
