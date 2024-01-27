<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<script type="text/javascript" >
$(document).ready (function(){
	<%-- 메일 발송 버튼 클릭시 --%>
	$("#btn_email_certification").on( "click", function(){
		var emailCheck = RegExp( /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/ );
		if( ! emailCheck.test( $("#email").val() ) ){
			alert_warning( "이메일이 유효하지 않습니다.", null );
			return;
		}
		
		$("#email").prop("readonly",true);
		$("#btn_email_certification").prop('disabled', true);
		
		<%-- 이메일 인증 --%>
		var action = "/authentication_email.do";
		
		var form_data = new FormData( $( "#signup" )[0] );
		var succ_func = function( resData, status ){
			
			var is_already_user_email = resData.isAlreadyUserEmail;
			
			if( is_already_user_email == true ) {
				
				$("#email").removeAttr("readonly");
				$("#btn_email_certification").removeAttr('disabled');
				
				alert_warning( "이미 사용중인 이메일입니다.", null );
				return false;
			}
			
			alert_success( "발송되었습니다. 이메일을 통해 가입을 진행해 주세요.", null );
		}
		
		ajax_form_post( action, form_data, succ_func );
		
		
	});

	<%-- form submit  --%>
	$("#signup").submit(function() {
		return false;
	});

	<%-- 로그인 링크 클릭시 --%>
	$("._2HSkKzK52EGNdMxxw32hwS").on( "click", function(){
		move_get( "/login/loginMain/index.do", null );
	});


});




</script>

<link rel="stylesheet" href="<c:url value='/styles/bootstrap.min.css'/>" >
<link rel="stylesheet" href="<c:url value='/styles/login.css'/>">

<div id="app">
	<section class="_1DWYPoRL0QljP7xf5wZdtW">
		<form:form modelAttribute="signup">
			<form:hidden path="role_type"/>
			<form:hidden path="terms_yn"/>
			<form:hidden path="consent_yn"/>
	
			<div class="UoHqaUkevwrvJbwERySSt">
				<div class="_38wHjPwZlDoJPr9W-xySh _11sHgd9B8OCSX70aYZL0wk">
						LMS 회원 가입
				</div>
			</div>
	
			<div class="mt40">
	            <div class="email-info mb30 text-center">
	                <img src="<c:url value='/assets/pc/images/login/email_join.png'/>">
	                <h4 class="mt30">이메일 인증</h4>
	                <p>아래 입력된 이메일로 인증 메일을 발송합니다.<br>이메일을 입력하고 <span class="color">메일 발송</span> 버튼을 클릭하세요.<br>받으신 이메일의 <span class="color">회원 가입하러 가기</span> 버튼을 클릭하면 인증이 완료됩니다.</p>
	            </div>
				<div class="_3r8UdvnjCUKW78BTIsh43f">
					<div class="_1SEj5DUSRdWttGiLyovDY0">
						<form:input path="email" placeholder="이메일"  autocomplete="off" cssClass="form-control-lg form-control"
									   data-valid-name="이메일"  />
						<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" id="btn_email_certification"><span>메일 발송</span></button>
					</div>
				</div>
	
				<div class="Khgcot06J7xIcqTkU4kzX _38xG3sOUag2Xj5TM649sAw">
					<span>이미 계정이 있으세요?</span>
					<a class="_2HSkKzK52EGNdMxxw32hwS" href="javascript:void(0);"><span>로그인</span></a>
				</div>
			</div>
			<p class="_2d-xByT7Z84eA5s0I_vt_e USormlxqXIIh6_cCv9jhX">
				<span>CopyRightⓒ2023 . All Rights Reserved.
				</span>
				<a href="/"><span style="color : red;"> 홈으로가기</span></a>
			</p>
		</form:form>
	</section>
</div>


