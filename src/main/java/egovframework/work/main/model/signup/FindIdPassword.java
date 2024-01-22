package egovframework.work.main.model.signup;

import javax.validation.constraints.NotEmpty;

import egovframework.common.base.BaseController.ALL;
import egovframework.work.main.web.NoneMenuController.RESET_PASSWORD;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Getter @Setter @ToString
public class FindIdPassword {

	/** 이메일 **/
	@NotEmpty( groups = { ALL.class } )
	private String email;

	/** 사용자 아이디 **/
	@NotEmpty( groups = { RESET_PASSWORD.class } )
	private String user_id;

}
