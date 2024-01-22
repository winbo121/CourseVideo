<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script type="text/javascript">
<%-- DOCUMENT 상에서 AJAX 전송 전에 HEADER 에 AJAX 라는 구분값을 세팅한다. (AJAX 통신시 SPRING SECURITY 권한 체크를 위함)  --%>
$(document).ajaxSend(function( event, jqxhr, settings ) {
	jqxhr.setRequestHeader('X-Ajax-Yn', 'Y' );
	<%-- CSRF 설정 --%>
	var _csrf_header = $("meta[name='_csrf_header']").attr("content");
	var _csrf = $("meta[name='_csrf']").attr("content");
	 if( !$.isEmptyObject( _csrf ) ){
		 jqxhr.setRequestHeader( _csrf_header, _csrf );
	 }
});

<%-- DOCUMENT 상에서  AJAX 전송후 실패 처리  --%>
$(document).ajaxError( function ( event, jqxhr, settings, thrownError ) {
	var movePage = new MovePage();
	movePage._method = "GET";

	<%-- HTTP STATUS --%>
	var status = jqxhr.status;
	if( status == 401 ){ <%-- SPRING SECURITY 로그인 하지 않은 사용자가 권한 필요한 URI 요청한 경우 --%>
		movePage._action = "/login_page.do";
		movePage.move();
		return;
	}else if( status == 403 ){ <%-- SPRING SECURITY 로그인 하였으나 권한이 없는 URI 요청한 경우 --%>
		movePage._action = "/access_denied.do";
		movePage.move();
		return;
	}
	<%-- 응답 객체 --%>
	var result = null;
	try{
		result = $.parseJSON(  jqxhr.responseText );
		<%-- 에러 함수 처리 실행  --%>
		errorFunction( result );
	}catch( exception ) {
		alert(xhr.responseText);
		alert(  '[VIEW]서비스에서 정의되지 않은 오류 발생 ' , null ,null  );
		
		<%-- 로딩 처리가 되어 있는 화면을 위한 로딩 해제 처리 --%>
		loading_hidden();
		resetIsRun();
		return ;
	}
	
});

<%-- 에러처리 함수  errorResponse JSON 형태의 에러 객체 --%>
function errorFunction( errorResponse ){
	if( $.isEmptyObject( errorResponse ) ){
		var basicAlert = new BasicAlert();
		basicAlert._type = "error";
		basicAlert._html = "알수없는 내부 서버 오류";
		basicAlert.fire();
		return;
	}
	<%-- 내부오류에 대한 에러코드, 메세지. 이동 URL --%>
	var errorCode		= errorResponse.errorCode;
	var errorMessage	= errorResponse.errorMessage;
	var errorViewUrl		= errorResponse.errorViewUrl;

	if( ! $.isEmptyObject( errorMessage )  ){
		var confirm_func = function(){
			if( ! $.isEmptyObject( errorViewUrl )  ){
				<%-- 페이지이동 --%>
				var movePage = new MovePage();
					movePage._method = "GET";
					movePage._action = errorViewUrl;
					movePage.move();
			}
		};

		var basicAlert = new BasicAlert();
			basicAlert._type = "error";
			basicAlert._html = errorMessage;
			basicAlert._confirm_func = confirm_func;
			basicAlert.fire();
	}
	
	<%-- 로딩 처리가 되어 있는 화면을 위한 로딩 해제 처리 --%>
	loading_hidden();
	resetIsRun();
}



<%-- 페이지 이동 --%>
function MovePage(){
	var _action;
	var _method;
	var _formData;
	var _target;


	MovePage.prototype.move = function(){
		var action = this._action;
		var method = this._method;
		var formData = this._formData;
		var target  = this._target;

		if( $.isEmptyObject( action ) ){
			alert('movePage 이동할 URL 이 존재하지 않습니다.');
			return;
		}
		<%-- formData 존재유무 확인  --%>
		if( !(formData instanceof FormData) ){
			formData = new FormData();
		}

		if( method != "GET" ){
			<%-- CSRF 설정 --%>
			var csrfParameter = $("meta[name='_csrf_parameter']").attr("content");
	        var csrfToken = $("meta[name='_csrf']").attr("content");
	        if( !$.isEmptyObject( csrfToken ) ){
	        	formData.append( csrfParameter ,csrfToken );
	        }
		}


		var contextPath = '${pageContext.request.contextPath}';
		var url = contextPath + action;


		var params = null;
		if( url.indexOf('?') > 0 ){
			<%-- action 에 존재하는 query param  --%>
			var params = url.substring( url.indexOf( '?' )+1, url.length );
				 params = params.split( "&" );
		}

		<%-- FORM DATA 에 QUERY PARAMETER 세팅 --%>
		if(  !$.isEmptyObject( params ) ){
			$.each( params, function( index, param ){
				try{
					paramData = param.split('=');
					var name  = paramData[0];
					var value = paramData[1];
					formData.append(name, value );
				}catch( exception ) {}
			});
		}

		var $form = $('<form></form>');
		$form.attr('action', url);
		$form.attr('method', method);

		if( !$.isEmptyObject( target ) ){
			$form.attr('target', target );
		}


		<%-- IE 때문에 구현함  --%>
		var es, e, pair;
	    for (es = formData.entries(); !(e = es.next()).done && (pair = e.value);) {
	        var name = pair[0];
	        var value = pair[1];

			var field = $('<input></input>');
			field.attr("type", "hidden");
			field.attr("name", name);
			field.attr("value", value);

			$form.append( field );
	    }

		$form.appendTo('body');
		$form.submit();
	};

}

<%-- AJAX FORM --%>
function AjaxForm(){
	var _method;
	var _action;
	var _form_data;
	var _succ_func;

	AjaxForm.prototype.send = function(){
		var method = this._method;
		var url = '${pageContext.request.contextPath}' + this._action;

		var form_data = this._form_data;
		if( !(form_data instanceof FormData)  ){
			form_data = new FormData();
		}
		var succ_func = this._succ_func;

		$.ajax({
			type: method,
			url:  url ,
			data: form_data,
	        cache: false,
	        processData: false,
			contentType: false
			})
			.done(function(resData, status) { 
				<%-- 응답값이 존재하는 경우 --%>
				if( ! $.isEmptyObject( resData ) ) {
					
					<%-- JSON PARSE가 안되는 응답값에 대한 예외 처리 --%>
					try{
						var result = $.parseJSON( resData );
					} catch(e) {
						var result = resData;
					}
					
					if( ! $.isEmptyObject( result.errorMessage ) ) {
						<%-- 에러 함수 처리 실행 --%>
						errorFunction( result );
						return;
					}
				}
				
				if( $.isFunction( succ_func ) ){
					succ_func( resData, status );
				}
				
				 
			
		});

	};
}

<%-- AJAX JSON --%>
function AjaxJson(){
	var _method;
	var _action;
	var _json;
	var _succ_func;

	AjaxJson.prototype.send = function(){
		var method = this._method;
		var url = '${pageContext.request.contextPath}' + this._action;

		var json = this._json;
		var succ_func = this._succ_func;

		$.ajax({
			type: method ,
			url:  url ,
			data: json,
			dataType:'json',
			timeout:( 1000 * 30 * 5 ),
			success: function( resData, status ){
				if( $.isFunction( succ_func ) ){
					succ_func( resData, status );
				}
			}
		});

	};
}

<%-- FILE DOWNLOAD --%>
function FileDownloadOnce(){
	var _file_seq;
	var _succ_func;
	var _fail_func;

	FileDownloadOnce.prototype.download = function(){
		var file_seq = this._file_seq;
		var succ_func = this._succ_func;
		var fail_func = this._fail_func;

		if( ! $.isNumeric( file_seq ) ){
			alert('파일다운로드 필수값 file_seq 가 유효하지 않습니다.');
			return;
		}
		var url = '${pageContext.request.contextPath}' + '/file/download.do';
		var params = {   'X-Ajax-Yn': 'Y' ,'file_seq' : file_seq };

		<%-- CSRF 설정 --%>
		var csrfParameter = $("meta[name='_csrf_parameter']").attr("content");
	    var csrfToken = $("meta[name='_csrf']").attr("content");
	    if( !$.isEmptyObject( csrfToken ) ){
	    	params[csrfParameter] = csrfToken;
	    }

		$.fileDownload(url,{
			 httpMethod : "POST"
			,data: params
			,successCallback: function (url) {
				if(  $.isFunction( succ_func ) ){
					<%-- 성공함수가 존재할시 함수 실행 --%>
					succ_func();
				}
			}
			,failCallback: function (responseHtml, url) {
				if( $.isFunction( fail_func ) ){
					<%-- 실패함수가 존재할시 함수 실행후 종료 --%>
					fail_func();
					return;
				}

				try{
					var result = $.parseJSON(  responseHtml  );
					console.log("####### FILEDOWNLOAD FAIL... #######");
					console.log(result);
				}catch( exception ) {
					alert( '서비스에서 정의되지 않은 오류 발생 ' );
				}
			}
		 });

	};
}

