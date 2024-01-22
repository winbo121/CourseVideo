package egovframework.common.valid.validator;


import java.util.regex.Pattern;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import org.slieb.throwables.BiFunctionWithThrowable;

import egovframework.common.valid.annotation.Password;


/**
 * 비밀번호의 유효성을 체크한다.
 * @author yoon
 * @param <T>
 * @param <T>
 */
public class PasswordValidator implements ConstraintValidator<Password, Object > {

	String pattern;

	@Override
	public void initialize( Password constraintAnnotation) {
		this.pattern = constraintAnnotation.pattern();
	}

	private static final BiFunctionWithThrowable<String, String, Boolean, Throwable> PASSWORD_FUNCTION =
			( pattern_ , password_ ) -> Pattern.compile( pattern_ )
													  .matcher(  password_ )
													  .matches();

	@Override
	public boolean isValid( Object value, ConstraintValidatorContext context) {
		if(  value == null || ! ( value instanceof String ) ) {
			return true;
		}
		return PASSWORD_FUNCTION.thatReturnsOnCatch( Boolean.FALSE )
					.apply( this.pattern , (String) value );
	}





}
