<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>
<script>

$(document).ready(function(){
	
	<%-- 탭 이동 --%>
	$(document).on("click",".tab",function(){
		var tab = $(this).attr("id");
		var url = "/";
		if(tab == "profile" ) {
			url = "/myprofile/profileMain/index.do";
		}
		if(tab == "study" ) {
			url = "/mystudy/myStudyHistory/index.do";
		}
		if(tab == "delete" ){
			url = "/myprofile/profileDelete/index.do";
		}
		
		location.href = url;
	});

});
</script>
<!-- Breadcrumb -->
			<div class="course-student-header">
				<div class="container">
					<div class="student-group">
						<div class="course-group ">
							<div class="course-group-img d-flex">
								<!-- <a href="student-profile.html"><img src="/assets/img/user/user11.jpg" alt="" class="img-fluid"></a> -->
								<c:choose>
									<c:when test="${!empty userImg}">
										<img src="${userImg.img_url}" style="width:100px;height:100px;" alt="" class="img-fluid">
									</c:when>
									<c:otherwise>
										<img src="/assets/img/instructor/ttl-stud-icon.png" style="width:100px;height:100px;" alt="" class="img-fluid">
									</c:otherwise>
								</c:choose>
								
								<sec:authentication var="principal" property="principal" />
								<div class="d-flex align-items-center">
									<div class="course-name">
										<h4><a href="javascript:void(0)">${principal.user_name}</a></h4>
									<p>${principal.role_type}</p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="my-student-list">
						<ul>
							<li><a class="tab <c:if test='${tab eq "profile" }'>active</c:if>" href="javascript:void(0);" id="profile">내 프로필</a></li>
							<li><a class="tab <c:if test='${tab eq "study" }'>active</c:if>"href="javascript:void(0);" id="study">학습 이력</a></li>
							<li><a class="tab <c:if test='${tab eq "delete" }'>active</c:if>"href="javascript:void(0);" id="delete">회원 탈퇴</a></li>
						</ul>
					</div>
				</div>
			</div>
<!-- /Breadcrumb -->