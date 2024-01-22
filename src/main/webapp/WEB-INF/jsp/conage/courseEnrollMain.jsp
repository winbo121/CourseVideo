<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
	.instructor-product-content {
		display:contents;
		flex-flow: row wrap;
		justify-content:space-around;
	}
</style>
<!-- Feather CSS -->
		<link rel="stylesheet" href="/assets/css/feather.css">
<script type="text/javascript">
$(document).ready(function(){
	init();
	
	$("#ajax_search").on( "click", function( event ){
		event.preventDefault();
		set_data(1);
	});
	
	$("#search_text").on("keydown", function(key) {
		if (key.keyCode == 13) {
			var search_text = $(this).val().trim();
			if(search_text == ''){
				var toaster = new BasicToastr();
				toaster.title = "검색";
				toaster.warning('검색어를 입력하세요.');
			} else {
				set_data();
			}
		}
	});
	
	$("#nav-tab a").on("click", function() {
		tabMove();
		set_data(1);
	});
	
	$(document).on("click",".data", function() {
		var seq = $(this).attr("id");
		seq = seq.replace("data_","");
		location.href="/conage/contentEnroll/update.do?contents_seq=" + seq;
	});
	
});

function init() {
	set_data(1);
}

function set_data(pageNo) {
	var action = "/conage/courseEnrollMain/index.do";
	
	if(pageNo == '' || pageNo == null){
		
		pageNo = 1;
	}
	
	$("#pageNo").val(pageNo);
	
	var formdata = $("#search")[0];
	var form_data = new FormData(formdata);
	var json = $("#search").serialize();
	
	var succ_func = function(resData, status ) {
		drawList(resData);
	};
	
	ajax_json_post("/conage/courseEnrollMain/index.do", json, succ_func);
};

function tabMove() {
	var tab = $("#nav-tab").find(".active").data("tab");
	$("#search_tap").val(tab);
}

//임시 강좌 운영 활성화 버튼
$(document).on('click','.open_btn',function(){
	var seq = $(this).data("seq");
	var confirm_func = function (){
		var form_data = new FormData();
		form_data.append( "course_seq" , seq );
		form_data.append( "use_yn", "Y" );
		var action = "/conage/courseEnroll/change.do";
		var succ_func = function(resData , status){
			
			if(resData.result == "success"){
				let move_list = function(){
					location.href = "/conage/courseEnrollMain/index.do";
				}
				alert_success("운영 활성화가 완료되었습니다.",move_list);
			} else {
				alert_error( resData.msg, null );
			}
		}
		
		ajax_form_put( action, form_data, succ_func );
	};
	confirm_warning("임시 강좌 운영 활성화 하시겠습니까?",confirm_func);
});

// 운영 강좌 종료 버튼
$(document).on('click','.close_btn',function(){
	var seq = $(this).data("seq");
	var confirm_func = function (){
		
		var form_data = new FormData();
		form_data.append( "course_seq" , seq );
		form_data.append( "use_yn" , "N" );
		var action = "/conage/courseEnroll/change.do";
		var succ_func = function(resData , status){
			
			if(resData.result == "success"){
				let move_list = function(){
					location.href = "/conage/courseEnrollMain/index.do";
				}
				alert_success("운영 종료가 완료되었습니다.",move_list);
			} else {
				alert_error( resData.msg, null );
			}
		}
		ajax_form_put( action, form_data, succ_func );
	};
	confirm_warning("해당 강좌를 운영 종료 하시겠습니까?",confirm_func);
});

</script>

