<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<style>
	#body-course_real > tr:hover{
		background:rgba(1, 118, 213, 0.1);
	}
</style>
<%-- Ajax Paging --%>
<script>
	
	var start_page_no = 1;
	var end_page_no = start_page_no + 4;
	var check_end = 'N';
	var click_val = 'all';
	
	$(document).ready(function(){
		$("#ajax_search").on( "click", function( event ){ 
	 		start_page_no = 1;
	 		end_page_no = start_page_no + 4;
	 		check_end = 'N';
	 		
			set_data();
		});
		
		$("#search_type").on( "change", function(  ){
	 		
	 		click_val = $(this).val();
	 		start_page_no = 1;
	 		end_page_no = start_page_no + 4;
	 		check_end = 'N';
	 		set_data();
	
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
	 	
		// radio button click
	 	$(document).on("click","#body-course_real > tr",function(){
	 		$(this).children().find("input").prop("checked",true);
	 	});
	 	
		// 강좌 입력 버튼
		$("#ins_course").on("click", function() {
			var checkedValue = $("#body-course_real > tr > td > input[type=radio]:checked").val();

			if(isEmpty(checkedValue)){
				alert_error("등록할 강좌를 선택해주세요.");
				return;
			}
			
			var confirm_func = function() {
				var form_data = new FormData();
				form_data.append( "course_seq", checkedValue );
				
				var succ_func = function(resData, status ) {
					var course = resData.course;
					var contents = resData.contents;
					
					// put course data
					$("#course_nm").val(course.course_nm);
					$("#course_subject").val(course.course_subject);
					$("#category_seq").val(course.category_seq);
					$("#select2-category_seq-container").attr("title",$("#category_seq option:selected").text());
					$("#select2-category_seq-container").text($("#category_seq option:selected").text());
					$("#instructor_nm").val(course.instructor_nm);
					$("#reg_inst_nm").val(course.reg_inst_nm);
					editor.setData(course.course_descr);
					
					// put contents data
					bf_type = course.type_seq;
					$("#type_seq").val(course.type_seq);
					$("#select2-type_seq-container").attr("title",$("#type_seq option:selected").text());
					$("#select2-type_seq-container").text($("#type_seq option:selected").text());
					
					$("#accordion").empty();
					$.each( contents, function( index, data ){
						if(data.del_yn == 'N' && data.use_yn == 'Y'){
							var template = makeContents(data);
							$(template).tmpl().appendTo($("#accordion"));	
						}
					});
					
					// inputValid check 
					inputValid("input");
					inputValid("category");
					inputValid("type");
					
					alert_success( "입력 완료하였습니다.");
					
					$(".remodal-cancel").click();
				};
				
				ajax_form_put("/conage/modal/courseEnrollCourse.do", form_data, succ_func);
			};
			
			confirm_warning("해당 강좌를 입력하시겠습니까?",confirm_func);
		});
		
		$("#exit_course").on("click",function(){
			basicReModal.destory();
		})		            
	});
	
	function set_data(pageNo){
		
		/* 마지막 페이지 정보 초기화 */
		end_page_no = start_page_no + 4;
		check_end = 'N';
		
		var text = $('#search_text').val();
		var action = "/conage/modal/courseEnrollCourse.do";
		
		if(pageNo == '' || pageNo == null){
			
			pageNo = 1;
		}
		
		
		var form_data = new FormData();
		form_data.append( "pageNo", pageNo );
		form_data.append( "search_type", click_val );
		form_data.append( "search_text", text );
		
		var str = "";
		var page_info = "";
		
		var succ_func = function( resData, status ){
			
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;
			
			//Set Table Data
			if (listLen > 0) {
				$.each( list, function( index, data ){					
					str += "<tr style='cursor:pointer;'>";				
					str += "<td><input type='radio' name='seq' value='" + data.courseSeq + "'/></td>";
					str += "<td><span>" + data.courseNm  + "</span></td>";
					str += "<td><span>" + data.categoryNm  + "</span></td>";
					str += "<td><span>" + data.typeNm  + "</span></td>";
					str += "<td><span>" + data.courseRound  + "</span></td>";
					str += "<td><span>" + data.status  + "</span></td>";
					str += "</tr>";
				}); 
				
					//Set Pagination Data					
					page_info += "<ul class='pagination lms-page'>";
					page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page2();'><i class='fas fa-angle-left'></i></a></li>";
					
					if(end_page_no >= resData.search.pageCount ){
						end_page_no = resData.search.pageCount;
						check_end = 'Y';
					}
					
					
					for (var a = start_page_no; a <= end_page_no; a++) {
						var setNog = resData.paging.page;
						if(a == setNog){
							var class_name = 'page-item first-page active';
						}else{
							var class_name = 'page-item first-page';
						}
						page_info += "<li class='"+ class_name +"'>";
						page_info += "<a class='page-link' href='javascript:void(0)' onclick='set_data("+ a +");'>"+ a +"</a></li>";
					}
					
					page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page2();'><i class='fas fa-angle-right'></i></a></li>";
					page_info += "</ul>";
					
				
				// Put data
				$("#body-course_real").html(str);
				$("#pagination2").html(page_info);		
			
			
			}else{
				str += "<tr><td colspan='6' style='text-align:center' class='mb-4'>	데이터가 존재하지 않습니다. </td></tr>";
				$("#body-course_real").html(str);
				$("#pagination2").html(page_info);
			}

		}		
			
		
		
		ajax_form_post( action, form_data, succ_func );
		
	}

</script>

<div class="remodal" role="dialog" data-remodal-id="course">
	<button data-remodal-action="close" class="remodal-close"
		aria-label="Close"></button>
	<div class="modal-content">
		<div class="modal-body">
			<div class="col-lg-12" style="margin-bottom:20px;">
				<div class="show-filter add-course-info">
					<form:form modelAttribute="search" onsubmit="return false;">
						<div class="row gx-2 align-items-center">
							<div class="col-md-6 col-lg-5 col-item">
								<div class="form-group select-form mb-0">
									<form:select path="search_type" class="form-select select course_type">
										<form:option value="all"><spring:message code="search.all"/></form:option>
										<form:option value="name"><spring:message code="course.name"/></form:option>
										<form:option value="descr"><spring:message code="course.descr"/></form:option>
									</form:select>
								</div>
							</div>
							<div class="col-md-6 col-lg-5 col-item">
								<div class=" search-group">
									<i class="feather-search"></i>
									<c:set var ="searchMsg"><spring:message code='search.keyword'/></c:set>
									<input type="hidden"/>
									<form:input path="search_text" type="text" class="form-control course_text"
										placeholder="${searchMsg}" />
								</div>
							</div>
							<div class="ticket-btn-grp col-md-12 col-lg-2">
								<a href="javascript:void(0);" id="ajax_search" class="course_search">조회</a>
							</div>
						</div>
					</form:form>
				</div>
			</div>
			<div class="row">
				<div class="col-12">
					<div class="card">
						<!-- /.card-header -->
						<div class="card-body table-responsive p-0" style="height: 350px;">					
							<!-- Referred Users-->
							<table class="table table-nowrap mb-0">
								<thead>
									<tr>
										<th>선택</th>
										<th><spring:message code="course.name"/></th>
										<th><spring:message code="course.category"/></th>
										<th><spring:message code="course.type"/></th>
										<th>콘텐츠수</th>
										<th><spring:message code="course.status"/></th>
										
									</tr>
								</thead>
								<tbody id="body-course_real">
								</tbody>
							</table>
							<!-- /Referred Users-->
							
							
							<div class="row">
								<div class="col-md-12" id="pagination2">
								</div>
							</div>
							
						</div>
					</div>
				</div>
			</div>
	</div>
		</div>
		<div class="modal-footer justify-content-between">
			<button data-remodal-action="cancel" class="remodal-cancel">닫기</button>
			<button class="remodal-confirm" id="ins_course">강좌 입력</button>
		</div>
	<!-- /.modal-content -->

</div>
