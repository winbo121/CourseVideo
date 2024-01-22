package egovframework.config.interceptor;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.simple.JSONValue;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import egovframework.common.util.LocalThread;
import egovframework.common.util.egov.EgovSessionCookieUtil;

@EnableScheduling
@EnableAsync
public class WebLogInterceptor extends HandlerInterceptorAdapter {

	// Logger Name이 "web.log"인 Logger설정을 따르는 Logger 객체 생성
	Logger logger = LogManager.getLogger("web.log");
	
	/** 이미지 서버 ROOT 경로 **/
	@Value(value="${weblog.file.dir}")
	private String weblog_file_dir;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		return super.preHandle(request, response, handler);
		
	}
	
	
	
	/**
	 * 웹 로그정보를 생성한다.
	 * 
	 * @param HttpServletRequest request, HttpServletResponse response, Object handler 
	 * @return 
	 * @throws Exception 
	 */
	@Override
	public void postHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler, ModelAndView modeAndView) throws Exception {
		
		final String IS_MOBILE = "MOBI";
		final String IS_PC = "PC";
		
		try{
			// 현재 시간 구하기 (시스템 시계, 시스템 타임존)
		    Date nowDate = new Date();
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd HHmmss");
			String strNowDate = simpleDateFormat.format(nowDate); 
			String requestURI = request.getRequestURI().toString();
			Boolean isLogin = LocalThread.isLogin();
			Boolean isAdinLogin = LocalThread.isAdmin();
			String userIp = LocalThread.getRemoteAddr();
			String userId = "";
			String userType = "";
			String conn_way = "";
			String course_seq = null;
			String category_code = null;
			
			//모바일,PC 접속 여부 확인
			String userAgent = request.getHeader("User-Agent").toUpperCase();
		    if(userAgent.indexOf(IS_MOBILE) > -1) {
		    	conn_way = "M";
		    } else {
		    	conn_way = "P";
		    }
			
		    //Y는 로그인 N 은 비로그인
			if(isLogin || isAdinLogin) {
				userType = "Y";
				userId = LocalThread.getLoginId();
			} else {
				userType = "N";
			}
			
			//강좌 상세 페이지 course_seq 로그 입력
			Map params = request.getParameterMap() ;
			Set s = params.entrySet() ;
			Iterator it = s.iterator();
			
			//강좌찾기 -> 강좌상세 (course_seq)
			if(requestURI.equals("/course/courseFindDetail.do")) {
				while(it.hasNext()){
					@SuppressWarnings("unchecked")
					Map.Entry<String,String[]> entry = (Map.Entry<String,String[]>)it.next();
					String key = entry.getKey();
					if(key.equals("course_seq")) {
						String[] value  = entry.getValue();
						course_seq = value[0].toString();
					}
				}
				
			}
			
			//메인 -> 강좌찾기 (category_seq)
			if(requestURI.equals("/course/courseFind/index.do")) {
				while(it.hasNext()){
					@SuppressWarnings("unchecked")
					Map.Entry<String,String[]> entry = (Map.Entry<String,String[]>)it.next();
					String key = entry.getKey();
					if(key.equals("codeGubun")) {
						String[] value  = entry.getValue();
						category_code = value[0].toString();
					}
				}
				
			}
			
			//log데이터 생성
			@SuppressWarnings("rawtypes")
			Map obj = new LinkedHashMap();
		    obj.put("logWebStrNowDate", strNowDate);
		    obj.put("userType", userType);
		    obj.put("conn_way", conn_way);
		    obj.put("userIp", userIp);
		    obj.put("userId", userId);
		    obj.put("timeOnPage", null);
		    obj.put("requestURI", requestURI);
		    obj.put("courseSeq", course_seq);
		    obj.put("category_code", category_code);
			
		    
			HttpSession session = request.getSession();
			
			Timer local_service = (Timer)EgovSessionCookieUtil.getSessionAttribute(request, "Timer");
			if( ObjectUtils.isNotEmpty(local_service) ) {
				//접속이력 있음
				Map local_obj =  (Map) EgovSessionCookieUtil.getSessionAttribute(request, "obj");
				
				Date obj_date = simpleDateFormat.parse((String) local_obj.get("logWebStrNowDate"));
				
	    		// Date -> 밀리세컨즈 
	    		long timeMil1 = obj_date.getTime();
	    		long timeMil2 = nowDate.getTime();
				long timeOnPage = (timeMil2 - timeMil1)/1000;
				
				local_obj.put("timeOnPage", String.valueOf(timeOnPage));
				
				String jsonText = JSONValue.toJSONString(local_obj).replaceAll("\\\\", "");
				
				//로그 사용
				//logger.info(jsonText);
				
				//파일 생성 사용
				writeLog(jsonText);
				
				local_service.cancel();
			} 

			Timer scheduler = new Timer();
	        TimerTask task0 = new TimerTask() {
	            @Override
	            public void run() {
	            	fixedRateScheduler0(session, obj, scheduler);
	            }
	        };

	        session.setAttribute("obj", obj);
	        session.setAttribute("Timer", scheduler);
	        
	        //Integer maxaxInactiveInterval = session.getMaxInactiveInterval();
	        scheduler.schedule(task0, 600000); 	        //페이지 이동없이 설정 시간(600초) 경과 후
		
		} catch(Exception e){
	    	e.printStackTrace();
	    }
        
	}
	
	public void fixedRateScheduler0(HttpSession session, Map<String, String> obj, Timer scheduler) {
		obj.put("timeOnPage", "OUT");
		
		String jsonText = JSONValue.toJSONString(obj).replaceAll("\\\\", "");
		//logger.info(jsonText);
		
		//파일 생성 사용
		writeLog(jsonText);
		
		//session obj초기화
		session.setAttribute("obj", null);
		session.setAttribute("Timer", null);
	}
	
	public void writeLog(String jsonText) {
		//Calendar 객체 생성
		Calendar cal = Calendar.getInstance();
		//오늘 날짜 설정
		cal.setTime(new Date());
		
		SimpleDateFormat dtFormat = new SimpleDateFormat("yyyy-MM-dd");
		String myString = dtFormat.format(cal.getTime());
		
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH)+1;
		
		String folderPath = weblog_file_dir+"\\"+year+"\\"+month;
		String filePath = folderPath+"\\weblog.log."+myString;
		
		//폴더 생성
		File Folder = new File(folderPath);
		if (!Folder.exists()) {
			try{ 
				Folder.mkdirs(); //폴더 생성합니다.
			} catch(Exception e){
			    e.getStackTrace();
			}   
		} else { 
		}
		
		//파일 생성
        File file = new File(filePath); // File객체 생성
        if(!file.exists()){ // 파일이 존재하지 않으면
            try {
				file.createNewFile();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} // 신규생성
        }

        try{
        	// BufferedWriter 생성
			BufferedWriter writer = new BufferedWriter(new FileWriter(file, true));

			System.out.println("jsonText:"+ jsonText);
			
	        // 파일에 쓰기
	        writer.write(jsonText);
	        writer.newLine();
	        // 버퍼 및 스트림 뒷정리
	        writer.flush(); // 버퍼의 남은 데이터를 모두 쓰기
	        writer.close(); // 스트림 종료
		
        } catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
