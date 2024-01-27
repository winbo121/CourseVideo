<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<jsp:include page="/WEB-INF/layout/common/player.jsp" />
<style>
	.course-box-three .heart-three .fa-solid:hover {
    color: #0DD3A3 !important;
    /* font-weight:1 !important; */
    background-color: white !important;

	}
	
</style>


<script type="text/javascript" >
	function move_detail(seq,findTxt){
		var url = '';
			if(findTxt =='on'){
				var searchType ="1";
				var searchPlace ="1";
				var searchTxt= $('#searchTxt').val(); 
				
				if(searchTxt == '' || searchTxt == null){
					
					alert('검색어를 입력해 주세요.')
					return false;
					
				}
				
				save_search(searchType,searchPlace,searchTxt);
				url = '/course/courseFind/index.do?searchTxt='+searchTxt;
			}else{
				var searchType ="2";
				var searchPlace ="1";
				save_search(searchType,searchPlace,seq);
				url = '/course/courseFind/index.do?codeGubun='+seq;
			}
		move_get(url , null);
		
	}
	
	
	function go_result_like(ck_val){
		var likeId = 'like'+ck_val;
		var conLike = document.getElementById(likeId);
		var html = "";
		var confirm_func = function(){
			  return false;
			 };
		
			 
			 
		if($("#"+likeId).hasClass("fa-solid") === true) {
			
			conLike.classList.remove("fa-solid");
			$("#"+likeId).css("background-color","");
			$("#"+likeId).css("color","");
			html="찜하기가 취소되었습니다.";
			alert_info( html, confirm_func  );
		}else if($("#"+likeId).hasClass("fa-solid") === false) {
			
			conLike.classList.add("fa-solid");
			$("#"+likeId).css("background-color","#0DD3A3");
			$("#"+likeId).css("color","#ffffff");
			
			html="찜하기가 등록되었습니다.";
			alert_info( html, confirm_func  );
		}
		
		
		
	}
	
	function move_searhTxt(){
		
		if (window.event.keyCode == 13) {
			var searchTxt= $('#searchTxt').val(); 
			
			if(searchTxt == '' || searchTxt == null){
				
				alert('검색어를 입력해 주세요.')
				return false;
				
			}
			
			var searchType ="1";
			var searchPlace ="1";
			
			
			save_search(searchType, searchPlace,searchTxt );
			
			
			
			
			url = '/course/courseFind/index.do?searchTxt='+searchTxt;
			move_get(url , null);
		}
		
	}
	
	
	function go_detil(courseId) {

		var form_data = new FormData();
		var token = "${_csrf.token}";
		form_data.append("_csrf", token );
		form_data.append("course_seq", courseId );
		
		
		var searchTxt= courseId; 
		var searchType ="7";
		var searchPlace ="1";
		save_search(searchType, searchPlace,searchTxt );
		
		var url = '/course/courseFindDetail.do';
		move_post( url, form_data );
	}
