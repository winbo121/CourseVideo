<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

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
										<li class="breadcrumb-item" aria-current="page"><a href="/notice/noticeMain/index.do?">공지사항</a></li>
										<li class="breadcrumb-item active" aria-current="page"><a>${notice_detail.title }</a></li>
									</ol>
								</nav>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- /Breadcrumb -->
			
			<!-- Blog Details -->
			<section class="course-content">
				<div class="container">
					<div class="row">
					
						<div class="col-lg-9 col-md-12">
							<form:form id="submitForm" modelAttribute="notice" method="POST">
							<!-- Blog Post -->
							<div class="blog" style=" width: 100%; overflow-x: auto; white-space: nowrap;">
							
								<div class="blog-image">
									<c:if test="${notice_detail.thumb.img_url != null  }">
										<a id="thumb"><img class="img-fluid" src="${notice_detail.thumb.img_url}" alt="Post Image" style="max-height: 300px;" onError="this.src='/images/noimage.png'"></a>
									</c:if>
									<c:if test="${notice_detail.thumb.img_url == null  }">
										<!-- <a href=""><img class="img-fluid" src="/images/home/no_image.svg"alt="Post Image"></a> -->
										<!-- <a href=""><img class="img-fluid" src="/images/noimage.png" alt="Post Image" style="max-height: 300px;" onError="this.src='/images/noimage.png'"></a> -->
									</c:if>
								</div> 
								
								<h3 class="blog-title">${notice_detail.title }</h3><!-- /assets/img/icon/career-04.svg -->
								<div class="blog-info clearfix">
									<div class="post-left">
										<ul>
											<li>
												<div class="post-author">
													<!-- <img src="/assets/img/user/user.jpg" alt="Post Author"> --> <span>${notice_detail.reg_user }</span>
												</div>
												
											</li>
											<li><img class="img-fluid" src="/assets/img/icon/icon-22.svg" alt="">${notice_detail.reg_dts }</li>
											<li><img class="img-fluid" src="/assets/img/icon/icon-23.svg" alt="">${notice_detail.hits }</li>
										</ul>
									</div>
								</div>
		                        <c:if test="${not empty notice_detail.fileList}">
			                        <div class="files" align="right" style="padding-top: 3em; padding-bottom: 3em;">
				                  		<c:forEach var="file" items="${notice_detail.fileList}">
				                  			<div>
				                                <a id="${file.file_seq}" href="javascript:void(0);"  data-file_seq="${file.file_seq}"  class="download" target="_blank"><img class="img-fluid" src="/assets/img/icon/book-icon.svg" alt=""> ${file.orgin_filenm}.${file.file_ext}</a>
				                            </div>
				                  		</c:forEach>
			                        </div>
		                        </c:if>
								<!-- <div class="blog-content blog-read"  style="word-break: break-all; overflow: hidden;"> -->
								<div class="blog-content blog-read"  style="word-break: break-all;  display: inline-block; white-space: pre-wrap;">
									<p>${notice_detail.contents }</p>
								</div>
							</div>
							<div>
								
								<div>	
									<div>
										<span>
											<p style="word-break: break-all; -webkit-line-clamp: 1; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden;">이전글 : <a id="prev_btn" href="javascript:prevNotice();"><i>${notice_detail.prev_title }</i></a></p>
										</span>
									</div>
									<div>
										<span>
											<p style="word-break: break-all; -webkit-line-clamp: 1; text-overflow: ellipsis; display: -webkit-box;  -webkit-box-orient: vertical; overflow: hidden;">다음글 : <a id="next_btn" href="javascript:nextNotice();" ><i>${notice_detail.next_title }</i></a></p>
										</span>
									</div>
								</div>
								
							</div>
							</form:form>
							<div class="submit-ticket" style="place-content: center;">
								<button type="button" class="btn btn-dark" id="list_btn">목록</button>&nbsp;&nbsp;&nbsp;
								<sec:authorize access="isAuthenticated()">
									<sec:authorize access=" hasRole('ROLE_ADMIN')">
										<button type="button" class="btn btn-primary" id="update_btn">수정</button>
										<!-- <div class="profile-share" align="right"> -->
										<button type="button" class="btn btn-danger" id="delete_btn">삭제</button>
										<!-- </div> -->
									</sec:authorize>
								</sec:authorize>	
							</div>		
									
							<!-- /Blog Post -->
						</div>
						
						<!-- Blog Sidebar -->
						<div class="col-lg-3 col-md-12 sidebar-right theiaStickySidebar">

							<!-- Search -->
							<div class="card search-widget blog-search blog-widget">
								<div class="card-body">
									<form class="search-form">
										<div class="input-group">
											<input type="text" id="searchNotice" placeholder="검색어를 입력하세요" class="form-control" onkeyup="enterkey();">
											<input type="text" style="display:none;" placeholder="Search..." class="form-control">
											<button type="button" id="search_text" class="btn btn-primary"><i class="fa fa-search"></i></button>
										</div>
									</form>
								</div>
							</div>
							<!-- /Search -->

							

							<!-- Categories -->
							<div class="card category-widget blog-widget">
								<div class="card-header">
									<h4 class="card-title">Categories</h4>
								</div>
								<div class="card-body">
									<ul class="categories">
										<li><a id="search" href="/notice/noticeMain/index.do"><i class="fas fa-angle-right"></i>전체</a></li>
										<c:forEach items="${noticeGb}" var="search" varStatus="status">
											<li><a id="search${status.index}" data-value="${search.code}" href="/notice/noticeMain/index.do?notice_gb=${search.code}"><i class="fas fa-angle-right"></i>${search.code_nm}</a></li>
											<%-- <li><a id="search${status.index}" data-value="${search.code}" href="javascript:set_data(1,'${search.code}');><i class="fas fa-angle-right"></i>${search.code_nm}</a></li> --%>
											<input type="hidden" id="notice_gb"  value="${search.code}" class="notice_gb">
										</c:forEach>
									</ul>
								</div>
							</div>
							
							
							<!-- Latest Posts -->
							<div class="card post-widget blog-widget">
								<div class="card-header">
									<h4 class="card-title">고정 공지</h4>
								</div>
								<div class="card-body">
									<ul class="latest-posts">
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
													<p><a><img class="img-fluid" src="/assets/img/icon/icon-22.svg" alt="">${fix.upd_dts }</a>&nbsp;<a><img class="img-fluid" src="/assets/img/icon/icon-23.svg" alt="">${fix.hits }</a></p>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
							</div>
							<!-- /Latest Posts -->
						</div>
						<!-- /Blog Sidebar -->
						
					</div>
				</div>
			</section>
			<!-- /Blog Details -->


