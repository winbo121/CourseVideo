package egovframework.common.menu.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

@Getter @ToString
@AllArgsConstructor( staticName = "of" )
public class Lv2Menu {

	/** LV2 메뉴명 **/
	private String name;
	/** LV2 메뉴 활성화 여부 **/
	private Boolean on;
	/** LV2 메뉴 인덱스 페이지 **/
	private String index_url;

	/** 모바일 환경에서 LV2 메뉴 활성 여부 **/
	private Boolean mobile;
	
	/** 새창열기 여부 **/
	private Boolean target;


	/** LV1 메뉴 role **/
	private String menu_role;
}
