package egovframework.work.test.model.jsp;

import java.util.List;

import org.apache.commons.lang3.ObjectUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString(callSuper = true)
public class TestJspPagingSearch extends JspPagingSearch {

	/** 검색어 유형 **/
	private String search_type;

	/** 검색어 **/
	private String search_text;
	
	/** 검색어 **/
	private String user_id;
	
	/** 카테고리 체크 **/
	private List<String> search_chk;
	
	/** 등록자 체크 **/
	private List<String> search_user;
	
	/** 등록자 체크 **/
	private String search_inst;
	
	/** 검색 구분 체크 **/
	private String search_select;

	/** 검색어 여부 **/
	@JsonIgnore
	public boolean getIsSearch() {
		if( ObjectUtils.isNotEmpty( this.search_type ) && ObjectUtils.isNotEmpty( this.search_text )   ) {
			return true;
		}
		return false;
	}

}
