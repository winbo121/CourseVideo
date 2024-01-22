package egovframework.common.base;

import java.math.RoundingMode;
import java.util.List;
import java.util.function.Supplier;
import org.springframework.beans.factory.annotation.Autowired;
import com.google.common.base.Preconditions;
import com.google.common.math.IntMath;

import egovframework.common.component.file.mapper.FileMapper;
import egovframework.common.constrant.EnumCodes.FILE_DOWN_TYPE;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.error.util.datatable.paging.DtPagingResult;
import egovframework.common.error.util.datatable.paging.DtPagingSearch;
import egovframework.common.error.util.jsp.paging.JspPagingResult;
import egovframework.common.error.util.jsp.paging.JspPagingSearch;
import egovframework.common.util.LocalThread;

/** 기본 서비스 **/
public abstract class BaseService {

	@Autowired
	private FileMapper fileMapper;
	
	/** JSP 페이징 응답값 변환 **/
	protected final <E> JspPagingResult<E>  convertJspPaging( JspPagingSearch search, List<E> pagedList, Integer totalCount  ) {

		/** 유효성 체크  **/
		Preconditions.checkNotNull( search );
		Preconditions.checkNotNull( pagedList );
		Preconditions.checkNotNull( totalCount );
		Preconditions.checkArgument( search.getIsPaging() , "페이징 처리 요청이 아닙니다." );

		/** 현재 페이지 번호 **/
		int pageNo = search.getPageNo();
		/** 한 페이지당 글 사이즈 **/
		int pageSize = search.getPageSize();
		/** 현재 범위 번호 **/
		int rangeNo = search.getRangeNo();
		/** 한 범위당 페이즈 사이즈 **/
		int rangeSize = search.getRangeSize();

		/** 페이지 전체 수량 **/
		int pageCount = IntMath.divide( totalCount , pageSize , RoundingMode.CEILING );
		/** 전체 범위 수량 **/
		int rangeCount = IntMath.divide( pageCount ,  rangeSize , RoundingMode.CEILING );

		/** search 객체 데이터 주입 **/
		search.initResponseCount( totalCount, pageCount, rangeCount );


		/** 해당범위의 시작 페이지 **/
		int startRange =( rangeNo - 1) * rangeSize + 1 ;
		/** 해당범위의 끝 페이지 **/
		int endRange = rangeNo * rangeSize;

		/** 이전 RANGE 버튼 상태 **/
		boolean prevRange = rangeNo == 1 ? false : true;

		/** 다음 RANGE 버튼 상태 **/
		boolean nextRange = endRange > pageCount ? false : true;
		if ( endRange >=  pageCount ) {
			endRange = pageCount;
			nextRange = false;
		}

		/** 이전 PAGE 버튼 상태 **/
		boolean prevPage = pageNo == 1  ? false : true;
		/** 다음 PAGE 버튼 상태 **/
		boolean nextPage = pageNo < pageCount ? true: false;

		/** 첫 페이지 버튼 활성 여부 **/
		boolean firstPage = pageNo == 1 ? false : true;

		/** 마지막 페이지 활성 여부 **/
		boolean lastPage = pageNo < pageCount ? true: false;


		return JspPagingResult.builder( pagedList )
											.page( pageNo )
											.startRange( startRange )
											.endRange( endRange )
											.prevRange( prevRange )
											.nextRange( nextRange  )
											.prevPage( prevPage  )
											.nextPage( nextPage  )
											.firstPage( firstPage )
											.lastPage( lastPage )
											.build();
	}


	/** DATA TABLE 페이징 응답값 변환 **/
	protected final <E> DtPagingResult<E>  convertDtPaging( DtPagingSearch search, List<E> pagedList, Integer totalCount  ) {
		Preconditions.checkNotNull( search );

		Integer draw = search.getDraw();
		return DtPagingResult.builder( pagedList, totalCount, draw )
									.isPaged( search.getIsPaging() )
									.isSorted( search.getIsSort()  )
									.build();
	}


	/** ERROR MESSAGE EXCEPTION SUPPILER **/
	protected final 	Supplier<ErrorMessageException> getErrorMessageSuppiler( String error_code ){
		return () -> new ErrorMessageException( error_code );
	}
	
	
	/** FILE DOWNLOAD 요청에 대한 이력을 남긴다. **/
	protected final void addFileDownloadLog( FILE_DOWN_TYPE excel_down_type ) {
		Preconditions.checkArgument( LocalThread.isLogin() );
		
		fileMapper.addFileDownloadLog( excel_down_type.code() );
	}


}
