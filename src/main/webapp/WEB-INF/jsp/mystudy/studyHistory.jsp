<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
.my-student-list ul li a:hover {
	border-bottom: 4px solid #1fa3f1;
}
</style>
<script type="text/javascript">

var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';

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
				toaster.warning('과정명을 입력하세요.');
			} else {
				// search_log
				save_search(1,3,search_text);
				// set data
				set_data(1);
			}
		}
	});
	
});

function init() {
	set_data(1);
}

function set_data(pageNo) {
	if(pageNo == '' || pageNo == null){
		
		pageNo = 1;
	}
	
	$("#pageNo").val(pageNo);
	
	var formdata = $("#search")[0];
	var form_data = new FormData(formdata);
	var json = $("#search").serialize();
	
	var succ_func = function(resData, status ) {

		drawList(resData);
		
		<!-- 진도율 그래프 -->
	    $('.progress-bar').each(function(){
	        var $this = $(this);
	        var percent = $this.attr('percent');
	        $this.animate({
	        	width: percent + '%',
	        }, 1000);
	        //$this.css("width",percent+'%');
	        /* 
	        $({animatedValue: 0}).animate({animatedValue: percent},{
	            duration: 1000,
	            step: function(){
	                $this.attr('percent', Math.floor(this.animatedValue) + '%');
	            },
	            complete: function(){
	                $this.attr('percent', Math.floor(this.animatedValue) + '%');
	            }
	        });
	         */
	        
	    });
	};
	
	ajax_json_post("/mystudy/myStudyHistory/index.do", json, succ_func);
	
};

function go_detil(courseId) {

	var form_data = new FormData();
	var token = "${_csrf.token}";
	form_data.append("_csrf", token );
	form_data.append("course_seq", courseId );
	var url = '/course/courseFindDetail.do';
	move_post( url, form_data );
}

</script>

			<!-- Student Header -->
			<%-- <jsp:include page="/WEB-INF/layout/common/mypageBanner.jsp" /> --%>
			<!-- /Student Header -->
			
			<!-- My Course -->
			<section class="course-content">
				<div class="container">
					<div class="student-widget">
						<div class="student-widget-group">
							<div class="row">
								<div class="col-lg-12">
								
									<!-- Filter -->
									<div class="showing-list">
										<div class="row">
											<div class="col-lg-12">	
												<div class="show-filter choose-search-blk">
													<!-- 검색 -->
													<form:form modelAttribute="search" onSubmit="return false;">
														<form:hidden path="pageNo"/>	<%-- JSP PAGING 현재 페이지 번호 --%>
														<form:hidden path="rangeNo"/> <%-- JSP PAGING 현재 범위 번호 --%>
														<form:hidden path="pageSize"/> <%-- JSP PAGING 페이지 당 레코드 카운트 --%>
														<form:hidden path="rangeSize"/> <%-- JSP PAGING 범위 당 페이지 사이즈   --%>
														<form:hidden path="totalCount"/> <%-- JSP PAGING 현재 검색조건 글의 카운트   --%>
														<form:hidden path="pageCount"/> <%-- JSP PAGING 현재 검색조건 페이지 카운트   --%>
														<form:hidden path="rangeCount"/> <%-- JSP PAGING 현재 검색조건 범위 카운트   --%>
														<div class="mycourse-student align-items-center">	
															<div class="student-search">
																<div class=" search-group">
																	<i class="feather-search"></i>
																	<c:set var ="searchMsg"><spring:message code='search.keyword'/></c:set>
																	<form:input path="search_text" type="text" class="form-control" placeholder="${searchMsg}" />
																	<div class="ticket-btn-grp my-search d-flex">
																		<a href="javascript:void(0);" id="ajax_search"><spring:message code="button.search"/></a>
																	</div>
																</div>
															</div>
															<div class="student-filter">
																<div class="form-group select-form mb-0">
																	<form:select path="search_type" class="form-select select">
												                        <option value=""  <c:if test="${empty search.search_type}">selected</c:if>>전체</option>
												                        <option value="learning" <c:if test="${search.search_type == 'learning'}">selected</c:if>>수강중(학습이력증명강좌)</option>
												                        <option value="done" <c:if test="${search.search_type == 'done'}">selected</c:if>>수강완료(학습이력증명강좌)</option>
												                        <option value="outCourse" <c:if test="${search.search_type == 'done'}">selected</c:if>>기타(외부강좌)</option>
																	</form:select>
																</div>
															</div>	
														</div>
													</form:form>
												</div>	
											</div>
										</div>
									</div>
									<!-- /Filter -->
									<div class="show-result">
										<h4>
											<p><span id="searchResult"></span></p>
										</h4>
									</div>
									<div class="row" id="card-body">
									</div>
									
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
			<!-- /My Course -->
			
