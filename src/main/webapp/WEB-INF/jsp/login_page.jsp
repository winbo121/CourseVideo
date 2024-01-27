<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<!-- Favicon -->
		<link rel="shortcut icon" type="image/x-icon" href="assets/img/favicon.svg">
		
		<!-- Bootstrap CSS -->
		<link rel="stylesheet" href="/assets/css/bootstrap.min.css">
		
		<!-- Fontawesome CSS -->
		<link rel="stylesheet" href="/assets/plugins/fontawesome/css/fontawesome.min.css">
		<link rel="stylesheet" href="/assets/plugins/fontawesome/css/all.min.css">

		<!-- Owl Carousel CSS -->
		<link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
		<link rel="stylesheet" href="/assets/css/owl.theme.default.min.css">
		
		<!-- Feathericon CSS -->
        <link rel="stylesheet" href="/assets/plugins/feather/feather.css">

		<!-- Main CSS -->
		<link rel="stylesheet" href="/assets/css/style.css">


<script type="text/javascript" >
$(document).ready (function(){
	
	$("#user_id, #user_pw").on("keydown", function(key) {
		if (key.keyCode == 13) {
			var id = $("#user_id").val().trim();
			var pw = $("#user_pw").val();
			if(id == ''){
				alert_error("아이디를 입력 바랍니다.");
				$("#user_id").focus();
				return;
			} else if(pw == ''){
				alert_error("비밀번호를 입력 바랍니다.");
				$("#user_pw").focus();
				return;
			} else {
				$("#btn_ajaxlogin").click();	
			}
			
		}
	});
	
	<%-- 로그인 버튼 클릭시 --%>
	$("#btn_login").click(function(){
		$("#login").submit();		
	});
	
	<%-- AJAX 로그인 버튼 클릭시 --%>
	$("#btn_ajaxlogin").click(function(){
		<%--  더블 클릭 방지 --%>
		if(checkIsRun()) {
			return;
		}
		
		var formdata = $("#login")[0];
		var form_data = new FormData(formdata);
		var json = $("#login").serialize();
		
		var succ_func = function(resData, status ) {
			var result = resData.result;
			if(result == 'success') {
				var confirm_func = function() {
					location.href="/";
				};
				
				alert_success( resData.msg, confirm_func );
			} else {
				
				<%-- 더블 클릭 방지 리셋 --%>
				resetIsRun();
				
				alert_error( resData.msg, null );
			}
		};
		try {
			
			ajax_json_post("/ajax_login.do", json, succ_func);
			//ajax_form_post("/ajax_login.do", form_data, succ_func);
			
		} catch (error) {
			
			<%-- 더블 클릭 방지 리셋 --%>
			resetIsRun();
			
			alert_error( "아이디 또는 비밀번호를 확인 바랍니다.", null );	
		}
		

	});
	
	//일반 회원가입 클릭시
	$("#userLogin").on( "click", function(){
		var role_type = "ROLE_USER";
		var url = $( this ).data( "url" );
		var form_data = new FormData();
		var token = "${_csrf.token}";
		form_data.append("role_type", role_type );
		form_data.append("_csrf", token );
		
		move_post( url, form_data );
		
		
	});
	
	<%-- 아이디 저장 쿠키의 key --%>
	var cookie_remember_id_key = "${cookie_remember_id_key}";
	
	<%-- 아이디 저장 쿠키가 존재하는지 여부 --%>
	var has_remember_id_check = document.cookie.indexOf( cookie_remember_id_key ) != -1;
	
	<%-- 아이디 저장 쿠키가 남아있다면 --%>
	if( has_remember_id_check == true ) {
		
		<%-- 각 쿠키 리스트는 세미콜론으로 구분되므로 세미콜론으로 split 해서 배열로 만든다. --%>
		var cookie_array = document.cookie.split( ";" );
		$( cookie_array ).each( function( index, cookie ) {
			
			<%-- 맨 앞에 공백이 존재하는 경우가 존재하므로 공백 처리를 해준다. --%>
			if( cookie.charAt(0) === " " ){
				cookie = cookie.substring( 1 );
			}
			
			<%-- 쿠키를 읽어들여서 아이디와 체크박스 값 세팅 --%>
			if( cookie.indexOf( cookie_remember_id_key ) != -1 ) {
				var remember_id = cookie.slice( "_KOTECHLMS_REMEMBER_ID_".length + 1, cookie.length );
				$( "#remember_id" ).prop( "checked", true );
				$( "#user_id" ).val( remember_id ); 
				return;
			}
		});
		
	}
	
});
</script>
    <div class="main-wrapper log-wrap">
		
			<div class="row">
			
				<!-- Login Banner -->
				<div class="col-md-6 login-bg">
					<div class="owl-carousel login-slide owl-theme">
						<div class="welcome-login">
							<div class="login-banner">
								<img src="/assets/img/login-img.png" class="img-fluid" alt="Logo">
							</div>
							<div class="mentor-course text-center">
								<h2>Welcome to <br>LMS Courses.</h2>
								<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.</p>
							</div>
						</div>
						<!-- <div class="welcome-login">
							<div class="login-banner">
								<img src="/assets/img/login-img.png" class="img-fluid" alt="Logo">
							</div>
							<div class="mentor-course text-center">
								<h2>Welcome to <br>LMS Courses.</h2>
								<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.</p>
							</div>
						</div> -->
					</div>
				</div>
				<!-- /Login Banner -->
				
				<div class="col-md-6 login-wrap-bg">		
				
					<!-- Login -->
					<div class="login-wrapper">
						<div class="loginbox">
							<div class="w-100">
								<div class="img-logo">