<!-- Banner -->
<%-- <jsp:include page="/WEB-INF/layout/common/banner.jsp" /> --%>
<!-- /Banner -->
	
			<!-- Instructor Dashboard -->
			<section class="page-content course-sec">
				<div class="container">
					<div class="row">  
						<div class="col-lg-12">
							<div class="card instructor-card">
								<div class="settings-inner-blk p-0">
								<div class="comman-space pb-0">
								<div class="filter-grp ticket-grp align-items-center justify-content-between">
									<div class="mb20">
										<h3>강좌 등록</h3>
										<p><spring:message code="course.info"/></p>
									</div>

									<!-- Filter -->
									<div class="d-multi">
										<div class="show-filter add-course-info col-lg-6">
											<form:form modelAttribute="search" onSubmit="return false;">
												<form:hidden path="pageNo"/>	<%-- JSP PAGING 현재 페이지 번호 --%>
												<form:hidden path="rangeNo"/> <%-- JSP PAGING 현재 범위 번호 --%>
												<form:hidden path="pageSize"/> <%-- JSP PAGING 페이지 당 레코드 카운트 --%>
												<form:hidden path="rangeSize"/> <%-- JSP PAGING 범위 당 페이지 사이즈   --%>
												<form:hidden path="totalCount"/> <%-- JSP PAGING 현재 검색조건 글의 카운트   --%>
												<form:hidden path="pageCount"/> <%-- JSP PAGING 현재 검색조건 페이지 카운트   --%>
												<form:hidden path="rangeCount"/> <%-- JSP PAGING 현재 검색조건 범위 카운트   --%>
												<form:hidden path="search_tap"/> <%-- JSP PAGING 현재 검색조건 강좌상태   --%>
												<div class="row gx-2 align-items-center">
													<div class="col-md-8 col-item">
														<div class=" search-group">
															<i class="feather-search"></i> 
															<c:set var ="searchMsg"><spring:message code='search.keyword'/></c:set>
															<form:input path="search_text" class="form-control" placeholder="${searchMsg}"/>
														</div>
													</div>
													<div class="col-md-3 col-item">
														<div class="form-group select-form mb-0">
															<form:select path="search_type" class="form-select select" name="sellist1">
																<option value = "all"><spring:message code="search.all"/></option>
																<option value = "name"><spring:message code="course.name"/></option>
																<option value = "descr"><spring:message code="course.descr"/></option>
															</form:select>
														</div>
													</div>
												</div>
											</form:form>
										</div>
										<div class="col-lg-6">
											<div class="ticket-btn-grp">
												<a class="btn search-btn fl mr10" href="javascript:void(0)" id="ajax_search"><spring:message code="button.search"/></a>
												<a href="/conage/courseEnroll/insert.do" class="btn btn-register fr"><spring:message code="button.create"/></a>
											</div>
										</div>
									</div>
									<!-- /Filter -->

								</div>
								<!-- Ticket Tab -->
								<div class="category-tab tickets-tab-blk">
									<ul id="nav-tab" class="nav nav-justified ">
										<li class="nav-item">
											<a href="javascript:void(0);" class="nav-link active bs-20" data-bs-toggle="tab" data-tab="all"><spring:message code="search.all"/></a>
										</li>
										<li class="nav-item">
											<c:set var="opened"><spring:message code="course.opened"/></c:set>
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="opened">${opened}</a>
										</li>
										<li class="nav-item">
											<c:set var="temp"><spring:message code="course.temp"/></c:set>
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="temp">${temp}</a>
										</li>
										<%-- 
										<li class="nav-item">
											<c:set var="closed"><spring:message code="course.closed"/></c:set>
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="closed">${closed}</a>
										</li>
										 --%>
									</ul>
								</div>
								<!-- /Ticket Tab -->
									<div class="show-result">
										<h4>
											<span id="searchResult"></span>
										</h4>
									</div>
								</div>
								</div>
								<div class="card-body" id="card-body">
								</div>
							</div>
						</div>	
					</div>
					
					<!-- /pagination -->
							<div class="row">
								<div class="col-md-12" id="pagination">
								</div>
							</div>
							<!-- /pagination -->
					
				</div>
			</section>
			<!-- /Instructor Dashboard -->
			
<script type="text/javascript">
var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';

