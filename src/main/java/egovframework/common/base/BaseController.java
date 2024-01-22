package egovframework.common.base;

import java.util.Optional;
import java.util.function.Function;
import java.util.function.Supplier;

import org.apache.commons.lang3.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import egovframework.common.constrant.Constrants;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.error.exception.ValidException;
import egovframework.common.view.excel.model.ExcelResult;
import egovframework.common.view.excel.template.SheetTemplate;

/** 기본 컨트롤러 **/
public abstract class BaseController {

	@Autowired
	private LocalValidatorFactoryBean validator;

	/** hibernate validator group 처리를 위한 인터페이스 **/
	public interface ALL{}
	public interface POST extends ALL {}
	public interface GET extends ALL {}
	public interface DELETE extends ALL {}
	public interface PUT extends ALL {}
	public interface MULTI extends ALL {}

	/** MODEL 객체애 대한 BINDING RESULT 를 생성한다. **/
	private static final Function<Object, BindingResult> GET_MODEL_BINDING_RESULT
		= model -> Optional.ofNullable( model )
								.map( Object::getClass  )
								.map( Class::getSimpleName )
								.map( clazzName -> { return new BeanPropertyBindingResult( model, clazzName );   } )
								.orElseThrow( ValidException::new  );

	/**
	 * @Valid 를 사용할수없는 hibernate Validator 를 사용하기위해서
	 * @param model
	 */
	protected final void doValid( Object model ) {
		BindingResult bindingResult = GET_MODEL_BINDING_RESULT.apply( model );
		this.validator.validate(model, bindingResult );

		if( BooleanUtils.isTrue( bindingResult.hasErrors() ) ){
			throw new ValidException( bindingResult );
		}

	}

	/**
	 * @Validted 를 사용할수없는 hibernate Validator 를 사용하기위해서
	 * @param model
	 * @param targetGroup
	 */
	protected final void doValidted(  Object model, Class<?> targetGroup ) {
		BindingResult bindingResult = GET_MODEL_BINDING_RESULT.apply( model );
		this.validator.validate(model, bindingResult, targetGroup);

		if( BooleanUtils.isTrue( bindingResult.hasErrors() ) ){
			throw new ValidException( bindingResult );
		}
	}



	/**
	 * 파라미터 유효성 체크 오류를 발생시킨다.
	 */
	protected final void throwValidException(String objectName , String fieldName, String defaultMessage, Object input  ) {
		FieldError error = new FieldError(objectName, fieldName , defaultMessage );
		BindingResult bindingResult = new BeanPropertyBindingResult(input, "input");
		bindingResult.addError(error);

		throw new ValidException(bindingResult);
	}


	/** message exception 발생 **/
	protected final void throwMessageException( String msg_id ) {
		throw new ErrorMessageException( msg_id );
	}
	protected final void throwArgsMessageException( String msg_id, Object... args ) {
		throw new ErrorMessageException( msg_id, args );
	}


	/**
	 * 엑셀다운로드
	 * @param list
	 * @param model
	 * @return
	 */
	protected final String excelDown( String fileName, SheetTemplate sheetTemplate, Model model) {
		model.addAttribute( Constrants.EXCEL_ATTRIBUTE,  ExcelResult.of( fileName,  sheetTemplate ) );
		return Constrants.XLS_VIEW_NAME;
	}


	/** ERROR MESSAGE EXCEPTION SUPPILER **/
	protected final 	Supplier<ErrorMessageException> getErrorMessageSuppiler( String error_code ){
		return () -> new ErrorMessageException( error_code );
	}


}
