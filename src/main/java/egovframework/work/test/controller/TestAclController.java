package egovframework.work.test.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.common.base.BaseController;


@Controller
public class TestAclController extends BaseController {

	@RequestMapping( value = "/user/test.do", method = RequestMethod.GET )
	public String user_test( Model model ) {
		return "test/acl_user";
	}

	@RequestMapping( value = "/student/test.do", method = RequestMethod.GET )
	public String student_test( Model model ) {
		return "test/acl_student";
	}

	@RequestMapping( value = "/teacher/test.do", method = RequestMethod.GET )
	public String teacher_test( Model model ) {
		return "test/acl_teacher";
	}

}
