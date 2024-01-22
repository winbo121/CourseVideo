package egovframework.work.statistics.model;

import java.util.List;

import org.apache.commons.lang3.ObjectUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString(callSuper = true)
public class StaticsPagingSearch extends JspPagingSearch {

	/** 날짜 유형 **/
	private String search_type;
	
	/** 검색 날짜 **/
	private String search_date;
	
	/** 검색 날짜 종료**/
	private String search_date_end;

	/** 검색어 **/
	private String search_text;
	
	/** 등록자 체크 **/
	private List<String> search_user;
	
	/** 로그인 유저 체크 **/
	private Boolean check_login_yn;
	
	/** 시간 **/
	private String time_page;
	
	/** 성별 **/
	private String gender;
	
	/** 지역 **/
	private String region;
	
	/** 나이 **/
	private String age;
	
	/** 직업 **/
	private String job;
	
	private String log_type;
	
	/** 로그인 사용자 상세 검색 조건 여부 **/
	private String search_detail_yn;
	
	

	/** 검색어 여부 **/
	@JsonIgnore
	public boolean getIsSearch() {
		if( ObjectUtils.isNotEmpty( this.search_type ) && ObjectUtils.isNotEmpty( this.search_text )   ) {
			return true;
		}
		return false;
	}

}
