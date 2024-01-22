<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<style>
	#body-contents > tr:hover{
		background:rgba(1, 118, 213, 0.1);
	}
</style>
<script type="text/javascript">

$(document).ready (function(){
	
	// 일괄등록 버튼 클릭
	$("#ins_chk_contents").click(function(){
		
		// 등록된 건수
		var count = 0;

		var selectedList = $("input[name=get_contents_seqs]").map(function(){return $(this).val();}).get();
		var checkedList = $("#body-contents > tr > td > input[type=checkbox]:checked").map(function(){return $(this).val();}).get();
		
		if(checkedList.length == 0){
			alert_warning("등록할 콘텐츠를 선택바랍니다.");
			return;
		}
		
		var isDuplicated = false;
		// 중복건이 있을 시 등록 불가 하게 처리
		$("#body-contents > tr > td > input:checkbox").each(function(){
			var checked = $(this).is(":checked");
			if(checked){
				var seq = $(this).val();
				// 이미 등록되지 않은 경우에만
				if(selectedList.indexOf(seq) == -1){
					isDuplicated = true;
				}
			}
			if(isDuplicated){
				alert_warning("이미 등록된 콘텐츠는 등록할 수 없습니다.");
				return;
			}
		});
		
		// 외부영상 타입은 1개만 등록 할 수 있다.
		var tSeq = $("#type_seq").val();
		if(tSeq == 188){
			if(checkedList.length > 1 || selectedList.length > 0){
				alert_warning("외부영상 콘텐츠는 1건만 등록 할 수 있습니다.");
				return;
			}
		}
		if(tSeq == 534){
			if(checkedList.length > 1 || selectedList.length > 0){
				alert_warning("유튜브 콘텐츠는 1건만 등록 할 수 있습니다.");
				return;
			}
		}
		
		var isDuplicated = false;
		// 중복건이 있을 시 등록 불가 하게 처리
		$("#body-contents > tr > td > input:checkbox").each(function(){
			var checked = $(this).is(":checked");
			if(checked){
				var seq = $(this).val();
				// 이미 등록되지 않은 경우에만
				if(selectedList.indexOf(seq) != -1){
					isDuplicated = true;
				}
			}
		});
		if(isDuplicated){
			alert_warning("이미 등록된 콘텐츠는 등록할 수 없습니다.");
			return;
		}
		
		
		// 중복건은 제외하고 등록한다.
		$("#body-contents > tr > td > input:checkbox").each(function(){
			var checked = $(this).is(":checked");
			if(checked){
				var seq = $(this).val();
				// 이미 등록되지 않은 경우에만
				if(selectedList.indexOf(seq) == -1){
					count = count + 1;
					var template = makeContents(contents[seq]);
					$(template).tmpl().appendTo($("#accordion"));
				}
				
			}
		});
		
		alert_info(count +"건이 등록되었습니다.");
		if($("input[name=get_contents_seqs]").length > 0){
			$(".emptyContents").remove();
		}
		
		//강좌콘텐츠 type 설정
		bf_type = $("#type_seq").val();
		
		$(".remodal-cancel").click();
		
	});
	
	// 콘텐츠 단일 선택
	$(document).off("click","#body-contents > tr ");
	$(document).on("click","#body-contents > tr ",function(event){
		if(!$(event.target).is('input')){
			var $checkbox = $(this).children().find("input");
			if($checkbox.is(":checked")){
				$checkbox.prop("checked",false);
			} else {
				$checkbox.prop("checked",true);
			}			
		}
 	});
	
	//콘텐츠 전체 선택 버튼
	$("#all_check").click(function(){
		// 전체선택
		if($(this).is(":checked")){
			$("#body-contents > tr > td > input:checkbox").prop("checked",true);
			
		// 전체해제
		} else {
			$("#body-contents > tr > td > input:checkbox").prop("checked",false);
		}
	});

});

</script>