<%-- BASIC CONFIRM (SWEET ALERT) --%>
function BasicConfirm(){
	<%-- CONFIRM TYPE --%>
	this._type;
	<%-- CONFIRM TITLE --%>
	this._title;
	<%-- CONFIRM HTML --%>
	this._html;

	<%-- 확인버튼 TEXT --%>
	this._confirm_text;
	<%-- 확인이후 후처리 함수 --%>
	this._confirm_func;

	<%-- 취소버튼 TEXT --%>
	this._cancel_text;
	<%-- 취소이후 후처리 함수 --%>
	this._cancel_func;

	<%-- ALERT CLOSE 이후 FOCUS TARGET --%>
	this._target_element;

	BasicConfirm.prototype.fire = function(){
		var type = 			( !$.isEmptyObject( this._type ) ) ? this._type : "";
		var title =  			( !$.isEmptyObject( this._title ) ) ? this._title : "";
		var html = 			( !$.isEmptyObject( this._html ) ) ? this._html : "";

		var confirm_text =  ( !$.isEmptyObject( this._confirm_text ) ) ? this._confirm_text : "확인";
		var confirm_func = ( $.isFunction( this._confirm_func ) ) ? this._confirm_func : function(){};

		var cancel_text =  	( !$.isEmptyObject( this._cancel_text ) ) ? this._cancel_text : "취소";
		var cancel_func = ( $.isFunction( this._cancel_func ) ) ? this._cancel_func : function(){};

		var target_element = this._target_element;

		swal.fire({
			type: type,
		    title: title,
		    html: html,
		    allowOutsideClick: false,
		    confirmButtonText: confirm_text,
		    cancelButtonText: cancel_text,
		    showCancelButton: true,
		  	onAfterClose: function() {
		  		if( !$.isEmptyObject( target_element ) ){
		 			try{
		 				$( target_element ).focus();
					}catch(excep){
					}
		  		}
		  	}
		}).then( function ( result ) {
			if( result.value == true  ){
				if( $.isFunction( confirm_func )  ){
					<%-- 확인이후 후처리 함수 실행 --%>
					confirm_func();
				}
			}else{
				if( $.isFunction( cancel_func )  ){
					<%-- 취소이후 후처리 함수 실행 --%>
					cancel_func();
				}
			}
		});


	};
}

<%-- BASIC ALERT (SWEET ALERT) --%>
function BasicAlert(){
	<%-- ALERT TYPE --%>
	this._type;
	<%-- ALERT TITLE --%>
	this._title;
	<%-- ALERT HTML --%>
	this._html;
	<%-- 확인버튼 TEXT --%>
	this._confirm_text;
	<%-- 확인이후 후처리 함수 --%>
	this._confirm_func;
	<%-- ALERT CLOSE 이후 FOCUS TARGET --%>
	this._target_element;

	BasicAlert.prototype.fire = function(){
		<%-- TYPE: success warning error info --%>
		var type = 			( !$.isEmptyObject( this._type ) ) ? this._type : "";
		var title =  			( !$.isEmptyObject( this._title ) ) ? this._title : "";
		var html = 			( !$.isEmptyObject( this._html ) ) ? this._html : "";
		var confirm_text =  ( !$.isEmptyObject( this._confirm_text ) ) ? this._confirm_text : "확인";
		var confirm_func = ( $.isFunction( this._confirm_func ) ) ? this._confirm_func : function(){};
		var target_element = this._target_element;

		swal.fire({
			type: type,
		    title: title,
		    html: html,
		    allowOutsideClick: false,
		  	onOpen: function(){
		  		Swal.getConfirmButton().focus();
		  	},
		  	onAfterClose: function() {
		  		if( !$.isEmptyObject( target_element ) ){
		 			try{
		 				$( target_element ).focus();
					}catch(excep){
					}
		  		}
		  	},
		    confirmButtonText: confirm_text

		}).then( function ( result ) {
			if( result.value == true  ){
				<%-- 확인이후 후처리 함수 실행 --%>
				confirm_func();
			}
		});
	};
}


<%-- BASIC MODAL --%>
function BasicModal(){
	<%-- MODAL ID --%>
	this._modal_id;
	<%-- HTTP ACTION --%>
	this._action;
	<%-- 요청값을 JSON 으로 보낼지 여부 --%>
	this._is_request_json = false;
	<%-- 전송할때 요청할 FORM 데이터 --%>
	this._form_data;
	<%-- 전송할때 요청할 JSON 데이터 --%>
	this._json_data;
	<%-- OPEN 성공시 함수 --%>
	this._open_succ_func;


	BasicModal.prototype.close = function(){
		 $( "#"+ this._modal_id ).modal( "hide" );
		 $( "#"+ this._modal_id ).html( "" );
	};

	BasicModal.prototype.open = function(){
		var modal_id = this._modal_id;
		var action = this._action;
		var is_request_json =  this._is_request_json;
		if( $.isEmptyObject( modal_id )  ){
			alert("모달아이디가 존재하지 않습니다."); return;
		}
		if( $.isEmptyObject( action )  ){
			alert("모달ACTION 이 존재하지 않습니다."); return;
		}
		if( is_request_json != true && is_request_json != false ){
			alert("요청값 JSON 여부가 존재하지 않습니다."); return;
		}

		var form_data = ( this._form_data instanceof FormData  ) ? this._form_data : new FormData() ;
		var json_data  = ( !$.isEmptyObject( this._json_data ) ) ? this._json_data : {} ;
		var open_succ_func = ( $.isFunction( this._open_succ_func ) ) ? this._open_succ_func : function(){};

		<%-- MODAL OPEN 함수 --%>
		var open_func = function( resData, status ){
			$( "#"+ modal_id ).html( resData );

			<%-- MODAL 객체  bootstrap.js 참조 --%>
			var _modal_object = $( "#"+ modal_id ).modal(
					{    backdrop: 'static'
						,keyboard: false
						,focus: false
					}
			);

			<%-- 포커스를 줄 ELEMENT  --%>
			var _focus_element = null;

			<%-- MODAL 에 존재하는 input elements --%>
			 var _modal_input_elements = $(_modal_object ).find( "input:text, select, input:checkbox, input:radio, textarea" )
			 														  .not(".flatpickr-with-time, .flatpickr-with-week, .flatpickr-without-time, .flatpickr-custom-time");

			 if( _modal_input_elements.length > 0 ){
				<%--  MODAL 첫번째 객체 --%>
				_focus_element = _modal_input_elements[0];
			 }else{
				 <%-- hidden 을 제외한 모든 input elements --%>
				 var _modal_show_elements = $(_modal_object ).find( ":input:not([type=hidden])" );
				 if( _modal_show_elements.length > 0 ){
					 <%-- 마지막 객체에 포커스  --%>
					 _focus_element =  $( _modal_show_elements ).last();
				 }
			 }

			 /** https://blog.naver.com/romeoyo/120188644234 **/

			 <%--  460 MS 이후에 포커스 주입 --%>
			 if( _focus_element != null ){
		 		 setTimeout(
		 			function() {
		 				$( _focus_element ).focus();
		 			}
		 			,460
			     );
			 }

			 if( $.isFunction( open_succ_func ) ){
		 		 setTimeout(
		 			function() {
		 				open_succ_func( resData, status );
		 			}
		 			,460
			     );
			 }
		};



		if( is_request_json == true ){
			<%-- 요청값을 JSON 으로 보낼경우 JSON 을 FORM DATA 로 변환   --%>
			appendFormdata( form_data , json_data );
		}
		form_data.append( "modal_id" , modal_id );

		<%-- AJAX FORM 으로 전송 --%>
		var ajaxForm = new AjaxForm();
		ajaxForm._method = "POST";
		ajaxForm._action = action;
		ajaxForm._form_data = form_data;
		ajaxForm._succ_func = open_func;
		ajaxForm.send();
	};

}


<%-- JSON 객체를 FORMDATA 로 변환한다. --%>
function jsonToFormData( json ){
	var fom_data = new FormData();

	appendFormdata( fom_data, json );

	return fom_data;
}

<%-- JSON 객체를 FORMDATA 로 변환한다. --%>
function appendFormdata(FormData, data, name){
    name = name || '';
    if (typeof data === 'object'){
        $.each(data, function(index, value){
            if (name == ''){
                appendFormdata(FormData, value, index);
            } else {
                appendFormdata(FormData, value, name + '['+index+']');
            }
        })
    } else {
        FormData.append(name, data);
    }
}

