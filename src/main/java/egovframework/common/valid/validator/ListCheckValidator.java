package egovframework.common.valid.validator;


import java.util.Collection;
import java.util.Optional;
import java.util.function.Function;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import org.apache.commons.collections4.CollectionUtils;

import egovframework.common.valid.annotation.ListCheck;
import egovframework.common.valid.validator.operator.ListCheckOperator;




/**
 * LIST 의 유효성을 체크한다.
 * @author yoon
 * @param <T>
 * @param <T>
 */
public class ListCheckValidator implements ConstraintValidator<ListCheck, Collection<?>> {

	private Class<? extends ListCheckOperator<?> > operator;

	@Override
	public void initialize(ListCheck constraintAnnotation) {
		this.operator = constraintAnnotation.operator();
	}


	private static final Function< Collection<?> , Function <Class<? extends ListCheckOperator<?> >, Boolean> > SCOPE_FUNC =
			collection -> clazz -> {
					try {

						/**
						 * rawtypes 무시
						 * generics 무시
						 */
						@SuppressWarnings({ "rawtypes" })
						ListCheckOperator instance =  clazz.newInstance();
						@SuppressWarnings("unchecked")
						boolean result = instance.isValid( collection );

						return result;
					}catch( Exception e) {
						return false;
					}
	};

	@Override
	public boolean isValid( Collection<?> value, ConstraintValidatorContext context) {
		if( CollectionUtils.isEmpty(value) ) {
			return true;
		}
		return  Optional.ofNullable( this.operator )
					.map( SCOPE_FUNC.apply( value ) )
					.orElseGet( () -> false );
	}




}
