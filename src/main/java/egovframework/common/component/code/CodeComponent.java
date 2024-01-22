package egovframework.common.component.code;

import java.util.List;
import java.util.Optional;
import java.util.function.BiFunction;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.google.common.base.Preconditions;

import egovframework.common.component.code.mapper.CodeMapper;
import egovframework.common.component.code.model.CommCd;
import egovframework.common.component.code.model.SchCd;
import egovframework.common.constrant.EnumCodes.LEADER_CD;
import egovframework.common.util.StreamUtils;

@Component
public class CodeComponent {

	@Autowired
	private CodeMapper codeMapper;

	/** 학교코드로 학교 정보를 조회한다. **/
	public Optional<SchCd> getSchCd( String sch_cd ) {
		Preconditions.checkNotNull( sch_cd );

		List<SchCd> school_list = codeMapper.getSchCds( sch_cd, null );
		return Optional.ofNullable( school_list )
							.filter( list -> list.size() == 1 )
							.map( list -> list.get(0) );
	}


	/** 학교명으로 학교정보 검색 리스트를 조회한다. sch_name EMPTY 인 경우 전체 리스트 **/
	public List<SchCd> getSchCds( String sch_name ){
		return codeMapper.getSchCds( null, sch_name );
	}


	/** 대표코드로 공통 코드 리스트 조회 **/
	public List<CommCd> getCommCds( LEADER_CD leader_cd ){
		Preconditions.checkNotNull( leader_cd );
		return codeMapper.getCommCds( leader_cd.code(), null );
	}

	/** 대표코드, 공통코드로 코드 상세 정보 조회 **/
	public Optional<CommCd> getCommCd( LEADER_CD leader_cd, String comm_cd  ){
		Preconditions.checkNotNull( leader_cd );
		Preconditions.checkNotNull( comm_cd );

		List<CommCd> comm_cd_list = codeMapper.getCommCds( leader_cd.code() , comm_cd );

		return Optional.ofNullable( comm_cd_list )
							.filter( list -> list.size() == 1 )
							.map( list -> list.get(0) );
	}



	/** 코드 리스트 에서 대상이 되는 코드 정보를 추출한다. **/
	private static final BiFunction< List<CommCd>, String, Optional<CommCd>> FIND_TARGET_CD =
		( comm_cds, target_cd  ) -> StreamUtils.toStream( comm_cds )
														 .filter( cd -> cd.isTarget(target_cd) )
														 .findFirst();


	/**
	 * 코드리스트 에서 대상이 되는 코드명을 조회한다.
	 * 존재하지 않을 경우 null 을 응답한다.
	 * @param comm_cds
	 * @param target_cd
	 * @return
	 */
	public static final String getCdName( List<CommCd> comm_cds, String target_cd ) {
		if( CollectionUtils.isEmpty(comm_cds) || StringUtils.isEmpty(target_cd) ) {
			return null;
		}
		return FIND_TARGET_CD.apply( comm_cds , target_cd )
							.map( CommCd::getCd_name )
							.orElseGet( () -> null );
	}


}
