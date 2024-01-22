package egovframework.common.tag;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import com.google.common.collect.Maps;

import egovframework.common.component.file.FileComponent;
import egovframework.common.constrant.Constrants;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.util.LocalThread;
import egovframework.config.provider.ApplicationContextProvider;
import egovframework.work.main.service.NoneMenuService;
import lombok.Getter;
import lombok.Setter;

/**
 * SPRING PROFILE 이 맞는지 확인한다.
 * @author yoon
 *
 */
public class IsUrlTag extends SimpleTagSupport {

	@Getter @Setter
	private String var;
	
	@Getter @Setter
	private String role_type;

	/** 현재 URI 와 메뉴가 매치 되는지 확인 **/
	private static final Map<String, Object> IS_MATCH_URI(String uri, String role_type) {
		Map<String, Object> result = Maps.newHashMap();
		// 사용자 관리자 공통 페이지 배너
		String[] common = {
				"/myprofile/profileMain/index.do",
				"/myprofile/profileDelete/index.do",
				"/mystudy/myStudyHistory/index.do"	
		};
		for(String str : common) {
		    if(str.equals(uri)) {
		    	result.put("role_type", "COMMON");
		    	result.put("is_matched", true);
		    	return result;
		    	
		    }
		
		}
		
		// 사용자 전용 페이지 배너
		String[] user = {
			
		};
		for(String str : user) {
		    if(str.equals(uri)) {
		    	result.put("role_type", "USER");
		    	result.put("is_matched", true);
		    	return result;
		    	
		    }
		
		}
		
		// 관리자 전용 페이지 배너
		String[] admin = {
				"/conage/courseEnrollMain/index.do", 
				"/conage/contentEnrollMain/index.do", 
				"/statics/accessRecordMain/index.do", 
				"/statics/activeRecordMain/index.do",
				"/statics/searchRecordMain/index.do"
				};
		for(String str : admin) {
		    if(str.equals(uri)) {
		    	result.put("role_type", "ADMIN");
		    	result.put("is_matched", true);
		    	return result;
		    	
		    }
		
		}
		
    	result.put("role_type", "ANONYMOUS");
    	result.put("is_matched", false);
		return result;
		
	}
		
	

	@Override
    public void doTag() throws JspException {
		Map<String, Object> result = Maps.newHashMap();
		HttpServletRequest request = TagUtils.getRequest( super.getJspContext() );
		String uri = (String) request.getAttribute( Constrants.REQUEST_URI_NAME );
		
		FileComponent fileComp = ApplicationContextProvider.getSafeBean( FileComponent.class );
		NoneMenuService service = ApplicationContextProvider.getSafeBean( NoneMenuService.class );
		
		// 사용자 관리자여부 체크
		if(LocalThread.isLogin()) {
			request.setAttribute("userImg", fileComp.getFirstFile(FILE_REG_GB.TS_USER_INFO, LocalThread.getLoginId()));
		}
		if(LocalThread.isAdmin()) {
			request.setAttribute("userImg", fileComp.getFirstFile(FILE_REG_GB.TS_USER_INFO, LocalThread.getLoginId()));
			request.setAttribute("totalStatistic", service.getTotalStatistic());
		}
		
		
		result = IS_MATCH_URI(uri,role_type);
		request.setAttribute( this.var,  result.get("is_matched") );
		request.setAttribute( this.role_type, result.get("role_type").toString());

	}

}
