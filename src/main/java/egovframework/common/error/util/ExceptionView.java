package egovframework.common.error.util;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import egovframework.common.component.message.MessageComponent;
import egovframework.common.constrant.Constrants;
import egovframework.common.util.CommonUtils;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NonNull;


@Builder
@AllArgsConstructor( access = AccessLevel.PRIVATE )
public class ExceptionView {

	@NonNull
	private HttpServletRequest request;

	@NonNull
	private MessageComponent message_component;

	@NonNull
	private MappingJackson2JsonView json_view;

	@NonNull
	private String error_code;

	private HttpStatus http_status;

	private Object[] args;



	public static ExceptionViewBuilder builder( HttpServletRequest request
														, MessageComponent message_component
														, MappingJackson2JsonView json_view
														, String error_code ) {
		return new ExceptionViewBuilder()
							.request( request )
							.message_component(message_component)
							.json_view(json_view)
							.error_code( error_code );
	}





	public ModelAndView newModelAndView() {
		ModelAndView result = new ModelAndView();

		/** 요청온 status 세팅  **/
		if( ObjectUtils.isNotEmpty( this.http_status ) ) {
			result.setStatus( this.http_status );
		}


		/** ERROR MESSAGE  **/
		String error_message = "";

		if( ObjectUtils.isEmpty( this.args ) ) {
			error_message = this.message_component.getPropertyMessage( this.error_code );
		}else {
			error_message = this.message_component.getPropertyMessage( this.error_code, this.args );
		}

		/**  ERROR VIEW URL **/
		String error_view_url = this.message_component.getPropertyMessage( this.error_code+".redirect.url" );

		/** ERROR VIEW NAME  **/
		String error_view_name= this.message_component.getPropertyMessage( this.error_code+".view.name" );
		error_view_name = StringUtils.defaultIfEmpty(error_view_name,  Constrants.ERROR_PAGE_VIEW_NAME  );


		/** 에러 상세 내용 세팅  **/
		result.addObject("errorCode", this.error_code);
		result.addObject("errorMessage", error_message);
		result.addObject("errorViewUrl", error_view_url);

		if( !CommonUtils.isResponseJsp( this.request ) ) {
			result.setView( this.json_view );
		}else {
			if( StringUtils.isNotEmpty( error_view_url ) ) {
				/** REDIRECT 시킬 URL **/
				result.setViewName( "redirect:" + error_view_url );
			}else {
				/** 에러페이지로 이동 존재하지 않으면 공통 에러페이지 **/
				result.setViewName( error_view_name  );

			}
		}

		return result;
	}





}
