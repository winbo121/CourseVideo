package egovframework.common.tag;

import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.util.AntPathMatcher;

import egovframework.common.constrant.Constrants;
import egovframework.common.menu.attribute.MenuAttribute;
import egovframework.common.menu.attribute.TopMenu;
import egovframework.common.menu.model.Lv1Menu;
import egovframework.common.util.LocalThread;
import egovframework.common.util.StreamUtils;
import egovframework.config.provider.ApplicationContextProvider;
import lombok.Getter;
import lombok.Setter;

public class MenuTag extends SimpleTagSupport {

	@Getter @Setter
	private String var;

	/** 메뉴의 권한과 현재 사용자의 권한중에 매치 되는것이 있는지 확인한다. **/
	private static final Function<List<String>, Predicate<String>> IS_MATCH_ROLE = user_roles -> {
		return menu_role -> {
			if( CollectionUtils.isEmpty( user_roles ) ) {
				return false;
			}
			return user_roles.contains( menu_role );
		};
	};


	/** 현재 URI 와 메뉴가 매치 되는지 확인 **/
	private static final Function< String, Predicate<String> > IS_MATCH_URI = uri -> {
		final AntPathMatcher mather = new AntPathMatcher();
		return pattern -> {
			if( StringUtils.isEmpty( uri ) || StringUtils.isEmpty( pattern) ) {
				return false;
			}
			return mather.match( pattern, uri );
		};
	};
	
	

	@Override
    public void doTag() throws JspException {

		HttpServletRequest request = TagUtils.getRequest( super.getJspContext() );
		String uri = (String) request.getAttribute( Constrants.REQUEST_URI_NAME );

		MenuAttribute menu_attribute = ApplicationContextProvider.getSafeBean( MenuAttribute.class );
		List<TopMenu> top_menus = menu_attribute.getTop_menus();

		/** 현재 사용자 권한 **/
		List<String> user_roles = 	LocalThread.getRoles();
		
		
		/** 메뉴의 권한과 현재 사용자의 권한중에 매치 되는것이 있는지 확인한다. **/
		Predicate< String > is_match_role = IS_MATCH_ROLE.apply( user_roles );
		
		/** 현재 URI 와 메뉴가 매치 되는지 확인 **/
		Predicate< String > is_match_uri = IS_MATCH_URI.apply( uri );

		/** 화면에서 출력할 메뉴 정보  **/
		List<Lv1Menu> result = StreamUtils.toStream( top_menus )
												   .filter( top_menu -> StreamUtils.toStream( top_menu.getRoles() )
							 															 .anyMatch( is_match_role ) )
												   .map( top_menu -> {
													   		Lv1Menu lv1 = Lv1Menu.of( top_menu.getName() );
															StreamUtils.toStream( top_menu.getChildren() )
																		 .filter( child -> StreamUtils.toStream( child.getRoles() )
																				 						.anyMatch( is_match_role ) )
																		 .forEach( child -> {
																			 String lv2_name  = child.getName();
																			 boolean lv2_on = is_match_uri.test( child.getPattern() );
																			 String lv2_index_page = child.getIndex_page();
																			 boolean mobile = child.isMobile();
																			 boolean target = child.isTarget();
																			 String menu_role = top_menu.getRoles().get(0);
																			 lv1.addLv2(lv2_name, lv2_on, lv2_index_page, mobile, target, menu_role);
																		 });
														     return lv1; }
														)
												   .collect( Collectors.toList() );
		/** 현재 선택된 lv1 메뉴  **/
		Lv1Menu now_lv1 = StreamUtils.toStream( result )
											 .filter( lv1 -> lv1.getOn() )
											 .findFirst()
											 .orElseGet( () -> null );
		StringBuilder sb = new StringBuilder( this.var );
		sb.append("_now");


		request.setAttribute( this.var,  result );
		request.setAttribute( sb.toString(),  now_lv1 );

	}


}
