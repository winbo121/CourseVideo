package egovframework.common.error.util.datatable.paging.sort;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class DtSorting {

	/** 정렬할 DB 컬럼 명 **/
	private String columnName;

	/** ASC , DESC  **/
	private String dir;

}
