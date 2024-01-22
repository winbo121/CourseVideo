/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.work.login.web;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.common.constrant.Constrants;
import egovframework.work.main.model.Login;




@Controller
@RequestMapping(value = "/login")
public class KotechLoginController {
	
	/**
	 * 로그인 화면을 조회한다.
	 */
	@GetMapping(value = "/loginMain/index.do")
	public String kotechLoginMain(ModelMap  model,  @ModelAttribute Login login) {
		
		model.addAttribute( "cookie_remember_id_key", Constrants.REMEMBER_USER_ID_KEY );
		return "login/loginMain";
	}
	
	

}
