<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>




<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <sec:csrfMetaTags/>
  <title> 팝업 [ <kb:springvalue name="spring.profiles" isWrite="true" /> ]</title>

  <!-- Tell the browser to be responsive to screen width -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <tiles:insertAttribute  name="head_com_js" />  <%-- 공통 스크립트 함수 --%>

  <%-- favicon image --%>
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">
  
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
	
	<!-- Select2 CSS -->
			<link rel="stylesheet" href="/assets/plugins/select2/css/select2.min.css">
	
	<!-- Bootstrap Tagsinput CSS -->
			<link rel="stylesheet" href="/assets/plugins/bootstrap-tagsinput/css/bootstrap-tagsinput.css">
	
	<!-- Feather CSS -->
	<link rel="stylesheet" href="/assets/css/feather.css">
	
	<!-- Main CSS -->
	<link rel="stylesheet" href="/assets/css/style.css">
	
	<!-- Owl Carousel CSS -->
			<link rel="stylesheet" href="/assets/css/owl.carousel.min.css">
			<link rel="stylesheet" href="/assets/css/owl.theme.default.min.css">
			
			<!-- Slick CSS -->
			<link rel="stylesheet" href="/assets/plugins/slick/slick.css">
			<link rel="stylesheet" href="/assets/plugins/slick/slick-theme.css">
	
	<!-- TOASTR -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/js/toastr/toastr.min.css' />" />
	
	<!--re-modal -->
	<link rel="stylesheet" href="<c:url value='/assets/pc/css/remodal.css'/>"/>
	<link rel="stylesheet" href="<c:url value='/assets/pc/css/remodal-default-theme.css'/>"/>

<script type="text/javascript" >

function autoSizePopup()
{
    var winResizeW=0;
    var winResizeH=0;

    $(document).ready(function() {
        //크롬, 사파리일때
        if (navigator.userAgent.indexOf('Chrome')>-1 || navigator.userAgent.indexOf('Safari')>-1)
        {
            $(window).resize(function() {

                if(winResizeW==0 && winResizeH==0)
                {
                    resizeWin();
                }
            });
        }
        //크롬, 사파리말고 모두
        else
        {
            resizeWin();
        }
    });

    function resizeWin()
    {
        var conW = $("div.wrapper").innerWidth(); //컨텐트 사이즈
        var conH = $("div.wrapper").innerHeight();

        var winOuterW = window.outerWidth; //브라우저 전체 사이즈
        var winOuterH = window.outerHeight;

        var winInnerW = window.innerWidth; //스크롤 포함한 body영역
        var winInnerH = window.innerHeight;

        var winOffSetW = window.document.body.offsetWidth; //스크롤 제외한 body영역
        var winOffSetH = window.document.body.offsetHeight;

        var borderW = winOuterW - winInnerW;
        var borderH = winOuterH - winInnerH;

        //var scrollW = winInnerW - winOffSetW;
        //var scrollH = winInnerH - winOffSetH;

        winResizeW = conW + borderW;
        winResizeH = conH + borderH;


        <%-- --%>
        if( winResizeW < 880 ){ winResizeW = 880; }

        console.log( winResizeW );
        console.log( winResizeH );

        window.resizeTo(winResizeW,winResizeH);
    }
}

function resizeWin2()
{
    var conW = $("div.wrapper").innerWidth(); //컨텐트 사이즈
    var conH = $("div.wrapper").innerHeight();

    var winOuterW = window.outerWidth; //브라우저 전체 사이즈
    var winOuterH = window.outerHeight;

    var winInnerW = window.innerWidth; //스크롤 포함한 body영역
    var winInnerH = window.innerHeight;

    var winOffSetW = window.document.body.offsetWidth; //스크롤 제외한 body영역
    var winOffSetH = window.document.body.offsetHeight;

    var borderW = winOuterW - winInnerW;
    var borderH = winOuterH - winInnerH;

    //var scrollW = winInnerW - winOffSetW;
    //var scrollH = winInnerH - winOffSetH;

    var winResizeW = conW + borderW;
    var winResizeH = conH + borderH;


    <%--
    if( winResizeW < 880 ){ winResizeW = 880; }

    console.log( winResizeW );
    console.log( winResizeH );  --%>

    window.resizeTo(winResizeW,winResizeH);
}


$(window).on("load", function(){
// 	autoSizePopup();
});

$(window).ready(function(){

<%--
	  var strDocumentWidth = $(document).outerWidth();
	  var strDocumentHeight = $(document).outerHeight();
	  window.resizeTo ( strDocumentWidth, strDocumentHeight );

	  var strMenuWidth = strDocumentWidth - $(window).width();
	  var strMenuHeight = strDocumentHeight - $(window).height();
	  var strWidth = $('div.wrapper').outerWidth() + strMenuWidth;
	  var strHeight = $('div.wrapper').outerHeight() + strMenuHeight;

	  window.resizeTo( strWidth, strHeight );
	  --%>
});


</script>

</head>


<body>
<%-- HIDDEN IFRAME 엑셀 다운로드 등에서 사용된다. --%>
<iframe src="javascript:false;" id="_hidden_iframe" name="_hidden_iframe"  style="display:none"></iframe>

	<kb:isProfile var="profile" target_profiles="local" />
	<sec:authorize var="isLogin" access="isAuthenticated()" />

<%-- TILES BODY  --%>
<tiles:insertAttribute name="body_content" />

		<!-- jQuery -->
		<!-- <script src="/assets/js/jquery-3.6.0.min.js"></script> -->
		
		<!--re-modal -->
		<script src="<c:url value='/assets/pc/js/remodal.js'/>"></script>
		
		<!-- Bootstrap Core JS -->
		<script src="/assets/js/bootstrap.bundle.min.js"></script>

		<!-- Select2 JS -->
	  	<script src="/assets/plugins/select2/js/select2.min.js"></script>

	  	<!-- Ckeditor JS -->
	  	<script src="/assets/js/ckeditor.js"></script>

		<!-- csrf js 추가 -->
		<script type="text/javascript"
			src="<c:url value='/assets/js/csrf.js'/>"></script>
	
		<!-- Bootstrap Tagsinput JS -->
			<script src="/assets/plugins/bootstrap-tagsinput/js/bootstrap-tagsinput.js"></script>
	
		<!-- Custom JS -->
		<script src="/assets/js/script.js"></script>
		
		<!-- counterup JS -->
		<script src="/assets/js/jquery.waypoints.js"></script>
		<script src="/assets/js/jquery.counterup.min.js"></script>

		<!-- Owl Carousel -->
		<script src="/assets/js/owl.carousel.min.js"></script>	

		<!-- Slick Slider -->
		<script src="/assets/plugins/slick/slick.js"></script>
		
		<!-- Sticky Sidebar JS -->
        <script src="/assets/plugins/theia-sticky-sidebar/ResizeSensor.js"></script>
        <script src="/assets/plugins/theia-sticky-sidebar/theia-sticky-sidebar.js"></script>


</body>
</html>