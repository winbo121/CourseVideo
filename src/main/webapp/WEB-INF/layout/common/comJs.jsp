<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>



<script type="text/javascript"
	src="<c:url value='/js/jquery-3.4.1.min.js' />"></script>

<%-- <script type="text/javascript"	src="<c:url value='/js/jquery-3.4.1.min.js' />"></script> --%>

<script type="text/javascript"
	src="<c:url value='/assets/pc/js/vendor/jquery/jquery-ui-1.11.4.custom/jquery-ui.min.js'/>"></script>

<!-- <script src="/assets/js/jquery-3.6.0.min.js"></script> -->

<%-- Bootstrap 4 MODAL 적용을 위해서 붙여놓음
<script src='<c:url value="/js/bundle/bootstrap.bundle.js"/>' ></script> --%>


<%-- IE 에서 동작되지 않는 JAVA SCRIPT 를 위해서 추가 --%>
<script type="text/javascript"
	src="<c:url value='/js/polyfill.min.js' />"></script>
<script type="text/javascript"
	src="<c:url value='/js/formdata.min.js' />"></script>
<script type="text/javascript"
	src="<c:url value='/js/jquery.tmpl.js' />"></script>
<script type="text/javascript"
	src="<c:url value='/js/jquery.fileDownload.js' />"></script>

<!-- DataTables -->
<link rel="stylesheet"
	href='<c:url value="/js/datatables/dataTables.bootstrap4.min.css"/>'>
<link rel="stylesheet"
	href='<c:url value="/js/datatables/responsive.bootstrap4.min.css"/>'>
<script src='<c:url value="/js/datatables/jquery.dataTables.min.js"/>'></script>
<script
	src='<c:url value="/js/datatables/dataTables.bootstrap4.min.js"/>'></script>
<script
	src='<c:url value="/js/datatables/dataTables.responsive.min.js"/>'></script>
<script
	src='<c:url value="/js/datatables/responsive.bootstrap4.min.js"/>'></script>

<%-- SWEET ALERT --%>
<link rel="stylesheet"
	href='<c:url value="/js/sweet/bootstrap-4.min.css"/>'>
<script src='<c:url value="/js/sweet/sweetalert2.all.min.js"/>'></script>

<%-- 공통 스크립트 함수 객체 --%>
<jsp:include page="/WEB-INF/layout/common/comFunction.jsp" />

<%-- VALIDATOR --%>
<script type="text/javascript"
	src="<c:url value='/js/jquery-validation/jquery.validate.js' />"></script>
<script type="text/javascript"
	src="<c:url value='/js/jquery-validation/additional-methods.js' />"></script>
<script type="text/javascript"
	src="<c:url value='/js/jquery-validation/localization/messages_ko.js' />"></script>


<%-- TOASTR --%>
<link rel="stylesheet" type="text/css"
	href="<c:url value='/js/toastr/toastr.min.css' />" />
<script type="text/javascript"
	src="<c:url value='/js/toastr/toastr.min.js' />"></script>

