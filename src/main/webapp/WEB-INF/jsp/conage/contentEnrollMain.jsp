<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- Feather CSS -->
<link rel="stylesheet" href="/assets/css/feather.css">
<style type="text/css">
	.contents-td {
		cursor:pointer;
	}
	
	.checkmark {
		margin-top: 3px;
		margin-left:8px;
	}
	
	td .checkmark {
		margin-left:16px;
	}
	
	.delete-btn-wrap {
		display:flex;
	}
	
	.delete-btn {
		margin-top:10px;
		margin-left:auto;
	}
	
	.search-btn {
		margin-right:5px;
	}
	
	.regist-btn {
		margin-left:auto;
	}
	
	.check-disabled {
    	cursor: default;
	}
	
	.check-disabled span {
		border: #d9dfe5 !important;
    	background-color: #d9dfe5 !important;
	}
	
	.check-disabled input {
		cursor: default;
	}
</style>


<script type="text/javascript">

var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';

$(document).ready(function(){
	init();
	
	$("#search_text").on("keydown", function(key) {
		if (key.keyCode == 13) {
			var search_text = $(this).val().trim();
			if(search_text == ''){
				alert("검색어를 입력해 주세요.");
				return false;
			} else {
				set_data(1);
			}
		}
	});
	
	$(".search-btn").on("click", function() {
		set_data(1);
	});
	
	$(document).on("click",".contents-td", function() {
		var seq = $(this).parents().attr("id");
		seq = seq.replace("data_","");
		location.href="/conage/contentEnroll/update.do?contents_seq=" + seq;
	});
	
	$("#nav-tab a").on("click", function() {
		tabMove();
		set_data(1);
	});
	
	//전체 체크박스 이벤트
	$("#check-all").on('click',function(){
		if($(this).is(":checked")){
			$("input.contents-check").prop("checked", true); //전체 체크박스 체크 후
		}else{
			$("input.contents-check").prop("checked", false);
		}
		
	});
	
	//개별 체크박스 이벤트
	$(document).on("click","input.contents-check",function(){
		let box_length = $("input.contents-check").length;
		let check_length = $("input.contents-check:checked").length;
		if(check_length == box_length){
			$("#check-all").prop("checked", true);
		}else{
			$("#check-all").prop("checked", false);
		}
		
	});
	
	//다중 삭제 버튼 이벤트 
	$(".delete-btn").click(function(){
		let form_data = new FormData();
		let del_items = $("input.contents-check");
		$(del_items).each(function(i,elt){
			if( $(elt).is(":checked") ){
				let contents_seq = $(elt).data("seq");
				form_data.append("del_seqs", contents_seq);
				
			}
		});
		del_notice_item(form_data);
		
	});
	
});

function init() {
	tabMove();
	set_data(1);
}

//23.04.18 공통 pagination 사용하기 위해 함수명 변경 contentsListAjax() -> set_data()
function set_data(pageNo) {
	var nowNo = $("input[name=pageNo]").val();
	var rangeNo = $("input[name=rangeNo]").val();
	
	if(pageNo == '1') {
		start_page_no = 1;
		end_page_no = start_page_no + 4;
		check_end = 'N';
	}
	
	$("input[name=pageNo]").val(pageNo);
	$("input[name=rangeNo]").val(rangeNo);
	
	var formdata = $("#search")[0];
	var form_data = new FormData(formdata);
	var json = $("#search").serialize();
	
	var succ_func = function(resData, status ) {
		drawList(resData);
	};
	
	ajax_json_post("/conage/contentEnrollMain/index.do", json, succ_func);
};

function tabMove() {
	var tab = $("#nav-tab").find(".active").data("tab");
	$("#search_tap").val(tab);
}

