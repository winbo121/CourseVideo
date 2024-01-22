package egovframework.common.error;

import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import egovframework.common.component.message.MessageComponent;
import egovframework.common.constrant.Constrants;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.error.exception.RestException;
import egovframework.common.error.exception.ValidException;
import egovframework.common.error.util.ExceptionView;
import egovframework.common.util.CommonUtils;
import egovframework.common.util.StreamUtils;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@ControllerAdvice
public class BootControllerAdvice //extends ResponseEntityExceptionHandler
{

	@Autowired
	private MessageComponent messageComponent;

	/** JSON VIEW **/
	@Autowired
	private MappingJackson2JsonView jsonView;



	/** Exception Handler  **/
	@ExceptionHandler(Exception.class)
	@ResponseStatus( HttpStatus.INTERNAL_SERVER_ERROR )
	public ModelAndView handleException( final HttpServletRequest request
										,final Exception exception ) {
		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = "exception";
		log.error("{}",exception);

		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.build()
									.newModelAndView();
	}

	/** NoHandlerFoundException Handler **/
	@ExceptionHandler( NoHandlerFoundException.class )
	@ResponseStatus( HttpStatus.NOT_FOUND )
	public ModelAndView handleNoHandlerFoundException( final HttpServletRequest request
																		,final NoHandlerFoundException noHandlerFoundException ) {
		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = "noHandlerFoundException";
		log.error("{}",noHandlerFoundException);
		String uri = request.getRequestURI();

		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.args( new String[]{ uri } )
									.build()
									.newModelAndView();
	}


	/** AuthenticationCredentialsNotFoundException Handler **/
	@ExceptionHandler( AuthenticationCredentialsNotFoundException.class )
	@ResponseStatus( HttpStatus.UNAUTHORIZED )
	public ModelAndView handleAuthenticationCredentialsNotFoundException( final HttpServletRequest request
			,final AuthenticationCredentialsNotFoundException authenticationCredentialsNotFoundException ) {

		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = "authenticationCredentialsNotFoundException";
		log.error("{}",authenticationCredentialsNotFoundException);

		/**
		 * Spring Security 에서 사용되는 예외를 사용했음.
		 * Spring Security 에서는 filter 내부에서 처리되나, LocalThread 같은 내부 에서 인증객체 사용시에 예외 처리
		 */
		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.build()
									.newModelAndView();
	}



	/** 최대 파일 사이즈 **/
	@Value(value="${spring.servlet.multipart.max-file-size}")
	private String max_file_size;
	/** 최대 요청 사이즈 **/
	@Value(value="${spring.servlet.multipart.max-request-size}")
	private String max_request_size;

	/** MaxUploadSizeExceededException Handler  **/
	@ExceptionHandler( MaxUploadSizeExceededException.class )
	@ResponseStatus( HttpStatus.INTERNAL_SERVER_ERROR )
	public ModelAndView handleMaxUploadSizeExceededException( final HttpServletRequest request
																				,final MaxUploadSizeExceededException multipartException  ){
		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = "maxUploadSizeExceededException";
		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.args( new String[]{ this.max_file_size, this.max_request_size } )
									.build()
									.newModelAndView();
	}


	/** RestException Handler **/
	@ExceptionHandler( RestException.class )
	@ResponseStatus( HttpStatus.INTERNAL_SERVER_ERROR )
	public ModelAndView handleRestException( final HttpServletRequest request
											,final RestException restException  ){
		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = "restException";
		String url = restException.getUrl();
		log.error("{}",restException);

		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.args( new String[]{ url } )
									.build()
									.newModelAndView();
	}


	/** ErrorMessageException Handler **/
	@ExceptionHandler( ErrorMessageException.class )
	//@ResponseStatus( HttpStatus.INTERNAL_SERVER_ERROR )
	@ResponseStatus( HttpStatus.OK )
	public ModelAndView handleErrorMessageException( final HttpServletRequest request
													 ,final ErrorMessageException errorMessageException  ){
		/** Exception 종류에 따라서 세팅한다.  **/
		String error_code = errorMessageException.getErrorCode();
		HttpStatus http_status = errorMessageException.getHttpStatus();

		/** 다국어 메세지 파라미터 **/
		Object[] args = (Object[]) errorMessageException.getArgs();
		log.error("{}",errorMessageException);

		return	ExceptionView.builder(request, this.messageComponent, this.jsonView,  error_code)
									.http_status( http_status )
									.args( args )
									.build()
									.newModelAndView();
	}


	/** 에러 메세지 FUNCTION **/
	private final Function<List<FieldError>, String> validExceptionFunction = fieldErrors -> {
		return StreamUtils.toStream( fieldErrors )
							.map( fe -> {
									StringBuilder sb = new StringBuilder();
									sb.append("(").append(fe.getField()).append("=").append(fe.getDefaultMessage()).append(")");
									return sb.toString(); } )
							.collect( Collectors.joining() );
	};

	/** ValidException Handler **/
	@ExceptionHandler( ValidException.class )
	//@ResponseStatus( HttpStatus.BAD_REQUEST )
	@ResponseStatus( HttpStatus.OK )
	public ModelAndView handleValidException(final HttpServletRequest request
														  ,final ValidException ex  ){
		String error_code = "validException";
		log.error("{}",ex);

		String error_message = Optional.ofNullable( ex )
												.map( ValidException::getBindingResult )
												.map( BindingResult::getFieldErrors )
												.map( this.validExceptionFunction )
												.orElse( "JSR-303 VALIDATOR NOT SUPPORT NULL INSTANCE" );

		ModelAndView modelAndView = new ModelAndView();
		if( CommonUtils.isResponseJsp(request) ) {
			modelAndView.setViewName( Constrants.ERROR_PAGE_VIEW_NAME );
		}else {
			modelAndView.setView( this.jsonView );
		}

		modelAndView.addObject("errorCode", error_code );
		modelAndView.addObject("errorMessage", error_message);
		modelAndView.addObject("errorViewUrl", null );

		return modelAndView;
	}


}