<%-- 기본형 DATA TABLE  --%>
function BasicDataTable(){
	<%-- TABLE ID --%>
	this._table_id = "";
	<%-- 페이징 사용여부 --%>
	var _paging = true;
	<%-- 소팅 사용여부 --%>
	var _ordering = true;

	<%-- 1페이지 당 ROW   --%>
	var _page_length = 10;
	<%-- PAGE LIMIT   --%>
	var _length_menu = [];
	<%-- 초기 ORDER 기준 --%>
	var _order = [];
	<%-- 데이터 테이블 컬럼 정보 --%>
	var _columns = [];
	<%-- 데이터 테이블 컬럼 정의--%>
	var _column_defs = [];

	<%-- 전체 카운트 VIEW 여부  --%>
	this._view_total_cnt = true;

	<%-- AJAX 요청 METHOD --%>
	var _ajax_method = "";
	<%-- AJAX 요청 ACTION --%>
	var _ajax_action = "";
	<%-- AJAX 요청 입력값 RETURN JSON --%>
	var _ajax_data = function(){};

	<%-- 더블 클릭 함수  --%>
	this._dbclick_func = function(){};
	<%-- 초기화 완료 함수  --%>
	this._init_complete_func = function( data_table ){};

	<%-- 데이터 테이블 DRAW 이후 함수 --%>
	this._draw_complete_func = function(){};

	<%-- 유효성체크 함수  --%>
	this._valid_func = null;

	<%-- 드래그 앤드랍 사용 여부 --%>
	this._is_dnd = false;
	<%-- 드래그 앤드랍 옵션들 --%>
	this._dnd_options = null;

	<%-- 초기화시 데이터 테이블 DRAW 여부 --%>
	this._is_init_table_draw = true;

	<%-- TBODY TR SELECTED 사용 여부  --%>
	this._is_tbody_tr_seleted = false;

	<%-- 생성된 DATA TABLE 객체  --%>
	this._data_table = null;

	<%-- 페이지 최초 로딩시 보여지는 row --%>
	this._display_start = 0;

	<%-- 현재 DATA TABLE 의 PAGE NAVI DATA 를 조회한다. [정렬정보, 1페이지당 ROW, 현재 페이지번호] --%>
	BasicDataTable.prototype.getPageNaviData = function(){
		var paged_navi_data = new Object();
			paged_navi_data.order = this._data_table.order();
			paged_navi_data.pageLength = this._data_table.page.len();
			paged_navi_data.start = this._data_table.page.info().start;
		return JSON.stringify( paged_navi_data );
	};

	<%-- 초기 PAGE NAVI DATA 를 세팅한다. --%>
	BasicDataTable.prototype.initPageNaviData = function( paged_navi_data ){
		try{
			var navi_data = JSON.parse( paged_navi_data );
			var order = navi_data.order;
			var pageLength = navi_data.pageLength;
			var start = navi_data.start;

			if( !$.isArray( order ) ) { return false; }
			if( !$.isNumeric( pageLength ) ){ return false; }
			if( !$.isNumeric( start ) ){ return false; }

			this._order = order;
			this._page_length = pageLength;
			this._display_start = start;

			return true;
		}catch( exception ){
			return false;
		}
	};

	<%-- DATA TABLE 데이터 리스트 조회  --%>
	BasicDataTable.prototype.getDataList = function(){
		var result = new Array();
		var _tbody_trs = this.getTbody().find("tr");

		if( _tbody_trs.length == 0 ){
			return result;
		}
		$.each( _tbody_trs, function( index, _tbody_tr ) {
			result.push( $(_tbody_tr).data() );
		});
		return result;
	};

	<%-- AJAX DATA 조회 --%>
	BasicDataTable.prototype.getAjaxData = function(){
		return this._data_table.context[0].oAjaxData;
	};

	<%-- DATA TABLE RELOAD --%>
	BasicDataTable.prototype.reload = function( callback_func, resetPaging ){
		if( !$.isFunction( callback_func ) ){
			callback_func = null;
		}
		if( resetPaging != true && resetPaging != false  ){
			resetPaging = true;
		}
		this._data_table.ajax.reload( callback_func, resetPaging );
	};

	<%-- DATA TABLE CHECKED  ROW 모든 정보 조회 --%>
	BasicDataTable.prototype.getCheckedAll = function( td_index ){
		if( !$.isNumeric( td_index ) ){
			alert("tb_index 필수"); return;
		}
		var result = new Array();

		<%-- TD INDEX 에 대한 CHECKED 된 TR DATA --%>
		var tbody_trs = this._data_table.$('tbody tr');
		var tbody_tds = tbody_trs.find( "td:eq("+td_index+")" );
		var target_trs = tbody_tds.find( "input:checked" ).parents("tr");

		if( target_trs.length == 0 ){
			return result;
		}

		$.each( target_trs, function( index, target_tr ) {
			var checked_data = $(target_tr).data();
			checked_data.sortableItem = null;
			result.push( checked_data );
		});
		return result;
	};

	<%-- DATA TABLE CHECK BOX CHECK 처리 --%>
	BasicDataTable.prototype.doCheck = function( td_index , checked_value ){
		if( !$.isNumeric( td_index ) ){
			alert("tb_index 필수"); return;
		}
		var tbody_trs = this._data_table.$('tbody tr');
		var tbody_tds = tbody_trs.find( "td:eq("+td_index+")" );
		var checkbox_collection = tbody_tds.find("input:checkbox");

		$.each( checkbox_collection, function( index, checkbox ) {
			var value = $(checkbox).val();
			if( value == checked_value ){
				 $(checkbox).prop('checked', true).change();
			}
		});

	};

	<%-- DATA TABLE CHECK BOX UN CHECK 처리 --%>
	BasicDataTable.prototype.doUnCheckAll = function( td_index  ){
		if( !$.isNumeric( td_index ) ){
			alert("tb_index 필수"); return;
		}
		var tbody_trs = this._data_table.$('tbody tr');
		var tbody_tds = tbody_trs.find( "td:eq("+td_index+")" );
		var checkbox_collection = tbody_tds.find("input:checkbox");
		$(checkbox_collection).prop('checked', false).change();
	};

	<%-- DATA TABLE UN CHECKED  ROW 정보 조회 --%>
	BasicDataTable.prototype.getUnChecked = function( td_index ){
		if( !$.isNumeric( td_index ) ){
			alert("tb_index 필수"); return;
		}
		<%-- TD INDEX 에 대한 CHECKED  --%>
		var tbody_trs = this._data_table.$('tbody tr');
		var tbody_tds = tbody_trs.find( "td:eq("+td_index+")" );

		<%-- 체크되지 체크 박스 조회 --%>
		var unchecked_collection = tbody_tds.find(" input:not(:checked)");

		var result = new Array();
		if( unchecked_collection.length == 0 ){
			return result;
		}
		$.each( unchecked_collection, function( index, element ) {
			var data = $(element).val();
 			result.push( data );
		});
		return result;
	};


	<%-- DATA TABLE CHECKED  ROW 정보 조회 --%>
	BasicDataTable.prototype.getChecked = function( td_index ){
		if( !$.isNumeric( td_index ) ){
			alert("tb_index 필수"); return;
		}
		<%-- TD INDEX 에 대한 CHECKED  --%>
		var tbody_trs = this._data_table.$('tbody tr');
		var tbody_tds = tbody_trs.find( "td:eq("+td_index+")" );
		<%-- 체크된 체크 박스 조회 --%>
		var checked_collection = tbody_tds.find(" input:checked");

		var result = new Array();
		if( checked_collection.length == 0 ){
			return result;
		}

		$.each( checked_collection, function( index, element ) {
			var data = $(element).val();
 			result.push( data );
		});

		return result;
	};

	<%-- DATA TABLE 선택된 ROW 정보 조회 --%>
	BasicDataTable.prototype.getSelected = function(){
		var selected_datas = this._data_table.rows(  [ ".selected" ]  ).data();
		if( selected_datas.length == 0 ){
			return;
		}
		if( selected_datas.length != 1 ){
			doErrorAlert( "테이블 항목은 하나만 선택할수 있습니다.", null, null );
			return;
		}
		var data = selected_datas[0];
		return data;
	};

	<%-- DATA TABLE INDEX 에대한 컬럼을 조회한다. --%>
	BasicDataTable.prototype.getColumn = function( column_index ){
		return this._data_table.column( column_index );
	};
	BasicDataTable.prototype.doShowColumn = function ( column_index ){
		var column = this.getColumn( column_index );
		column.visible( true );
	};
	BasicDataTable.prototype.doHideColumn = function( column_index ){
		var column = this.getColumn( column_index );
		column.visible( false );
	};

	<%-- DATA TABLE 을 파괴하지 않고 CLEAR 만 처리한다.  --%>
	BasicDataTable.prototype.clear = function(){
		var _table_tbody = $('#'+ this._table_id ).find( "tbody" );
		var _paginate =   $('#'+ this._table_id  + "_paginate" );
		_table_tbody.empty();
		_paginate.empty();
	};

	<%-- TABLE 의 TBODY 조회 --%>
	BasicDataTable.prototype.getTbody = function(){
		var _table = $('#'+ this._table_id );
		var _table_tbody =  $( _table  ).children("tbody");
		return _table_tbody;
	};

	<%-- TBODY 의 클릭 이벤트 세팅 --%>
	BasicDataTable.prototype.bindTbodyClick = function(){
		var _table_tbody = this.getTbody();

		<%-- 기존의 TBODY 클릭 이벤트 제거 --%>
		$( _table_tbody ).off('click' ,'tr' );

		<%-- TBODY TR 클릭시 이벤트 추가 --%>
		$( _table_tbody ).on('click', 'tr',  function () {
			var _selected_rows = _table_tbody.find( "tr.selected" );
			if ( $(this).hasClass('selected') ) {
				$(this).removeClass('selected');
			}else{
				$( _selected_rows ).removeClass("selected");
				$(this).toggleClass('selected');
			}
		});
	};

	<%-- TBODY 의 더블클릭 이벤트 세팅 --%>
	BasicDataTable.prototype.bindTbodyDoubleClick= function( dbclick_func ){
		if(  !$.isFunction( dbclick_func ) ){
			return ;
		}
		var _table_tbody = this.getTbody();
		var _data_table  = this._data_table;

		<%-- 기존의 TBODY 더블 클릭 이벤트 제거 --%>
		$( _table_tbody ).off('dblclick', 'tr');

		<%-- TBODY TR 더블 클릭시 이벤트 추가 --%>
		$( _table_tbody ).on('dblclick', 'tr', function () {
			var row_data = _data_table.row( this ).data();
			dbclick_func( row_data, this );
		});
	};

	<%-- DATA TABLE 초기화 --%>
	BasicDataTable.prototype.init= function(){
		var data_table = null;
		var _table = $('#'+ this._table_id );
		if(  $.isEmptyObject( _table ) ||  _table.length == 0  ){
			alert("테이블 객체가 존재하지 않습니다. ID="+ this._table_id );
			return;
		}
		if(  _table.length != 1  ){
			alert("DOM 상에 같은 테이블이 1건 이상 존재합니다.");
			return;
		}

		<%-- TABLE 에 HOVER 추가 --%>
		_table.addClass( "table-hover" );

		var _table_id = this._table_id;
		var _dbclick_func = this._dbclick_func;

		<%-- TOTAL CNT ID --%>
		var _total_cnt_div_classs     = _table_id + "_total_cnt_div_classs";
		var _total_cnt_id 	  = _table_id + "_total_cnt";
		var _table_length_id  = _table_id + "_length";
		var _table_row_class  = _table_id + "_row_class";

		<%-- 데이터 테이블 네비게이션 공통 class  --%>
		var _table_row_com_class = "datatable-paging";

		<%-- 드래그앤 드랍 여부 --%>
		var _is_dnd = this._is_dnd;
		<%-- 드래그앤 드랍 OPTIONS --%>
		var _dnd_options = this._dnd_options;


		var _ajax_method = this._ajax_method;
		var _ajax_action = this._ajax_action;
		var _ajax_data = this._ajax_data;
		var _valid_func =  this._valid_func;

		var _data_table = this._data_table;
		<%-- 초기화 완료 함수 --%>
		var _init_complete_func = this._init_complete_func;
		<%-- 데이터 테이블 DRAW 이후 함수 --%>
		var _draw_complete_func = this._draw_complete_func;

		<%-- 초기화시 데이터 테이블 DRAW 여부 --%>
		var _is_init_table_draw = this._is_init_table_draw;

		<%-- 유효성 체크 --%>
		if( ! $.isNumeric( this._display_start ) ){
			this._display_start = 0;
		}
		if( ! $.isNumeric( this._page_length ) ){
			this._page_length = 10;
		}


		data_table = _table.DataTable({

		dom: '<"top" <"total '+_total_cnt_div_classs+' "> >'
				+ 'rt'
				+'<"row '+_table_row_com_class+' '+_table_row_class+'  " <"col"  > <"col6" <"row" <"mr10"l> <""p>  > > <"col"> > ',
		paging: this._paging,
	    ordering: this._ordering,
	    info: false,
	    filter: false, // 사용자 정의 검색 form 사용
	    lengthChange: true,
	    order: this._order,
	    stateSave: false,
	    pagingType: "full_numbers", <%-- simple, simple_numbers, full, full_numbers --%>
	    scrollX: false,
	    scrollCollapse: false,
	    processing: true,
	    serverSide: true,
	    autoWidth: false,
	    responsive: true,
	    pageLength: this._page_length,
		lengthMenu: this._length_menu,
		displayStart: this._display_start,

		<%-- 초기화 완료 함수  --%>
		initComplete: function(settings, json) {
			if(  $.isFunction( _init_complete_func ) ){
				<%-- 초기화 완료 함수 처리  --%>
				_init_complete_func( this );
			}
		},

		createdRow: function(row, data, dataIndex){
			<%--  TR 에 DATA 를 주입한다.  --%>
			$(row).data( data );
		},

		drawCallback: function ( data ) {
			<%-- THEAD  --%>
			var _table_thead =  $( _table  ).children("thead");
			<%-- 첫번째 TR 의 TH 조회  --%>
			var _table_thead_ths =$( _table_thead ).children( "tr:first" ).children( "th" );
			<%-- THEAD 의 체크 박스들 --%>
			var _thead_checkboxs = $( _table_thead_ths ).find( ":checkbox" );


			<%-- TBODY --%>
			var _table_tbody = $( _table  ).children("tbody");
			<%-- TBODY 모든 TR --%>
			var _table_tbody_trs = $( _table_tbody ).children( "tr" );

			$.each( _thead_checkboxs, function( index, _thead_check_box ){
				var thead_th = $( _thead_check_box ).parents("th");
				var thead_index  = $( _table_thead_ths ).index( thead_th );

				<%-- 해당 Y 축에 대한 TD들 --%>
				var tbody_tds =  $( _table_tbody_trs ).find( "td:eq("+thead_index+")" );
				<%-- 해당 Y 축의 체크박스 카운트  --%>
				var tbody_checkbox_cnt = $( tbody_tds ).find( ":checkbox:enabled" ).length;
				<%-- 해당 Y 축의 체크된 체크박스 카운트  --%>
				var tbody_checked_cnt = $( tbody_tds ).find(" input:checked:enabled").length;

				if( tbody_checkbox_cnt > 0 ){

					//console.log( tbody_checkbox_cnt +"="+tbody_checked_cnt );

					if( tbody_checkbox_cnt == tbody_checked_cnt ){
						$( _thead_check_box ).prop('checked', true);
					}else{
						$( _thead_check_box ).prop('checked', false);
					}

				}else{

					<%-- 해당 Y 축 TBODY 에 체크 박스가 없을경우  --%>
					$( _thead_check_box ).prop('checked', false);
				}

			});

			var total_cnt = data._iRecordsTotal;
			$( '#' + _total_cnt_id  ).html( total_cnt ); <%-- 전체 카운트 주입 --%>

			<%-- 드래그앤 드랍 설정 --%>
			if( _is_dnd == true ){
				<%-- DRAG AND DROP  --%>
				$( _table_tbody ).sortable( _dnd_options );
			}

			<%-- TBODY 작성후 호출 함수 --%>
			if(  $.isFunction( _draw_complete_func ) ){
				_draw_complete_func( data );
			}

		},

		preDrawCallback: function( settings ){

			if( _is_init_table_draw == false ){
				<%-- 초기화시에 데이터테이블 DRAW 여부  --%>
			    _is_init_table_draw = true;
				return false;
			}

			if(  $.isFunction( _valid_func ) ){
				var is_valid =  _valid_func();
				return is_valid;
			}
			return true;
		},
		ajax: function ( data, callback, settings ){

			if(  $.isFunction( _ajax_data ) ){
				var req_json = _ajax_data();
				if(  !$.isEmptyObject( req_json ) ){
					try{
						$.each( req_json, function(key, value) {
							data[key] = value;
						});
					}catch( exception ) {}
				}
			}
			<%-- comJs.jsp 에 구현된 공통 AJAX DATA TABLE  JSON DATA 전송 API --%>
			doAjaxDataTable( _ajax_method
								  ,_ajax_action
								  ,data
								  ,callback  );
		},
	    columns: this._columns,
	    columnDefs: this._column_defs,
	    language: {
				lengthMenu: "_MENU_",
				zeroRecords: "데이터가 존재하지 않습니다",
				info: "Showing page _PAGE_ of _PAGES_",
				infoEmpty: "No records available",
				infoFiltered: "(filtered from _MAX_ total records)",
				paginate: {
					first: '<<',
					last: '>>',
					previous: "<",
					next: ">"
				}
	    },
		});

		if( this._view_total_cnt == true  ){
			 $("."+ _total_cnt_div_classs ).html('<div class="table-total">TOTAL <span id="'+_total_cnt_id+'">0</span> 건</div>');
		}
		$("#" + _table_length_id ).css('margin-top', '3px');

		<%-- THEAD --%>
		var _table_thead =  $( _table  ).children("thead");
		var _table_thead_ths =$( _table_thead ).children( "tr:first" ).children( "th" );

		<%-- TBODY --%>
		var _table_tbody =  $( _table  ).children("tbody");

		<%-- THEAD 의 체크 박스  --%>
		var _header_checkbox = $( _table_thead ).find( ":checkbox" );

		<%-- THEAD 체크박스 클릭시 이벤트  --%>
		$( _header_checkbox ).click(function(){
			<%-- 클릭한 체크박스 TH --%>
			var _target_th =$(this).parents( "th" );
			<%-- 이벤트가 일어난 TH index  --%>
			var _target_th_index = $( _table_thead_ths ).index( _target_th );

			if(  _target_th_index >= 0   ){
				var is_check = $( this ).prop("checked");
				var body_trs = $( _table_tbody ).children( "tr" );
				var body_tds =  $( body_trs ).find( "td:eq("+_target_th_index+")" );
				<%--  활성화 되어있는 체크박스들 --%>
				var body_checkboxs = $( body_tds ).find( ":checkbox:enabled" );

				if ( is_check == true ) {
					$( body_checkboxs ).prop('checked', true).change();
				}else{
					$( body_checkboxs ).prop('checked', false).change();
				}
			}
		});


		<%-- TBODY  체크박스 클릭시 이벤트  --%>
		$( _table_tbody ).on('change', ':checkbox', function () {

			var body_tr = $(this).parents("tr");
			var body_tds = 	$( body_tr ).children( "td" );
			var target_td = $(this).parents("td");
			var target_td_index = $( body_tds ).index( target_td );

			<%-- 현재 체크박스 체크 여부 --%>
			var is_check = $( this ).prop("checked");
			if ( is_check == true ) {
				$( body_tr ).addClass("checked");
			}else{
				$( body_tr ).removeClass("checked");
			}

			<%-- Y 축의 모든 TD 들 --%>
			var y_tbody_tds = $( _table_tbody ).children( "tr" ).find( "td:eq("+target_td_index+")" ) ;

			<%-- Y 축 BODY 의 체크박스 전체 카운트  --%>
			var y_body_checkbox_cnt =  $( y_tbody_tds ).find( ":checkbox:enabled" ).length;

			<%-- Y 축 BODY 의 체크된 체크박스 카운트  --%>
			var y_body_checked_cnt = $( y_tbody_tds ).find(" input:checked:enabled").length;

			<%-- HEADER 체크박스 체크유무 --%>
			var is_header_check = $( _header_checkbox ).prop("checked");

			<%-- Y 축 HEAD 체크박스 --%>
			var y_header_checkbox =  $( _table_thead_ths ).eq( target_td_index ).find( ":checkbox" );

			if(  y_body_checkbox_cnt  !=  y_body_checked_cnt  ){
				$( y_header_checkbox ).prop('checked', false).change();

			}else if(  y_body_checkbox_cnt  ==  y_body_checked_cnt  ){
				$( y_header_checkbox ).prop('checked', true).change();

			}

		});

		<%-- 생성된 DATA TABLE 주입 --%>
		this._data_table = data_table;

		if( this._is_tbody_tr_seleted == true  ){
			<%-- TBODY_TR 클릭시 이벤트  --%>
			this.bindTbodyClick();
		}

		if(  $.isFunction( _dbclick_func ) ){
			<%-- TBODY TR 더블 클릭시 이벤트  --%>
			this.bindTbodyDoubleClick( _dbclick_func );
		}

		return data_table;
	};




}



