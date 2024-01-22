<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>


<!-- Feather CSS -->
<link rel="stylesheet" href="/assets/css/feather.css">

<script type="text/javascript">

var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';
var click_val = 'all';

$(document).ready(function(){
	set_data();
	$("#ajax_search").on( "click", function( event ){
		event.preventDefault();
		set_data();
	});
	
 	$("#allclick").on( "click", function(  ){
		
 		click_val = 'all';
 		start_page_no = 1;
 		end_page_no = start_page_no + 4;
 		check_end = 'N';
 		set_data();

	});
 	
	$("#user").on( "click", function(  ){
		click_val = 'user';
		start_page_no = 1;
 		end_page_no = start_page_no + 4;
 		check_end = 'N';
		set_data();

	});
	
	$("#admin").on( "click", function(  ){
		click_val = 'admin';
		start_page_no = 1;
 		end_page_no = start_page_no + 4;
 		check_end = 'N';
		set_data();

	});
	
		            
});


	
function set_data(pageNo){
	
	var userId = $('#user_id').val();
	var action = "/accessRecordMain/jsp_paging.do";
	
	if(pageNo == '' || pageNo == null){
		
		pageNo = 1;
	}
	
	
	var form_data = new FormData();
	form_data.append( "pageNo", pageNo );
	//form_data.append( "search_type", "user_id" );
	form_data.append( "search_type", click_val );
	form_data.append( "search_text", userId );
			var str = "";
			var page_info = "";
	
		var succ_func = function( resData, status ){
			
			
			
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;
			
			
			if (listLen > 0) {
				$.each( list, function( index, data ){
					
					
					str += "<tr>";
					str += "<td><span class='link'> [" + data.user_id + "] " +"</span><span>";
					str += data.user_name  +"</span></td>";
					str += "<td><span>" + data.role_type  +"</span></td>";
					str += "<td><span>" + data.conn_ip  +"</span></td>";
					str += "<td><span>" + data.conn_dt  +"</span></td>";
					str += "</tr>";
				}) 
					page_info += "<ul class='pagination lms-page'>";
					page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";
					
					
					
					
					if(end_page_no >= resData.search.pageCount ){
						
						end_page_no = resData.search.pageCount;
						check_end = 'Y';
					}
					
					
					for (var a = start_page_no; a <= end_page_no; a++) {
						var setNog = resData.paging.page;
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
					
				
				$("#body-access").html(str);
				$("#body-access2").html(str);
				$("#body-access3").html(str);
				$("#pagination").html(page_info);		
			
			
			}else
			
		
				str += "<tr><td colspan='4' style='text-align:center'>	데이터가 존재하지 않습니다. </td></tr>";
				$("#body-access").html(str);
				$("#body-access2").html(str);
				$("#body-access3").html(str);
				$("#pagination").html(page_info);
			
			}		
			
		
	
		ajax_form_post( action, form_data, succ_func );
	
}	



	





</script>



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
										<h3>회원접속 기록</h3>
										<p>You can check the membership log.</p>
									</div>

									<!-- Filter -->
									<div class="d-multi">
										<div class="col-lg-3">
											<div class="show-filter add-course-info">
												<form action="#" onsubmit="return false;">
													<div class="row gx-2 align-items-center">
														<div class="col-md-11 col-item">
															<div class=" search-group">
																<i class="feather-search"></i> 
																<input type="text"
																	id="user_id" class="form-control"
																	placeholder="ID를 입력해 주세요.">
															</div>
														</div>
													</div>
												</form>
											</div>
										</div>
										<div class="col-lg-3">
											<div class="ticket-btn-grp mt10">
												<a class="regist-btn btn-register" href="javascript:void(0);" id="ajax_search">조회</a>
											</div>
										</div>
									</div>
									<!-- /Filter -->

								</div>
								<!-- Ticket Tab -->
								<div class="category-tab tickets-tab-blk">
									<ul class="nav nav-justified ">
										<li class="nav-item"><a href="#all"
											class="nav-link active bs-20" data-bs-toggle="tab" id='allclick'>ALL</a></li>
										<li class="nav-item"><a href="#open" class="nav-link bs-20"
											data-bs-toggle="tab" id='user'>USER</a></li>
										<li class="nav-item"><a href="#inprogress"
											class="nav-link bs-20" data-bs-toggle="tab" id='admin'>ADMIN</a></li>
									</ul>
								</div>
								<!-- /Ticket Tab -->

								<!-- Referred Ticket List -->
								<div class="tab-content">
									<div class="tab-pane fade show active" id="all">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>ID-이름</th>
														<th>권한</th>
														<th>접속 IP</th>
														<th>접속 날짜</th>
													</tr>
												</thead>
												<tbody id="body-access">
													
												</tbody>
											</table>
											<!-- /Referred Users-->

										</div>
									</div>

									<div class="tab-pane fade show " id="open">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>ID-이름</th>
														<th>권한</th>
														<th>접속 IP</th>
														<th>접속 날짜</th>
													</tr>
												</thead>
												<tbody id="body-access2">
													
												</tbody>
											</table>
											<!-- /Referred Users-->

										</div>
									</div>
									<div class="tab-pane fade show " id="inprogress">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>ID-이름</th>
														<th>권한</th>
														<th>접속 IP</th>
														<th>접속 날짜</th>
													</tr>
												</thead>
												<tbody id="body-access3">
													
												</tbody>
											</table>
											<!-- /Referred Users-->

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



			<div class="row">
				<div class="col-md-12" id="pagination">
				</div>
			</div>

		</div>
</section>





