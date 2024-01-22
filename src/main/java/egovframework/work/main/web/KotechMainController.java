package egovframework.work.main.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import egovframework.common.constrant.Constrants;
import egovframework.common.util.LocalThread;
import egovframework.work.course.service.KotechCourseService;
import egovframework.work.main.model.Login;
import egovframework.work.main.service.KotechMainService;
import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class KotechMainController {
	@Autowired
	protected KotechMainService kotechMainService;
	
	@Autowired
	protected KotechCourseService kotechCourseService;
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${img.server.root.path}")
	private String img_server_root_path;
	
	/** 파일 서버 ROOT 경로 **/
	@Value(value="${file.server.root.path}")
	private String file_server_root_path;
	
	
	
	/** 인덱스 페이지 **/
	@RequestMapping(value = { "/", "index.do" }, method = RequestMethod.GET)
	public String kotechMain(ModelMap  model,  @ModelAttribute Login login) {
		
		try {
		List<Map<String, Object>> courseGubun = kotechCourseService.courseGubun();
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("imgPath", img_server_root_path);
		param.put("filePath", file_server_root_path);
		
		Boolean isLogin = LocalThread.isLogin();
		String user_id = "";
		if (isLogin) {
			user_id = LocalThread.getLoginId();
		} 
		param.put("user_id", user_id);
		
		
		
		List<Map<String, Object>> mainCourseList = kotechMainService.courseList(param);
		
		Map<String,Object> mainObjCnt = kotechMainService.objectCntList();
		
		model.addAttribute( "course_totcnt", mainObjCnt.get("course_totcnt") );
		model.addAttribute( "stu_totcnt", mainObjCnt.get("stu_totcnt") );
		model.addAttribute( "his_totcnt", mainObjCnt.get("his_totcnt") );
		
		model.addAttribute( "cookie_remember_id_key", Constrants.REMEMBER_USER_ID_KEY );
		model.addAttribute( "courseGubun", courseGubun );
		model.addAttribute( "mainCourseList", mainCourseList );
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		
		return "main/kotechMain";
	}
	
	
	
}