<%-- AJAX DATA TABLE 전송   --%>
function doAjaxDataTable( method, action, data, succFunc ){
	var contextPath = '${pageContext.request.contextPath}';
	var url = contextPath + action;

	<%-- 3차원 columns 를 2차원으로 변경한다. --%>
	var columns = data.columns;
	if(  !$.isEmptyObject( columns ) ){
		$.each( columns, function( index, column ){
	        column.searchRegex = column.search.regex;
	        column.searchValue = column.search.value;
	        delete( column.search );
		});
	}
	$.ajax({
		type: method ,
		url:  url ,
		data: data,
		dataType:'json',
		timeout:( 1000*30*5 ),
		success: function( resData, status ){
			if( $.isFunction( succFunc ) ){
				succFunc( resData );
			}
		}
	});
}


<%-- BASIC PAGING --%>
function BasicPaging(){
	var _method;
	var _action;
	var _form_id;


	BasicPaging.prototype.validate = function(){
		if( $.isEmptyObject( this._form_id ) ){
			alert("FORM ID 가 존재하지 않습니다.");
			return false;
		}

		var _form = $('#'+ this._form_id );

		if(  $.isEmptyObject( _form ) ||  _form.length == 0  ){
			alert("대상 FORM 이 존재하지 않습니다. ID="+ this._form_id );
			return false;
		}

		if(  $( _form ).is("form") == false  ){
			alert("FORM 객체가 아닙니다. ID="+ this._form_id );
			return false;
		}

		if(  _form.length != 1  ){
			alert("DOM 상에 같은 FORM 이 1건 이상 존재합니다.");
			return false;
		}

		if( $.isEmptyObject( this._method ) ){
			alert("METHOD 가 존재하지 않습니다.");
			return false;
		}

		if( $.isEmptyObject( this._action ) ){
			alert("ACTION 이 존재하지 않습니다.");
			return false;
		}

		return true;
	};

	<%-- 대상 FORM DATA 조회 --%>
	BasicPaging.prototype.get_form_data = function (){
		var target_form = $( "#"+ this._form_id );
		var form_data = new FormData( target_form[0] );
		return form_data;
	};

	<%-- 페이지 번호로 이동  --%>
	BasicPaging.prototype.move_page_no = function( page_no ){
		var form_data = this.get_form_data();
		var range_no =  form_data.get("rangeNo");

		this.move( page_no, range_no  );
	};

	<%-- 다음 RANGE 이동 --%>
	BasicPaging.prototype.move_next_range = function(){
		var form_data = this.get_form_data();
		var range_no =  form_data.get("rangeNo");
			 range_no = parseInt( range_no );
		var range_size = form_data.get("rangeSize");
			 range_size = parseInt( range_size );
		var page_no = ( range_no * range_size )  + 1;

		this.move( page_no, ( range_no + 1 ) );
	};

	<%-- 이전 RANGE 이동  --%>
	BasicPaging.prototype.move_prev_range = function(){
		var form_data = this.get_form_data();
		var range_no =  form_data.get("rangeNo");
		 	 range_no = parseInt( range_no );
		var range_size = form_data.get("rangeSize");
			 range_size = parseInt( range_size );
		var page_no = ( (range_no - 2) * range_size ) + 1;

		this.move( page_no, ( range_no - 1 ) );
	};


	<%-- 다음 PAGE 이동  --%>
	BasicPaging.prototype.move_next_page = function(){
		var form_data = this.get_form_data();
		<%-- 현재  페이지번호 --%>
		var page_no = form_data.get("pageNo");
			 page_no = parseInt( page_no );
		<%-- 현재 RANGE 번호 --%>
		var range_no = form_data.get("rangeNo");
			 range_no = parseInt( range_no );
		<%-- 페이지 수량 --%>
		var page_count = form_data.get("pageCount");
			 page_count = parseInt( page_count );
		<%-- 현재 RANGE 사이즈 --%>
		var range_size = form_data.get("rangeSize");
			 range_size = parseInt( range_size );

		if( page_no >= page_count ){
			alert("다음페이지가 존재하지 않습니다.");
			return;
		}

		<%-- 다음 페이지 번호 --%>
		page_no = page_no + 1;

		if(  ( range_no * range_size ) < page_no  ){
			<%-- RANGE 추가  --%>
			range_no = range_no + 1;
		}
		this.move( page_no, range_no );
	};

	<%-- 이전 PAGE 이동  --%>
	BasicPaging.prototype.move_prev_page = function(){
		var form_data = this.get_form_data();
		<%-- 현재  페이지번호 --%>
		var page_no = form_data.get("pageNo");
			 page_no = parseInt( page_no );
		<%-- 현재 RANGE 번호 --%>
		var range_no = form_data.get("rangeNo");
			 range_no = parseInt( range_no );
		<%-- 현재 RANGE 사이즈 --%>
		var range_size = form_data.get("rangeSize");
			 range_size = parseInt( range_size );

		if( page_no <= 1  ){
			alert("이전페이지가 존재하지 않습니다.");
			return;
		}
		<%-- 이전 페이지 번호 --%>
		page_no = page_no - 1;

		if( range_no > 1 ){
			if( ( (range_no - 1) * range_size )  >=  page_no    ){
				<%-- RANGE 감소  --%>
				range_no = range_no - 1;
			}
		}
		this.move( page_no, range_no );
	};

	<%-- 첫 PAGE 이동  --%>
	BasicPaging.prototype.move_first_page = function(){
		this.move( 1, 1 );
	};

	<%-- 마지막 PAGE 이동  --%>
	BasicPaging.prototype.move_last_page = function(){
		var form_data = this.get_form_data();
		var page_count = form_data.get("pageCount");
			 page_count = parseInt( page_count );
		var range_count = form_data.get("rangeCount");
			 range_count = parseInt( range_count );
		this.move( page_count, range_count );
	};

	<%-- 페이지 이동 --%>
	BasicPaging.prototype.move = function( page_no, range_no ){
		var form_data = this.get_form_data();
			form_data.delete("pageNo");
			form_data.delete("rangeNo");
			form_data.append( "pageNo", page_no );
			form_data.append( "rangeNo", range_no );

		var movePage = new MovePage();
		movePage._method = this._method;
		movePage._action = this._action;
		movePage._formData = form_data;
		movePage.move();
	};
}


