package egovframework.common.aop;

import java.lang.annotation.Annotation;
import java.util.Optional;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import egovframework.common.aop.annotation.AopBefore;
import lombok.extern.slf4j.Slf4j;

/** SPRING BOOT AOP ASPECT **/
@Slf4j
@Aspect
@Component
public class BootAspect {

	@Before( value ="execution(* com.kicebook.work..*Service.*(..))"
					+ "&& @annotation( egovframework.common.aop.annotation.AopBefore )" )
	public void beforeService( JoinPoint joinPoint  ) {
		AopBefore annotation = getTargetAnnotation( joinPoint,  AopBefore.class );
		log.info("{}", annotation);

		return;
	}


	private static final <T extends Annotation > T  getTargetAnnotation( JoinPoint joinPoint , Class<T> clazz ) {
		return Optional.ofNullable( joinPoint )
							.map( JoinPoint::getSignature )
							.map( signature -> (MethodSignature) signature  )
							.map( MethodSignature::getMethod )
							.map( method -> method.getAnnotation( clazz ) )
							.orElseGet( () -> null );
	}
}
