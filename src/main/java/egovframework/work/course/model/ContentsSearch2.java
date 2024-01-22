package egovframework.work.course.model;

import org.apache.commons.lang3.ObjectUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import egovframework.common.error.util.datatable.paging.DtPagingSearch;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class ContentsSearch2 extends DtPagingSearch {
	
	/** 검색어 유형 **/
	private String search_type;

	/** 검색어 **/
	private String search_text;
	
	/** 검색어 여부 **/
	@JsonIgnore
	public boolean getIsSearch() {
		if( ObjectUtils.isNotEmpty( this.search_type ) && ObjectUtils.isNotEmpty( this.search_text )   ) {
			return true;
		}
		return false;
	}
}