<script type="text/javascript">
$(document).ready(function(){
	<%-- 시스템 점검을 띄워 주기 위한 변수 설정 (오늘날짜, 점검시작날짜, 점검종료날짜 --%>
	var today = new Date();
	var maintenanceStartDate = new Date('3/25/2024 16:00:00');
	var maintenanceEndDate = new Date('3/31/2024 16:30:00');
	
	<%-- 점검시작날짜 < 오늘날짜 < 점검종료날짜   일때 점검페이지로 redirect --%>
	if(today >= maintenanceStartDate && today <= maintenanceEndDate) {
		if(window.location.pathname.search('maintenance.do') == -1) {
			move_get('/maintenance.do', null);
		}
	}
	
<%-- 학생이 로그인후 15분이 된경우 reward 를 남긴다. --%>
<sec:authorize access=" hasRole('ROLE_STUDENT') " >
	var student_login_reward_mille_second = '${_STUDENT_LOGIN_REWARD_MILLE_SECOND_}';
	if( $.isNumeric( student_login_reward_mille_second ) ){
		var int_mille_second = parseInt( student_login_reward_mille_second );


		 setTimeout(
		 			function() {
			 				var action = "/login_compensation.do";
			 				var json = {};
			 				var succ_func = function( resData, status ){
			 				};
			 				ajax_json_post( action, json, succ_func );
		 			}
		 			,int_mille_second
			     );
	}
</sec:authorize>

<%--  회원정보 변경 필요 여부 --%>
<sec:authorize access=" hasRole('ROLE_USER') " >
	var need_modify_user = '${_NEED_MODIFY_USER_}';

	if( 'true' == need_modify_user  ){
		var html = "사용자 이메일 정보 혹은 <br/> 회원 정보가 존재하지 않습니다. <br/> 회원 정보를 수정해 주세요.";
		var confirm_func = function(){
			var action = "/account/detail.do";
			move_get( action, null );
		};

		alert_info( html, confirm_func );

	}


</sec:authorize>
});


<%-- SIMPLE ALERT SUCCESS --%>
function alert_success( html, confirm_func ){
	var basicAlert = new BasicAlert();
	basicAlert._type = "success";
	basicAlert._html = html; basicAlert._confirm_func = confirm_func;
	basicAlert.fire();
}
<%-- SIMPLE ALERT WARNING --%>
function alert_warning( html, confirm_func ){
	var basicAlert = new BasicAlert();
	basicAlert._type = "warning";
	basicAlert._html = html; basicAlert._confirm_func = confirm_func;
	basicAlert.fire();
}
<%-- SIMPLE ALERT ERROR --%>function alert_error( html, confirm_func ){
	var basicAlert = new BasicAlert();
	basicAlert._type = "error";
	basicAlert._html = html; basicAlert._confirm_func = confirm_func;
	basicAlert.fire();
}
<%-- SIMPLE ALERT INFO --%>
function alert_info( html, confirm_func ){
	var basicAlert = new BasicAlert();
	basicAlert._type = "info";
	basicAlert._html = html; basicAlert._confirm_func = confirm_func;
	basicAlert.fire();
}


<%-- SIMPLE CONFIRM SUCCESS --%>
function confirm_success( html, confirm_func, cancel_func  ){
	var basicConfirm = new BasicConfirm();
	basicConfirm._type = "success";
	basicConfirm._html = html; basicConfirm._confirm_func = confirm_func; basicConfirm._cancel_func = cancel_func;
	basicConfirm.fire();
}
<%-- SIMPLE CONFIRM WARNING --%>
function confirm_warning( html, confirm_func, cancel_func  ){
	var basicConfirm = new BasicConfirm();
	basicConfirm._type = "warning";
	basicConfirm._html = html; basicConfirm._confirm_func = confirm_func; basicConfirm._cancel_func = cancel_func;
	basicConfirm.fire();
}
<%-- SIMPLE CONFIRM ERROR --%>
function confirm_error( html, confirm_func, cancel_func  ){
	var basicConfirm = new BasicConfirm();
	basicConfirm._type = "error";
	basicConfirm._html = html; basicConfirm._confirm_func = confirm_func; basicConfirm._cancel_func = cancel_func;
	basicConfirm.fire();
}
<%-- SIMPLE CONFIRM INFO --%>
function confirm_info( html, confirm_func, cancel_func  ){
	var basicConfirm = new BasicConfirm();
	basicConfirm._type = "info";
	basicConfirm._html = html; basicConfirm._confirm_func = confirm_func; basicConfirm._cancel_func = cancel_func;
	basicConfirm.fire();
}


<%-- EXCEL DOWNLOAD DATA TABLE --%>
function excel_down_datatable( action, form_data, ajax_data ){
	var columns = null;
	var order = null;
	var search = null;

	if(  !$.isEmptyObject( ajax_data ) ){
		columns = ajax_data.columns;
		order = ajax_data.order;
		search = ajax_data.search;
	}

	<%-- formData 존재유무 확인  --%>
	if( !( form_data instanceof FormData) ){
		form_data = new FormData();
	}
	if(  !$.isEmptyObject( columns ) ){
		$.each( columns, function( index,  column ){
			try{
				$.each( column, function(key, value){
					var attr_name = "columns" + "["+index+"]"+"["+key+"]";
					form_data.append(attr_name ,value);
				});
			}catch( exception ) {}
		});
	}

	if(  !$.isEmptyObject( order ) ){
		$.each( order, function( index,  ord ){
			try{
				$.each( ord, function(key, value){
					var attr_name = "order" + "["+index+"]"+"["+key+"]";
					form_data.append(attr_name ,value);
				});
			}catch( exception ) {}
		});
	}

	if(  !$.isEmptyObject( search ) ){
		try{
			$.each( search, function(key, value){
				var attr_name = "search"+"["+key+"]";
				form_data.append(attr_name ,value);
			});
		}catch( exception ) {}
	}

	var movePage = new MovePage();
	movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	<%-- 모바일인 경우 target 이 들어가서는 안된다. --%>
	movePage._target = "_hidden_iframe";
	movePage.move();
}

<%-- 현재 화면이 PC 인지 여부 --%>
function is_device_pc(){
	var device_is_normal = $("meta[name='_device_is_normal']").attr("content");
	if( $.isEmptyObject( device_is_normal ) ){
		return false;
	}
	return device_is_normal == "true";
}

<%-- EXCEL DOWNLOAD --%>
function excel_down( action, form_data ){
	var movePage = new MovePage();
	movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	if( is_device_pc() ){
		<%-- 모바일인 경우 target 이 들어가서는 안된다. --%>
		movePage._target = "_hidden_iframe";
	}
	movePage.move();
}

<%-- FILE DOWNLOAD--%>
function file_down( file_seq, succ_func, fail_func ){
	var form_data = new FormData();
    	 form_data.append("file_seq", file_seq );
    	 var token = "${_csrf.token}";
		form_data.append("_csrf", token );

    var action = "/file/download.do";

	var movePage = new MovePage();
	movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	if( is_device_pc() ){
		<%-- 모바일인 경우 target 이 들어가서는 안된다. --%>
		movePage._target = "_hidden_iframe";
	}
	movePage.move();

	<%-- 모바일 웹에서 동작하지 않아서 주석처리
	var fileDownloadOnce = new FileDownloadOnce();
	fileDownloadOnce._file_seq = file_seq; fileDownloadOnce._succ_func = succ_func; fileDownloadOnce._fail_func = fail_func;
	fileDownloadOnce.download();
	--%>
}


<%-- FILE DOWNLOAD AND ADD LOG --%>
function file_down_log( file_seq, down_type, succ_func, fail_func ){
	var form_data = new FormData();
    	 form_data.append("file_seq", file_seq );
    	 form_data.append("down_type", down_type );

    var action = "/file/download.do";

	var movePage = new MovePage();
	movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	if( is_device_pc() ){
		<%-- 모바일인 경우 target 이 들어가서는 안된다. --%>
		movePage._target = "_hidden_iframe";
	}
	movePage.move();

	<%-- 모바일 웹에서 동작하지 않아서 주석처리
	var fileDownloadOnce = new FileDownloadOnce();
	fileDownloadOnce._file_seq = file_seq; fileDownloadOnce._succ_func = succ_func; fileDownloadOnce._fail_func = fail_func;
	fileDownloadOnce.download();
	--%>
}


<%--RESOURCE DOWNLOAD--%>
function resource_down( type, succ_func, fail_func ){
	var form_data = new FormData();
	 form_data.append("type", type );

	var action = "/file/resource_download.do";

	var movePage = new MovePage();
	movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	if( is_device_pc() ){
		<%-- 모바일인 경우 target 이 들어가서는 안된다. --%>
		movePage._target = "_hidden_iframe";
	}
	movePage.move();
}


<%-- POST MOVE --%>
function move_post( action, form_data ){
	var movePage = new MovePage();
		movePage._method = "POST"; movePage._action = action; movePage._formData = form_data;
	movePage.move();
}

<%-- GET MOVE --%>
function move_get( action, form_data ){
	var movePage = new MovePage();
	movePage._method = "GET"; movePage._action = action; movePage._formData = form_data;
	movePage.move();
}
<%-- PUT MOVE --%>
function move_put( action, form_data ){
	var movePage = new MovePage();
	movePage._method = "PUT"; movePage._action = action; movePage._formData = form_data;
	movePage.move();
}
<%-- DELETE MOVE --%>
function move_delete( action, form_data ){
	var movePage = new MovePage();
	movePage._method = "DELETE"; movePage._action = action; movePage._formData = form_data;
	movePage.move();
}


<%-- AJAX JSON POST --%>
function ajax_json_post( action, json, succ_func ){
	var ajaxJson = new AjaxJson();
	ajaxJson._method = "POST"; ajaxJson._action = action; ajaxJson._json = json; ajaxJson._succ_func = succ_func;
	ajaxJson.send();
}
<%-- AJAX JSON PUT --%>
function ajax_json_put( action, json, succ_func ){
	var ajaxJson = new AjaxJson();
	ajaxJson._method = "PUT"; ajaxJson._action = action; ajaxJson._json = json; ajaxJson._succ_func = succ_func;
	ajaxJson.send();
}
<%-- AJAX JSON DELETE --%>
function ajax_json_delete( action, json, succ_func ){
	var ajaxJson = new AjaxJson();
	ajaxJson._method = "DELETE"; ajaxJson._action = action; ajaxJson._json = json; ajaxJson._succ_func = succ_func;
	ajaxJson.send();
}
<%-- AJAX JSON GET --%>
function ajax_json_get( action, json, succ_func ){
	var ajaxJson = new AjaxJson();
	ajaxJson._method = "GET"; ajaxJson._action = action; ajaxJson._json = json; ajaxJson._succ_func = succ_func;
	ajaxJson.send();
}


<%-- AJAX FORMDATA POST --%>
function ajax_form_post( action, form_data, succ_func ){
	var ajaxForm = new AjaxForm();
	ajaxForm._method = "POST"; ajaxForm._action = action; ajaxForm._form_data = form_data; ajaxForm._succ_func = succ_func;
	ajaxForm.dataType  = "html";ajaxForm.async  = true;
	ajaxForm.send();
}
<%-- AJAX FORMDATA PUT --%>
function ajax_form_put( action, form_data, succ_func ){
	var ajaxForm = new AjaxForm();
	ajaxForm._method = "PUT"; ajaxForm._action = action; ajaxForm._form_data = form_data; ajaxForm._succ_func = succ_func;
	ajaxForm.send();
}
<%-- AJAX FORMDATA DELETE --%>
function ajax_form_delete( action, form_data, succ_func ){
	var ajaxForm = new AjaxForm();
	ajaxForm._method = "DELETE"; ajaxForm._action = action; ajaxForm._form_data = form_data; ajaxForm._succ_func = succ_func;
	ajaxForm.send();
}
<%-- AJAX FORMDATA GET --%>
function ajax_form_get( action, form_data, succ_func ){
	var ajaxForm = new AjaxForm();
	ajaxForm._method = "GET"; ajaxForm._action = action; ajaxForm._form_data = form_data; ajaxForm._succ_func = succ_func;
	ajaxForm.send();
}

<%-- 신규파일 구분값 --%>
function get_x_file_promise(){
	return "X_FILE_PROMISE";
}

<%-- FORM VALIDATOR 생성  --%>
function get_form_validator( _form, _form_rules, _form_messages ){
	<%-- FORM VALIDATOR 생성 --%>
	var _form_validator =
		$( _form ).validate({
				rules: _form_rules
				,messages: _form_messages
	    });

	return _form_validator;
}

<%-- FORM 의 데이터를 JSON OBJECT 로 변환한다.  --%>
$.fn.serializeObject = function(){
    var self = this,
        json = {},
        push_counters = {},
        patterns = {
            "validate": /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/,
            "key":      /[a-zA-Z0-9_]+|(?=\[\])/g,
            "push":     /^$/,
            "fixed":    /^\d+$/,
            "named":    /^[a-zA-Z0-9_]+$/
        };

    this.build = function(base, key, value){
        base[key] = value;
        return base;
    };
    this.push_counter = function(key){
        if(push_counters[key] === undefined){
            push_counters[key] = 0;
        }
        return push_counters[key]++;
    };
    $.each($(this).serializeArray(), function(){
        // Skip invalid keys
        if(!patterns.validate.test(this.name)){
            return;
        }

        var k,
            keys = this.name.match(patterns.key),
            merge = this.value,
            reverse_key = this.name;

        while((k = keys.pop()) !== undefined){

            // Adjust reverse_key
            reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), '');

            // Push
            if(k.match(patterns.push)){
                merge = self.build([], self.push_counter(reverse_key), merge);
            }

            // Fixed
            else if(k.match(patterns.fixed)){
                merge = self.build([], k, merge);
            }

            // Named
            else if(k.match(patterns.named)){
                merge = self.build({}, k, merge);
            }
        }
        json = $.extend(true, json, merge);
    });

    return json;
};


