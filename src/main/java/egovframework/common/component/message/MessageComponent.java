package egovframework.common.component.message;

import java.util.Locale;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;

@Component
public class MessageComponent {

	@Autowired
	private MessageSource messageSource;


	public String getPropertyMessage(String msg_id ) {
		return Optional.ofNullable( this.getPropertyMessage(msg_id, null, null) )
						    .orElse(null);
	}


	public String getPropertyMessage(String msg_id, Object[] args  ) {
		return Optional.ofNullable( this.getPropertyMessage(msg_id, null, args) )
							.orElse(null);
	}


	/**
	 * 다국어 메세지를 property 에서 조회한다.
	 * @param msg_id
	 * @param default_msg
	 * @param args
	 * @return
	 */
	public String getPropertyMessage( String msg_id, String default_msg, Object[] args  ) {
		Locale locale = new Locale("ko");
		return messageSource.getMessage(msg_id, args, default_msg, locale);
	}




}
