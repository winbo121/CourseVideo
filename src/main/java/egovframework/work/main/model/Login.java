package egovframework.work.main.model;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class Login {
	private String user_id;
	private String user_pw;

	private String login_error;
}
