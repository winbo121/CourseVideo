package egovframework.work.test.model.modal;

import java.util.List;
import java.util.Map;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class TestSampleJsonModal {

	private String str;

	private List<Map<String,Object> > list;
}
