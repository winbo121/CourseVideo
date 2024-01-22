package egovframework.common.error.exception;

import lombok.Getter;

@Getter
public class RestException extends RuntimeException {
	private static final long serialVersionUID = -7854394803049161086L;

	private String url;

	public RestException( String url, Throwable cause ) {
		super( cause );
		this.url = url;
	}

}
