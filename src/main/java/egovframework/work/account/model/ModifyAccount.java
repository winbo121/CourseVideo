package egovframework.work.account.model;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;
import org.hibernate.validator.constraints.Range;

import egovframework.common.base.BaseController.ALL;
import egovframework.common.base.BaseController.PUT;
import egovframework.common.valid.annotation.Password;
import egovframework.work.account.controller.AccountController.NEW_GRADE;
import egovframework.work.account.controller.AccountController.POST_ROLE_STUDENT;
import egovframework.work.account.controller.AccountController.POST_ROLE_TEACHER;
import egovframework.work.account.controller.AccountController.PUT_ROLE_STUDENT;
import egovframework.work.account.controller.AccountController.PUT_ROLE_TEACHER;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * 사용자 정보 변경
 * @author yoon
 *
 */
@Getter @Setter @ToString
public class ModifyAccount {

	/** 비밀번호 변경 여부 **/
	private boolean check;
	
	/** 새학년 정보 생성 여부 **/
	private boolean check_new_grade = Boolean.FALSE;

	/** 사용자 비밀번호 **/
	@NotEmpty( groups={PUT.class} )
	@Password( groups={PUT.class} )
	private String user_pw;

	/** 사용자 비밀번호 확인 **/
	@NotEmpty( groups={PUT.class} )
	private String user_pw_confirm;

	/** 학교코드 **/
	@NotEmpty
	private String sch_cd;

	/** 학년 **/
	@NotEmpty( groups={ POST_ROLE_TEACHER.class, PUT_ROLE_TEACHER.class, NEW_GRADE.class } )
	@Range( groups={ ALL.class }, min = 3, max = 6 )
	private String sch_grade;

	/** 반 **/
	@NotEmpty
	@Range(groups={ALL.class}, min = 1 )
	private String sch_class;

	/** 현재 년도 **/
	private String year_cd;
	
	/** 사용자 성별 **/
	@NotEmpty( groups= { POST_ROLE_STUDENT.class, PUT_ROLE_STUDENT.class } )
	@Pattern( regexp="1|2|", groups= { POST_ROLE_STUDENT.class, PUT_ROLE_STUDENT.class } )
	private String gender;  

	
	/** 사용자 이메일 **/
	@NotEmpty( groups={ALL.class} )
	private String user_email;
	  
	/** 비담임 여부 **/
	private String role_type;
	private boolean check_role = Boolean.FALSE;
	
	/** 사용자 이름 **/
	@NotEmpty
	private String user_name;
}