<!-- 									<img src="/assets/img/logo.png" class="img-fluid" alt="Logo"> -->
									<div class="back-home">
										<a href="/">메인화면으로</a>
									</div>
								</div>
								<h1>로그인</h1>
								<form:form modelAttribute="login" method="post" action="${pageContext.request.contextPath}/login.do" >    
									<div class="form-group">
										<label class="form-control-label">아이디</label>
										<form:input path="user_id" type="text" placeholder="아이디" class="form-control" value=""/>
									</div>
									<div class="form-group">
										<label class="form-control-label">비밀번호</label>
										<div class="pass-group">
											<form:password path="user_pw"   placeholder="비밀번호" maxLength="30" class="form-control pass-input" value=""/>
											<!-- <input type="password" class="form-control pass-input" placeholder="비밀번호"> -->
											<span class="feather-eye toggle-password"></span>
										</div>
									</div>
									<div class="forgot">
										<span><a class="forgot-link" href="javascript:void(0);">비밀번호를 잊어 버렸나요?</a></span>
									</div>
									<div class="remember-me">
										<label class="custom_check mr-2 mb-0 d-inline-flex remember-me"> 아이디 저장  
											<input type="checkbox" name="remember_id" id="remember_id">
											<span class="checkmark"></span>
										</label>
									</div>
									<div class="d-grid">
										<%-- <button  id="btn_login" class="btn btn-primary btn-start" type="button">로그인</button>--%>
										<button  id="btn_ajaxlogin" class="btn btn-primary btn-start" type="button">로그인</button>
									</div>
								</form:form> 
							</div>
						</div>
						<!-- <div class="google-bg text-center">
							<span><a href="#">Or sign in with</a></span>
							<div class="sign-google">
								<ul>
									<li><a href="#"><img src="/assets/img/net-icon-01.png" class="img-fluid" alt="Logo"> Sign In using Google</a></li>
									<li><a href="#"><img src="/assets/img/net-icon-02.png" class="img-fluid" alt="Logo">Sign In using Facebook</a></li>
								</ul>
							</div>
							
						</div> -->
						<div class="google-bg text-center">
							<jsp:include page="oAuth/loginOauth.jsp"/>
							<span><a href="#">Or sign in with</a></span>
							<div class="sign-google">
								<ul>
								<li></li>
									<li>
									<a id="userLogin" data-method="POST"
									class="nav-link signin-three-head" data-url="/rules_page.do"
									href="javascript:void(0)">회원 가입</a></li>
								</ul>
							</div>
							
						</div>
					</div>
					<!-- /Login -->
					
				</div>
				
			</div>
		   
	   </div>
	   
	    <!-- /Main Wrapper -->
	  
		<!-- jQuery -->
		<script src="/assets/js/jquery-3.6.0.min.js"></script>
		
		<!-- Bootstrap Core JS -->
		<script src="/assets/js/bootstrap.bundle.min.js"></script>

		<!-- Owl Carousel -->
		<script src="/assets/js/owl.carousel.min.js"></script>	
		
		<!-- Custom JS -->
		<script src="/assets/js/script.js"></script>

