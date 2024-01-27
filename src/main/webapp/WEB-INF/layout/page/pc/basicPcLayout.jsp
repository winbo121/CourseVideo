<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>

<!doctype html>
<html lang="kr">
<head>

<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=0" />
<meta name="Keywords" content="LMS" />
<meta name="Description" content="코테크시스템 LMS" />
<meta id="_csrf" name="_csrf" content="${_csrf.token}" />
<meta id="_csrf_header" name="_csrf_header" content="${_csrf.headerName}">
<title> LMS</title>

<tiles:insertAttribute name="head_com_js" />

<!-- Favicon -->
<link rel="shortcut icon" type="image/x-icon"
	href="/assets/img/favicon.svg">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="/assets/css/bootstrap.min.css">

<!-- Fontawesome CSS -->
<link rel="stylesheet"
	href="/assets/plugins/fontawesome/css/fontawesome.min.css">
<link rel="stylesheet"
	href="/assets/plugins/fontawesome/css/all.min.css">

<!-- Owl Carousel CSS -->
<link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
<link rel="stylesheet" href="/assets/css/owl.theme.default.min.css">

<!-- Feathericon CSS -->
<link rel="stylesheet" href="/assets/plugins/feather/feather.css">

<!-- Slick CSS -->
<link rel="stylesheet" href="/assets/plugins/slick/slick.css">
<link rel="stylesheet" href="/assets/plugins/slick/slick-theme.css">

<!-- Select2 CSS -->
<link rel="stylesheet"
	href="/assets/plugins/select2/css/select2.min.css">

<!-- Swiper CSS -->
<link rel="stylesheet" href="/assets/plugins/swiper/css/swiper.min.css">

<!-- Aos CSS -->
<link rel="stylesheet" href="/assets/plugins/aos/aos.css">

<!-- Main CSS -->
<link rel="stylesheet" href="/assets/css/style.css">

<!-- TOASTR -->
<link rel="stylesheet" type="text/css" href="<c:url value='/js/toastr/toastr.min.css' />" />

<style>
/* 학습이력 버튼 drop down hover 기능 추가 및 기존 css override */
.header-navbar-rht .user-nav:hover .dropdown-menu {
	visibility: visible;
	opacity: 1;
	margin-top: 0;
	-webkit-transform: translateY(100px);
	-ms-transform: translateY(100px);
	transform: translateY(100px);
	
}
.header-navbar-rht .dropdown-toggle.show + .dropdown-menu {
	visibility: visible;
	opacity: 1;
	margin-top: 0;
	-webkit-transform: translateY(0);
	-ms-transform: translateY(0);
	transform: translateY(0);
}
.header-navbar-rht li .dropdown-menu {
	visibility: hidden;
	opacity: 0;
	-webkit-transition: all .2s ease;
	transition: all .2s ease;
	display: block;
	-webkit-transform: translateY(-100px);
	-ms-transform: translateY(-100px);
	transform: translateY(-100px);
}
</style>



<!-- <script type="text/javascript">
	$(document).ready(function() {
		
		alert('23 45');
		
	});
</script> -->

</head>
<body>

	<%-- HIDDEN IFRAME 엑셀 다운로드 등에서 사용된다. --%>
	<iframe src="javascript:false;" id="_hidden_iframe"
		name="_hidden_iframe" style="display: none"></iframe>
	<kb:isUrl var="_is_url_" role_type="_role_type_"/>
	<kb:isProfile var="profile" target_profiles="local" />
	<sec:authorize var="isLogin" access="isAuthenticated()" />
<body class="home-three">



	<!-- Main Wrapper -->
	<div class="main-wrapper">

		<!-- Header -->
		<header class="header-three">
			<div class="header-fixed-three header-fixed">
				<nav class="navbar navbar-expand-lg header-nav-three scroll-sticky">
					<div class="container">
						<div class="navbar-header">
							<a id="mobile_btn" href="javascript:void(0);"> <span
								class="bar-icon"> <span></span> <span></span> <span></span>
							</span>
							</a>