<%-- BASIC RE MODAL --%>
function BasicReModal(){
	<%-- REMODAL 대상 객체 --%>
	this._remodal_element;
	<%-- OPEN 성공시 함수 --%>
	this._open_succ_func;

	this._remodal_instance;

	BasicReModal.prototype.open = function(){
		if(  this._remodal_element == null ){
			alert("대상 REMODAL 객체가 존재하지 않습니다.");
			return;
		}
		if( this._remodal_element.length != 1  ){
			alert("대상 REMODAL 객체가 1건이 아닙니다.");
			return;
		}
		this._remodal_instance = $( this._remodal_element ).remodal();


		<%--
		var options =  {
			    hashTracking: true,
			    closeOnConfirm: true,
			    closeOnCancel: true,
			    closeOnEscape: false,
			    closeOnOutsideClick: false,
			    modifier: '',
			    appendTo: null
		};
	--%>

		var settings = this._remodal_instance.settings;
		<%-- 설정 변경 --%>
		settings.hashTracking = false;
		settings.closeOnEscape = false;
		settings.closeOnOutsideClick = true;

		<%-- REMODAL OPEN --%>
		this._remodal_instance.open();

		<%-- 포커스를 줄 ELEMENT  --%>
		var _focus_element = null;

		var _modal_input_elements = $( this._remodal_element ).find( "input:text, select, input:checkbox, input:radio, textarea" )
		 																	 .not(".flatpickr-with-time, .flatpickr-with-week, .flatpickr-without-time, .flatpickr-custom-time");
		if( _modal_input_elements.length > 0 ){
			<%--  MODAL 첫번째 객체 --%>
			_focus_element = _modal_input_elements[0];
		}else{
			 <%-- hidden 을 제외한 모든 input elements --%>
			 var _modal_show_elements = $(this._remodal_element ).find( ":input:not([type=hidden])" );
			 if( _modal_show_elements.length > 0 ){
				 <%-- 마지막 객체에 포커스  --%>
				 _focus_element =  $( _modal_show_elements ).last();
			 }
		 }
		 if( _focus_element != null ){
	 		 setTimeout(
	 			function() {
	 				$( _focus_element ).focus();
	 			}
	 			,460
		     );
		 }
		 <%-- 후처리함수 실행 --%>
		 var target_function =  this._open_succ_func;
		 if( $.isFunction( target_function ) ){
	 		 setTimeout(
	 			function() {
	 				target_function();
	 			}
	 			,460
			);

		 }
	};

	BasicReModal.prototype.close = function(){
		this._remodal_instance.close();
	};
	BasicReModal.prototype.getState = function(){
		this._remodal_instance.getState();
	};
	BasicReModal.prototype.destroy = function(){
		this._remodal_instance.destroy();
	};

}