<script type="text/javascript">
$(document).ready(function() {
	
	/* $("#thumb").on("click", function (e) {
		e.preventDefault();
	}) */
	
	$('.image').children('img').css("width","100%");
	
	var state = "all";
	
	$("#search_text").on("click", function () {
		var serach_text = $("#searchNotice").val();
		
		if (search_text != null && search_text != "") {
	    	var searchType ="6";
			var searchPlace ="4";
			var searchTxt= $('#searchNotice').val(); 
			save_search(searchType,searchPlace,searchTxt);
		}
		
		location.href = '<c:url value="/notice/noticeMain/index.do?search_text='+serach_text+'"/>';
	})
	
	$("#search").on("click", function () {
		var notice_gb =  $(".notice_gb").val(); //"${noticeGb}";
		
		if (search_text != null && search_text != "") {
	    	var searchType ="6";
			var searchPlace ="4";
			var searchTxt= $('#searchNotice').val(); 
			save_search(searchType,searchPlace,notice_gb);
		}
		
		location.href = '<c:url value="/notice/noticeMain/index.do?notice_gb='+notice_gb+'"/>';
	})
	
	
	$("#list_btn").on("click", function(){
		location.href = '<c:url value="/notice/noticeMain/index.do?"/>';
	})
	
	
	$('.files .download').click(function(e){

		e.preventDefault();
		<%-- file_seq 가져오기--%>
		var file_seq = $(this).data("file_seq");

		<%--파일 다운로드 실행--%>
		fileDownload(file_seq);

	});
	
	function fileDownload(file_seq){
		<%-- 파일 다운로드  --%>
		file_down( file_seq, null, null  );
	}
	
	<%-- 삭제하기 버튼 클릭--%>
	$("#delete_btn").click(function() {
		let confirm_func = function(){
			let url= '<c:url value="/notice/noticeDelete.do"/>';
			let notice_seq = '<c:out value="${notice.notice_seq}"/>';
			let form_data = new FormData();
			let del_list = new Array();
			del_list.push(notice_seq);
			form_data.append("del_items", del_list);
			
			let succ_func = function(resData,status){
				if(resData.result == "success") {
					let move_list = function(){
						let list_url = "<c:url value='/notice/noticeMain/index.do'/>";
						move_get(list_url,null);			
					}
					alert_success("삭제가 완료되었습니다.",move_list);
				}
			}
			ajax_form_delete(url , form_data, succ_func);			
		}
		
		confirm_warning("삭제하시겠습니까?", confirm_func , null);
	});
	
	
	$("#update_btn").click(function() {
		location.href = '/notice/noticeModify.do?notice_seq='+'${notice_detail.notice_seq}';
	}); 
	
});

function prevNotice(e) {
	var seq = '${notice_detail.prev_seq}'
	var title = '${notice_detail.prev_title}'
		var min = '${min}';
		//seq = seq -1;
		if ( title == "이전글이 없습니다") {
			alert("이전 글이 없습니다.");
			//location.reload();
			e.preventDefault();
		} else {
			location.href = '<c:url value="/notice/noticeDetail.do?notice_seq='+seq+'"/>';
		}
}

function nextNotice(e) {
	var seq = '${notice_detail.next_seq}'
	var title = '${notice_detail.next_title}'
		if (title == "다음글이 없습니다") {
			alert("다음 글이 없습니다.");
			e.preventDefault();
			//location.reload();
		} else {
			location.href = '<c:url value="/notice/noticeDetail.do?notice_seq='+seq+'"/>';
		}
}

function enterkey() {
    if (window.event.keyCode == 13) {
    	if (search_text != null && search_text != "") {
	    	var searchType ="6";
			var searchPlace ="4";
			var searchTxt= $('#searchNotice').val(); 
			save_search(searchType,searchPlace,notice_gb);
			$("#search_text").click();
		}  else if (search_text == "" || search_text == null) {
			alert('검색어를 입력해 주세요.')
			return false;
		}
    }
}	
</script>
