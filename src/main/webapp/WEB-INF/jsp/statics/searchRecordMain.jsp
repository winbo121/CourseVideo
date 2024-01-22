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

<!-- Chart JS -->
<script src="/assets/plugins/apexchart/apexcharts.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {

	
	// Simple Column
	if($('#order_chart').length > 0) {

		var Mon = 0;
		var Tue = 0;
		var Wed = 0;
		var Thur = 0;
		var Fri = 0;
		var Sat = 0;
		var Sun = 0;
		
		if(!isEmpty($('#Mon').val())){
			Mon = $('#Mon').val();
		}
		if(!isEmpty($('#Tue').val())){
			Tue = $('#Tue').val();
		}
		if(!isEmpty($('#Wed').val())){
			Wed = $('#Wed').val();
		}
		if(!isEmpty($('#Thur').val())){
			Thur = $('#Thur').val();
		}
		if(!isEmpty($('#Fri').val())){
			Fri = $('#Fri').val();
		}
		if(!isEmpty($('#Sat').val())){
			Sat = $('#Sat').val();
		}
		if(!isEmpty($('#Sun').val())){
			Sun = $('#Sun').val();
		}

		
	var sCol = {
		chart: {
			height: 350,
			type: 'bar',
			toolbar: {
			  show: false,
			}
		},
		plotOptions: {
			bar: {
				horizontal: false,
				columnWidth: '20%',
				endingShape: 'rounded', 
				startingShape: 'rounded'  
			},
		},
		 colors: ['#1D9CFD'],
		dataLabels: {
			enabled: false
		},
		stroke: {
			show: true,
			width: 2,
			colors: ['transparent']
		},
		series: [{
			name: '검색 건수',
			data: [Mon, Tue, Wed, Thur, Fri, Sat, Sun]
		}],
		xaxis: {
			categories: ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun'],
		},
		fill: {
			opacity: 1

		},
		tooltip: {
			y: {
				formatter: function (val) {
					return  val + "건"
				}
			}
		}
	}

	var chart = new ApexCharts(
		document.querySelector("#order_chart"),
		sCol
	);

	chart.render();
	}
});


</script>

<%-- <section class="page-content course-sec">
	<!-- Instructor Dashboard -->
						<div class="container">
				
							
							<div class="row">
								<div class="col-md-12">
									<div class="card instructor-card">
										<div class="card-header">
											<h4>검색 기록</h4>
										</div>
									</div>
								</div>
								
							</div> --%>

<section class="page-content course-sec">
	<div class="container">
		<div class="row">
			<div class="col-lg-12">
				<div class="card instructor-card">


					<div class="settings-inner-blk p-0">
						<div class="comman-space pb-0">
							<div
								class="filter-grp ticket-grp align-items-center justify-content-between">
								<h3>검색 기록</h3>
								<p>You can check the searching log.</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>


		<div class="row">



			<div class="col-md-3 d-flex">
				<div class="card instructor-card w-100">
					<div class="card-header">
						<h4>메인화면 검색</h4>
					</div>
					<div class="card-body">
						<div class="instructor-inner">
							<h6>검색 총 건수</h6>
							<h4 class="instructor-text-success">${search_list_3[0].pl_cnt}</h4>
							<p>New this month</p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-3 d-flex">
				<div class="card instructor-card w-100">
					<div class="card-header">
						<h4>상세화면 검색</h4>
					</div>
					<div class="card-body">
						<div class="instructor-inner">
							<h6>검색 총 건수</h6>
							<h4 class="instructor-text-info">${search_list_3[3].pl_cnt}</h4>
							<p>New this month</p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-3 d-flex">
				<div class="card instructor-card w-100">
					<div class="card-header">
						<h4>학습이력 검색</h4>
					</div>
					<div class="card-body">
						<div class="instructor-inner">
							<h6>검색 총 건수</h6>
							<h4 class="instructor-text-warning">${search_list_3[1].pl_cnt}</h4>
							<p>New this month</p>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-3 d-flex">
				<div class="card instructor-card w-100">
					<div class="card-header">
						<h4>공지사항 검색</h4>
					</div>
					<div class="card-body">
						<div class="instructor-inner">
							<h6>검색 총 건수</h6>
							<h4 class="instructor-text" style="color: lightcoral;">${search_list_3[2].pl_cnt}</h4>
							<p>New this month</p>
						</div>
					</div>
				</div>
			</div>
		</div>


		<div class="row">
			<div class="col-md-12">
				<div class="card instructor-card">
					<div class="card-header">
						<h4>요일별 검색 기록 (기간 : 최근 한달)</h4>
					</div>
					<div class="card-body">
						<div id="order_chart"></div>
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-md-12">
				<div class="settings-widget">
					<div class="settings-inner-blk p-0">
						<div class="sell-course-head comman-space">
							<h3>검색어 순위 TOP 7 (기간 : 최근 한달)</h3>
						</div>
						<div class="comman-space pb-0">
							<div
								class="settings-tickets-blk course-instruct-blk table-responsive">

								<!-- Referred Users-->
								<table class="table table-nowrap mb-0">
									<thead>
										<tr>
											<th>순위</th>
											<th>검색어</th>
											<th>검색어 유형</th>
											<th>조회 건수</th>
										</tr>
									</thead>
									<tbody>

										<c:forEach items="${search_list_2}" var="list">

											<tr>
												<td>${list.rank_odr}</td>
												<td>
													<div class="sell-table-group d-flex align-items-center">
														<p>${list.search_descr}</p>
													</div>
												</td>
												<td>${list.code_nm}</td>
												<td>${list.tot_cnt}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
								<!-- /Referred Users-->
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div>


			<c:forEach items="${search_list_4}" var="list">
				<c:if test="${list.week_name == 'Mon' }">
					<input type="hidden" id="Mon" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Tue' }">
					<input type="hidden" id="Tue" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Wed' }">
					<input type="hidden" id="Wed" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Thu' }">
					<input type="hidden" id="Thu" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Fri' }">
					<input type="hidden" id="Fri" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Sat' }">
					<input type="hidden" id="Sat" value="${list.tot_cnt} " />
				</c:if>
				<c:if test="${list.week_name == 'Sun' }">
					<input type="hidden" id="Sun" value="${list.tot_cnt} " />
				</c:if>

			</c:forEach>





		</div>
	</div>
</section>
