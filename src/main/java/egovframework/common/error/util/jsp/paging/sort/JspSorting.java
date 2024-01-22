package egovframework.common.error.util.jsp.paging.sort;

import lombok.Getter;
import lombok.Setter;

public class JspSorting {

	/** 정렬할 DB 컬럼 명 **/
	@Getter @Setter
	private String columnName;

	/** ASC , DESC  **/
	@Getter @Setter
	private String dir;

}