<%-- BASIC TOARST --%>
function BasicToastr(){
	this.options =  {
            closeButton: true,
            progressBar: true,
            showMethod: 'slideDown',
            timeOut: 4000
        };

	this.title;

	BasicToastr.prototype.success = function( contents ){
		var title  = ( !$.isEmptyObject( this.title ) ) ? this.title : "" ;
		contents  = ( !$.isEmptyObject( contents ) ) ? contents : "" ;

		toastr.options = this.options;
		toastr.success( contents , title );
	};
	BasicToastr.prototype.info = function( contents ){
		var title  = ( !$.isEmptyObject( this.title ) ) ? this.title : "" ;
		contents  = ( !$.isEmptyObject( contents ) ) ? contents : "" ;

		toastr.options = this.options;
		toastr.info( contents , title );
	};
	BasicToastr.prototype.warning = function( contents ){
		var title  = ( !$.isEmptyObject( this.title ) ) ? this.title : "" ;
		contents  = ( !$.isEmptyObject( contents ) ) ? contents : "" ;

		toastr.options = this.options;
		toastr.warning( contents , title );
	};
	BasicToastr.prototype.error = function( contents ){
		var title  = ( !$.isEmptyObject( this.title ) ) ? this.title : "" ;
		contents  = ( !$.isEmptyObject( contents ) ) ? contents : "" ;

		toastr.options = this.options;
		toastr.error( contents , title );
	};

}


<%-- WINDOW POPUP --%>
function BasicWindow(){

	this._action = "";
	this._pop_name = "";

	<%-- 팝업창 가로길이 --%>
	this._width = 0;
	<%-- 팝업창 세로길이 --%>
	this._height = 0;
	<%-- 왼쪽에 창을 고정(ex. left=30 이런식으로 조절) --%>
	this._left=0;
	<%-- 위쪽에 창을 고정(ex. top=100 이런식으로 조절) --%>
	this._top=0;
	<%-- 단축도구창(툴바) 표시안함 --%>
	this._toolbar = 'no';
	<%-- 아래 상태바창 표시안함 --%>
	this._status = 'no';
	<%-- 창변형  --%>
	this._resizable = 'yes';
	<%-- 스크롤바 표시여부  --%>
	this._scrollbars ='no';
	<%--  내부 팝업 호출 여부  --%>
	this._is_inner = true;

	BasicWindow.prototype.close =  function(){

	};
	BasicWindow.prototype.open =  function(){
		var contextPath = '${pageContext.request.contextPath}';

		if( isEmpty( this._pop_name ) ){
			alert("팝업 명 필수");
			return;
		}

		var url = "";

		if( !isEmpty( this._action ) ){
			if( this._is_inner == true ){
				<%-- CMS 내부 팝업 --%>
				url = contextPath + this._action;
			}else{
				<%-- CMS 외부 팝업 --%>
				url = this._action;
			}

		}


		var options  = "";
			options += "width="+ this._width;
			options += ",height="+ this._height;
			options += ",left="+ this._left;
			options += ",top="+ this._top;
			options += ",toolbar="+ this._toolbar;
			options += ",status="+ this._status;
			options += ",scrollbars="+ this._scrollbars;
			options += ",resizable="+ this._resizable;

		window.open( url ,this._pop_name ,options );
	};
}

function isEmpty( val ){
	if( val == undefined || val == null || val == "" ){
		return true;
	}else{
		return false;
	}
}



