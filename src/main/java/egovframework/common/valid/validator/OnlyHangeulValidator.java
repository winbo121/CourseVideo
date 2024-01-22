package egovframework.common.valid.validator;


import java.util.regex.Pattern;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import egovframework.common.valid.annotation.OnlyHangeul;



/**
 * 2~5 자리의 한글만 입력가능하다.
 * @author yoon
 * @param <T>
 * @param <T>
 */
public class OnlyHangeulValidator implements ConstraintValidator<OnlyHangeul, Object > {

	@Override
	public void initialize( OnlyHangeul constraintAnnotation) {
	}


	@Override
	public boolean isValid( Object value, ConstraintValidatorContext context) {
		if(  value == null || ! ( value instanceof String ) ) {
			return true;
		}
		return Pattern.matches("^[ㄱ-ㅎ가-힣]*$", String.valueOf( value ) );
	}





}
