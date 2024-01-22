<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
.jb-division-line {
  border-top: 1px solid #444444;
  margin: 30px 0px;
}
.image {
  display:none;
}
 .table {
  display:none;
} 
.media {
  display:none;
}
.image-inline {
  display:none;
}
.blog-content img{
  display:none;
} 
 p table {
  display:none;
} 
p media {
  display:none;
}
p iframe {
  display:none;
}

body { background: #fff; }
.blueone {
  border-collapse: collapse;
}  
.blueone th {
  padding: 10px;
  color: #168;
  border-bottom: 3px solid #168;
  text-align: center;
}
.blueone td {
  color: #669;
  padding: 10px;
  border-bottom: 1px solid #ddd;
}
.blueone tr:hover td {
  color: #004;
}
</style>
<sec:authorize var="isLogin" access="isAuthenticated()" />

   <!-- Breadcrumb -->
			<div class="breadcrumb-bar">
				<div class="container">
					<div class="row">
						<div class="col-md-12 col-12">
							<div class="breadcrumb-list">
								<nav aria-label="breadcrumb" class="page-breadcrumb">
									<ol class="breadcrumb">
										<li class="breadcrumb-item"><a href="/">Home</a></li>
										<li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">커뮤니티</a></li>
										<li class="breadcrumb-item active" aria-current="page"><a href="/notice/noticeMain/index.do?">공지사항</a></li>
										<%-- <c:choose> --%>
											<%-- <c:when test="${noticeGb == '' || noticeGb == null} ">
												<li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">전체</a></li>
											</c:when>
											<c:when test="${noticeGb[0].code == '1' ">
												<li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">공지사항</a></li>
											</c:when>
											<c:when test="${noticeGb[1].code == '2'} ">
												<li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">자료실</a></li>
											</c:when> --%>
										<%-- </c:choose> --%>
										<%-- <li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">${search_txt}</a></li> --%>
										<!-- <li class="breadcrumb-item" aria-current="page">Blog List</li> -->
									</ol>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /Breadcrumb -->
			
			<!-- Course -->
			<section class="course-content">
				<div class="container">
					<div class="row">
						<div class="col-lg-9 col-md-12">
							<form:form modelAttribute="search" method="get">
								<form:hidden path="pageNo"/>	<%-- JSP PAGING 현재 페이지 번호 --%>
								<form:hidden path="rangeNo"/> <%-- JSP PAGING 현재 범위 번호 --%>
								<form:hidden path="pageSize"/> <%-- JSP PAGING 페이지 당 레코드 카운트 --%>
								<form:hidden path="rangeSize"/> <%-- JSP PAGING 범위 당 페이지 사이즈   --%>
								<form:hidden path="totalCount"/> <%-- JSP PAGING 현재 검색조건 글의 카운트   --%>
								<form:hidden path="pageCount"/> <%-- JSP PAGING 현재 검색조건 페이지 카운트   --%>
								<form:hidden path="rangeCount"/> <%-- JSP PAGING 현재 검색조건 범위 카운트   --%>
								<form:hidden path="search_condition"/>
							
							<div
									class="filter-grp ticket-grp d-flex align-items-center justify-content-between">
									<!-- <div>
										<h1><Strong>공지 사항</Strong></h1>
									</div> -->
												
								
									<div class="show-result">
									<h4>
										10개씩 검색 결과 표시  |  총 건수 <span id="totalCnt">0</span>건 
									</h4>
									</div>
									
									<sec:authorize access="isAuthenticated()">
										<sec:authorize access=" hasRole('ROLE_ADMIN')">
											<div class="ticket-btn-grp mt7">
												<a href="/notice/noticeEnrollDetail.do">공지사항 등록</a>
											</div>
										</sec:authorize>
									</sec:authorize>
									
								</div>
							
							
							<!-- <div class="jb-division-line"></div> -->
							<!-- Blog Post -->
							<div class="blog" >
								
							</div>
							<!-- /Blog Post -->
							

							<!-- Blog pagination -->
							<div class="row">
								<div class="col-md-12">
									<ul class="pagination lms-page">
										
									</ul>
								</div>
							</div>
							<!-- /Blog pagination -->
							</form:form>
						</div>
						
						<!-- Blog Sidebar -->
						<div class="col-lg-3 col-md-12 sidebar-right theiaStickySidebar">

							<!-- Search -->
							<div class="card search-widget blog-search blog-widget">
								<div class="card-body">
									<form class="search-form">
										<div class="input-group">
											<input type="text" id="searchNotice" placeholder="검색어를 입력하세요" class="form-control" value="${search.search_text }" onkeyup="enterkey();" onsubmit="return false;">
											<input type="text" style="display:none;" id="11" placeholder="Search..." class="form-control" value="${search.search_text }" onkeyup="enterkey();" onsubmit="return false;">
											<button type="button" id="search" class="btn btn-primary" onclick="set_data(1);"><i class="fa fa-search"></i></button>
										</div>
									</form>
								</div>
							</div>
							<!-- /Search -->



							<!-- Categories -->
							<div class="card category-widget blog-widget">
								<div class="card-header">
									<h4 class="card-title">카테고리</h4>
								</div>
								<div class="card-body">
									<ul class="categories">
										<li><a id="search" href="javascript:set_data(1,'');"><i class="fas fa-angle-right"></i>전체</a></li>
										<%-- <input type="hidden" id="notice_gb${status.index}"  value="${search.code}" class="notice_gb"> --%>
										<c:forEach items="${noticeGb}" var="search" varStatus="status">
											<li><a id="search${status.index}" href="javascript:set_data(1,${search.code});"><i class="fas fa-angle-right"></i>${search.code_nm}</a></li>
											<input type="hidden" id="notice_gb${status.index}"  value="${search.code}" class="notice_gb">
										</c:forEach>
									</ul>
								</div>
							</div>
							<!-- /Categories -->
							
														<!-- Latest Posts -->
							<div class="card post-widget blog-widget" >
								<div class="card-header">
									<h4 class="card-title">고정 공지</h4>
									
									<sec:authorize access="isAuthenticated()">
										<sec:authorize access=" hasRole('ROLE_ADMIN')">
										<div align="right">
											<a href='javascript:void(0)' id="fix_notice" onclick="" value="관리"> 관리</a>
										</div>
										</sec:authorize>
									</sec:authorize>
									
								</div>
								<div class="card-body">
									<ul class="latest-posts">
									<c:if test="${sideList.size() != 0}">
										<c:forEach items="${sideList }" var="fix" varStatus="status">
											<li>
												<div class="post-thumb">
													<a href='/notice/noticeDetail.do?notice_seq=${fix.notice_seq}'>
														<c:choose>
															<c:when test="${fix.thumb.img_url != null}">
																<%-- <img class="img-fluid" src="${image_alise}${fix.thumb.file_save_path }${fix.thumb.save_filenm }" alt=""> --%>
																<img class="img-fluid" src="${fix.thumb.img_url}" alt="" onError="this.src='/images/noimage.png'" 
																	style="max-height: 44.83px; width: 100%;">
															</c:when>
															<c:otherwise>
																<img class="img-fluid" src="/images/noimage.png" alt="" onError="this.src='/images/noimage.png'">
															</c:otherwise>
														</c:choose>
													</a>
												</div>
												<div class="post-info" >
												<div>
													<p>
														<a href='/notice/noticeDetail.do?notice_seq=${fix.notice_seq}' style="word-break: break-all; -webkit-line-clamp: 2; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden;"><h4>${fix.title }</h4></a>
													</p>
													<p><a><img class="img-fluid" src="/assets/img/icon/icon-22.svg" alt=""/>${fix.upd_dts }</a>&nbsp;<a><img class="img-fluid" src="/assets/img/icon/icon-23.svg" alt="">${fix.hits }</a></p>
												</div>
												</div>
											</li>
										</c:forEach>
									</c:if>
									<c:if test="${sideList.size() == 0}">
										<div style='text-align:center;color: blue;'>	데이터가 존재하지 않습니다. </div>
									</c:if>
									</ul>
								</div>
							</div>
							<!-- /Latest Posts -->
						</div>
						<!-- /Blog Sidebar -->
						
					</div>
				</div>
			</section>
			<!-- /Course -->



<div id="modal_regist" class="remodal record-wrap" data-remodal-id="modal" role="dialog" aria-labelledby="modal1Title" aria-describedby="modal1Desc" style="padding: 1px; /* margin: 3px; */">
<%-- <form id="modal_form" name="modal_form" > --%>
	<button data-remodal-action="close" class="remodal-close" aria-label="Close" id="close_btn" ></button> <!-- onclick="closeModal();" -->
	<div class="modal_form" style="padding-top: 30px;">
								<!-- <div id="tableData" class="add-course-form" style="display: block;"> -->
									<label for="tab_1" class="tab"><h3>고정공지 관리</h3></label>
									<div>
										<!-- <button type="button" class="btn btn-danger" id="delete_btn">선택삭제</button> -->
										</div>
											<!-- 	<div class="add-course-form" style="padding: 3px;">
													<div class="curriculum-grid" style="overflow: auto; height:400px;">
														<div class="curriculum-head">
														</div>
														<div class="curriculum-info">
															<div id="accordion"> -->
																<table id="sideManage" class="blueone">
																	<thead align="center">
																		<tr align="center">
																			<!-- <th width="5%" align="center"><input type="checkbox" id="chkAll" value=""></th> -->
																			<th width="13%"  align="center">no</th>
																			<th width="75%"  align="center">제목</th>
																			<th width="1%"  align="center"></th>
																			<th width="1%"  align="center"></th>
																			<th width="10%" align="center">관리</th>
																		</tr>
																	</thead>
																	<tbody id="list">
																		<%-- <c:forEach items="${sideNoticeList}" var="list" varStatus="status" begin="1"> --%>
																		<c:forEach items="${sideNoticeList}" var="list" varStatus="status" begin="0">
																			<%-- <tr id="${list.sort }" class="sor"> --%>
																			<tr id="fix_${list.notice_seq}" class="sor">
																				<%-- <td id="sortNo"><input type="checkbox" class="chkItem" value="${list.notice_seq}"></td> --%>
																				<td id="sortNo">${status.index +1}</td>
																				<td>${list.title}</td>
																				<td><input type="hidden" id="fix_yn" name="fix_yn" value="${list.top_fixed_yn}"></td>
																				<td><input type="hidden" id="seq" name="seq" value="${list.notice_seq}"></td>
																				<td><a id="fixDel" href="javascript:deleteFixNotice(${list.notice_seq});"><i>x</i></a> </td>
																			</tr>
																		</c:forEach>
																	</tbody>
																</table>
																<c:if test="${sideNoticeList eq null }"><div class="emptyContents">등록된 고정 공지가 없습니다.</div></c:if>
															</div>
														<!-- </div>
													</div> -->
													<div class="widget-btn" align="right">
														<button class="btn btn-black prev_btn" data-remodal-action="cancel" onclick="closeModal();" >닫기</button> <!-- onclick="closeModal()" -->
														
														<button class="btn btn-info-light next_btn" data-remodal-action="confirm"  onclick="saveModal();">확인</button>
													</div>
													<!-- </div> -->
	</div>
<%-- </form> --%>
</div>

<div id="result"></div>
			
<script type="text/javascript">
$(document).ready(function() {

	jQuery.ajaxSettings.traditional = true;
	$('.notice_detail').click(function(e){
		e.preventDefault();
		var url = "/notice/noticeDetail.do";
		var form_data = new FormData( $("#Notice")[0] );
		var notice_seq = $(this).data("notice-seq");
		form_data.append( "notice_seq", notice_seq );
		move_get( url, form_data );
	});
	
	

	<%-- 모달 액션 --%>
	// 콘텐츠 검색
	$("#fix_notice").on("click",function(){
		
		
		var remodal_element =  $('[data-remodal-id=modal]');

		var input_elements = $( remodal_element ).find($(".blueone >tbody tr"));
		$( input_elements ).val("");

		<%-- RE MODAL OPEN 성공 이후 후처리 함수 --%>
		var open_succ_func = function(){
			//alert("RE_MODAL OPEN....");
		};

		basicReModal = new BasicReModal();
			basicReModal._remodal_element = remodal_element;
			basicReModal._open_succ_func = open_succ_func;
		basicReModal.open();
		
		
	}); 
	

});

var start_page_no = 1;
var end_page_no = start_page_no + 4;
var check_end = 'N';
var click_val = 'all';
let gubn = '';

const urlParams = new URL(location.href).searchParams;
const search_txt = urlParams.get('notice_gb');
if (urlParams.get('notice_gb') != null || urlParams.get('notice_gb') != "") {
	set_data(1,search_txt);
} else {
	set_data(1,gubn);
}

/* getNoticeList(1,search_txt); */

//set_data(1,gubn);


function next_page(gb){
	
	if(check_end == 'Y'){
		alert('마지막 페이지 입니다.')
		return false;
	}else{
	
	start_page_no = start_page_no + 5;
	end_page_no = start_page_no + 4;
	check_end = 'N';
	set_data(start_page_no,gb);
	}
	
}

function before_page(gb){
	if(start_page_no == 1){
		alert('첫번째 페이지 입니다.')
		return false;
	}else{
	
	start_page_no = start_page_no - 5;
	end_page_no = start_page_no + 4;
	check_end = 'N';
	set_data(start_page_no,gb);
	}
}

<%-- 검색 AJAX 시작 --%>
function set_data(page, notice_gb){
	
	
	gubn = notice_gb;
	if (page == 1) {
		start_page_no = 1;
	}
	end_page_no = start_page_no + 4;
	//check_end = 'N';
	var search_text = $("#searchNotice").val();
	
	var action = "/notice/noticeListAjax.do";
	var json = { "pageNo":page , "search_text" : search_text , "notice_gb" : gubn };
	
	if (search_text != null && search_text != "") {
    	var searchType ="6";
		var searchPlace ="4";
		var searchTxt= $('#searchNotice').val(); 
		save_search(searchType,searchPlace,searchTxt);
	}
	
	var succ_func = function( resData, status ){
		noticeList(resData.result ,resData.paging);
		var totalCount = resData.paging.totalCount;
		$("#totalCnt").html(totalCount);
	}
	
	ajax_json_post( action, json, succ_func );
	
};



/* 공지관리목록 AJAX DOM 그리기 */
function noticeList(data,page){
	
	var htmlStr = '';
	var PageStr = '';
	if(data.length > 0){
		
		for(var i = 0; i < data.length; i++) {
			var notice_seq = data[i].notice_seq == null ? "" : data[i].notice_seq;
			var notice_gb = data[i].notice_gb == null ? "" : data[i].notice_gb;
			var title = data[i].title == null ? "" : data[i].title;
			var contents = data[i].contents == null ? "" : data[i].contents;
			
			var hits = data[i].hits == null ? "" : data[i].hits;
			var fixed_top_yn = data[i].fixed_top_yn == null ? "" : data[i].fixed_top_yn;
			var information_state = data[i].information_state == null ? "" : data[i].information_state;
			var display_yn = data[i].display_yn == null ? "" : data[i].display_yn;
			var reg_dts = data[i].reg_dts == null ? "" : data[i].reg_dts;
			var reg_user = data[i].reg_user == null ? "" : data[i].reg_user;
			var No = data[i].No == null ? "" : data[i].No;
			var thumb = data[i].thumb == null ? "" : data[i].thumb;
			var content = data[i].content == null ? "" : data[i].content;
			
			
			htmlStr +=		'<div class="blog-image">';
			htmlStr +=			'<a href="/notice/noticeDetail.do?notice_seq='+data[i].notice_seq+'" style="background-color: #eeeeee;">';
								if (data[i].thumb != null) {
									htmlStr +=	'<img class="img-fluid" src="'+data[i].thumb.img_url+'" alt="" style="max-height: 300px;" onError="this.src='+"'/images/noimage.png'"+'">';			
								} else if (data[i].thumb == null){
									//htmlStr +=	'<img class="img-fluid" src="/images/home/no_image.svg" alt="" style="max-height: 300px;">';
									//htmlStr +=	'<img class="img-fluid" src="/images/noimage.png" alt="" style="max-height: 300px;" onError="this.src='+"'/images/noimage.png'"+'">';
								}
			htmlStr +=			'</a>';
			htmlStr +=		'</div>';
			
			htmlStr +=	'<div><span><h3 class="blog-title"><a href="/notice/noticeDetail.do?notice_seq='+data[i].notice_seq+'" style="word-break: break-all; -webkit-line-clamp: 2; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden;">'+'['+data[i].notice_gb+']'+data[i].title +'</a></h3></span></div>';
			htmlStr +=	'<div class="blog-info clearfix">';
			htmlStr +=		'<div class="post-left">';
			htmlStr +=				'<ul>';
			htmlStr +=					'<li>';
			htmlStr +=						'<div class="post-author">';
			htmlStr +=							'<a> <span>'+ data[i].reg_user +'</span></a>';  ///* <img src="/assets/img/user/user.jpg" alt="Post Author"> */
			htmlStr +=						'</div>';
			htmlStr +=					'</li>';
			//htmlStr +=					'<li><img class="img-fluid" src="/assets/img/icon/icon-22.svg" alt="">'+ data[i].reg_dts.year+'-'+data[i].reg_dts.monthValue+'-'+data[i].reg_dts.dayOfMonth +'</li>';
			htmlStr +=					'<li><img class="img-fluid" src="/assets/img/icon/icon-22.svg" alt="">'+ data[i].reg_dts +'</li>';
			htmlStr +=					'<li><img class="img-fluid" src="/assets/img/icon/icon-23.svg" alt="">'+ data[i].hits +'</li>';
			htmlStr +=				'</ul>';
			htmlStr +=		'</div>';
			htmlStr +=	'</div>';
			htmlStr +=		'<div class="blog-content blog-read" style="word-break: break-all; -webkit-line-clamp: 4; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden; white-space: pre-wrap; line-height:25px; height:125px;">';
			//htmlStr +=		'<div class="blog-content blog-read" style="word-break: break-all; -webkit-line-clamp: 4; text-overflow: hidden; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden; white-space: pre-wrap; line-height:25px; height:125px;">';
			//htmlStr +=		'<div class="blog-content blog-read" style="word-break: break-all; -webkit-line-clamp: 4; text-overflow: ellipsis; display: webkit-box;  -webkit-box-orient: vertical; overflow: hidden; white-space: pre-wrap;">';
			//htmlStr +=		'<div class="blog-content blog-read" >';
			//htmlStr +=			'<p style="word-break: break-all; -webkit-line-clamp: 4; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden;">'+data[i].contents +'</p>';
			htmlStr +=			'<p style="white-space: pre-wrap;">'+data[i].contents +'</p>';
			//htmlStr +=			'<a href="/notice/noticeDetail.do?notice_seq='+data[i].notice_seq+'" class="read-more btn btn-primary">'+'더보기' +'</a>';
			htmlStr +=		'</div></br>';
			htmlStr +=		'<div class="blog-content blog-read" >';
			htmlStr +=			'<a href="/notice/noticeDetail.do?notice_seq='+data[i].notice_seq+'" class="read-more btn btn-primary">'+'더보기' +'</a>';
			htmlStr +=		'</div>';
			htmlStr +=		'</br>';
			htmlStr +=		'</br>';
			htmlStr +=	'<div class="jb-division-line"></div>';
			//<i>'+data[i].No+'. '+'</i>'
		}
		
		
		if(data.length > 0)
    	{
			PageStr += "<ul class='pagination lms-page'>";
			PageStr += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page("+gubn+");'><i class='fas fa-angle-left'></i></a></li>";
			if(end_page_no >= page.pageCount ){
				
				end_page_no = page.pageCount;
				check_end = 'Y';
			} 
			
			for (var a = start_page_no; a <= end_page_no; a++) {
				var setNog = page.pageNo;
				if(a == setNog){
					var class_name = 'page-item first-page active';
				}else{
					var class_name = 'page-item first-page';
				}
				PageStr += "<li class='"+ class_name +"'>";
				PageStr += "<a class='page-link' href='javascript:void(0)' onclick='set_data("+ a +','+gubn+");'>"+ a +"</a></li>";
				//PageStr += "<a class='page-link' href='javascript:void(0)' onclick='set_data("+ a +");'>"+ a +"</a></li>";
			}
			
			PageStr += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page("+gubn+");'><i class='fas fa-angle-right'></i></a></li>";
			PageStr += "</ul>";
    	}
		
	} else {
		htmlStr += '</br>';
		htmlStr += '</br>';
		htmlStr += '</br>';
		htmlStr += "<div style='text-align:center;color: blue;'>	데이터가 존재하지 않습니다. </div>";
	}
		
		var pageHtml = $.parseHTML(PageStr);
		var html = $.parseHTML(htmlStr);
		
		$(".blog").html(html);
		$(".pagination.lms-page").html(pageHtml);
		
}

function enterkey() {
    if (window.event.keyCode == 13) {
    	if ($("#searchNotice").val() != "" && $("#searchNotice").val() != null) {
    		set_data();
		} else if ($("#searchNotice").val() == "" || $("#searchNotice").val() == null) {
			alert('검색어를 입력해 주세요.')
			return false;
		}
    }
}	

function closeModal() {
	basicReModal.close();
}	


function delete_fix(seq) {
	$("<tr></tr>", {
		type : "hidden",
		name : "fix_yn",
		value : seq
	}).appendTo($('#modal_form')[0]);
	// 삭제대상 숨김처리
	$("#fix_" + seq).hide();
	$("#fix_" + seq).remove();
} 

function deleteFixNotice(noticeSeq) {
	
	const arrayRemove = (arr, index) => {
	    arr.splice(index, 1);
	};
	
	var num;
	
	var cnt = sortNum.length;
	
	var confirm_func = function () {
		
		var action = "/notice/noticeFixDelAjax.do";
		var json = { notice_seq:noticeSeq };
		var succ_func = function( resData, status ){
			delete_fix(noticeSeq);
			for (var i = 0; i < cnt; i++) {
			    if (parseInt(seq[i]) === noticeSeq) {
			    	
			    	arrayRemove(seq, i);
			    	arrayRemove(sortNum, i);
				}
			}
			
			
		};
		ajax_json_delete( action, json, succ_func  );
	}
	confirm_error( "해당 공지를 고정해제 하시겠습니까?", confirm_func, null  );
}; 


function saveModal() {
	var confirm_func = function () {
		
		var action = "/notice/noticeFixSortAjax.do";
		var json = { "sortNum":[sortNum], "seq":[seq] };
		var succ_func = function( resData, status ){
		};
		ajax_json_post( action, json, succ_func  );
		location.reload();
	}
	confirm_info( "수정사항을 저장하시겠습니까?", confirm_func, null  );
	
}

var sortNum = [];
var seq = [];
$(function(){
	
	$("#list").sortable({
		cusor: 'move',
		opacity : 0.5,
		stop : function (e, ui) {
			$("#result").text($("#list").sortable('toArray'));

			//sortNum = [];
			//seq = [];
			for (var i = 1; i <= $(".blueone >tbody tr").length; i++) {
				$(".blueone >tbody tr:nth-child("+i+") td:nth-child(1)").text(i);
				sortNum.push($(".blueone >tbody tr:nth-child("+i+") td:nth-child(1)").text());
				seq.push($(".blueone >tbody tr:nth-child("+i+") td:nth-child(4) input[name='seq']").val());
			}
		}
		
	});

	
	
});



</script>