</script>
    <!-- Home Banner -->
			<section class="home-three-slide d-flex align-items-center">
				<div class="container">
					<div class="row ">
						<div class="col-xl-6 col-lg-8 col-md-12 col-12" data-aos="fade-down">
							<div class="home-three-slide-face">
								<div class="home-three-slide-text">
									<h5>온라인 학습의 선두 주자</h5>
									<h1>Engaging<span>&</span>  모두를 위한 온라인 LMS</h1>
									<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eget aenean accumsan bibendum gravida maecenas augue elementum et</p>
								</div>
								<div class="banner-three-content">
										<div class="form-inner-three">
											<div class="input-group">
												<input id="searchTxt" type="text" class="form-control" placeholder="동영상, 온라인 교육과정 등 검색" onkeyup ="move_searhTxt()"/>
												<!-- <span class="drop-detail-three">
													<select class="form-three-select select">
														<option>분류 선택</option>
														<option>직무</option>
														<option>자기개발</option>
														<option>외국어</option>
														<option>지격증</option>
														<option>Etc.</option>
													</select>
												</span> -->
												<button type="button" class="btn btn-three-primary sub-btn" type="submit" onclick="move_detail('','on')"><i class="fas fa-arrow-right"></i></button>
											</div>
										</div>
								</div>
							</div>
						</div>
						<div class="col-xl-6 col-lg-4 col-md-6 col-12"  data-aos="fade-up">
							<div class="girl-slide-img aos">
								<img class="img-fluid" src="/assets/img/slider/home-slider.png" alt="">
							</div>
						</div>
					</div>
				</div>
			</section>
			<!-- /Home Banner -->
			
			<!--Online Courses -->
			<section class="section student-course home-three-course">
				<div class="container">
					<div class="course-widget-three">
						<div class="row">
							<div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up">
								<div class="course-details-three">
									<div class="align-items-center">
										<div class="course-count-three course-count ms-0">
											<div class="course-img">
												<img class="img-fluid" src="/assets/img/icon-three/course-01.svg" alt="">
											</div>
											<div class="course-content-three">
												<h4 class="text-blue"><span data="10" class="counterUp">10</span>K</h4>
												<p>Online Courses</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up">
								<div class="course-details-three">
									<div class="align-items-center">
										<div class="course-count-three course-count ms-0">
											<div class="course-img">
												<img class="img-fluid" src="/assets/img/icon-three/course-02.svg" alt="">
											</div>
											<div class="course-content-three">
												<h4 class="text-yellow"><span data="200" class="counterUp">200</span>+</h4>
												<p>Expert Tutors</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up">
								<div class="course-details-three">
									<div class="align-items-center">
										<div class="course-count-three course-count ms-0">
											<div class="course-img">
												<img class="img-fluid" src="/assets/img/icon-three/course-03.svg" alt="">
											</div>
											<div class="course-content-three">
												<h4 class="text-info"><span data="6" class="counterUp">6</span>K+</h4>
												<p>Ceritified Courses</p>
											</div>
										</div>
									</div>
								</div>	
							</div>
							<div class="col-lg-3 col-md-6 d-flex" data-aos="fade-up">
								<div class="course-details-three mb-0">
									<div class="align-items-center">
										<div class="course-count-three">
											<div class="course-img">
												<img class="img-fluid" src="/assets/img/icon-three/course-04.svg" alt="">
											</div>
											<div class="course-content-three course-count ms-0">
												<h4 class="text-green"><span data="60" class="counterUp">60</span>K +</h4>
												<p>Online Students</p> 
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!-- /Online Courses -->
			
			<!-- Master skills Career -->
			<section class="master-skill-three">
				<div class="master-three-vector">
					<img class="ellipse-right img-fluid" src="/assets/img/bg/pattern-01.png" alt="">
				</div>
				<div class="container">
					<div class="row">		
						<div class="col-xl-6 col-lg-6 col-md-12" data-aos="fade-right">
							<div class="master-three-images">
								<div class="master-three-left"> 
									<img class="img-fluid" src="/assets/img/students/career.png" alt="image-banner" title="image-banner">
								</div>
							</div>
						</div>
						
						<div class="col-xl-6 col-lg-6 col-md-12" data-aos="fade-left">
							<div class="home-three-head" data-aos="fade-up">
								<h2>강의를 듣고 자신만에 career를 쌓아 보세요</h2>
							</div>
							<div class="home-three-content" data-aos="fade-up">
								<p>자격증을 취득하고, 최신 기술 기술을 습득하고, 경력을 쌓으십시오. 처음 시작하는 사람이든 숙련된 전문가든 상관없이 95%의 eLearning 학습자가 Seagate의 실습 콘텐츠가 경력에 직접적인 도움이 되었다고 보고합니다.</p>
							</div>
							<div class="skils-group">
								<div class="row">
									<div class="col-lg-6 col-xs-12 col-sm-6" data-aos="fade-down">
										<div class="skils-icon-item">
											<div class="skils-icon">
												<img class="img-fluid" src="/assets/img/icon-three/career-01.svg" alt="certified">
											</div>
											<div class="skils-content">
												<p class="mb-0">Get certified with 100+ certification courses</p>
											</div>
										</div>
									</div>
									<div class="col-lg-6 col-xs-12 col-sm-6" data-aos="fade-up">
										<div class="skils-icon-item">
											<div class="skils-icon">
												<img class="img-fluid" src="/assets/img/icon-three/career-02.svg" alt="Build skills">
											</div>
											<div class="skils-content">
												<p class="mb-0">Build skills your way, from labs to courses</p>
											</div>
										</div>
									</div>
									<div class="col-lg-6 col-xs-12 col-sm-6" data-aos="fade-right">
										<div class="skils-icon-item">
											<div class="skils-icon">
												<img class="img-fluid" src="/assets/img/icon-three/career-03.svg" alt="Stay Motivated">
											</div>
											<div class="skils-content">
												<p class="mb-0">Stay motivated with engaging instructors</p>
											</div>
										</div>
									</div>
									<div class="col-lg-6 col-xs-12 col-sm-6" data-aos="fade-left">
										<div class="skils-icon-item">
											<div class="skils-icon">
												<img class="img-fluid" src="/assets/img/icon-three/career-04.svg" alt="latest cloud">
											</div>
											<div class="skils-content">
												<p class="mb-0">Keep up with the latest in cloud</p>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>		
				</div>
			</section>
			<!-- /Master skills Career -->
			
			
			
			<!-- Favourite Course -->
			<section class="home-three-favourite">
				<div class="container">
					<div class="row">
						<div class="container">
							<div class="home-three-head section-header-title" data-aos="fade-up">
								<div class="row align-items-center d-flex justify-content-between">
									<div class="col-lg-8 col-sm-12">
										<h2>상위 카테고리에서 즐겨찾는 과정 선택</h2>
									</div>
									<div class="col-lg-4 col-sm-12">
										<div class="see-all">											
											<a href="/course/courseFind/index.do">See all<span class="see-all-icon"><i class="fas fa-arrow-right"></i></span></a>
										</div>
									</div>
								</div>
							</div>
							
							
							<div class="owl-carousel home-three-favourite-carousel owl-theme aos">
							
							<c:forEach items="${courseGubun}" var="contents">
								<div  class="favourite-box" data-aos="fade-down" onclick="move_detail(${contents.code_seq},'')">					
									<div  class="favourite-item flex-fill">
										<div class="categories-icon">
											<img class="img-fluid" src="/assets/img/category/${contents.code_descr}" alt="${contents.code_nm}">
										</div>
										<div class="categories-content course-info">
											<h3>${contents.code_nm} Category</h3>
										</div>
										<div class="course-instructors">
											<div class="instructors-info">
												<p class="me-4">등록된 과정수</p>
												<ul class="instructors-list">
													<li>
														<a href="javascript:void(0)"><img src="/assets/img/profiles/avatar-01.jpg" alt="img"></a>
													</li>
													<li>
														<a href="javascript:void(0)" ><img src="/assets/img/profiles/avatar-02.jpg" alt="img"></a>
													</li>
													<li>
														<a href="javascript:void(0)" ><img src="/assets/img/profiles/avatar-03.jpg" alt="img"></a>
													</li>
													<li class="more-set">
														<a href="javascript:void(0)"  data-bs-toggle="tooltip" data-bs-placement="top" title="" data-bs-original-title="${contents.code_nm} ${contents.code_cnt} 과정">${contents.code_cnt}+</a>
													</li>
												</ul>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
							
						</div>
					</div>
					<!-- /Favourite Course -->
				</div>
			</section>			
			<!-- Feature Course -->	
			
			<!-- Courses -->
			<section class="home-three-courses">
				<div class="container">
					<div class="favourite-course-sec">
						<div class="row">
							<div class="home-three-head section-header-title" data-aos="fade-up">
								<div class="row align-items-center d-flex justify-content-between">
									<div class="col-lg-6 col-sm-8">
										<h2>코테크 추천강좌</h2>
									</div>
									<div class="col-lg-6 col-sm-4">
										<div class="see-all">											
											<a href="/course/courseFind/index.do">See all<span class="see-all-icon"><i class="fas fa-arrow-right"></i></span></a>
										</div>
									</div>
								</div>
							</div>

							<div class="all-corses-main">
								<div class="tab-content">
									<div class="nav tablist-three" role="tablist">
										<a class="nav-tab active me-3" data-bs-toggle="tab" href="#alltab" role="tab" area-selected="true" style="color: #7B1FFE;font-weight: bold;">인기 강좌</a>
									</div>
									
									
									<div class="tab-content">
									
										<!-- All -->
										<div class="tab-pane fade active show" id="alltab" role="tabpanel" >
											<div class="all-course">
												<div class="row">

												<c:forEach items="${mainCourseList}" var="contents" varStatus="status">
													<!-- Col -->
													<div class="col-xl-3 col-lg-6 col-md-6 col-12" data-aos="fade-up" >
														<div class="course-box-three" >
															<div class="course-three-item">
																<div class="course-three-img" >
																<%-- onmouseover="move_player2('${status.index}')" onmouseout="move_player('${status.index}')" > --%>
																	<a href="javascript:void(0)" onclick="go_detil(${contents.course_seq})"
																	<%-- onmouseover="move_player2('${status.index}')"  onmouseout="move_player('${status.index}')" --%>
																	>
																		<!-- <img class="img-fluid" alt="" src="/assets/img/course/course-26.jpg"> -->
																		<c:if test="${contents.file_url != '' }"> 
																			<img class="img-fluid"  id ="img${status.index}"
																			 onmouseover="move_player2('${status.index}','${contents.vod_url}')"
																			onError="this.src='/images/noimage.png'" alt="image_thumbnail" src="${contents.file_url}"/>
																			<div id ="jw${status.index}"></div>
																		</c:if>
																		<c:if test="${contents.file_url == '' }">
																			<img class="img-fluid" id ="img'${status.index}'" 
																			onmouseover="move_player2('${status.index}','${contents.vod_url}')"
																			onError="this.src='/images/noimage.png' alt="image_thumbnail" src="/images/noimage.png" />
																			<div id ="jw${status.index}"></div>	
																		</c:if>
																	</a>													
																	<c:if test="${contents.like_yn == 'Y' }"> 
																		<div class="heart-three">
																		<a href="javascript:void(0)" onclick="sel_like(${contents.course_seq})"><i class="fa-regular fa-heart fa-solid" 
																		id='like${contents.course_seq}' style="background-color: #0DD3A3;color: #ffffff;"></i></a>
																	</div>
																	</c:if>
																	
																	<c:if test="${contents.like_yn == 'N' }"> 
																		<div class="heart-three">
																		<a href="javascript:void(0)" onclick="sel_like(${contents.course_seq})"><i class="fa-regular fa-heart"
																		id='like${contents.course_seq}' ></i></a>
																	</div>
																	</c:if>
																	
																	
																	
																</div>
																<div class="course-three-content">	
																	<!-- <div class="course-group-three">
																		<div class="group-three-img">
																			<a href="instructor-profile.html"><img src="/assets/img/user/user1.jpg" alt="" class="img-fluid"></a>
																		</div>
																	</div> -->

																	<div class="course-three-text">
																		<a href="javascript:void(0)" onclick="go_detil(${contents.course_seq})">
																			<p>${contents.code_nm }</p>
																			<h3 class="title instructor-text">${contents.course_nm }</h3>
																		</a>
																	</div>
																	
																	<div class="student-counts-info d-flex align-items-center">
																		<div class="students-three-counts d-flex align-items-center">
																			<img src="/assets/img/icon-three/student.svg" alt="">
																			<p>${contents.stu_cnt } 수강완료</p>
																		</div>
																	</div>
							
																	<div class="price-three-group d-flex align-items-center justify-content-between justify-content-between">
																		<div class="price-three-view d-flex align-items-center">
																			<div class="course-price-three">
																				<h3>${contents.course_round}차시</h3>
																			</div>
																		</div>
																		<div class="price-three-time d-inline-flex align-items-center">
																			<i class="fa-regular fa-clock me-2"></i>
																			<span>
																			<c:if test="${contents.vod_hour != '0' }"> 
																			${contents.vod_hour}시간
																			</c:if>
																			<c:if test="${contents.vod_min != '00' }"> 
																			${contents.vod_min}분
																			</c:if>
																			<c:if test="${contents.vod_min == '00' }"> 
																			1분 미만
																			</c:if>
																			</span>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
													</c:forEach>
													<!-- /Col -->

												</div>
											</div>
										</div>
										<!-- /All -->
									
									</div>
								</div>
							</div>
							

						</div>
					</div>
				</div>
			</section>
			<!-- /Courses -->	
			
            
			<!-- Acheive you Goals  -->
			<section class="home-three-goals">
                <div class="container">
                    <div class="row align-items-center">

						<!-- Col -->
                        <div class="col-xl-3 col-lg-12 col-md-12" data-aos="fade-down">
							<div class="acheive-goals-main">
								<h2>LMS와 함께 목표를 달성하세요</h2>
							</div>
						</div>
						<!-- /Col -->

						<!-- Col -->
						<div class="col-xl-3 col-lg-4 col-md-4 col-12" data-aos="fade-down">
							<div class="acheive-goals">
								<div class="acheive-elips-one">
									<img src="/assets/img/icon-three/ellipse-1.svg" alt="">
								</div>
								<div class="acheive-goals-content text-center course-count ms-0">
									<h4><span data="${his_totcnt }" class="counterUp">${his_totcnt }</span></h4>
									<p>다양한 LMS 학습이력 총 건수</p>
								</div>
							</div>
						</div>
						<!-- /Col -->

						<!-- Col -->
						<div class="col-xl-3 col-lg-4 col-md-4 col-12" data-aos="fade-down">
							<div class="acheive-goals">
								<div class="acheive-elips-two">
									<img src="/assets/img/icon-three/ellipse-2.svg" alt="">
								</div>
								<div class="acheive-goals-content text-center course-count ms-0">
									<h4><span data="${course_totcnt }" class="counterUp">${course_totcnt }</span></h4>
									<p>플랫폼에<br> 등록된 총 강좌</p>
								</div>
							</div>
						</div>
						<!-- /Col -->

						<!-- Col -->
						<div class="col-xl-3 col-lg-4 col-md-4 col-12" data-aos="fade-down">
							<div class="acheive-goals">
								<div class="acheive-elips-two">
									<img src="/assets/img/icon-three/ellipse-3.svg" alt="">
								</div>
								<div class="acheive-goals-content text-center course-count ms-0">
									<h4><span data="${stu_totcnt }" class="counterUp">${stu_totcnt }</span></h4>
									<p>전 세계에서<br> 등록된 학생들 </p>
								</div>
							</div>
						</div>
						<!-- /Col -->

					</div>
				</div>
			</section>
			<!-- /Acheive you Goals  -->				

			
