package egovframework.common.menu.attribute;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class TopMenu {

	private String name;
	private List<String> roles;
	private List<ChildMenu> children;

}
