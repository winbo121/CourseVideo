package egovframework.common.menu.attribute;

import java.util.List;

import org.apache.commons.lang3.StringUtils;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class ChildMenu {

	private String name;
	private boolean mobile;
	private String pattern;
	private List<String> roles;
	private boolean target;

	/** 해당 메뉴의 인덱스 페이지 조회 **/
	public String getIndex_page() {
		if( StringUtils.endsWith(this.pattern, "/**") ) {
			return StringUtils.replaceOnce(this.pattern, "/**", "/index.do");
		}
		return null;
	}


}
