package egovframework.common.component.code.model;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/** 공통 코드 정보 **/
@Getter @Setter @ToString
public class CommCd {

	/** 대표코드 **/
	private String leader_cd;
	/** 공통코드 **/
	private String comm_cd;
	/** 코드명 **/
	private String cd_name;
	/** 설명 **/
	private String definition;
	/** 게시순서 **/
	private String cd_order;

	/** 타켓이 되는 코드인지 여부 확인 **/
	@JsonIgnore
	public boolean isTarget( String target_cd ) {
		return StringUtils.equals( this.comm_cd, target_cd );
	}



}
