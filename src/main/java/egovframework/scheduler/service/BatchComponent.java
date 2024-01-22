package egovframework.scheduler.service;

import java.io.IOException;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.common.constrant.Constrants;
import egovframework.common.util.DurationUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@EnableScheduling
public class BatchComponent {
	
	@Autowired
	WebLogSchedulerService webLogScheduleService;

	// 배치 매일 0시
	//@Scheduled(cron="0 0 0 * * ?")
	@Scheduled(cron="0 0 0 * * ?")
	public void daily_up_batch() throws IOException {
		String run_time1 = DurationUtils.getTimeString( LocalDateTime.now(), Constrants.YYYY_MM_DD_HH_MM );
		log.info("################# daily_up_batch Start #################"+run_time1);
		
		webLogScheduleService.startTimer();
		
		String run_time2 = DurationUtils.getTimeString( LocalDateTime.now(), Constrants.YYYY_MM_DD_HH_MM );
		log.info("################# daily_up_batch End #################"+run_time2);
	}
	
	
}