<%-- Ajax Paging --%>
<script>
	
	var start_page_no = 1;
	var end_page_no = start_page_no + 4;
	var check_end = 'N';
	var click_val = 'all';
	var contents = {};
	
	$(document).ready(function(){
		$("#ajax_search").on( "click", function( event ){ 
	 		start_page_no = 1;
	 		end_page_no = start_page_no + 4;
	 		check_end = 'N';
	 		
			set_data();
		});
		
	 	$("#search_type").on( "change", function(  ){
	 		
	 		// 전체선택 버튼 초기화
			$("#all_check").prop("checked",false);
	 		
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
		            
	});
	
	function set_data(pageNo){
		
		/* 마지막 페이지 정보 초기화 */
		end_page_no = start_page_no + 4;
		check_end = 'N';
		
 		// 전체선택 버튼 초기화
		$("#all_check").prop("checked",false);
		
		var text = $('#search_text').val();
		var courseType = $("#type_seq").val();
		var action = "/conage/modal/courseEnrollContents.do";
		
		if(pageNo == '' || pageNo == null){
			
			pageNo = 1;
		}
		
		
		var form_data = new FormData();
		form_data.append( "pageNo", pageNo );
		form_data.append( "search_type", click_val );
		form_data.append( "search_text", text );
		form_data.append( "search_tap" , courseType);
		
		var str = "";
		var page_info = "";
		
		var succ_func = function( resData, status ){
			
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;
			
			//Set Table Data
			if (listLen > 0) {
				// 이미 등록된 리스트는 회색 배경 표시
				var selectedList = $("input[name=get_contents_seqs]").map(function(){return $(this).val();}).get();
				$.each( list, function( index, data ){
					
					content = {};
					content['contents_seq'] = data.contents_seq;
					content['contents_nm'] = data.contents_nm;
					content['contents_descr'] = data.contents_descr;
					content['vod_gb'] = data.vod_gb;
					content['vod_url'] = data.vod_url;
					content['width_size'] = data.width_size;
					content['height_size'] = data.height_size;
					content['vod_time_sec'] = data.vod_time_sec;
					content['use_yn'] = data.use_yn;
					content['del_yn'] = data.del_yn;
					content['reg_dts'] = data.reg_dts;
					content['reg_user'] = data.reg_user;
					content['upd_dts'] = data.upd_dts;
					content['upd_user'] = data.upd_user;
					
					contents[data.contents_seq] = content;
					var seq = data.contents_seq;
					// 이미 등록되지 않은 경우에만
					if(selectedList.indexOf(seq.toString()) != -1){
						str += "<tr style='cursor:pointer;background:rgba(0,0,0,0.1);'>";
					} else {
						str += "<tr style='cursor:pointer;'>";	
					}
									
					str += "<td><input type='checkbox' name='seq' value='" + data.contents_seq + "'></input></td>";
					str +=	'<td>' + data.contents_nm  +'</td>';
					str += "<td>" + ($("#type_seq").val() == 186 ? data.vod_time_sec : $("#type_seq").val() == 187 ? "-" : data.vod_url )  +"</td>";
					str += "</tr>";
				}) 
				
					//Set Pagination Data					
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
						}else{
							var class_name = 'page-item first-page';
						}
						page_info += "<li class='"+ class_name +"'>";
						page_info += "<a class='page-link' href='javascript:void(0)' onclick='set_data("+ a +");'>"+ a +"</a></li>";
					}
					
					page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
					page_info += "</ul>";
					
				
				// Put data
				$("#body-contents").html(str);
				$("#pagination").html(page_info);		
			
			
			} else {
				str += "<tr><td colspan='3' style='text-align:center' class='mb-4'>	데이터가 존재하지 않습니다. </td></tr>";
				$("#body-contents").html(str);
				$("#pagination").html(page_info);
			}
		}		
			
		
		
		ajax_form_post( action, form_data, succ_func );
		
	}	

</script>

<div class="remodal" role="dialog" data-remodal-id="contents">
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
									<form:select path="search_type" class="form-select select contents_type">
										<form:option value="all">전체</form:option>
										<form:option value="name"><spring:message code="contents.name"/></form:option>
										<form:option value="descr"><spring:message code="contents.descr"/></form:option>
									</form:select>
								</div>
							</div>
							<div class="col-md-6 col-lg-5 col-item">
								<div class=" search-group">
									<i class="feather-search"></i>
									<c:set var ="searchMsg"><spring:message code='search.keyword'/></c:set>
									<input type="hidden"/>
									<form:input path="search_text" type="text" class="form-control contents_text"
										placeholder="${searchMsg}" />
								</div>
							</div>
							<div class="ticket-btn-grp col-md-12 col-lg-2">
								<a href="javascript:void(0);" id="ajax_search" class="contents_search">조회</a>
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
										<th><label for="all_check"><input type="checkbox" id="all_check"/>선택</th></label>
										<th><spring:message code="contents.name"/></th>
										<th id="chg_type"><spring:message code="contents.vodTime"/></th>
									</tr>
								</thead>
								<tbody id="body-contents">
								</tbody>
							</table>
							<!-- /Referred Users-->
							
							
							<div class="row">
								<div class="col-md-12" id="pagination">
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
			<button class="remodal-confirm" id="ins_chk_contents">일괄등록</button>
		</div>
	<!-- /.modal-content -->

</div>
