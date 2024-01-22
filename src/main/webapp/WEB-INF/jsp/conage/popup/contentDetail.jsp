<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>


<jsp:include page="/WEB-INF/jsp/conage/contentEnrollDetail.jsp"/>

<%-- 기존 update 문 override --%>
<script type="text/javascript">
$(document).ready (function(){
	
	$(".ticket-btn-grp").hide();
	
	$("#cancel_btn").unbind("click").on("click", function() {
		self.close();
	});
	
	$("#update_btn").unbind("click").on("click", function() {
		<%--  더블 클릭 방지 --%>
		if(checkIsRun()) {
			return false;
		}
		
		var descr = editor.getData();
		$("#contents_descr").val(descr);
		
		<%-- 유효성 체크 --%>
		initFormValidator();
		var is_valid = $("#contents").valid();
		if( is_valid != true  ){
			resetIsRun();
			return false;
		}
		
		var formdata = $("#contents")[0];
		var form_data = new FormData(formdata);
		var mode = "${mode}";
		if(mode == 'N') {
			form_data.append("vod_gb", $("#vod_gb").val());
		}
		
		//썸네일 append
		if($("#vod_file").val()){
			getThumbnail(form_data);
		}
		
		loading_show();
		var succ_func = function(resData, status ) {
			var result = resData.result;
			
			loading_hidden();
			if(result == 'success') {
				var confirm_func = function() {
					opener.setContent(form_data);
					self.close();
				};
				
				alert_success( "수정하였습니다.", confirm_func );
			} else {
				alert_error( resData.msg, null );
			}
			resetIsRun();
		};
		
		ajax_form_put("/conage/contentEnroll/update.do", form_data, succ_func);
	});
});
</script>