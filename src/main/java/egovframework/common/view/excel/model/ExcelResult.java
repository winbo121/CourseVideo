package egovframework.common.view.excel.model;

import java.io.Serializable;

import egovframework.common.view.excel.template.SheetTemplate;
import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor( staticName = "of" )
public class ExcelResult implements Serializable {

	private static final long serialVersionUID = 5717582009683482931L;

	@NonNull
	private String fileName;

	@NonNull
	private  SheetTemplate sheet;


}
