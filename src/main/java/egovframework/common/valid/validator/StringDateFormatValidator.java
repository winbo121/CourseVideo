package egovframework.common.valid.validator;

import java.util.Optional;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import org.apache.commons.lang3.StringUtils;

import egovframework.common.util.DurationUtils;
import egovframework.common.valid.annotation.StringDateFormat;


/**
 * String type 의 날짜의 유효성을 체크한다.
 * @author yoon
 */
public class StringDateFormatValidator implements ConstraintValidator<StringDateFormat, String> {

	private String pattern;

	@Override
	public void initialize(StringDateFormat constraintAnnotation) {
		this.pattern = constraintAnnotation.pattern();
	}


	@Override
	public boolean isValid(String value, ConstraintValidatorContext context) {
		return Optional.ofNullable( value )
						 .filter( StringUtils::isNotEmpty )
						 .map( time ->  DurationUtils.isValidFormat( time, this.pattern )   )
						 .orElse( true );
	}

}
