package egovframework.work.account.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.base.BaseController;
import egovframework.common.component.code.CodeComponent;
import egovframework.common.component.code.model.SchCd;

/** 학교 정보 조회  **/
@Controller
public class SchoolController extends BaseController {

	@Autowired
	private CodeComponent codeComponent;

	/** 학교 정보 리스트 조회 ( 회원가입에도 사용할수있기 때문에 비로그인 사용자도 접근가능해야한다. ) **/
	@ResponseBody
	@RequestMapping( value= "/school/list.do" , method=RequestMethod.POST )
	public Map<String, Object> list( @ModelAttribute SchCd input ){

		String sch_name = input.getSch_name();
		List<SchCd> schools = codeComponent.getSchCds( sch_name );

		/** 응답값 **/
		Map<String, Object> result = Maps.newHashMap();
		result.put("schools", schools);

		return result;
	}

}