<%-- 베이직 CHART 객체 --%>
function BasicChart() {
	
	<%-- CHART TYPE --%>
	this._type;
	
	<%-- CHART를 로딩할 타겟 리스트 --%>
	this._target;
	
	<%-- CHART 데이터 항목 리스트 ( ex. 사과 배 딸기 ... ) --%>
	this._labels = [];
	
	<%-- 데이타셋 --%>	
	this._data_sets = [];
	
	<%-- 테두리색 --%>
	this._line_color = "black";
	
	<%-- 항목 글꼴 사이즈 --%>
	this._label_font_size = 16;
	
	<%-- 항목 글꼴 색 --%>
	this._label_font_color = "black";
	
	<%-- 데이터 글꼴 사이즈 (방사형에서만 일단은 사용됨) --%>
	this._data_font_size = 14;
	
	<%-- 데이터 글꼴 색 (방사형에서만 일단은 사용됨) --%>
	this._data_font_color = "black";
	
	<%-- 레이블 클릭 이벤트 --%>
	this._label_click_func;
	
	<%-- 데이터중에 가장 높은 수 --%>
	this._max_count;
	
	<%-- 항목 글꼴 --%>
	this._fontFamily = 'Noto Sans KR';

	BasicChart.prototype.validate = function(){
		
		if( $.isEmptyObject( this._target ) ){
			alert("타겟을 지정하지 않았습니다.");
			return false;
		}
		
		
		if( $.isEmptyObject( this._target ) || this._target == 0 ){
			alert("타겟 이 존재하지 않습니다. TARGET="+ this._target );
			return false;
		}
		
		if(  this._target.length != 1  ){
			alert("DOM 상에 같은 TARGET 이 1건 이상 존재합니다. TARGET="+ this._target );
			return false;
		}
		
		if( $.isEmptyObject( this._type ) ){
			alert("타입을 지정하지 않았습니다.");
			return false;
		}
		
		
		return true;
	};
	
	BasicChart.prototype.init = function() {
		var is_valid = this.validate();
		if( is_valid != true ) {
			return;
		}
		
		
		if( this._type == 'radar' ) {
			
			var _target_ = $( this._target )[0];
			var ctx = _target_.getContext('2d');
			var label_click_func = this._label_click_func;
			
			var myChart = new Chart( ctx, {
				type: this._type,
				data: {
					labels: this._labels,
					datasets: this._data_sets
				},
				options: {
					maintainAspectRatio: false,
	                legend: {
	                	 position: 'bottom', 
	                	 display: true,
	                     labels: {
	                             fontSize: this._label_font_size,
	                             fontFamily: this._fontFamily,
	                             fontColor: this._label_font_color,
	                             fontStyle: 'bold',
	                     }
	                },
	                
	                scale: {
	                	gridLines: {
	                		color: this._line_color,
	                		lineWidth: 1
	                	},
	                	angleLines: {
	                		display: true
	                	},
	                    ticks: {
	                    	beginAtZero: true,
	                    	min: 0,
	                    	//max: 100,
	                    	stepSize: this._max_count / 5,
	                    },
		                pointLabels: {
		                    fontSize: this._data_font_size,
		                    fontColor: this._data_font_color,
		                    hoverBorderColor: "orange",
		                    fontFamily: this._fontFamily,
		                    fontStyle : "500"
		                }
	                },
	                
	                onClick: function( e ) {
	                	
						var scale = this.scale;
						var mouseX = e.offsetX; 
						var mouseY = e.offsetY;
						label_location_list = get_label_location( this, mouseX, mouseY );
				        
				        $( label_location_list ).each( function( i, item ){
				        	if( mouseX >= item.left && mouseX <= item.right && mouseY <= item.bottom && mouseY >= item.top ) {
								if( $.isFunction( label_click_func ) ) {
									var label_index = i + 1;
									label_click_func( label_index );
								}
				        	}
				        	
				        });
					},
					
					tooltips: {
						enabled: true,
				        callbacks: {
				            title: function( tooltipItem, data ){
				            	<%--
				            	var title = "";
				            	$( tooltipItem ).each( function( index, item ){
				            		if( index != 0 ) { title += "\n" };
				            			title += data.labels[item.index];
				            	});
				            	return title;
				            	--%>
				            }, label: function( tooltipItem, data ) {
				            	var _show_label_ = data.labels[tooltipItem.index];
				            	var _show_value_ = Number( data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] );
				            	
				            	
				            	return _show_label_ + ' : ' + _show_value_;
				            }
				        }
				    }
	         	}
			});
			
			
			
			
			
		} else if( this._type == 'line' ) {
			var myChart = new Chart( this._target, {
				type: this._type,
				data: {
					labels: this._labels,
					datasets: this._data_sets
				},
				options: {
	                maintainAspectRatio: false,
	                legend: {
	                	 position: 'bottom', 
	                	 display: true,
	                     labels: {
	                             fontSize: this._label_font_size,
	                             fontFamily: 'sans-serif',
	                             fontColor: this._label_font_color,
	                             fontStyle: 'bold',
	                     }
	                }
	         	}
			})
		} else if( this._type == 'bar' ) {
			var myChart = new Chart( this._target, {
				type: this._type,
				data: {
					labels: this._labels,
					datasets: this._data_sets
				},
				options: {
	                maintainAspectRatio: false,
	                legend: {
	                	 position: 'bottom', 
	                	 display: true,
	                     labels: {
	                             fontSize: this._label_font_size,
	                             fontFamily: 'sans-serif',
	                             fontColor: this._label_font_color,
	                             fontStyle: 'bold',
	                     }
	                }
	         	}
			})
		} else if( this._type == 'pie' ) {
			var myChart = new Chart( this._target, {
				type: this._type,
				data: {
					labels: this._labels,
					datasets: this._data_sets
				},
				options: {
	                maintainAspectRatio: false,
	                legend: {
	                	 position: 'bottom', 
	                	 display: true,
	                     labels: {
	                             fontSize: this._label_font_size,
	                             fontFamily: 'sans-serif',
	                             fontColor: this._label_font_color,
	                             fontStyle: 'bold',
	                     }
	                },
	         	}
			})
		}
		
		
		<%-- 레이블 클릭 함수 존재시 레이블 hover CSS 효과 주입 --%>
		if( $.isFunction( this._label_click_func ) ){
			$( this._target ).on( "mousemove", function(e){
				var mouseX = e.offsetX; 
				var mouseY = e.offsetY;
				label_location_list = get_label_location( myChart, mouseX, mouseY );
		        
				var check = false;
		        $( label_location_list ).each( function( i, item ){
		        	if( mouseX >= item.left && mouseX <= item.right && mouseY <= item.bottom && mouseY >= item.top ) {
		        		check = true;
		        		return;
		        	}
		        	
		        });
		        
		        if( check == true ) {
		        	$( this ).css( "cursor", "pointer" );
					return;			        	
		        }
		        
		        $( this ).css( "cursor", "auto" );
		        
			});
		}
		
		<%-- 차트 레이블들의 좌표값 리스트 --%>
		var get_label_location = function( chart_instance, mouseX, mouseY ) {
			var helpers = Chart.helpers;
	        var scale = chart_instance.scale;
	        var opts = scale.options;
	        var tickOpts = opts.ticks;
					
	        <%-- Position of click relative to canvas. --%>
	        // var mouseX = e.offsetX;
	        // var mouseY = e.offsetY;
	        
	        <%-- number pixels to expand label bounding box by --%>
	        var labelPadding = 5;
	        
	        <%-- get the label render position --%>
	        <%-- calcs taken from drawPointLabels() in scale.radialLinear.js --%>
	        var tickBackdropHeight = (tickOpts.display && opts.display) ?
	            helpers.valueOrDefault(tickOpts.fontSize, Chart.defaults.global.defaultFontSize) + 5: 0;
	        var outerDistance = scale.getDistanceFromCenterForValue(opts.ticks.reverse ? scale.min : scale.max);
	        
	        
	        var label_location_list = new Array();
	        
	        
	        $( scale.pointLabels ).each( function( index, point_label ){
	        	var extra = ( index === 0 ? tickBackdropHeight / 2 : 0 );
	        	var pointLabelPosition = scale.getPointPosition( index, outerDistance + extra + 5 );
	        	
	        	var plSize = scale._pointLabelSizes[ index ];
	        	
	        	var angleRadians = scale.getIndexAngle( index );
        		var angle = helpers.toDegrees( angleRadians );
        		
        		var textAlign = 'right';
	            if (angle == 0 || angle == 180) {
	                textAlign = 'center';
	            } else if (angle < 180) {
	                textAlign = 'left';
	            }
	            
	            
	            var verticalTextOffset = 0;
	            
	            if (angle === 90 || angle === 270) {
	                verticalTextOffset = plSize.h / 2;
	            } else if (angle > 270 || angle < 90) {
	                verticalTextOffset = plSize.h;
	            }
	            
	            
	            var labelTop = pointLabelPosition.y - verticalTextOffset - labelPadding;
	            var labelHeight = 2*labelPadding + plSize.h;
	            var labelBottom = labelTop + labelHeight;

				var labelWidth = plSize.w + 2*labelPadding;
	            var labelLeft;
	            
	            
				switch (textAlign) {
					case 'center':
						var labelLeft = pointLabelPosition.x - labelWidth/2;
						break;
					case 'left':
						var labelLeft = pointLabelPosition.x - labelPadding;
						break;
					case 'right':
						var labelLeft = pointLabelPosition.x - labelWidth + labelPadding;
						break;
					default:
						console.log('ERROR: unknown textAlign '+textAlign);
				}
	            
				var labelRight = labelLeft + labelWidth;
	            
				<%-- 레이블 좌표 정보를 담은 객체 --%>
	            var labe_location = {
	            	top : labelTop,
	            	bottom : labelBottom,
	            	left : labelLeft,
	            	right : labelRight,
	            	width: labelWidth,
	            	height: labelHeight
	            };
	            
	            label_location_list.push( labe_location );
	        });
	        
	        return label_location_list;
		}
		
	}
}



