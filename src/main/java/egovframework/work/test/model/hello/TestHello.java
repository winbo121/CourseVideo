package egovframework.work.test.model.hello;

import javax.validation.constraints.NotEmpty;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter @ToString
public class TestHello {

	@NotEmpty
	private String abc;

	private String xxx;

}
