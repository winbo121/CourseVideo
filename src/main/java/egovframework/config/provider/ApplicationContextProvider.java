package egovframework.config.provider;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

@SuppressWarnings("static-access")
public class ApplicationContextProvider implements ApplicationContextAware {

	private static ApplicationContext applicationContext;

	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}


	/**
	 * SPRING LOAD 구동 시점에 따라서 객체 조회 가 안되는 경우를 위함.
	 * @param requiredType
	 * @return
	 */
	public static <T> T getSafeBean(Class<T> requiredType) {
		try{
			return applicationContext.getBean(requiredType);
		}catch(Exception e){
			return null;
		}
	}

	/**
	 * SPRING BEANS 가 아닌 함수에서 SPRING @Value 를 접근하기 위해서 사용한다.
	 * @param name
	 * @return
	 */
	public static String getSafeValue(String name ) {
		try{
			String result = applicationContext.getEnvironment().getProperty(name);
			return result;
		}catch(Exception e){
			return null;
		}
	}

}
