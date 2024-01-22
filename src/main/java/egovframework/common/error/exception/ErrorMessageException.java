package egovframework.common.error.exception;

import org.springframework.http.HttpStatus;
import lombok.Getter;

@Getter
public class ErrorMessageException extends RuntimeException {
	private static final long serialVersionUID = -1439411292728720657L;

	private String errorCode;
	private HttpStatus httpStatus;

	/** 다국어 메세지 파라미터 **/
	private Object[] args;

	public ErrorMessageException( String errorCode ) {
		this.errorCode = errorCode;
	}

	public ErrorMessageException( String errorCode, Object... args ) {
		this.errorCode = errorCode;
		this.args = args;
	}

	public ErrorMessageException( String errorCode ,HttpStatus httpStatus) {
		this.errorCode = errorCode;
		this.httpStatus = httpStatus;
	}

	public ErrorMessageException( String errorCode ,HttpStatus httpStatus ,Object... args) {
		this.errorCode = errorCode;
		this.httpStatus = httpStatus;
		this.args = args;
	}

}
