package egovframework.work.course.model;

import org.apache.commons.lang3.ObjectUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class ContentsSearch extends JspPagingSearch {
	
	/** 검색어 유형 **/
	private String search_type;

	/** 검색어 **/
	private String search_text;
	
	/** 탭 **/
	private String search_tap;
	
	/** 검색어 여부 **/
	@JsonIgnore
	public boolean getIsSearch() {
		if( ObjectUtils.isNotEmpty( this.search_type ) && ObjectUtils.isNotEmpty( this.search_text )   ) {
			return true;
		}
		return false;
	}
}
