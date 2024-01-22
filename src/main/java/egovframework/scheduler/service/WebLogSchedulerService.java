package egovframework.scheduler.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.poi.util.SystemOutLogger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import egovframework.common.component.scheduler.mapper.WebLogSchedulerMapper;

@Service
public class WebLogSchedulerService {
	
	@Autowired
	WebLogSchedulerMapper webLogSchedulerMapper; 
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${weblog.file.dir}")
	private String weblog_file_dir;
	
	int scheduler_seq = 2;		//스케줄러 테이블 설정 seq 
	
	public void startTimer() {
		Timer timer = new Timer();
		WeblogTask task = new WeblogTask();
		
		Calendar date = Calendar.getInstance();
		
		Map<String,Object> getScheduler = webLogSchedulerMapper.getScheduler(scheduler_seq);
		
		String schedulerType = (String) getScheduler.get("scheduler_type");
		Integer day = null;
		Integer hour = null;
		Integer minute = null;
		if(ObjectUtils.isNotEmpty( getScheduler.get("day") )) {
			day = (Integer) getScheduler.get("day");
			//날짜정보
	        date.set(Calendar.DAY_OF_MONTH, day-1); 
		};
		if(ObjectUtils.isNotEmpty( getScheduler.get("hour") )) {
			hour = (int) getScheduler.get("hour");
			 //시정보
	        date.set(Calendar.HOUR_OF_DAY, hour); 
		};
		if(ObjectUtils.isNotEmpty( getScheduler.get("hour") )) {
			minute = (int) getScheduler.get("minute");
			//분정보
	        date.set(Calendar.MINUTE, minute);
		};
        
        Date dateDt = date.getTime();
        
        timer.schedule(task, dateDt); 
	}
	
	class WeblogTask extends TimerTask {
		public void run() {
			//스케줄러 시퀀스 입력
			Map<String,Object> LogParam = new HashMap<String,Object>();
			LogParam.put("scheduler_seq", scheduler_seq);

			// tb_scheduler_log 테이블 시작 insert
			webLogSchedulerMapper.addSchedulerLog(LogParam);
			// insert후 schedulerLogSeq 값
			String schedulerLogSeq = LogParam.get("scheduler_log_seq").toString();
			
			try {
				startScheduler(schedulerLogSeq);
				LogParam.put("success_yn", "Y");
				// tb_scheduler_log 테이블 종료 성공여부 update
				webLogSchedulerMapper.updateSchedulerLog(LogParam);
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			
		}
	}

	public void startScheduler(String schedulerLogSeq) throws IOException {
		
		//Calendar 객체 생성
		Calendar cal = Calendar.getInstance();
		//오늘 날짜 설정
		cal.setTime(new Date());
		
		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd");
		cal.add(Calendar.DATE, -1);
		String myString = dtFormat.format(cal.getTime());
		
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH)+1;
		
		//String file = "D:\\KotechLms_log\\daily\\dailyRollingSample.log.2023-05-04";
		String file = weblog_file_dir+"\\"+year+"\\"+month+"\\weblog.log."+myString;
		
		// 1. 파일 전체 읽기
		List<String> lines = Files.readAllLines(Paths.get(file));
		
        // 2. n번째 라인 읽기
        //String nthLine = lines.get(2);

        // 3. 결과 출력
        //System.out.println(nthLine);  // line 3
		
		int lingIndex = 1;
		int successCnt = 0;
		int failCnt = 0;
		
		//스케줄러 시퀀스 입력
		Map<String,Object> activeLogParam = new HashMap<String,Object>();
		
		activeLogParam.put("scheduler_log_seq", schedulerLogSeq);
		
		// tb_scheduler_active_log 테이블 시작 insert
		webLogSchedulerMapper.addSchedulerActiveLog(activeLogParam);
		// insert후 schedulerActiveLogSeq 값
		String schedulerActiveLogSeq = activeLogParam.get("schedulerActiveLogSeq").toString();
		
		for (String line : lines) {
			
			JSONParser parser = new JSONParser();
			
	        Object obj;
			try {
				obj = parser.parse(line);
				JSONObject jsonObj = (JSONObject)obj;
				
				Map<String,Object> param = new HashMap<String,Object>();
				
				param.put("conn_ip", (String)jsonObj.get("userIp"));
				param.put("conn_uri", (String)jsonObj.get("requestURI"));
				param.put("reg_dts", (String)jsonObj.get("logWebStrNowDate"));
				param.put("conn_way", (String)jsonObj.get("conn_way"));
				param.put("login_yn", (String)jsonObj.get("userType"));
				param.put("user_id", (String)jsonObj.get("userId"));
				param.put("time_on_page", (String)jsonObj.get("timeOnPage"));
				param.put("course_seq", (String)jsonObj.get("courseSeq"));
				
				try {
					webLogSchedulerMapper.callActiveLog(param);
					
					successCnt++;
					
				} catch (Exception e) {
					Map<String,Object> FailLogParam = new HashMap<String,Object>();
					
					FailLogParam.put("scheduler_active_log_seq", schedulerActiveLogSeq);
					FailLogParam.put("file_line", lingIndex);
					
					//tb_scheduler_fail_log 테이블 실패 line_index insert
					webLogSchedulerMapper.addSchedulerFailLog(FailLogParam);
					
					failCnt++;
					e.printStackTrace();
				}
				
				
			} catch (ParseException e) {
				e.printStackTrace();
			}
	        
			lingIndex++;
			
		}
		
		activeLogParam.put("success_cnt", successCnt);
		activeLogParam.put("fail_cnt", failCnt);
		activeLogParam.put("scheduler_active_log_seq", schedulerActiveLogSeq);
		
		// tb_scheduler_active_log 테이블 종료 성공, 실패 카운트 update
		webLogSchedulerMapper.updateSchedulerActiveLog(activeLogParam);
		
	};
	
}