<%-- 베이직 Flatpickr 객체 --%>
function BasicFlatpickr() {
	
	<%-- flatpickr 이 열리는 타겟 --%>
	this._target;
	<%-- flatpickr 의 타입 --%>
	this._type;
	<%-- flatpickr 기본 세팅 날짜 [ 2021-05-31 ] --%>
	this._default_date;
	<%-- flatpickr 기본 세팅 시간 [ 24 ] --%>
	this._default_hour;
	<%-- flatpickr 기본 세팅 분 [ 60 ] --%>
	this._default_minute;
	
	<%-- flatpickr 선택 가능 최소 날짜
	[example] flatpickr._min_month_date = new Date('2021-03-01');
	 --%>
	this._min_date;
	<%-- flatpickr 선택 가능 최대 날짜
	[example] flatpickr._min_month_date = new Date('2021-05-31'); // Date 함수의 인자값을 안주면 오늘 날짜
	 --%>
	this._max_date;
	<%-- flatpickr 선택 가능 최소 월
	[example] flatpickr._min_month_date = '2021-03';
	 --%>
	this._min_month_date;
	<%-- flatpickr 선택 가능 최대 월
	[example] flatpickr._min_month_date = '2021-06';
	 --%>
	this._max_month_date;
	<%-- 비활성화 날짜 목록 (현재는 월 달력에는 미개발) --%>
	this._disable = [];
	<%-- 활성화 날짜 목록 (현재는 월 달력에는 미개발) --%>
	this._enable = [];
	
	BasicFlatpickr.prototype.init = function(){
		
		<%-- 기본 날짜 세팅 없을시 --%>
		if( $.isEmptyObject( this._default_date ) ) { 
			this._default_date =  $.isEmptyObject( $( this._target ).val() ) ? new Date() : $( this._target ).val(); 
		}
		
		if( this._type == "with-time" ) {
			
			<%-- 사용자 지정 날짜 --%>
			var default_date = new Date( this._default_date );
			
			<%-- 사용자 지정 시간 --%>
			if( ! $.isEmptyObject( this._default_hour ) ) { 
				default_date.setHours( this._default_hour );
			}
			
			<%-- 사용자 지정 분 --%>
			if( ! $.isEmptyObject( this._default_minute ) ) { 
				default_date.setMinutes( this._default_minute );
			}
			
			$( this._target ).flatpickr({
				enableTime: true,
				locale: 'kr',
				defaultDate: default_date,
				dateFormat: "Y-m-d H:i",
				minDate: this._min_date,
				maxDate: this._max_date,
				<%-- disable: this._disable,	disable, enable 을 사용하면 시간이 포함된 달력에서는 작동하지 않는다.
				enable: _enable, --%>
			});
		}
		
		if( this._type == "with-week" ) {
			$( this._target ).flatpickr({
				enableTime: false,
				locale: 'kr',
				defaultDate: this._default_date,
				dateFormat: "Y-m-d D",
				minDate: this._min_date,
				maxDate: this._max_date,
				disable: this._disable,
				enable: this._enable,
			});
		}
		
		if( this._type == "without-time" ) {
			
			var target = this._target;
			
			$( this._target ).flatpickr({
				defaultDate: this._default_date,
				locale: 'kr',
				enableTime: false,
				minDate: this._min_date,
				maxDate: this._max_date,
				disable: this._disable,
				enable: this._enable,
				onOpen: function(){
				}
			})
		}
		
		if( this._type == "monthSelect" ) {
			$( this._target ).flatpickr({
				enableTime: false,
				locale: 'kr',
				defaultDate: default_date,
				plugins: [
					new monthSelectPlugin({
						shorthand: true, //defaults to false
						dateFormat: "Y-m", //defaults to "F Y"
						altFormat: "F Y", //defaults to "F Y"
					})
				],
				minDate: this._min_month_date,
				maxDate: this._max_month_date,
			});
		}
	}
}


<%-- 베이직 SUMMERNOTE 객체 --%>
function BasicSummerNote() {
	
	<%-- 썸머노트를 로딩할 타겟 리스트 --%>
	this._targets;
	
	<%-- 에디터 높이, MIN/MAX 높이값 설정 --%>
	this._size = { "height" : 300,
					"minHeight" : null,
					"maxHeight" : null
				 };
	
	<%-- 에디터 로딩후 포커스를 맞출지 여부 --%>
	this._focus = true;
	
	this._lang = "ko-KR";
	
	<%-- 에디터 disable 처리 여부 --%>
	this._disable = false;
	
	<%-- 에디터 enable 처리 여부 --%>
	this._enable = false;
	
	this._placeholder = "";
	
	
	BasicSummerNote.prototype.validate = function(){
		if( $.isEmptyObject( this._targets ) ){
			alert("타겟을 지정하지 않았습니다.");
			return false;
		}

		var element_check = true;
		$.each( this._targets, function( index, target ){
			
			var element = $( target );
			
			if( $.isEmptyObject( element ) || element == 0 ){
				alert("타겟 이 존재하지 않습니다. TARGET="+ target );
				element_check = false;
				return false;
			}
			
			if(  element.length != 1  ){
				alert("DOM 상에 같은 TARGET 이 1건 이상 존재합니다. TARGET="+ target );
				element_check = false;
				return false;
			}
		});

		return element_check;
	};
	
	BasicSummerNote.prototype.init = function() {
		
		var is_valid = this.validate();
		if( is_valid != true ) {
			return;
		}
		
		var editor_size = this._size;
		var targets = this._targets;
		var disable = this._disable;
		
		$.each( targets, function( index, target ){
			$( target ).summernote({
				height: editor_size[ "height" ],
				minHeight: editor_size[ "minHeight" ],
				maxHeight: editor_size[ "maxHeight" ],
				focus: this._focus,
				lang: this._lang,
				placeholder: this._placeholder,
				toolbar: [
					['fontname', ['fontname']],
					['fontsize', ['fontsize']],
					['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
					['color', ['forecolor','color']],
					['table', ['table']],
					['para', ['ul', 'ol', 'paragraph']],
					['height', ['height']],
					['insert',['picture','link','video']],
					['view', ['fullscreen', 'help']]
				],
				fontNames: [ 'Arial'
							,'Arial Black'
							,'Comic Sans MS'
							,'Courier New'
							,'Helvetica'
							,'Impact'
							,'Tahoma'
							,'Times New Roman'
							,'Verdana'
							,'맑은 고딕'
							,'궁서'
							,'굴림체'
							,'굴림'
							,'돋움체'
							,'바탕체'
							,'휴먼명조' ],
				fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72']
			});
			
			<%-- editor disable 처리 --%>
			if( disable == true ) {
				$( target ).summernote( 'disable' );
			}
			
			<%-- elements with non-unique id 방지 --%>
			$( "#backColorPicker" ).attr( "id" , "backColorPicker_"+index );
			$( "#foreColorPicker" ).attr( "id" , "foreColorPicker_"+index );
		});
	}
}



<%-- LOADING BAR SETTING AND SHOW --%>
function loading_show( height ) {
	
	<%-- 로딩바 레이어 CSS 설정 --%>
	var document_height = $( document ).height();
	var document_width = $( document ).width();
			
	$( ".loading-background" ).css({ 'width': document_width
					, 'height': document_height
					, 'opacity': '0.3' });
	
	
	<%-- 로딩바 위치(height) 디폴트 가운데 --%>
	var top = height == undefined ? $(window).scrollTop() + $(window).height() * 0.5 : height;
	
	$( ".loading-bar" ).css( { 'top' : top } );
	
	
	$( ".loading-background" ).show();
	$( ".loading-bar" ).show();
}


<%-- LOADING BAR HIDE --%>
function loading_hidden() {
	$( ".loading-background" ).hide();
	$( ".loading-bar" ).hide();
}

</script>

