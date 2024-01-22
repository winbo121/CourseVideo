<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<script type="text/javascript">

$(document).ready (function(){

	<%-- 비밀번호 변경 --%>
	$("#btn_reset_pass").on("click",function(){
		<%--  더블 클릭 방지 --%>
		if(checkIsRun()) {
			return;
		}
		
		<%-- 유효성 체크 --%>
		var is_valid = $("#userInfo2").valid();
		console.log(is_valid,"유효성 체크");
		if( is_valid != true  ){
			
			<%-- 더블 클릭 방지 리셋 --%>
			resetIsRun();
			
			return;
		}
		
		var formdata = $("#userInfo2")[0];
		var form_data = new FormData(formdata);
		
		var succ_func = function(resData, status ) {
			var result = resData.result;
			
			if(result == 'success') {
				var confirm_func = function() {
					//location.href="/myprofile/profileMain/index.do";
					$(".remodal-close").click();
				};					
				
				alert_success( "비밀번호가 변경되었습니다.", confirm_func );
			} else {
				
				<%-- 더블 클릭 방지 리셋 --%>
				resetIsRun();
				
				alert_error( resData.msg, null );
			}
		};
		
		ajax_form_put("/myprofile/profileMain/update.do", form_data, succ_func);
		
	});	
	
	<%-- FORM VALIDATOR 초기화 --%>
	initFormValidator2();
	

	
});

</script>
<script>
<%-- FORM  유효성 체크 --%>
var _form_validator2 = null;

<%-- FORM VALIDATOR 초기화  --%>
function initFormValidator2(){
	<%-- VALIDATOR 대상 FORM  --%>
	var _form2 = $("#userInfo2");

	var _form_rules2 = null;
	var _form_messages2 = null;
	
	_form_rules2 = {
			 user_pw: { required:true, userPassword1:true
				 						, userPassword2:true
				 						, userPassword3:true
				 						, userPassword4:true
				 						, userPassword5:true
				 						, userPassword6:true
				 						, userPassword7:true
				 						, userPassword8:true }
			 ,user_pw_confirm: { required:true , equalTo: 'input[name=user_pw]'  }
		 };

		_form_messages2 = {
			user_pw_confirm:{
				equalTo: '비밀번호와 같아야합니다.'
			}
		};

	if( _form_validator2 != null ){
		_form_validator2.settings.rules = _form_rules2;
		_form_validator2.settings.messages = _form_messages2;
	}else{
		_form_validator2 = get_form_validator( _form2, _form_rules2, _form_messages2   );
	}

}
</script>

<div class="remodal" role="dialog" data-remodal-id="repass">
	<button data-remodal-action="close" class="remodal-close"
		aria-label="Close"></button>
	<div class="modal-content">
		<div class="modal-body">
			<div class="row">
			<h1>비밀번호 변경</h1>
				<form id="userInfo2">
				<div class="form-group">
					<label class="form-control-label">변경 비밀번호</label>
					<div class="pass-group" id="passwordInput">																	
						<input type="password" name="user_pw" class="form-control pass-input" placeholder="비밀번호 입력" data-valid-name="비밀번호">
						<span class="toggle-password feather-eye"></span>
						<span class="pass-checked"><i class="feather-check"></i></span>
					</div>
					<div  class="password-strength" id="passwordStrength">
						<span id="poor"></span>
						<span id="weak"></span>
						<span id="strong"></span>
						<span id="heavy"></span>
					</div>
					<div id="passwordInfo"></div>	
				</div>
				<div class="form-group">
					<label class="form-control-label">변경 비밀번호 확인</label>
					<div class="pass-group" id="passwordInputs">																	
						<input type="password" name="user_pw_confirm" class="form-control pass-input" placeholder="비밀번호 재입력" data-valid-name="비밀번호 재입력">
						<span class="toggle-password feather-eye"></span>
						<span class="pass-checked"><i class="feather-check"></i></span>
					</div>
					<div  class="password-strength" id="passwordStrengths">
						<span id="poors"></span>
						<span id="weaks"></span>
						<span id="strongs"></span>
						<span id="heavys"></span>
					</div>
					<div id="passwordInfos"></div>	
				</div>
				<div class="d-grid">
					<button class="btn btn-primary btn-start" type="button" id="btn_reset_pass">비밀번호 변경</button>
				</div>
				</form>
			</div>
	</div>
		</div>
		<div class="modal-footer justify-content-between">
			<!-- <button data-remodal-action="cancel" class="remodal-cancel">닫기</button> -->
			<!-- <button class="remodal-confirm" id="ins_chk_contents">변경</button> -->
		</div>
	<!-- /.modal-content -->

</div>

		<!-- Validation-->
		<script src="/assets/js/validation.js"></script>	
