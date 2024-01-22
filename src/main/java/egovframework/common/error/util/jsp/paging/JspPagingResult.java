package egovframework.common.error.util.jsp.paging;

import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;

@Builder @Getter
@AllArgsConstructor( access = AccessLevel.PRIVATE  )
public class JspPagingResult<E> {

	/** 결과값 리스트  **/
	@NonNull
	private List< E > data;

	/** 현재 페이지 번호  **/
	private int page;

	/** 각 페이지 범위 시작 번호  **/
	private int startRange;
	/** 각 페이지 범위 끝 번호 **/
	private int endRange;


	/** 이전 RANGE 여부 **/
	private boolean prevRange;
	/** 다음 RANGE 여부 **/
	private boolean nextRange;


	/** 이전 PAGE 여부 **/
	private boolean prevPage;
	/** 다음 PAGE 여부 **/
	private boolean nextPage;


	/** 첫 PAGE 활성여부 **/
	private boolean firstPage;
	/** 마지막 PAGE 활성 여부 **/
	private boolean lastPage;


	/** Builder 생성 **/
	public  static <E> JspPagingResultBuilder<E>  builder( List<E> pagedList  )   {
		return new JspPagingResultBuilder<E>()
						.data( pagedList );
	}

}