function before_page(){
	if(start_page_no == 1){
		alert('첫번째 페이지 입니다.')
		return false;
	}else{
	
	start_page_no = start_page_no - 5;
	end_page_no = start_page_no + 4;
	check_end = 'N';
	set_data(start_page_no);
	}
}

function next_page(){
	
	if(check_end == 'Y'){
		alert('마지막 페이지 입니다.')
		return false;
	}else{
	
	start_page_no = start_page_no + 5;
	end_page_no = start_page_no + 4;
	check_end = 'N';
	set_data(start_page_no);
	}
	
}

function save_search(searchType,searchPlace,searchTxt){
	var result_code = "";
	var url = '/search/saveData.do';
	var json = {"searchTxt": searchTxt,
			    "searchType": searchType, 
			    "searchPlace": searchPlace};
	
	var succ_func = function(resData, status ) {
		result_code = resData.result_code;
	};
	
	ajax_json_post(url, json, succ_func);
	
}


<%--  AJAX 버튼 더블 클릭 방지 --%>
<%--  script 상단의 sec:authentication로 로그인 정보를 불러와야 작동함 --%>
/* var isRun = '${principal.user_id}'; */
var isRun = true;



function checkIsRun() {
	
	if(isRun){
		isRun = false;
		return false;
		
	}else{
		return true;
	}
		
}

function resetIsRun() {
	isRun = true;
}


function sel_like(sel_it){
	<sec:authorize access="! isAuthenticated()">
	var html = "찜하기 기능은 로그인후에 이용하실 수 있습니다.";
		 var confirm_func = function(){
		  return false;
		 };
		
		  alert_info( html, confirm_func  );
	
	</sec:authorize>
	
/* 	var result_code = "";
	var url = '/search/saveData.do';
	var json = {"searchTxt": searchTxt,
			    "searchType": searchType, 
			    "searchPlace": searchPlace};
	
	var succ_func = function(resData, status ) {
		result_code = resData.result_code;
	};
	
	ajax_json_post(url, json, succ_func, ''); */
	
	<sec:authorize
	access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')  ">
	<sec:authentication var="principal" property="principal" />
	var isRun = '${principal.user_id}';
	var action = "/course/saveLike.do";
		var json = {"courseId" : sel_it};
		var succ_func = function( resData, status ){
			
			go_result_like(sel_it);
			
		};
		
		ajax_json_post( action, json, succ_func );
	
		</sec:authorize>
}

</script>



