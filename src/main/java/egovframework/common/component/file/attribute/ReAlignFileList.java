package egovframework.common.component.file.attribute;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import com.google.common.base.Predicates;
import com.google.common.collect.FluentIterable;

import egovframework.common.constrant.Constrants;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.StreamUtils;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;


/** 파일 재정렬 객체  **/
@NoArgsConstructor( access = AccessLevel.PRIVATE )
public class ReAlignFileList  extends ArrayList< ReAlignFile > {

	private static final long serialVersionUID = 3953748667446445253L;



	/** MULTI PART FILE accumulator  **/
	private static final Function< MultipartFile[], BiConsumer< ReAlignFileList, String >  >
		MULTI_PART_FILE_ACCUMULATOR = ( multi_part_files  ) -> {
				/** 신규 파일 ITERATOR  **/
				Iterator<MultipartFile> new_file_iterator = StreamUtils.toStream( multi_part_files ).iterator();
				BiConsumer< ReAlignFileList, String > bi_consumer = ( align_list,  img_file_seq ) -> {
					if( StringUtils.equals( img_file_seq, Constrants.X_FILE_PROMISE ) ) {

						align_list.add( ReAlignFile.of( null,  new_file_iterator.next() ) );
					} else {
						align_list.add( ReAlignFile.of( Integer.parseInt( img_file_seq ), null )  );
					}
				};
				return bi_consumer;
		};

	/**
	 * 파일 재정렬 객체 생성
	 * @param file_seqs 기존 FILE SEQ + 신규 추가되는 X_FILE_PROMISE
	 * @param new_files 신규 추가되는 MultipartFile 들
	 * @return
	 */
	public static ReAlignFileList of(  List<String> file_seqs , MultipartFile[] new_files   ) {
		if( CollectionUtils.isEmpty( file_seqs ) ) {
			/** FILE SEQ 존재하지 않을 경우  **/
			return new ReAlignFileList();
		}

		/** 신규  물리 파일 카운트 **/
		long multi_files_length = StreamUtils.toStream( new_files )
													.filter( Predicates.not( MultipartFile::isEmpty ) )
													.count();

		/** 신규 등록되는 파일의 카운트  **/
		long file_cnt = StreamUtils.toStream( file_seqs )
											.filter( Predicates.equalTo( Constrants.X_FILE_PROMISE  ) )
											.count();

		if( multi_files_length != file_cnt ) {
			/** 물리파일 수량과 신규파일 수량이 일치하지않습니다. **/
			throw new ErrorMessageException("file.not.match.cnt");
		}

		/** 중복 제거된 FILE SEQ  **/
		long distinct_file_seqs_count = StreamUtils.toStream( file_seqs )
																.filter( StringUtils::isNumeric )
																.distinct()
																.count();

		if( CollectionUtils.size( file_seqs ) != ( file_cnt + distinct_file_seqs_count )  ) {
			/** 중복되는 fileSeq 가 존재합니다. **/
			throw new ErrorMessageException("file.duplicate.seq");
		}

		/** 기존 파일 SEQ 와 신규 파일 들을 순차적으로 파싱한다. **/
		return StreamUtils.toStream( file_seqs )
								.collect( 	ReAlignFileList::new
										   ,MULTI_PART_FILE_ACCUMULATOR.apply( new_files )
										   ,ReAlignFileList::addAll );

	}



	/** 수정할 시퀀스 조회 **/
	public List<Integer> getModifyFileSeqs(){
		return StreamUtils.toStream( this )
								.filter( reassign -> ObjectUtils.isNotEmpty( reassign.getFile_seq() )   )
								.map( ReAlignFile::getFile_seq )
								.collect( Collectors.toList() );
	}


	/**
	 * 현재파일( DB 정보 ) 과 비교하여 유효하지 않은 파일 시퀀스가 있는지 확인한다.
	 */
	public boolean isValidFileSeqs( List<Integer> old_file_seqs ) {

		/** 수정할 파일 시퀀스 **/
		List<Integer> modifyFileSeqs = this.getModifyFileSeqs();
		if( CollectionUtils.isEmpty( modifyFileSeqs ) ) { return true; }

		boolean has_not_match = FluentIterable.from( modifyFileSeqs )
														.filter( Predicates.not( Predicates.in( old_file_seqs )  )  )
														.first()
														.isPresent();
		/** NOT MATCH 가 있으면 응답값 FALSE 없으면 TRUE **/
		return !has_not_match;
	}


	/**
	 * 현재 파일들중에 삭제할 파일 시퀀스를 조회한다.
	 */
	public List<Integer> getRemoveFileSeqs( List<Integer> old_file_seqs ){
		if( CollectionUtils.isEmpty(old_file_seqs) ) {
			return null;
		}

		/** 수정할 파일 시퀀스 **/
		List<Integer> modifyFileSeqs = this.getModifyFileSeqs();

		List<Integer> removeFileSeqs = FluentIterable.from( old_file_seqs )
																.filter( Predicates.not( Predicates.in( modifyFileSeqs )  ) )
																.toList();
		return removeFileSeqs;
	}


}
