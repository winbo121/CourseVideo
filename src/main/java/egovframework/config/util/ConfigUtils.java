package egovframework.config.util;

import java.io.IOException;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class ConfigUtils {

	private static final 	PathMatchingResourcePatternResolver RESOURCE_RESOLVER = new PathMatchingResourcePatternResolver();

	public static Resource getResource( String location ) {
		return RESOURCE_RESOLVER.getResource( location );
	}

	public static Resource[] getResources( String locationPattern ) throws IOException {
		return RESOURCE_RESOLVER.getResources( locationPattern );
	}

}