<script type="text/javascript">
function drawList(resData) {
	
	/* 마지막 페이지 정보 초기화 */
	end_page_no = start_page_no + 4;
	check_end = 'N';
	
	var setNo = resData.search.pageNo;
	var rangeCount = resData.search.rangeCount;
	var list = resData.list.data;
	var listLen = list.length;
	
	// 검색결과 업데이트(totalCnt)
	var totalCount = resData.search.totalCount;
	var pageSize = resData.search.pageSize;
	
	var msg = "<spring:message code='search.result'/>";
	msg = msg.replace("{0}",totalCount).replace("{1}",pageSize);
	$("#searchResult").html(msg);
	
	var html = "";
	var page_info = "";
	
	// draw table data
	if(listLen > 0){
		$.each(list, function( index, data ) {
		html += '<div class="col-xl-3 col-lg-4 col-md-6 d-flex">';
		html += '	<div class="course-box course-design d-flex " >';
		html += '		<div class="product">';
		if(data.type_seq == 186){
			html += '			<div><span><strong>학습이력증명강좌</strong></span></div>';	
		} else {
			html += '			<div><span><strong>외부강좌</strong></span></div>';
		}
		html += '			<div class="product-img">';
		html += '				<a href="javascript:void(0);" onclick="go_detil(' + this.course_seq + ');">';
		//html += '					<img class="img-fluid" alt="" src="/assets/img/course/course-10.jpg">';
		html += '					<img class="img-fluid" alt="" src="${rootPath}' + data.file_save_path + data.save_filenm +'" onerror="this.src = \'/images/home/no_image.svg\'">';
		html += '				</a>';
		html += '			</div>';
		html += '			<div class="product-content">';
		html += '				<h3 class="title">(' + data.category_nm + ')' + data.course_nm + '</h3>';
		//html += '				<!--'; 
		//html += '				<div class="rating-student">';							
		//html += '					<div class="rating">';							
		//html += '						<i class="fas fa-star filled"></i>';
		//html += '						<i class="fas fa-star filled"></i>';
		//html += '						<i class="fas fa-star filled"></i>';
		//html += '						<i class="fas fa-star filled"></i>';';
		//html += '						<i class="fas fa-star"></i>';
		//html += '						<span class="d-inline-block average-rating"><span>4.0</span></span>';
		//html += '					</div>';
		//html += '					<div class="edit-rate">';
		//html += '						<a href="javascript:;">Edit rating</a>';
		//html += '					</div>';
		//html += '				</div>';
		//html += '				 -->';
		html += '			    <div>' + data.strt_time + ' ~ ' + data.end_time + '</div>';
		if(data.type_seq == 186){
			html += '				<div class="progress-stip">';
			html += '					<div class="progress-bar bg-success progress-bar-striped active-stip" percent="' + this.total_progress + '"></div>';
			html += '				</div>';
			html += '				<div class="student-percent">';
			html += '					<p>진도율 ' + data.total_progress + '% ';
			html += '					(';
			if(data.use_yn == 'Y'){
				if(data.is_done == 'Y'){
					html += '					<td class="font-orange">수강완료</td>';	
				} else if (data.is_done == 'N') {
					html += '					<td class="font-blue">수강중</td>';	
				}				
			} else {
				html += '					<td class="font-blue">수강종료</td>';
			}
			

			html += '					)';
			html += '					</p>';
			html += '				</div>';
		} else {
			html += '				<p></p>';
		}
		
		html += '				<div class="start-leason d-flex align-items-center">';
		if(data.use_yn == 'Y'){
			html += '					<a href="javascript:void(0);" class="btn btn-primary" onclick="go_detil(' + this.course_seq + ');">강좌 듣기</a>';	
		} else {
			html += '					<a href="javascript:void(0);" class="btn btn-primary" onclick="alert_warning(\'종료된 강좌입니다.\');">강좌 듣기</a>';
		}
		
		html += '				</div>';
		html += '			</div>';
		html += '		</div>';
		html += '	</div>';
		html += '</div>';
		
		});
		
		// draw pagenation
		page_info += "<ul class='pagination lms-page'>";
		page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";
		
		if(end_page_no >= resData.search.pageCount ){
			end_page_no = resData.search.pageCount;
			check_end = 'Y';
		}
		
		for (var a = start_page_no; a <= end_page_no; a++) {
			var setNog = resData.list.page;
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
	
	$("#card-body").html(html);
	$("#pagination").html(page_info);	

}

//전체,수강중,수강완료, 외부강좌 선택
$("#search_type").on('change',function(){			
	set_data(1);
});

</script>