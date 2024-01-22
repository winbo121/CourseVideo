package egovframework.common.valid.validator.operator;

import java.util.Collection;

public abstract class ListCheckOperator<T> {

	/** 리스트가 유효한지 확인한다. **/
	public abstract boolean isValid( Collection<T> value );

}