function del_notice_item(form_data){
	let del_url= "/conage/contentEnroll/delete.do";
	let confirm_func = function(){
		
		let check_length = $("input.contents-check:checked").length;
		if(check_length <= 0) {
			alert_warning("삭제할 콘텐츠를 선택해주세요.");
			return;
		}
		
		let succ_func = function(resData , status){
			
			if(resData.result == "success"){
				let move_list = function(){
					location.href = "/conage/contentEnrollMain/index.do";
				}
				alert_success("삭제가 완료되었습니다.",move_list);
			} else if(resData.result == "failed") {
				alert_error( resData.msg, null );
			} else if(resData.result == "checked") {
				var html = resData.course[0].contents_nm +' 콘텐츠가 <br>';
				html += '현재 운영중인 강좌에 연결되어있습니다.<br><br>';
				html += '<div style="overflow-y:scroll; height:200px;">';
				$.each(resData.course, function() {
					html +='<a href="/conage/courseEnroll/view.do?course_seq='+ this.course_seq +'">' + this.course_nm + '</a><br>';
				});
				html += '</div>';
				
				alert_error( html, null );
			}
		}
		
		ajax_form_delete( del_url, form_data ,succ_func);
	}
	
	confirm_warning("삭제하시겠습니까?" , confirm_func);
}

