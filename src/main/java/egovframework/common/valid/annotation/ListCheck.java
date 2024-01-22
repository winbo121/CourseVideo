package egovframework.common.valid.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.validation.Constraint;
import javax.validation.Payload;

import egovframework.common.valid.validator.ListCheckValidator;
import egovframework.common.valid.validator.operator.ListCheckOperator;


@Target({ElementType.FIELD,  ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE })
@Retention( RetentionPolicy.RUNTIME )
@Constraint(validatedBy = ListCheckValidator.class)
public @interface ListCheck {

	Class<?>[] groups() default { };
	String message() default "IS NOT VALID LIST";
	Class<? extends Payload>[] payload() default { };

	/** 리스트 체크 연산자 **/
	Class<? extends ListCheckOperator<?> > operator();


}
