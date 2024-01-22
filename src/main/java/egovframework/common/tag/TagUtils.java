package egovframework.common.tag;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.PageContext;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;


@NoArgsConstructor( access = AccessLevel.PRIVATE )
public class TagUtils {

	public static void writeHtml( JspContext jspContext, String html ) {
		try {
			getPageContext(jspContext).getOut().write( html );
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public static PageContext getPageContext( JspContext jspContext ){
		return (PageContext) jspContext;
	}

	public static  HttpServletRequest getRequest( JspContext jspContext ) {
		return (HttpServletRequest) getPageContext( jspContext ).getRequest();
	}


}
