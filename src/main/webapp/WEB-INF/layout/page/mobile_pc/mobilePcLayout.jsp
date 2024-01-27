<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>
<%--
	메뉴가 존재하지 않는 페이지
	PC & 모바일 겸용
 --%>
<!doctype html>
<html lang="kr">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<c:if test="${ !empty currentDevice }">
	<meta name="_device_is_normal" content="${currentDevice.normal}">
</c:if>
    <sec:csrfMetaTags/>
	<title>LMS</title>
	<tiles:insertAttribute  name="head_com_js" /> <%-- 공통 스크립트 함수 --%>

    <!--re-modal -->
    <link rel="stylesheet" href="<c:url value='/assets/pc/css/remodal.css'/>"/>
    <link rel="stylesheet" href="<c:url value='/assets/pc/css/remodal-default-theme.css'/>"/>

    <!--re-modal -->
    <script src="<c:url value='/assets/pc/js/remodal.js'/>"></script>


	<%-- favicon image --%>
	<link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon">


<script type="text/javascript">
$(document).ready (function(){



});


</script>

</head>
<body>
<%-- HIDDEN IFRAME 엑셀 다운로드 등에서 사용된다. --%>
<iframe src="javascript:false;" id="_hidden_iframe" name="_hidden_iframe"  style="display:none"></iframe>


<%-- TILES BODY  --%>
<tiles:insertAttribute name="body_content" />

</body>
</html>
