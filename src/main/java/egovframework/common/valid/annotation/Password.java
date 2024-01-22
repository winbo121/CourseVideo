package egovframework.common.valid.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import javax.validation.Constraint;
import javax.validation.Payload;

import egovframework.common.valid.validator.PasswordValidator;


/** 비밀번호 체크 **/
@Target({ElementType.FIELD,  ElementType.METHOD, ElementType.PARAMETER, ElementType.ANNOTATION_TYPE })
@Retention( RetentionPolicy.RUNTIME )
@Constraint(validatedBy = PasswordValidator.class)
public @interface Password {

	Class<?>[] groups() default { };
	String message() default "비밀번호는 영문, 숫자, 특수 문자 조합으로 8~30자 로 생성하여주세요.";
	Class<? extends Payload>[] payload() default { };

//	String pattern() default "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[$@$!%*#?&])[A-Za-z[0-9]$@$!%*#?&]{8,30}$";

	String pattern() default "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,30}$";

}
