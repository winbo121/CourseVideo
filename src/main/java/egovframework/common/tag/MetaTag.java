package egovframework.common.tag;

import javax.servlet.jsp.tagext.SimpleTagSupport;
import org.apache.commons.lang3.StringUtils;

import egovframework.common.constrant.Constrants;

/** 폐기 **/
@Deprecated
public class MetaTag extends SimpleTagSupport {

	@Override
    public void doTag() {
		/** MENU META 정보 조회 **/
		String meta_menu = (String) TagUtils.getRequest( super.getJspContext() )
													 .getAttribute( Constrants.META_NAME );
		TagUtils.writeHtml(  super.getJspContext() , this.getStringMeta(meta_menu) );
 	}



	private String getStringMeta( String content  ) {
		StringBuilder builder = new StringBuilder();

		String dq = "\"";

		builder.append("<meta " );
		builder.append("name=").append(dq).append( Constrants.META_NAME ).append(dq);
		builder.append(" content");

		if( StringUtils.isNotEmpty(content) ) {
			builder.append("=");
			builder.append(dq).append(content).append(dq);
		}
		builder.append(" />" );

		return builder.toString();
	}


}
