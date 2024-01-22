package egovframework.config.security.meta;

import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.util.CollectionUtils;

import egovframework.common.util.StreamUtils;
import egovframework.config.security.secured.SecuredService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ReloadableFilterInvocationSecurityMetadataSource  implements FilterInvocationSecurityMetadataSource  {

	private SecuredService securedService;

	private LinkedHashMap<RequestMatcher, List<ConfigAttribute>> requestMap;


	public ReloadableFilterInvocationSecurityMetadataSource( SecuredService securedService ) {
		this.securedService = Objects.requireNonNull( securedService , "SecuredObjectService is null" );
		this.requestMap = this.securedService.getRolesAndUrl();
	}


	@Override
    public Collection<ConfigAttribute> getAllConfigAttributes() {
        Set<ConfigAttribute> allAttributes = new HashSet<ConfigAttribute>();
        Set<RequestMatcher> keys = requestMap.keySet();

        if(  CollectionUtils.isEmpty( keys ) ) {
        	return allAttributes;
        }

        for ( RequestMatcher req_matcher : keys ) {
        	allAttributes.addAll( requestMap.get( req_matcher ) );
        }

        return allAttributes;
    }

	@Override
    public Collection<ConfigAttribute> getAttributes(Object object) {

		final HttpServletRequest request = ((FilterInvocation) object).getRequest();
        Set<RequestMatcher> keys = requestMap.keySet();

        Optional< RequestMatcher >
        	optional_key =  StreamUtils.toStream( keys )
							        				.filter(  matcher -> matcher.matches( request )  )
							        				.findFirst();
        return  optional_key.map( k -> this.requestMap.get( k ) )
        				.orElseGet( () -> null );
    }

	@Override
	public boolean supports(Class<?> clazz) {
		 return FilterInvocation.class.isAssignableFrom(clazz);
	}


	/** RUNTIME METASOURCE 의 갱신을 위해서는 SPRING BEANS 에세  reload 메서드를 호출해야한다. **/
	public void reload()  {
		synchronized ( this.requestMap ) {
			this.requestMap = this.securedService.getRolesAndUrl();
			log.debug("Secured Url Resources - Role Mappings reloaded at Runtime!");
		}

//		LinkedHashMap<RequestMatcher, List<ConfigAttribute>> reloadedMap = this.securedService.getRolesAndUrl();
//        Iterator<Entry<RequestMatcher, List<ConfigAttribute>>> iterator = reloadedMap.entrySet().iterator();
//
//        /** requestMap 삭제이후 재세팅 보다는 requestMap 교체가 안전하지 않을지? 원자화, 동기화 감안해야할듯하다.  **/
//        /** 이전 데이터 삭제 **/
//        this.requestMap.clear();
//
//        while (iterator.hasNext()) {
//        	Entry<RequestMatcher, List<ConfigAttribute>> entry = iterator.next();
//
//        	this.requestMap.put(entry.getKey(), entry.getValue());
//        }
//    	log.info("Secured Url Resources - Role Mappings reloaded at Runtime!");



    }

}
