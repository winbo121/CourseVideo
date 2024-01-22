package egovframework.config.security.functions;

import java.util.Optional;
import java.util.function.BiConsumer;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE )
public class SecurityFunctions {

	/** 로그아웃 핸들러 **/
	private static final SecurityContextLogoutHandler LOG_OUT_HANDLER = new SecurityContextLogoutHandler();

	/** 강제 로그아웃  **/
	public static final BiConsumer< HttpServletRequest, HttpServletResponse > FORCED_LOGOUT
	= ( request, response ) -> Optional.ofNullable( SecurityContextHolder.getContext() )
												.map( SecurityContext::getAuthentication )
												.ifPresent( authentication -> {
													/** 실제적으로 authentication 은 사용되지 않음. **/
													LOG_OUT_HANDLER.logout( request, response, authentication );
												});

}
