package egovframework.scheduler.controller;


import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.common.base.BaseController;
import egovframework.scheduler.service.WebLogSchedulerService;

@Controller
public class WebLogController extends BaseController {
	@Autowired
	WebLogSchedulerService webLogScheduleService;
	
	@RequestMapping( value= "/scheduler/webLogScheduleServiceManual.do" , method=RequestMethod.GET )
	@ResponseBody
	public void webLogScheduleServiceManual() throws ParseException {
		webLogScheduleService.startTimer();
	}

}
