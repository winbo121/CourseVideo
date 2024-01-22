<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>

<!-- Breadcrumb -->
<div class="page-banner instructor-bg-blk">
	<div class="container">
		<div class="row align-items-center">
			<div class="col-lg-6 col-md-12">
				<div class="instructor-profile d-flex align-items-center">
					<div class="instructor-profile-pic">
						<a href="jvascript:void(0);"> 
								<c:choose>
									<c:when test="${!empty userImg}">
										<img src="${userImg.img_url}" style="width:100px;height:100px;" alt="" class="img-fluid">
									</c:when>
									<c:otherwise>
										<img src="/assets/img/instructor/ttl-stud-icon.png" style="width:100px;height:100px;" alt="" class="img-fluid">
									</c:otherwise>
								</c:choose>
						</a>
					</div>
					<sec:authentication var="principal" property="principal" />
					<div class="instructor-profile-content">
						<h4>
							<a href="javascript:void(0)">${principal.user_name} <!-- <span>Beginner</span> --></a>
						</h4>
						<p>${principal.role_type}</p>
					</div>
				</div>							
			</div>
			<div class="col-lg-6 col-md-12">
				<div class="instructor-profile-menu">
					<ul class="nav">
						<li>
							<div class="d-flex align-items-center">
								<div class="instructor-profile-menu-img">
									<img src="/assets/img/icon/icon-25.svg" alt="">
								</div>
								<div class="instructor-profile-menu-content">
									<h4>${totalStatistic.tot_course_cnt}</h4>
									<p>총 강좌 수</p>
								</div>
							</div>
						</li>
						<li>
							<div class="d-flex align-items-center">
								<div class="instructor-profile-menu-img">
									<img src="/assets/img/icon/icon-26.svg" alt="">
								</div>
								<div class="instructor-profile-menu-content">
									<h4>${totalStatistic.tot_user_cnt}</h4>
									<p>총 회원 수</p>
								</div>
							</div>
						</li>
						<li>
							<div class="d-flex align-items-center">
								<div class="instructor-profile-menu-img">
									<img src="/assets/img/icon/icon-27.svg" alt="">
								</div>
								<div class="instructor-profile-menu-content">
									<h4>${totalStatistic.tot_score_cnt}</h4>
									<p>총 리뷰 수</p>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-md-12">
				<div class="instructor-profile-text">
					<p>${principal.role_type} 계정입니다. 강좌,콘텐츠와 통계기능을 관리할 수 있습니다.</p>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- /Breadcrumb -->