package egovframework.common.menu.model;

import java.util.List;

import com.google.common.collect.Lists;

import egovframework.common.util.StreamUtils;
import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.ToString;

@Getter @ToString
@RequiredArgsConstructor( staticName = "of" )
public class Lv1Menu {

	/** LV1 메뉴명 **/
	@NonNull
	private String name;

	/** LV1 메뉴 활성화 여부 **/
	private Boolean on = false;

	/** LV2 메뉴 리스트 **/
	private List<Lv2Menu> lv2_menus = Lists.newArrayList();


	public void addLv2( String lv2_name, boolean lv2_on, String lv2_index_page, boolean mobile, boolean target,  String menu_role ) {
		if( lv2_on == true ) {
			this.on = true;
		}
		this.lv2_menus.add( Lv2Menu.of(lv2_name, lv2_on, lv2_index_page, mobile, target,  menu_role )  );
	}

	/** LV1 메뉴의 인덱스 URL 조회  **/
	public String getIndex_url() {
		return StreamUtils.toStream( this.lv2_menus )
								.findFirst()
								.map( Lv2Menu::getIndex_url )
								.orElseGet( () -> null );
	}


}
