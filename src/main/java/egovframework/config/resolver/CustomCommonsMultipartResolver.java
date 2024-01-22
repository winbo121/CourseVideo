package egovframework.config.resolver;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;


public class CustomCommonsMultipartResolver extends CommonsMultipartResolver {


	@Override
	public boolean isMultipart(HttpServletRequest request) {
		if( request == null ) {
			return false;
		}
		 return FileUploadBase.isMultipartContent(new ServletRequestContext(request));
	}

}
