<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<!-- Feather CSS -->
<link rel="stylesheet" href="/assets/css/feather.css">

<!-- flatpickr CSS, js -->
<link rel="stylesheet" href="/assets/pc/css/flatpickr.min.css">
<link rel="stylesheet" href="/assets/pc/css/monthSelect.css">
<script src="<c:url value='/js/flatpickr.js' />"></script>
<script src="<c:url value='/js/monthSelect.js' />"></script>

<!-- Chart JS -->
<script src="/assets/plugins/apexchart/apexcharts.min.js"></script>

<script type="text/javascript">


var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';
var click_val = 'all';
var search_type = 'month';
var check_login_yn = false;

$(document).ready(function(){
	set_data();
	
	<%-- flatpickr 객체 생성 --%>
	var flatpickr = new BasicFlatpickr();
		flatpickr._target = $( "#search_date" );
		flatpickr._type = "monthSelect";
		flatpickr.init();

	var today = new Date();
	var year = today.getFullYear();
	var month = today.getMonth()+1;
	var default_month = year+"-"+(("00"+month.toString()).slice(-2));
	var default_Date = default_month+"-"+today.getDate();
	
	$( "#search_date" ).val(default_month);
	
	// 날짜 선택
	$("#search_type").on("change",function(){
		<%-- 달력 구분 (M 월별, D 일별) --%>
		var regist_gb = $( this ).val();
		var type = "monthSelect";
		var defaultDate = "";

		<%-- 월별 --%>
		if( regist_gb == "month" ) {
			type = "monthSelect";
			defaultDate = default_month
		}
		
		<%-- 일별 --%>
		if( regist_gb == "day" ) {
			type = "without-time";
			defaultDate = default_Date
		}
		
		<%-- 직접입력 --%>
		if( regist_gb == "period" ) {
			type = "without-time";
		}
		
		if(regist_gb == "period" ){
			$("div[name='period_calendar']").show();
			$("div[name='type_calendar']").hide();
			
			<%-- flatpickr 객체 생성 --%>
			var flatpickr = new BasicFlatpickr();
				flatpickr._target = $("div[name='period_calendar'] .flatpickr");
				flatpickr._type = type;
				flatpickr.init();
			
		} else {
			$("div[name='period_calendar']").hide();
			$("div[name='type_calendar']").show();
			$( "#search_date" ).val(defaultDate);
			
			<%-- flatpickr 객체 생성 --%>
			var flatpickr = new BasicFlatpickr();
				flatpickr._target = $( "#search_date" ); 
				flatpickr._type = type;
				flatpickr.init();
			
			if( regist_gb == "month" ) {
				$( "#search_date" ).val(defaultDate);
			}
		}
		
		
		
	});
	
	//조회 버튼 클릭시 
	$("#ajax_search").on( "click", function( event ){
		event.preventDefault();
		check_render_chart();		//chart 노출여부
		var time_page_val = $("#time_page option:selected").val();
		
		switch (click_val){
			case "all":
				if(check_login_yn){
					set_login_user_data(null, time_page_val);					
				} else {
					set_data(null, time_page_val);
				}
			break;
			
			case "course":
				set_course_data(null, time_page_val);
			break;
			
			default:
				set_data(null, time_page_val);
		}
		
	});
	
	// 메뉴유입통계 버튼 클릭시 
 	$("#allClick").on( "click", function(  ){
 		click_val = 'all';
 		var time_page_val = $("#time_page option:selected").val();
 		$("#allClick").addClass("active");
 		$("input:checkbox[id='check_login_info']").prop("checked", false);
 		check_render_chart();		//chart 노출여부
 		check_login_info_select();
 		$(".tab-content").children().addClass("show");
 		
		start_page_no = 1;
 		end_page_no = start_page_no + 4;
 		check_end = 'N';
 		
 		set_data(null, time_page_val);
	});
	
 	$("#courseClick").on( "click", function(  ){
 		course_click();
	});
	
	// 시간 선택
	$("#time_page").change(function (){
		var time_page_val = $("#time_page option:selected").val();
		
		if( !$.isEmptyObject( time_page_val ) && !(time_page_val == '' || time_page_val == null)){
			$("th[name='time_page']").hide();
			$("th[id="+time_page_val+"]").show();
		} else {
			$("th[name='time_page']").show();
		}
		
		if("course" == click_val){
			set_course_data(null, time_page_val);
		} else {
			if(check_login_yn){
				set_login_user_data(null, time_page_val);
			} else {
				set_data(null, time_page_val);
			}
		}
		
	});
	
	$("#check_login_info").on("click", function(){
		check_login_info_select();
	});
	
});	
	
	//메뉴유입통계
	function set_data(pageNo, time_page) {
		check_render_chart();		//chart 노출여부
		
		var action = "/statics/activeRecordMain/jsp_paging.do";

		if (pageNo == '' || pageNo == null) {
			pageNo = 1;
		}
		
		//기간 겁색
		search_type = $('#search_type').val();
		
		//날짜 검색
		var search_date = "";
		var search_date_end = "";
		
		if(search_type == "period"){
			search_date = $("#start_date").val();
			search_date_end = $("#end_date").val();
		} else {
			search_date = $("#search_date").val();
		}

		var form_data = new FormData();
		form_data.append("pageNo", pageNo);
		form_data.append("search_type", search_type);
		form_data.append("search_date", search_date);
		form_data.append("search_date_end", search_date_end);
		
		if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
			form_data.append("time_page", time_page);
		}

		var str = "";
		var page_info = "";

		var succ_func = function(resData, status) {
			
			/* 상단 차트 생성 시작 */
			const today = new Date();
			const lastday = new Date(today.getFullYear(), today.getMonth()+1, 0);
			const lastdate = lastday.getDate();

			var series = [];
			var arr_menu_data = {};
			var arr_menu_nm_data = {};
			var chartData = resData.activeRecordChart;

			//차트 데이터 0으로 설정
			$.each(chartData, function(index, data) {
				var lastdate_fill = new Array(lastdate).fill(0);
				arr_menu_data[data.menu_seq] = lastdate_fill;
				arr_menu_nm_data[data.menu_seq] = data.menu_nm;
			});
			
			//차트 데이터 변경
			$.each(chartData, function(index, data) {
				arr_menu_data[data.menu_seq][data.day-1]  = data.sum_cnt;
			});
			
			//차트 데이터 셋팅
			$.each(arr_menu_nm_data, function(index, data) {
				var data = {"name" : data , "data" : arr_menu_data[index]};
				series.push(data);
			});
			
			//차트 생성
			render_chart(series);
			/* 상단 차트 생성 끝 */
			
			
			/* 하단 리스트 생성 시작 */
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;

			$(".tab-content").children().removeClass("active");
			$("#all").addClass("active");
			
			if (listLen > 0) {
				$.each(list, function(index, data) {
					str += "<tr>";
					
					if(data.menu_seq == 8){
						str += "<td ><a href='#course' onclick='course_click(); return false;'><span>" + data.menu_nm + "</span></a></td>";
					} else {
						str += "<td><span>" + data.menu_nm + "</span></td>";
					}
					str += "<td><span>" + data.date + "</span></td>";
					str += "<td><span>" + data.sum_cnt + "</span></td>";
					
					if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
						str += "<td><span>" + data.sum_cnt + "</span></td>";
					} else {
						str += "<td><span>" + data.IM + "</span></td>";
						str += "<td><span>" + data.thirty_sec + "</span></td>";
						str += "<td><span>" + data.three_min + "</span></td>";
						str += "<td><span>" + data.five_min + "</span></td>";
						str += "<td><span>" + data.ten_min + "</span></td>";
					}
					
					str += "<td><span>" + data.log_y_cnt + "</span></td>";
					str += "<td><span>" + data.log_n_cnt + "</span></td>";
					str += "<td><span>" + data.mobile + "</span></td>";
					str += "<td><span>" + data.pc + "</span></td>";
					str += "<td><span>" + data.admin + "</span></td>";
					str += "<td><span>" + data.user + "</span></td>";
					str += "</tr>";
				});

				page_info += "<ul class='pagination lms-page'>";
				page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";

				if (end_page_no >= resData.search.pageCount) {
					end_page_no = resData.search.pageCount;
					check_end = 'Y';
				}

				for (var a = start_page_no; a <= end_page_no; a++) {
					var setNog = resData.paging.page;
					if (a == setNog) {
						var class_name = 'page-item first-page active';
						var fn_name = "return false;";
					} else {
						var class_name = 'page-item first-page';
						var fn_name = "set_data("+ a +");";
					}
					page_info += "<li class='"+ class_name +"'>";
					page_info += "<a class='page-link' href='javascript:void(0)' onclick='" + fn_name + "'>" + a + "</a></li>";
				}

				page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
				page_info += "</ul>";

				
				$("#body-access").html(str);
				$("#pagination").html(page_info);
			} else {
				str += "<tr><td colspan='13' style='text-align:center'>	데이터가 존재하지 않습니다. </td></tr>";
			}
			$("#body-access").html(str);
			$("#pagination").html(page_info);
			/* 하단 리스트 생성 끝 */
		}

		ajax_form_post(action, form_data, succ_func);
	}

	//로그인사용자정보
	function set_login_user_data(pageNo, time_page) {
		check_render_chart();		//chart 노출여부
		
		var action = "/statics/activeLoginUserRecord/jsp_paging.do";

		if (pageNo == '' || pageNo == null) {
			pageNo = 1;
		}
		
		//시간 겁색
		search_type = $('#search_type').val();
		
		//날짜 검색
		var search_date = "";
		var search_date_end = "";
		
		if(search_type == "period"){
			search_date = $("#start_date").val();
			search_date_end = $("#end_date").val();
		} else {
			search_date = $("#search_date").val();
		}
		
		//성별 검색
		var gender;
		var region;
		var age;
		var job
		var search_detail_yn;
		if(check_login_yn){
			gender = $("#gender").val();
			region = $("#region").val();
			age = $("#age").val();
			job = $("#job").val();
			
			if(gender == "" && region == "" && age == "" && job == ""){
				search_detail_yn = "N";
				$("#login_detail_type").hide();
			} else {
				search_detail_yn = "Y";
				$("#login_detail_type").show();
			}
		}
		
		var form_data = new FormData();
		form_data.append("pageNo", pageNo);
		form_data.append("search_type", search_type);
		form_data.append("search_date", search_date);
		form_data.append("search_date_end", search_date_end);
		form_data.append("gender", gender);
		form_data.append("region", region);
		form_data.append("age", age);
		form_data.append("job", job);
		form_data.append("search_detail_yn", search_detail_yn);

		if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
			form_data.append("time_page", time_page);
		}

		var str = "";
		var page_info = "";

		var succ_func = function(resData, status) {
			$(".tab-content").children().removeClass("active");
			$("#login_user").addClass("active");
			
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;

			if (listLen > 0) {
				$.each(list, function(index, data) {
					str += "<tr>";
					str += "<td><span>" + data.menu_nm + "</span></td>";
					str += "<td><span>" + data.date + "</span></td>";
					if(search_detail_yn == "Y"){
						str += "<td><span>" + data.detail_type_nm +"("+data.detail_gb_nm+")</span></td>";
					} 
					str += "<td><span>" + data.sum_cnt + "</span></td>";
					if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
						str += "<td><span>" + data.sum_cnt + "</span></td>";
					} else {
						str += "<td><span>" + data.IM + "</span></td>";
						str += "<td><span>" + data.thirty_sec + "</span></td>";
						str += "<td><span>" + data.three_min + "</span></td>";
						str += "<td><span>" + data.five_min + "</span></td>";
						str += "<td><span>" + data.ten_min + "</span></td>";
						
					}
					str += "<td><span>" + data.mobile + "</span></td>";
					str += "<td><span>" + data.pc + "</span></td>";
					str += "</tr>";
				});

				page_info += "<ul class='pagination lms-page'>";
				page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";

				if (end_page_no >= resData.search.pageCount) {
					end_page_no = resData.search.pageCount;
					check_end = 'Y';
				}

				for (var a = start_page_no; a <= end_page_no; a++) {
					var setNog = resData.paging.page;
					if (a == setNog) {
						var class_name = 'page-item first-page active';
						var fn_name = "return false;";
					} else {
						var class_name = 'page-item first-page';
						var fn_name = "set_data("+ a +");";
					}
					page_info += "<li class='"+ class_name +"'>";
					page_info += "<a class='page-link' href='javascript:void(0)' onclick='" + fn_name + "'>" + a + "</a></li>";
				}

				page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
				page_info += "</ul>";

				
				$("#body-access2").html(str);
				$("#pagination").html(page_info);
			} else {
				str += "<tr><td colspan=11' style='text-align:center'>	데이터가 존재하지 않습니다. </td></tr>";
			}
			$("#body-access2").html(str);
			$("#pagination").html(page_info);
		}

		ajax_form_post(action, form_data, succ_func);
	}

	//강좌통계
	function set_course_data(pageNo, time_page) {
		check_render_chart();		//chart 노출여부
		
		var action = "/statics/courseRecord/jsp_paging.do";

		if (pageNo == '' || pageNo == null) {
			pageNo = 1;
		}
		
		//테이블 비로그인 사용자 th 숨기기
		if(check_login_yn){
			$("th[name='check_login_yn']").hide();
		} else {
			$("th[name='check_login_yn']").show();
		}
		
		//시간 겁색
		search_type = $('#search_type').val();
		
		//날짜 검색
		var search_date = "";
		var search_date_end = "";
		
		if(search_type == "period"){
			search_date = $("#start_date").val();
			search_date_end = $("#end_date").val();
		} else {
			search_date = $("#search_date").val();
		}

		//성별 검색
		var gender;
		var region;
		var age;
		var job
		var search_detail_yn;
		if(check_login_yn){
			gender = $("#gender").val();
			region = $("#region").val();
			age = $("#age").val();
			job = $("#job").val();
			
			if(gender == "" && region == "" && age == "" && job == ""){
				search_detail_yn = "N";
				$("#course_detail_type").hide();
			} else {
				search_detail_yn = "Y";
				$("#course_detail_type").show();
			}
		}
		
		var form_data = new FormData();
		form_data.append("pageNo", pageNo);
		form_data.append("search_type", search_type);
		form_data.append("search_date", search_date);
		form_data.append("search_date_end", search_date_end);
		form_data.append("check_login_yn", check_login_yn);
		form_data.append("gender", gender);
		form_data.append("region", region);
		form_data.append("age", age);
		form_data.append("job", job);
		form_data.append("search_detail_yn", search_detail_yn);
		
		if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
			form_data.append("time_page", time_page);
		}
		
		var str = "";
		var page_info = "";

		var succ_func = function(resData, status) {
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var list = resData.paging.data;
			var listLen = list.length;

			if (listLen > 0) {
				$.each(list, function(index, data) {
					str += "<tr>";
					str += "<td><span>" + data.course_nm + "</span></td>";
					str += "<td><span>" + data.date + "</span></td>";
					if(check_login_yn){
						if(search_detail_yn == "Y"){
							str += "<td><span>" + data.detail_type_nm +"("+data.detail_gb_nm+")</span></td>";
						} 
					}
					str += "<td><span>" + data.sum_course_cnt + "</span></td>";
					if( !$.isEmptyObject( time_page ) && !(time_page == '' || time_page == null)){
						str += "<td><span>" + data.sum_course_cnt + "</span></td>";
					} else {
						str += "<td><span>" + data.IM + "</span></td>";
						str += "<td><span>" + data.thirty_sec + "</span></td>";
						str += "<td><span>" + data.three_min + "</span></td>";
						str += "<td><span>" + data.five_min + "</span></td>";
						str += "<td><span>" + data.ten_min + "</span></td>";
						
					}
					str += "<td><span>" + data.log_y_cnt + "</span></td>";
					if(!check_login_yn){
						str += "<td><span>" + data.log_n_cnt + "</span></td>";
					}
					str += "<td><span>" + data.mobile + "</span></td>";
					str += "<td><span>" + data.pc + "</span></td>";
					str += "</tr>";
				});

				page_info += "<ul class='pagination lms-page'>";
				page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";

				if (end_page_no >= resData.search.pageCount) {
					end_page_no = resData.search.pageCount;
					check_end = 'Y';
				}

				for (var a = start_page_no; a <= end_page_no; a++) {
					var setNog = resData.paging.page;
					if (a == setNog) {
						var class_name = 'page-item first-page active';
						var fn_name = "return false;";
					} else {
						var class_name = 'page-item first-page';
						var fn_name = "set_data("+ a +");";
					}
					page_info += "<li class='"+ class_name +"'>";
					page_info += "<a class='page-link' href='javascript:void(0)' onclick='" + fn_name + "'>" + a + "</a></li>";
				}

				page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
				page_info += "</ul>";

				$(".tab-content").children().removeClass("active");
				$("#course").addClass("active");
				$("#body-access3").html(str);
				$("#pagination").html(page_info);
			} else {
				str += "<tr><td colspan='10' style='text-align:center'>	데이터가 존재하지 않습니다. </td></tr>";
			}
			$("#body-access3").html(str);
			$("#pagination").html(page_info);
		}

		ajax_form_post(action, form_data, succ_func);
	}
	
	function set_chart_data(categories, series){
		var options = {
				series : series,
				colors : [ '#FF9364', '#0d6efd', '#198754', '#ffc107' ],
				chart : {
					id: 'mychart',
					height : 300,
					type : 'area',
					toolbar : {
						show : false
					},
					zoom : {
						enabled : false
					}
				},
				markers : {
					size : 3,
				},
				dataLabels : {
					enabled : false
				},
				stroke : {
					curve : 'smooth',
					width : 3,
				},
				legend : {
					position : 'top',
					horizontalAlign : 'right',
				},
				grid : {
					show : true,
				},
				yaxis : {
					axisBorder : {
						show : true,
					},
				},
				xaxis : {
					categories : categories,
					labels: {
						rotate: 0
					}
				
				}
			};
		
		return options;
	}
	
	var log_chart;
	function render_chart(series){
		/* 상단 차트 생성 시작 */
		var chartday = [];
		
		const today = new Date();
		const lastday = new Date(today.getFullYear(), today.getMonth()+1, 0);
		const lastdate = lastday.getDate();
		
		//차트 x축 날짜 데이터
		for (var i=1; i <= lastdate; i++) {
			chartday.push(i);
		}
		
		$("#active_record_chart").empty();
		if ($('#active_record_chart').length > 0) {
			var options_val = set_chart_data(chartday, series); 
			
			if($.isEmptyObject( log_chart )){
				log_chart = new ApexCharts(document.querySelector("#active_record_chart"), options_val);
				log_chart.render();
			} else {
				log_chart.updateSeries(series);
			}

		}
	}
	
	//강좌상세메뉴 클릭시(=강좌통계)
	function course_click(){
		click_val = 'course';
		var time_page_val = $("#time_page option:selected").val();
		$("#allClick").removeClass("active");
		$("#courseClick").addClass("active");
		
		$("input:checkbox[id='check_login_info']").prop("checked", false);
		check_login_yn = $("#check_login_info").is(":checked");		//로그인 사용자정보 전역변수
		$("th[name='detail_type']").hide();
		
		check_render_chart();		//chart 노출여부
		check_login_info_select();
		
		start_page_no = 1;
 		end_page_no = start_page_no + 4;
 		check_end = 'N';
 		set_course_data(null, time_page_val);
	}
	
	//로그인사용자정보 체크박스 체크시
	function check_login_info(){
		check_render_chart();		//chart 노출여부
		var time_page_val = $("#time_page option:selected").val();
		check_login_yn = $("#check_login_info").is(":checked");		//로그인 사용자정보 전역변수
		
		if("course" == click_val){
			set_course_data(null, time_page_val);
		} else {
			if(check_login_yn){
				set_login_user_data(null, time_page_val);
			} else {
				set_data(null, time_page_val);
			}
		}
	}
	
	//차트영역 노출 여부
	function check_render_chart(){
		//메뉴유입통계 클릭시
		if($("#allClick").hasClass("active")){
			$("#active_record_chart").show();
		} else if($("#courseClick").hasClass("active")){
			$("#active_record_chart").hide();
		}
	}
	
	function check_login_info_select(){
		if($("#check_login_info").is(":checked")){
			$("#select_login_info").css("display", "flex");
		}else {
			$("#select_login_info").hide();
			$("th[name='detail_type']").hide();
		}
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
								<div class="filter-grp ticket-grp align-items-center justify-content-between">
									<div class="mb20">
										<h3>활동 기록</h3>
										<p>You can check the membership log.</p>
									</div>

									<!-- Filter -->
									<div class="col-lg-12">
										<div class="show-filter all-select-blk">
											<form action="#">
												<div class="row gx-2 align-items-center">
													<div class="col-md-2 col-item">
													페이지 머문 시간
														<div class="form-group select-form mb-1 mt10">
															<select class="form-select select" name="time_page" id="time_page">
																<option value="">전체</option>
																<option value="IM">단순조회</option>
																<option value="30S">30초</option>
																<option value="3M">3분</option>
																<option value="5M">5분</option>
																<option value="10M">10분</option>
															</select>
														</div>
													</div>
									                
													<div class="col-md-2 col-item mt10">
													기간 선택
														<div class="form-group select-form mb-1">
															<select class="form-select select" name="search_type" id="search_type">
																<option value="day">일간</option>
																<option value="month" selected="selected">월간</option>
																<option value="period">직접입력</option>
															</select>
														</div>
													</div>
													
													<div class="col-md-2 col-item mt10" name="type_calendar">
													기간 지정
														<div class="form-group select-form mb-1">
															<input type="text" id="search_date" name="search_date" class="flatpickr form-control" readonly="readonly" />
															<img class="img-calendar" src="/images/home/ico_calendar.svg" alt="">
														</div>
													</div>
													
													<div class="col-md-2 col-item mt10" name="period_calendar" style="display: none;">
													기간 지정
														<div class="form-group select-form mb-1"">
															<input type="text" id="start_date" name="start_date" class="flatpickr form-control" readonly="readonly" />
															<img class="img-calendar" src="/images/home/ico_calendar.svg" alt="">
														</div>
													</div>
													<div class="col-md-2 col-item mt10" name="period_calendar" style="display: none;">
													<span class="pc-view">　</span>
														<div class="form-group select-form mb-1">
															<span class="period">~</span>
															<input type="text" id="end_date" name="end_date" class="flatpickr form-control " readonly="readonly" />
															<img class="img-calendar" src="/images/home/ico_calendar.svg" alt="">
														</div>
													</div>
													<div class="col-md-1">
														<div class="ticket-btn-grp mt25">
															<a href="javascript:void(0);" id="ajax_search">조회</a>
														</div>
													</div>
												</div>
											</form>
										</div>
										
									</div>
									<!-- /Filter -->


								</div>
								<!-- Ticket Tab -->
								<div class="category-tab tickets-tab-blk">
									<ul class="nav nav-justified ">
										<li class="nav-item"><a href="#all" class="nav-link active bs-20" data-bs-toggle="tab" id="allClick" >메뉴유입통계</a></li>
										<li class="nav-item"><a href="#course" class="nav-link bs-20" data-bs-toggle="tab" id="courseClick" >강좌통계</a></li>
										<li class="nav-item">
											<div class="mt7">
												<label class="custom_check" onchange="check_login_info();"> 
													<input type="checkbox" name="check_login_info" id="check_login_info"> 
													<span class="checkmark"></span>
													<p>로그인사용자정보</p>
												</label>
											</div>
										</li>
										<div class="" style="display: none; flex-wrap: wrap;" id="select_login_info"> 
										성별
											<div class="form-group select-form mb-1">
												<select class="form-select select" name="gender" id="gender">
													<option value="">전체</option>
													<option value="1">남성</option>
													<option value="2">여성</option>
												</select>
											</div>
										지역
											<div class="form-group select-form mb-1">
												<select class="form-select select" name="region" id="region">
													<option value="">전체</option>
													<c:forEach items="${sido_code}" var="sido_code" begin="1" step="1">
														<option value="${sido_code.code}">${sido_code.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										연령
											<div class="form-group select-form mb-2">
												<select class="form-select select" name="age" id="age">
													<option value="">전체</option>
													<c:forEach items="${age_code}" var="age_code" begin="1" step="1">
														<option value="${age_code.code}">${age_code.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										직업분류
											<div class="form-group select-form mb-1">
												<select class="form-select select" name=job id="job">
													<option value="">전체</option>
													<c:forEach items="${job_code}" var="job_code" begin="1" step="1">
														<option value="${job_code.code}">${job_code.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									</ul>
								</div>
								<!-- /Ticket Tab -->


								<div id="active_record_chart"></div>
								

								<!-- Referred Ticket List -->
								<div class="tab-content">
									<div class="tab-pane fade show active" id="all">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>메뉴명</th>
														<th>날짜</th>
														<th>총합</th>
														<th name="time_page" id="IM">단순<br>조회</th>
														<th name="time_page" id="30S">30초</th>
														<th name="time_page" id="3M">3분</th>
														<th name="time_page" id="5M">5분</th>
														<th name="time_page" id="10M">10분</th>
														<th>로그인<br>사용자수</th>
														<th>비로그인<br>사용자수</th>
														<th>모바일<br>접속자수</th>
														<th>PC<br>접속자수</th>
														<th>관리자<br>접속수</th>
														<th>사용자<br>접속수</th>
													</tr>
												</thead>
												<tbody id="body-access">

												</tbody>
											</table>
											<!-- /Referred Users-->

										</div>
									</div>

									<!-- 로그인 사용자 상세 정보 통계-->
									<div class="tab-pane fade show" id="login_user">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>메뉴명</th>
														<th>날짜</th>
														<th name="detail_type" id="login_detail_type" style="display: none;">상세타입구분</th>
														<th>총합</th>
														<th name="time_page" id="IM">단순<br>조회</th>
														<th name="time_page" id="30S">30초</th>
														<th name="time_page" id="3M">3분</th>
														<th name="time_page" id="5M">5분</th>
														<th name="time_page" id="10M">10분</th>
														<th>모바일<br>접속자수</th>
														<th>PC<br>접속자수</th>
													</tr>
												</thead>
												<tbody id="body-access2">

												</tbody>
											</table>
											<!-- /Referred Users-->
										</div>
									</div>
									
									<!-- 강좌 정보 통계-->
									<div class="tab-pane fade show" id="course">
										<div class="settings-tickets-blk table-responsive">

											<!-- Referred Users-->
											<table class="table table-nowrap mb-0">
												<thead>
													<tr>
														<th>강좌명</th>
														<th>날짜</th>
														<th name="detail_type" id="course_detail_type" style="display: none;">상세타입구분</th>
														<th>총합</th>
														<th name="time_page" id="IM">단순<br>조회</th>
														<th name="time_page" id="30S">30초</th>
														<th name="time_page" id="3M">3분</th>
														<th name="time_page" id="5M">5분</th>
														<th name="time_page" id="10M">10분</th>
														<th>로그인<br>사용자수</th>
														<th name="check_login_yn">비로그인<br>사용자수</th>
														<th>모바일<br>접속자수</th>
														<th>PC<br>접속자수</th>
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

<!-- 			<div class="row"> -->
<!-- 				<div class="col-md-12" id="pagination"></div> -->
<!-- 			</div> -->

		</div>
</section>