function drawList(resData) {
	
	/* 마지막 페이지 정보 초기화 */
	end_page_no = start_page_no + 4;
	check_end = 'N';
	
	$("#table-body").empty();
	$("#page-ul").empty();
	var list = resData.list;
	var search = resData.search;
	var html = "";
	var page_info = "";
	
	//총 건수
	var totalCount = search.totalCount;
	$("#totalCnt").html(totalCount);
	
	// draw table data
	if(list.data.length > 0){
		$.each(list.data, function() {
			html += '<tr id="data_'+this.contents_seq+'">';
			html += '<td><label class="custom_check">';
			html += '<input type="checkbox" class="contents-check" data-seq="'+this.contents_seq+'">';
			html += '<span class="checkmark"></span></label></td>';
			html += '<td class="contents-td"><a href="javascript:;" class="link">';
			if(this.contents_nm != '') {
				html +=	'['+this.contents_seq+'] </a> <span>'+this.contents_nm+'</span></td>';
			} else {
				html +=	'['+this.contents_seq+'] </a> <span>-</span></td>';
			}
			if(this.vod_gb =='M') {
				html +=	'<td class="contents-td"><span class="badge info-low">동영상</span></td>';
			} else if(this.vod_gb =='O') {
				html +=	'<td class="contents-td"><span class="badge info-medium">외부영상</span></td>';
			} else if(this.vod_gb =='Y') {
				html +=	'<td class="contents-td"><span class="badge info-high">유튜브</span></td>';
			} else {
				html +=	'<td class="contents-td"><span>-</span></td>';
			}
			if(this.reg_dts != '') {
				html +=	'<td class="contents-td">'+this.reg_dts+'</td>';
			} else {
				html +=	'<td class="contents-td">-</td>';
			}
			if(this.reg_user_nm != '') {
				html +=	'<td class="contents-td">'+this.reg_user_nm+'</td>';
			} else {
				html +=	'<td class="contents-td">-</td>';
			}
			if(this.use_yn =='Y') {
				html +=	'<td class="contents-td"><span class="badge info-low">사용</span></td>';
			} else if(this.use_yn =='N') {
				html +=	'<td class="contents-td"><span class="badge info-high">중지</span></td>';
			} else {
				html +=	'<td class="contents-td"><span>-</span></td>';
			}
			if(this.update_yn =='Y') {
				html +=	'<td class="contents-td"><span class="badge info-low">가능</span></td>';
			} else {
				html +=	'<td class="contents-td"><span class="badge info-high">불가</span></td>';
			}
			html += '</tr>';
		});
		
		//draw pagenation
		page_info += "<ul class='pagination lms-page'>";
		page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";
	
		if (end_page_no >= resData.search.pageCount) {
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
		html += "<tr><td colspan='6' style='text-align:center' class='mb-4'>	데이터가 존재하지 않습니다. </td></tr>";
	}
	$("#table-body").append(html);
	$("#pagination").html(page_info);

}

</script>
<%-- <!-- Banner -->
<jsp:include page="/WEB-INF/layout/common/banner.jsp" />
<!-- /Banner --> --%>

<!-- Instructor Dashboard -->
<section class="page-content course-sec">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<div class="card instructor-card">


					<div class="settings-widget">
						<div class="settings-inner-blk p-0">
							<div class="comman-space pb-0">
								<div
									class="filter-grp ticket-grp align-items-center justify-content-between">
									<div class="mb20">
										<h3>콘텐츠 등록</h3>
										<p>콘텐츠를 등록할 수 있습니다.</p>
									</div>

									<!-- Filter -->
									<div class="d-multi">
										<div class="show-filter add-course-info col-lg-6">
											<form:form modelAttribute="search" onSubmit="return false;">
												<form:hidden path="pageNo"/>	<%-- JSP PAGING 현재 페이지 번호 --%>
												<form:hidden path="rangeNo"/> <%-- JSP PAGING 현재 범위 번호 --%>
												<form:hidden path="pageSize"/> <%-- JSP PAGING 페이지 당 레코드 카운트 --%>
												<form:hidden path="rangeSize" value="5"/> <%-- JSP PAGING 범위 당 페이지 사이즈   --%>
												<form:hidden path="totalCount"/> <%-- JSP PAGING 현재 검색조건 글의 카운트   --%>
												<form:hidden path="pageCount"/> <%-- JSP PAGING 현재 검색조건 페이지 카운트   --%>
												<form:hidden path="rangeCount"/> <%-- JSP PAGING 현재 검색조건 범위 카운트   --%>
												<form:hidden path="search_tap"/>
												<div class="row gx-2 align-items-center">
													<div class="col-md-8 col-item">
														<div class=" search-group">
															<i class="feather-search"></i> 
															<form:input class="form-control" path="search_text" placeholder="검색어를 입력해주세요"/>
														</div>
													</div>
													<div class="col-md-3 col-item">
														<div class="form-group select-form mb-0">
															<form:select class="form-select select" path="search_type">
																<form:option value="all">전체</form:option>
																<form:option value="VN">콘텐츠명</form:option>
																<form:option value="VR">등록자</form:option>
															</form:select>
														</div>
													</div>
												</div>
											</form:form>
										</div>
										<div class="col-lg-6">
											<div class="ticket-btn-grp">
												<a class="search-btn mr10 fl" href="javascript:void(0)">검색</a>
												<a class="regist-btn fr btn-register" href="/conage/contentEnroll/detail.do">등록</a>
											</div>
										</div>
									</div>
									<!-- /Filter -->

								</div>
								<!-- Ticket Tab -->
								<div class="category-tab tickets-tab-blk">
									<ul id="nav-tab" class="nav nav-justified ">
										<li class="nav-item">
											<a href="javascript:void(0);" class="nav-link active bs-20" data-bs-toggle="tab" data-tab="all">전체</a>
										</li>
										<li class="nav-item">
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="video">동영상</a>
										</li>
										<li class="nav-item">
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="link">외부영상</a>
										</li>
										<li class="nav-item">
											<a href="javascript:void(0);" class="nav-link bs-20" data-bs-toggle="tab" data-tab="youtube">유튜브</a>
										</li>
									</ul>
								</div>
								<!-- /Ticket Tab -->
								
								<div class="show-result" style="text-align: right;margin-bottom: 5px;">
									<h4>
										총 <span id="totalCnt">0</span>건
									</h4>
								</div>

								<!-- Referred Ticket List -->
								<div class="tab-content">
									<div class="tab-pane fade show active" id="all">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Contents-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>
															<label class="custom_check">
																<input type="checkbox" id="check-all">
																<span class="checkmark"></span>
															</label>
														</th>
														<th>콘텐츠명</th>
														<th>영상구분</th>
														<th>등록일</th>
														<th>등록자</th>
														<th>상태</th>
														<th>삭제</th>
													</tr>
												</thead>
												<tbody id="table-body">
												</tbody>
											</table>
											<!-- /Referred Contents-->

										</div>
									</div>
									
								</div>
								<!-- Referred Ticket List -->
							</div>
						</div>
					</div>
				</div>
				<!-- Profile Details -->

			</div>
			
			<!-- /pagination -->
			<div class="row">
				<div class="col-md-10" id="pagination"></div>
				<div class="col-md-2 ticket-btn-grp delete-btn-wrap">
					<a class="delete-btn" href="javascript:void(0)" style="background: #B71C1C; border: 1px solid #B71C1C;">삭제</a>
				</div>
			</div>
			<!-- /pagination -->
			
		</div>
	</div>
</section>
<!-- /Instructor Dashboard -->

