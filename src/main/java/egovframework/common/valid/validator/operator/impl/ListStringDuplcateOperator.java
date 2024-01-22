package egovframework.common.valid.validator.operator.impl;

import java.util.Collection;
import java.util.stream.Collectors;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import egovframework.common.util.StreamUtils;
import egovframework.common.valid.validator.operator.ListCheckOperator;


/**
 * List<String> 의 내용이 중복되는 값이 있는지 확인한다.
 * @author yoon
 */
public class ListStringDuplcateOperator extends ListCheckOperator<String> {

	@Override
	public boolean isValid( Collection<String> collection ) {
		if( CollectionUtils.isEmpty( collection ) ) {
			return true;
		}

		/** 원본 컬렉션의 사이즈 **/
		int original_size = CollectionUtils.size( collection );

		/** 중복값 & 공백값 제거한 컬렉션 **/
		Collection<String> distinct_collection = 	StreamUtils.toParallelStream( collection )
																		.filter( StringUtils::isNotEmpty )
																		.distinct()
																		.collect( Collectors.toList() );

		/** 중복값 & 공백값 제거한 컬렉션 사이즈 **/
		int distinct_collection_size = CollectionUtils.size( distinct_collection );

		if( original_size != distinct_collection_size ) {
			return false;
		}

		return true;
	}

}