<!-- 							 <a href="/" class="navbar-brand logo"> <img -->
<!-- 								src="/assets/img/logo/logo.png" class="img-fluid" alt="Logo"> -->
<!-- 							</a> -->
						</div>
						<div class="main-menu-wrapper">
							<div class="menu-header">
								<a href="/" class="menu-logo"> <img
									src="/assets/img/logo/logo.png" class="img-fluid" alt="Logo">
								</a> <a id="menu_close" class="menu-close"
									href="javascript:void(0);"> <i class="fas fa-times"></i>
								</a>
							</div>

							<ul class="main-nav">
								<kb:menu var="_top_menus_" />
								<c:forEach var="top_menu" items="${_top_menus_}"
									varStatus="status">
									<li class="has-submenu"><a href="#">${top_menu.name} <i
										class="fas fa-chevron-down"></i></a>
										<ul class="submenu">
											<c:forEach var="child_menu" items="${top_menu.lv2_menus}">
												<li><a href="#" data-url="${child_menu.index_url}"
													data-target="${child_menu.target }"
													data-role="${child_menu.menu_role }">${child_menu.name}</a></li>
											</c:forEach>
										</ul></li>
								</c:forEach>
								
								<sec:authorize access="! isAuthenticated()">
								<li class="login-link">
										<a href="/login_page.do">로그인 / 회원가입</a>
								</li>
								</sec:authorize>
								<sec:authorize
							access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')  ">
							
									<li class="login-link">
									<a class="dropdown-item" href="/myprofile/profileMain/index.do">  내 프로필</a>
									</li>
								
									<li class="login-link">
									<a class="dropdown-item" href="/mystudy/myStudyHistory/index.do">학습이력</a>
									</li>
							
									<li class="login-link">
										<a class="dropdown-item" id="login-out2" data-method="POST"
									class="nav-link login-three-head button" data-url="/logout.do" href="javascript:void(0)"> 로그아웃</a>
									</li>
								</sec:authorize>
								
							</ul>

						</div>
						<sec:authorize access="! isAuthenticated()">
							<ul class="nav header-navbar-rht align-items-center">
								<li class="nav-item"><a
									class="nav-link login-three-head button"
									href="/login_page.do"><span><!-- Login -->로그인</span></a></li>
								<li class="nav-item"><a id="userLogin" data-method="POST"
									class="nav-link signin-three-head" data-url="/rules_page.do"
									href="javascript:void(0)"><span><!-- Register -->회원가입</span></a></li>

							</ul>
						</sec:authorize>
						<sec:authentication var="principal" property="principal" />

						<!-- 로그인 했을 때 -->
						<sec:authorize
							access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')  ">
							
							<ul class="nav header-navbar-rht">
							<li><span style="font-weight: bold;">${principal.user_name}</span>님 환영합니다</li>
							<li class="nav-item user-nav">
									<a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">
										<span class="user-img">
											<c:if test="${empty userImg }">
												<img src="/assets/img/instructor/ttl-stud-icon.png" alt="">
											</c:if>
											<c:if test="${!empty userImg }">
												<img src="${userImg.img_url}" alt="">
											</c:if>
											<span class="status online"></span>
										</span>
									</a>
							
								<div class="users dropdown-menu dropdown-menu-right" data-popper-placement="bottom-end" >
										<div class="user-header">
										
											<div class="avatar avatar-sm">
												<c:if test="${empty userImg }">
													<img src="/assets/img/instructor/ttl-stud-icon.png" alt="User Image" class="avatar-img rounded-circle">
												</c:if>
												<c:if test="${!empty userImg }">
													<img src="${userImg.img_url}" alt="User Image" class="avatar-img rounded-circle">
												</c:if>
											</div>
											<div class="user-text">
												<h6>${principal.user_id}</h6>
												<p class="text-muted mb-0">${principal.role_type}</p>
											</div>
										</div>
										<a class="dropdown-item" href="/myprofile/profileMain/index.do"><i class="feather-user me-1"></i> 내 프로필</a>
										<a class="dropdown-item" href="/mystudy/myStudyHistory/index.do"><i class="feather-home me-1"></i> 학습이력</a>
										<!-- <a class="dropdown-item" href="/"><i class="feather-star me-1"></i> Edit Profile</a>
										<div class="dropdown-item night-mode">
											<span><i class="feather-moon me-1"></i> Night Mode </span>
											<div class="form-check form-switch check-on m-0">
												<input class="form-check-input" type="checkbox" id="night-mode">
											</div>
										</div> -->
										<a class="dropdown-item" id="login-out" data-method="POST"
									class="nav-link login-three-head button" data-url="/logout.do" href="javascript:void(0)"><i class="feather-log-out me-1"></i> 로그아웃</a>
								</div>
							</li>
							
							</ul>
						</sec:authorize>

					</div>
				</nav>
			</div>
		</header>





		<%-- TILES BODY  --%>
		<tiles:insertAttribute name="body_content" />


		<!-- Footer -->
		<footer class="footer footer-three">

			<!-- Footer Top -->
			<div class="footer-three-top" data-aos="fade-up">
				<div class="container">
					<div class="footer-three-top-content">
						<div class="row align-items-center">
							<div class="col-lg-6 col-md-6 col-12">

								<!-- Footer Widget -->
								<div class="footer-widget-three footer-about">