function drawList(resData) {
	
	/* 마지막 페이지 정보 초기화 */
	end_page_no = start_page_no + 4;
	check_end = 'N';
	
	$("#card-body").empty();
	
	var list = resData.list;
	var search = resData.search;
	
	// 검색결과 업데이트(totalCnt)
	var totalCount = search.totalCount;
	var pageSize = search.pageSize;
	
	var msg = "<spring:message code='search.result'/>";
	msg = msg.replace("{0}",totalCount).replace("{1}",pageSize);
	$("#searchResult").html(msg);
	
	var html = "";
	var page_info = "";
	
	var learningTime = function (timeTotSec){
		var hr = parseInt(timeTotSec / (60 * 60));
		var min = parseInt(timeTotSec % (60 * 60) / 60);
		if(min > 0){
			return hr +"시간 " + min + "분"; 
		} else if (min == 0) {
			return "1분 미만";
		} else {
			return min + "분";
		}
		
	}
	
	if(list.data.length > 0){	
		// draw table data
		$.each(list.data, function(index) {
			var isUsed = this.useYn;
			var seq = this.courseSeq;
			var type = "";
			var url = "";
			if(isUsed == 'Y'){
				type = "view";
			}
			if(isUsed == 'N'){
				type = "update";
			}
			var url = "/conage/courseEnroll/" + type + ".do?course_seq=" + seq;
			html += '<div class="instructor-grid">';
			//html += '	<div class="product-img">';
			//html += '		<a href="' + url + '">';
			//html += '			<img src="/assets/img/course/course-10.jpg" class="img-fluid" alt="">';
			//html += '			<img style="height:100px;" src="${rootPath}' + this.fileSavePath + this.saveFileNm + '" class="img-fluid" alt="">';
			//html += '		</a>';
			//html += '	</div>';
			html += '	<div class="instructor-product-content">';
			html += '		<div class="head-course-title">';
			html += '			<h3 class="title"><a href="' + url + '">';
			html += '			<div class="d-flex align-items-center" data-seq="' + seq + '">';
			if(isUsed == 'Y'){
				html += '				<div class="badge btn-primary mr10" >${opened}</div>';
			}
			if(isUsed == 'N'){
				html += '				<div class="badge btn-warning mr10" >${temp}</div>';
			}
			html += this.courseNm;
			html += '			</div>';				
			html += '				</a></h3>';
			html += '		</div>';
			html += '		<div class="course-info d-flex align-items-center border-bottom-0 pb-0 mr30">';
			html += '			<div class="rating-img d-flex align-items-center ">';
			html += '				<img src="/assets/img/icon/icon-01.svg" alt="">';
			html += '				<p>' + this.courseCnt + ' 차시</p>';
			html += '			</div>';
			html += '			<div class="course-view d-flex align-items-center ">';
			html += '				<img src="/assets/img/icon/icon-02.svg" alt="">';
			html += '				<p>' + learningTime(this.courseTm) + '</p>';
			html += '			</div>';
			html += '		</div>';
			//html += '		<div class="rating mb-0">';							
			//html += '			<i class="fas fa-star filled"></i>';
			//html += '			<i class="fas fa-star filled"></i>';
			//html += '			<i class="fas fa-star filled"></i>';
			//html += '			<i class="fas fa-star filled"></i>';
			//html += '			<i class="fas fa-star"></i>';
			//html += '			<span class="d-inline-block average-rating"><span>4.0</span> (15)</span>';
			//html += '		</div>';
			html += '		<div class="course-info d-flex align-items-center border-bottom-0 pb-0">';
			if(isUsed == 'Y'){
				html += '		<a href="javascript:void(0);" class="badge btn-primary close_btn" style="width:100%;" data-seq="' + seq + '">${opened}</a>';			
			}
			if(isUsed == 'N'){
				html += '		<a href="javascript:void(0);" class="badge btn-warning open_btn" style="width:100%;" data-seq="' + seq + '">${temp}</a>';			
			}
			html += '		</div>';
			html += '	</div>';
			html += '</div>';
		});
		
		
		
		//draw pagination
		page_info += "<ul class='pagination lms-page'>";
		page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";
		if(end_page_no >= resData.search.pageCount ){
			
			end_page_no = resData.search.pageCount;
			check_end = 'Y';
		}
		
		
		for (var a = start_page_no; a <= end_page_no; a++) {
			var setNog = list.page;
			if(a == setNog){
				var class_name = 'page-item first-page active';
				var fn_name = "return false;";
			}else{
				var class_name = 'page-item first-page';
				var fn_name = "set_data("+ a +");";
			}
			page_info += "<li class='"+ class_name +"'>";
			page_info += "<a class='page-link' href='javascript:void(0)' onclick='" + fn_name + "'>"+ a +"</a></li>";
		}
		
		page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
		page_info += "</ul>";

	} else {
		html += "<div style='text-align:center' class='mb-4'>	데이터가 존재하지 않습니다. </div>";
	}
	
	$("#card-body").append(html);
	$("#pagination").html(page_info);
}

</script>