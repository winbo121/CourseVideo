package egovframework.common.tag;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.jstl.core.ConditionalTagSupport;
import org.apache.commons.lang3.StringUtils;

import egovframework.common.util.StreamUtils;
import egovframework.config.provider.ApplicationContextProvider;
import lombok.Setter;

/**
 * SPRING PROFILE 이 맞는지 확인한다.
 * @author yoon
 *
 */
public class IsProfileTag extends ConditionalTagSupport {

	private static final long serialVersionUID = -930462813518135857L;

	@Setter
	private String target_profiles;

	private static final String SPRING_PROFILE = "spring.profiles";

	@Override
	protected boolean condition() throws JspTagException {
		if( StringUtils.isEmpty( this.target_profiles ) ) {
			return false;
		}
		String spring_profile = ApplicationContextProvider.getSafeValue( SPRING_PROFILE );
		if( StringUtils.isEmpty( spring_profile ) ) {
			return false;
		}
		String[] target_array = 	StringUtils.split( this.target_profiles, "," );
		return StreamUtils.toStream( target_array )
						.filter( StringUtils::isNotBlank )
						.filter( t -> StringUtils.equals( t , spring_profile ) )
						.findFirst()
						.isPresent();
	}

}
