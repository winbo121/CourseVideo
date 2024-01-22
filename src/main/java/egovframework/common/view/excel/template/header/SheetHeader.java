package egovframework.common.view.excel.template.header;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor( staticName = "of" )
public class SheetHeader implements Serializable {

	private static final long serialVersionUID = 8480877012702483083L;

	@Getter
	private String headerName;
	@Getter
	private String headerKey;

	/** HTML 여부  **/
	@Getter
	private boolean isHtml;


}
