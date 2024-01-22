package egovframework.common.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang3.StringUtils;

import egovframework.config.provider.ApplicationContextProvider;
import lombok.Getter;
import lombok.Setter;

public class ValueTag  extends SimpleTagSupport {

	@Getter @Setter
	private String var;

	@Getter @Setter
	private String name;

	@Getter @Setter
	private Boolean isWrite;

	@Override
    public void doTag() throws JspException {
		String value = ApplicationContextProvider.getSafeValue( this.name );

		/** REQUEST 에 세팅  **/
		PageContext pageContext = TagUtils.getPageContext( super.getJspContext() );

		if( BooleanUtils.isTrue( this.isWrite ) ) {
			TagUtils.writeHtml( super.getJspContext() , value);
		}

		if( StringUtils.isNotEmpty( this.var ) ) {
			pageContext.setAttribute( this.var, value  );
		}
	}


}
