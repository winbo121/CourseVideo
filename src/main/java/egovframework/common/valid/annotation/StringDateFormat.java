package egovframework.common.valid.annotation;

import static java.lang.annotation.ElementType.ANNOTATION_TYPE;
import static java.lang.annotation.ElementType.CONSTRUCTOR;
import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.ElementType.PARAMETER;
import static java.lang.annotation.ElementType.TYPE_USE;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import java.lang.annotation.Documented;
import java.lang.annotation.Repeatable;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import javax.validation.Constraint;
import javax.validation.Payload;

import egovframework.common.valid.validator.StringDateFormatValidator;
import egovframework.common.valid.annotation.StringDateFormat.List;




@Documented
@Constraint(validatedBy = StringDateFormatValidator.class)
@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
@Retention( RUNTIME )
@Repeatable( List.class )
public @interface StringDateFormat {


	Class<?>[] groups() default { };
	String message() default "IS NOT VALID DATE FORMAT";
	Class<? extends Payload>[] payload() default { };
	String pattern();

	/**
	 * Defines several {@code @NotEmpty} constraints on the same element.
	 *
	 * @see StringDateFormat
	 */
	@Target({ METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER, TYPE_USE })
	@Retention(RUNTIME)
	@Documented
	public @interface List {
		StringDateFormat[] value();
	}



}
