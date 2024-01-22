package egovframework.common.error.util.datatable.paging;

import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;


@Getter
@Builder
@AllArgsConstructor( access = AccessLevel.PRIVATE  )
public class DtPagingResult<E> {

	/** 결과값 리스트  **/
	@NonNull
	private List< E > data;

	/** PAGE NO DATA TABLE 에서 요청한 데이터  **/
	@NonNull
	private Integer draw;

	/** 리스트의 총카운트 **/
	@NonNull
	private Integer recordsTotal;

	/** 리스트의 총카운트 **/
	@NonNull
	private Integer recordsFiltered;


	/** 페이징 처리 여부 **/
	private Boolean isPaged;

	/** 소팅 처리 여부 **/
	private Boolean isSorted;

	/** Builder 생성 **/
	public  static <E> DtPagingResultBuilder<E>  builder( List<E> pagedList, Integer totalCount, Integer draw )   {
		return new DtPagingResultBuilder<E>()
						.data( pagedList )
						.draw( draw )
						.recordsTotal( totalCount )
						.recordsFiltered( totalCount );
	}




}
