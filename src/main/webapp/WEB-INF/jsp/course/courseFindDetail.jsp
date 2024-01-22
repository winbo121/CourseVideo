<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
#myform fieldset{
    display: inline-block;
    direction: rtl;
    border:0;
}
#myform fieldset legend{
    text-align: right;
}
#myform input[type=radio]{
    display: none;
}
#myform label{
    font-size: 3em;
    color: transparent;
    text-shadow: 0 0 0 #f0f0f0;
}
#myform label:hover{
    text-shadow: 0 0 0 rgba(250, 208, 0, 0.99);
}
#myform label:hover ~ label{
    text-shadow: 0 0 0 rgba(250, 208, 0, 0.99);
}
#myform input[type=radio]:checked ~ label{
    text-shadow: 0 0 0 rgba(250, 208, 0, 0.99);
}
#reviewContents {
    width: 100%;
    height: 150px;
    padding: 10px;
    box-sizing: border-box;
    border: solid 1.5px #D3D3D3;
    border-radius: 5px;
    font-size: 16px;
    resize: none;
}
</style>


<jsp:include page="/WEB-INF/layout/common/jwPlayer.jsp" />
    	<!-- Breadcrumb -->
			<div class="breadcrumb-bar">
				<div class="container">
					<div class="row">
						<div class="col-md-12 col-12">
							<div class="breadcrumb-list">
								<nav aria-label="breadcrumb" class="page-breadcrumb">
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="/">Home</a></li>
										<li class="breadcrumb-item" aria-current="page">온라인 강좌</li>
										<li class="breadcrumb-item" aria-current="page">강좌 찾기</li>
										<li class="breadcrumb-item active" aria-current="page">${courseInfo.course_nm}</li>
									</ol>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /Breadcrumb -->
			
			<!-- Course Content -->
			<section class="course-content course-sec">
				<div class="container">
				
					<div class="row">
						
						
						
						
						<!-- Complete Course -->
						<div class="col-lg-12">
							<div class="card complete-sec">
								<div class="card-body">
									<div class="com-info">
									<div>
										<h2>${courseInfo.course_nm}</h2>
										<p>${courseInfo.course_subject}</p>
										<div class="instructor-wrap border-bottom-0 m-0">
											<div class="about-instructor align-items-center">
												<div class="instructor-detail">
													<h5><a>${courseInfo.user_name}</a></h5>
													<p>${courseInfo.role_type}</p>
												</div>									

											</div>


										</div>	
										<div class="course-info d-flex align-items-center border-bottom-0 p-0 m-0">
											<div class="cou-info">
												<img src="/assets/img/icon/icon-01.svg" alt="">
												<p>${courseInfo.course_cnt} 차시</p>
											</div>
											<c:if test="${courseInfo.all_secound ne null }">
												<div class="cou-info">
													<img src="/assets/img/icon/timer-icon.svg" alt="">
													<p>${courseInfo.all_secound_menu}</p>
												</div>
											</c:if>
										</div>
										<div class="instructor-wrap border-bottom-0 m-0" style="padding-top: 20px;"> 
											<div class="cou-info" style="padding-right: 10px;">
											<div class="rating">
												<c:choose>
											<c:when test="${avgStar.avg == 5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 4.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 4}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 3.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 3}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 2.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 2}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 1.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 1}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 0.5}">
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg eq null}">
												<span class='d-inline-block average-rating' style="color: blue;"><span></span>등록된 별점이 없습니다.</span>
											</c:when>
											<c:otherwise>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
											</c:otherwise>
										</c:choose>
												<c:if test="${avgStar.avg ne null}">
													<span class='d-inline-block average-rating' ><Strong><span>${avgStar.avg}</span> (${avgStar.cnt})</Strong></span>
												</c:if>
												<c:if test="${avgStar.avg eq null}">
													<span><strong>(0)</strong></span>
												</c:if>
											</div>
											</div>
									</div>

								</div>
								 <a id="urlLinkBtn" href="javascript:void(0);" style="display: none" ><span class="web-badge text-dark" style="float: right;">외부링크</span></a>
								 <a id="youtubeLinkBtn" href="javascript:void(0);" style="display: none" ><span class="web-badge text-dark" style="float: right;">유튜브링크</span></a>
									<!-- <button id="urlLinkBtn" class="btn btn-info-light next_btn" style="width: 100%;" ><i style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>외부링크</button> -->
								</div>
							</div>
						
						<!-- /Complete Course -->
						
						<div class="col-lg-12 pd20">
							<div class="card overview-sec">
								<div class="card-body">
									<h5 class="subs-title">강좌설명</h5>
									<p>${courseInfo.course_descr}</p>
									
								</div>
							</div>
							
						</div>
					</div>
					</div>
					
				<div id="showDetail">
				
					<div class="row">
						<div class="col-lg-4">
							<!-- Course Lesson -->
							<div class="lesson-group" id="lesson-group">
								<div class="course-card">
									<h6 class="cou-title">
										<a class="" data-bs-toggle="collapse" href="#collapseOne" aria-expanded="true">${courseInfo.course_nm} <span>${courseInfo.course_cnt} 차시</span> </a>
									</h6>
									<div id="collapseOne" class="card-collapse collapse show" style="">
									</div>

								</div>
							</div>
							<div class="lesson-group" id="star" align="center" >
								
			                </div>
							<div class="lesson-group" id="avgStar" align="center" >
								<div class="course-card">
									<div class="rating">
										<span class='d-inline-block average-rating' style="padding-top: 20px;"><span></span><Strong>평균별점</Strong></span>
									</div>
									<div>
										<span><strong>${avgStar.avg}</strong></span>
									</div>
									<div class="rating">
										<c:choose>
											<c:when test="${avgStar.avg == 5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 4.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 4}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 3.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 3}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 2.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 2}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 1.5}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 1}">
												<i class='fas fa-star filled'></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg >= 0.5}">
												<i class='fas fa-star-half-alt'></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star'></i>
											</c:when>
											<c:when test="${avgStar.avg eq null}">
												<span class='d-inline-block average-rating' style="color: blue;"><span></span>등록된 별점이 없습니다.</span>
											</c:when>
											<c:otherwise>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
												<i class='fas fa-star '></i>
											</c:otherwise>
										</c:choose>
									</div>
									<div>
										<p>(${avgStar.cnt}명 등록)</p>
									</div>	
								</div>
			                </div>
							<!-- /Course Lesson -->
						</div>	
						
					
						
						<div id="player" class="col-lg-8">
						
							<!-- Introduction -->
							<div id="introduction" class="student-widget lesson-introduction">
								<div class="lesson-widget-group">
									<h4 class="tittle" id="setContentNm"></h4>
									<div id="moviePlayer">
									</div>

								</div>
							</div>
							<br>
							<div class="submit-ticket" style="display: inline-block; float: right;" >
								<button type="button" class="btn btn-dark"  id="backCourseList">목록</button>
							</div>														
						</div>	
						
					
					</div>	
					
					
				</div>
					
					
						
				</div>
			</section>
			<!-- /Pricing Plan -->

			<script type="text/javascript">
					
			$(document).ready(function(){
				      $("#backCourseList").on("click", function(e){			      
				            location.href="/course/courseFind/index.do";		         
				      });
				      var contents_mapped_seq = '${firstcourseContents.contents_mapped_seq}' ;
				      var course_seq = '${firstcourseContents.course_seq}' ;
				      var contents_seq = '${firstcourseContents.contents_seq}';
				      
  			          jwplayerView(contents_mapped_seq ,course_seq,contents_seq);
  			          $('.image').children('img').css("width","100%");
				      $("#backCourseList").on("click", function(e){			      
				            location.href="/course/courseFind/index.do";		         
				      });
				     
				     
			      
			});
			
			</script>