<!-- 									<div class="footer-three-logo"> -->
<!-- 										<img class="img-fluid" src="/assets/img/logo/white_logo.png" -->
<!-- 											alt="logo"> -->
<!-- 									</div> -->
									<div class="footer-three-about">
										<p>
											Get the best with the best technology! <br />It's going to
											be the world's best in the field of OCR, OPEN edX,
											U-Learning, SI.
										</p>
									</div>

								</div>
								<!-- /Footer Widget -->

							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /Footer Top -->
			<!-- Footer Bottom -->
			<div class="footer-three-bottom" data-aos="fade-up">
				<div class="container">

					<!-- Copyright -->
					<div class="copyright-three">
						<div class="row">
							<div class="col-md-4">
								<div class="social-icon-three">
									<h6>Connect Socially</h6>
								</div>
							</div>
							<div class="col-md-4">

							</div>
							<div class="col-md-4">
								<div class="copyright-text-three">
									<p class="mb-0">&copy; 2023 LMS. All rights
										reserved.</p>
								</div>
							</div>
						</div>
					</div>
					<!-- /Copyright -->
					
					
					<div style="height: 3px; text-align: center;" id="testd">
			<kb:isProfile target_profiles="local">
				<%-- 로컬환경, 개발환경에서만 출력 --%>
			 <a href="javascript:void(0);" data-url="/testfile/sample_file.do">[파일]</a>&nbsp;&nbsp;
			 <a href="javascript:void(0);" data-url="/test/sweet_alert.do">[스위트
					얼랏]</a>&nbsp;&nbsp;
			 <a href="javascript:void(0);" data-url="/test/jquery_validator.do">[유효성체크]</a>&nbsp;&nbsp;
			 <a href="javascript:void(0);" data-url="/test/modal.do">[모달]</a>&nbsp;&nbsp;
			 <a href="javascript:void(0);" data-url="/test/datatable_paging.do">[데이터테이블]</a>&nbsp;&nbsp;
			 <a href="javascript:void(0);" data-url="/test/jsp_paging.do">[JSP
					페이징]</a>
			</kb:isProfile>
		</div>
					
				</div>
			</div>
			<!-- /Footer Bottom -->
			
				
			

		</footer>
		<!-- /Footer -->

	</div>
	<!-- /Main Wrapper -->




	<!-- jQuery -->
	
	<!-- jQuery -->
		<!-- <script src="/assets/js/jquery-3.6.0.min.js"></script> -->

	<script type="text/javascript"
		src="<c:url value='/assets/pc/js/vendor/jquery/jquery.easing.1.3.js'/>"></script>
	<script type="text/javascript"
		src="<c:url value='/assets/pc/js/vendor/jquery/jquery-ui-1.11.4.custom/jquery-ui.min.js'/>"></script>
	<!--re-modal -->
	<script src="<c:url value='/assets/pc/js/remodal.js'/>"></script>

	<!-- Bootstrap Core JS -->
	<script src="/assets/js/bootstrap.bundle.min.js"></script>

	<!-- Owl Carousel JS -->
	<script src="/assets/js/owl.carousel.min.js"></script>

	<!-- Aos -->
	<script src="/assets/plugins/aos/aos.js"></script>

	<!-- counterup JS -->
	<script src="/assets/js/jquery.waypoints.js"></script>
	<script src="/assets/js/jquery.counterup.min.js"></script>

	<!-- Select2 JS -->
	<script src="/assets/plugins/select2/js/select2.min.js"></script>

	<!-- Slick Slider -->
	<script src="/assets/plugins/slick/slick.js"></script>

	<!-- Swiper Slider -->
	<script src="/assets/plugins/swiper/js/swiper.min.js"></script>

	<!-- csrf js 추가 -->
	<script type="text/javascript"
		src="<c:url value='/assets/js/csrf.js'/>"></script>



	<!-- Custom JS -->
	<script src="/assets/js/script.js"></script>

	<script type="text/javascript">
	$(document).ready(function() {
		

		
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
	
	
		
		
	//HEADER TOP MENU 클릭시 이동
	$(".submenu").on( "click", "a", function(){
		var clicked_anchor = $( this );
		var menu_role = $( clicked_anchor ).data("role");
		var url = 	$( clicked_anchor ).data("url")+"?mobileTrue=N";
		
			if( $.isEmptyObject( url ) ){
				var target_anchor = $( clicked_anchor ).parent("li").children("ul").find("a").first();
				url = 	$( target_anchor ).data("url");
			}
			if( !$.isEmptyObject( url ) ){
				move_get( url, null );
			}
		
	});
	
	$("#login-out").on( "click", function(){
		var url = $( this ).data( "url" );
		move_post( url, null );
	});
	
	$("#login-out2").on( "click", function(){
		var url = $( this ).data( "url" );
		move_post( url, null );
	});
	
	
	
	
	//샘플 코드 클릭시 이동
	$("#testd").on( "click", "a", function(){
		var clicked_anchor = $( this );
		var url = 	$( clicked_anchor ).data("url");
		var method = $( clicked_anchor ).data("method");
		var form_data = new FormData();
		var token = "${_csrf.token}";
		form_data.append("_csrf", token );
		
		if( method == "POST" ){
			move_post( url, null );
		}else{
			move_get( url, null );
		}
	});
	
	
	});
	
	
	
</script>




</body>


</html>
