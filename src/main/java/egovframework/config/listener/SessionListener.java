package egovframework.config.listener;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;


@RequiredArgsConstructor
public class SessionListener implements HttpSessionListener {

	@NonNull
	private Integer maxInactiveInterval;

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		se.getSession().setMaxInactiveInterval( this.maxInactiveInterval );
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
	}

}
