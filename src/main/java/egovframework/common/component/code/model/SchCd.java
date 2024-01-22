package egovframework.common.component.code.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/** 학교 코드 정보 **/
@Getter @Setter @ToString
public class SchCd {

	/** 학교 코드 **/
	private String sch_cd;

	/** 전체 학교 명 **/
	private String sch_full_name;

	/** 학교 명 **/
	private String sch_name;


}
