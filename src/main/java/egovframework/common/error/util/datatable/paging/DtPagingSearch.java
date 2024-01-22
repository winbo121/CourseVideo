package egovframework.common.error.util.datatable.paging;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import egovframework.common.error.util.datatable.paging.sort.DtSorting;
import egovframework.common.util.StreamUtils;
import lombok.Getter;
import lombok.Setter;

/**
 *  검색, 페이징, 정렬 공통 객체
 */
public abstract class DtPagingSearch {

	/**  DATA TABLE DRAW 횟수 **/
	@Getter @Setter
	private Integer draw;

	/** DATA TABLE PAGING START INDEX **/
	@Getter @Setter
	private Integer start;

	/** DATA TABLE PAGING LIMIT **/
	@Getter @Setter
	private Integer length;

	/** DATA TABLE PAGE NO **/
	public final Integer getPage() {
		if( ObjectUtils.allNotNull( this.start, this.length )  ) {
			Integer result =  ( this.start  / this.length ) + 1;
			return result;
		}
		return 1;
	}


	@Getter @Setter
	private Map<SearchCriterias, String> search;

	@Getter @Setter
	private List<Map<ColumnCriterias, String>> columns;

	@Getter @Setter
	private List<Map<OrderCriterias, String>> order;


	public enum SearchCriterias {
        value,
        regex
    }
    public enum OrderCriterias {
        column,
        dir
    }
    public enum ColumnCriterias {
        data,
        name,
        searchable,
        orderable,
        searchValue,
        searchRegex
    }

    /** 페이징 처리를 하지 않고 전체 리스트를 조회한다. **/
    @JsonIgnore
    public final void doNotPaging() {
    	this.start = null;
    	this.length = null;
    }
	/** 페이징 여부 **/
	@JsonIgnore
	public final boolean getIsPaging() {
		Integer start = getStart();
		Integer length = getLength();
		if( ObjectUtils.isNotEmpty( start ) && ObjectUtils.isNotEmpty( length )   ) {
			if(  start >= 0 && length >= 0 ) {
				return true;
			}else {
				return false;
			}
		}
		return false;
	}

	/** SORTING 여부 **/
	@JsonIgnore
	public final boolean getIsSort() {
		return CollectionUtils.isNotEmpty( this.order );
	}

	/** SORTING 할 정보를 조회한다. **/
	@JsonIgnore
	public final List<DtSorting> getSorts() {
		/** example: [{column=2, dir=desc}]  **/
		List<DtSorting> result =
		StreamUtils.toStream(  this.order )
						.filter( MapUtils::isNotEmpty )
						.filter( ord -> StringUtils.isNumeric( ord.get( OrderCriterias.column )  ) )
						.filter( ord -> StringUtils.equalsAnyIgnoreCase( ord.get( OrderCriterias.dir ), "asc", "desc" ) )
						.map( ord -> {
								Integer column_index =  Integer.parseInt( ord.get( OrderCriterias.column ) );
								String dir = ord.get( OrderCriterias.dir );
								return  Optional.ofNullable( this.columns )
											.filter( columns -> columns.size() > column_index  )
											.map( columns -> columns.get( column_index ) )
											.map( colum -> colum.get( ColumnCriterias.name ) )
											.map( column_name ->  new DtSorting(column_name, dir)   )
											.orElseGet( () -> null ); 	})
						.filter( ObjectUtils::isNotEmpty )
						.collect( Collectors.toList() ) ;
		return result;
	}

}
