package egovframework.common.valid.annotation;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.CONSTRUCTOR;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.ElementType.TYPE_USE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import javax.validation.Constraint;
import javax.validation.Payload;

import egovframework.common.valid.validator.OnlyHangeulValidator;



/** 한글만 입력가능 **/
@Documented
@Constraint(validatedBy = OnlyHangeulValidator.class)
@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
@Retention( RUNTIME )
public @interface OnlyHangeul {

	Class<?>[] groups() default { };
	String message() default "한글만 입력할수 있습니다.";
	Class<? extends Payload>[] payload() default { };

}
