package egovframework.common.util;

import java.util.Optional;
import java.util.stream.Collectors;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class CacheUtils {

	/**
	 * CACHE 를 사용할 @Service method 에 아래와 같이 주입한다.
	 * @Cacheable(key=CacheUtils.CACHE_KEY_GENERATE , value=CacheUtils.CACHE_NAME_CMS )
	 */
	public static final String CACHE_KEY_GENERATE = "T(com.kicebook.common.util.CacheUtils).createKey(#root.targetClass, #root.methodName, #root.args )";
	public static final String CACHE_NAME = "kicebook_cache";

	/**
	 * CACHE KEY 를 생성한다.
	 * @param clazz
	 * @param method_name
	 * @param params
	 * @return
	 */
	public static Object createKey( Class<?> clazz, String method_name, Object... params  ) {

		/** 대상 Classs name  **/
		String class_name = Optional.ofNullable(clazz)
													.map(Class::getSimpleName)
													.orElse("");
		/** 대상 Method params **/
		String target_params = StreamUtils.toStream( params )
				.map( String::valueOf )
				.collect( Collectors.joining("|", "<", ">") );

		StringBuilder sb = new StringBuilder();
		sb.append("[");
		sb.append( class_name );
		sb.append( "." );
		sb.append( method_name );
		sb.append("]");
		sb.append(target_params);

		return sb.toString();
	}


}
