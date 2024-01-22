package egovframework.work.search.web;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.common.collect.Maps;

import egovframework.common.util.LocalThread;
import egovframework.work.main.model.Login;
import egovframework.work.search.service.CommonSearchService;

@Controller
public class CommonSearchController {
	@Autowired
	protected CommonSearchService commonSearchService;

	/** 검색 저장 **/
	@PostMapping(value = "/search/saveData.do")
	@ResponseBody
	public Map<String, Object> kotechMain(ModelMap model, @ModelAttribute Login login,
			@RequestParam Map<String, Object> param) {
		Map<String, Object> result = Maps.newHashMap();
		String result_message = "";
		try {

			Boolean isLogin = LocalThread.isLogin();
			String loginYn = "";
			String user_id = "";
			if (isLogin) {
				user_id = LocalThread.getLoginId();
				loginYn = "Y";

			} else {
				user_id = "";
				loginYn = "N";
			}

			param.put("userId", user_id);
			param.put("loginYn", loginYn);

			commonSearchService.insertSearchLog(param);

			result_message = "SUCCESS";
			result.put("result_code", result_message);

		} catch (Exception e) {
			e.printStackTrace();
			result_message = "FAIL";
			result.put("result_code", result_message);
		}

		return result;
	}

}
