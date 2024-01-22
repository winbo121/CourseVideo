<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
.ck-editor__editable_inline {
	white-space: pre-wrap; 
};
.ck-editor__main {
	white-space: pre-wrap; 
};
#cont {
	white-space: pre-wrap; 
};
</style>

<!--Dashbord Student -->
<div class="page-content">
	<div class="container">
		<div class="row">
			<!-- Profile Details -->
			<div class="col-md-12">
				<div
					class="filter-grp ticket-grp tiket-suport d-flex align-items-center justify-content-between">
					<div>
						<h3>공지사항 등록</h3>
					</div>
					<div class="ticket-btn-grp">
						<a href="/notice/noticeMain/index.do">공지사항 목록가기</a>
					</div>
				</div>
				<div class="settings-widget">
					<div class="settings-inner-blk add-course-info new-ticket-blk p-0">
						<div class="comman-space">
							<!-- <h4>새 공지사항 등록</h4> -->
							<c:choose>
								<c:when test="${paramVal eq 'U' }">
									<h4>공지사항 수정</h4>
								</c:when>
								<c:when test="${paramVal eq 'I' }">
									<h4>새 공지사항 등록</h4>
								</c:when>
							</c:choose>
							<form:form id="submitForm" modelAttribute="notice" method="POST">
								<input type="hidden" id="notice_seq" name="notice_seq"
									class="form-control ht35 mr5" value="${ notice.notice_seq }" />
								<div>
									<div class="form-group">
										<label class="form-control-label">제목</label>
										<form:input path="title" class="form-control ht35 mr5" />
									</div>
									<div class="form-group">
										<label class="add-course-label">내용</label>
										<div id="editor" style="display: inline-block; white-space: pre-wrap;"></div>
										<form:hidden path="contents" class="form-control mr5 fl"/>
									</div>
									<div class="form-group ">
										<label class="add-course-label" style="margin-bottom: 1px;">파일첨부</label>
										<i style="color: blue;">(* 업로드 가능한 확장자: bmp, gif, jpeg,
												jpg, png, tif, tiff, hwp, hwpx, doc, docx, xls, xlsx, ppt, pptx,
												pdf, txt, zip, 7z)</i>
										<div id="fileTd" class="form-group">
											
											<div class="relative-form" id="thumb-form" align="right" style="width: 19%; padding-left: 0px; height: 0px;">
												<!-- span id="thumb-span"> -->
												<label class="relative-file-upload" style="margin-bottom: 1px;  color: white; position: inherit;" > <!-- float: right; -->
													<spring:message code="button.upload"/>
													<br>
													<input multiple="multiple" type="file" id="fileInput"
													name="fileInput" onchange="addFile(this);" />
												</label>
											</div>
											
											<!-- <div class="relative-form" id="thumb-form"> -->
											<input multiple="multiple" type="hidden" id="fileInput2"
													name="fileInput"  style="margin-bottom: 1px;"/>
											<!-- </div> -->
											<br>
											
											<c:forEach items="${files }" var="result">
												<li id="file_${result.file_seq }"><a href="#none"
													onclick="file_down(${result.file_seq},'','')">${result.orgin_filenm }.${result.file_ext }</a>
													<a
													href="javascript:deleteFile('${result.file_seq }','${ notice.notice_seq }');"
													class="me-0 remove_btn"> <%-- <img src="<c:url value='/assets/images/ico_closecircle.svg'/>" class="ml5" > --%>
														<i class="far fa-trash-can"></i>
												</a></li>
											</c:forEach>
										</div>
									</div>
									<div class="form-group">
										<label class="add-course-label">사이드 노출</label></br> <label
											class="custom_check"> <input type="checkbox"
											id="top_fixed_yn" name="top_fixed_yn" value="Y"
											<c:if test="${notice.top_fixed_yn eq 'Y'}"> checked </c:if>>
											<span class="checkmark"></span> <i for="top_fixed_yn">게시물을
												고정공지로 등록합니다.</i>
										</label>
									</div>
									<div class="form-group">
										<label class="add-course-labe">공지사항 카테고리</label></br> <label
											class="custom_check custom_one"> <input type="radio"
											id="notice_gb" name="notice_gb" value="1"
											class="radio-with-img"
											<c:if test="${notice.notice_gb eq '1'}"> checked </c:if>
											checked="checked"> <span class="checkmark"></span> <label
											class="add-course-label">공지사항</label>
										</label>&nbsp; <label class="custom_check custom_one"> <input
											type="radio" id="notice_gb" name="notice_gb" value="2"
											class="radio-with-img"
											<c:if test="${notice.notice_gb eq '2'}"> checked </c:if>>
											<span class="checkmark"></span> <label
											class="add-course-label">자료실</label>
										</label>&nbsp;
									</div>




									<div class="form-group ">
										<label class="add-course-label" style="margin-bottom: 1px;">썸네일 첨부</label>
										<i style="color: blue;">(* 업로드 가능한 확장자: bmp, gif, jpeg,
												jpg, png, tif, tiff )</i>
										<div id="thumbTd" class="form-group">
										
											<div class="relative-form" id="thumb-form" align="right" style="width: 19%; padding-left: 0px; height: 0px;">
												<!-- span id="thumb-span"> -->
												<label class="relative-file-upload"  style="margin-bottom: 1px;  color: white; position: inherit;" >
													<spring:message code="button.upload"/>
													<br>
													<input multiple="multiple" type="file" id="thumbInput"
													name="thumbInput" onchange="addThumb(this);" />
												</label>
											</div>
											<br>
												<i style="color: blue;">* 권장 썸네일 사이즈 : 900 x 300</i>
										
											<input multiple="multiple" type="hidden" id="thumbInput2"
												name="thumbInput" onchange="addThumb(this);" /> 
											
											<c:forEach items="${thumb_files }" var="result">
												<li id="file_${result.file_seq }"><a href="#none"
													onclick="file_down(${result.file_seq},'','')">${result.orgin_filenm }.${result.file_ext }</a>
													<a
													href="javascript:deleteFile('${result.file_seq }','${ notice.notice_seq }');"
													class="me-0 remove_btn"> <i class="far fa-trash-can"></i>
												</a></li>
												<!-- <a href="javascript:void(0);" class="me-0 remove_btn">
																					<i class="far fa-trash-can"></i>
																				</a> -->
											</c:forEach>
										</div>
									</div>






									<c:choose>
										<c:when test="${paramVal eq 'U' }">
											<div class="submit-ticket" style="place-content: center;">
												<button type="button" class="btn btn-primary"
													id="update_btn" onclick="modifyNotice();">수정</button>
												<button type="button" id="list_btn" class="btn btn-dark">취소</button>
												<!-- <div style="place-content: right;"> -->
												<!-- <button type="button" class="" id="delete_btn">삭제</button> -->
												<!-- </div> -->
											</div>

										</c:when>
										<c:when test="${paramVal eq 'I' }">
											<div class="submit-ticket">
												<button type="button" class="btn btn-primary" id="save_btn"
													onclick="insertNotice();">등록</button>
												<button type="button" id="list_btn" class="btn btn-dark">취소</button>
											</div>
										</c:when>
									</c:choose>
								</div>
							</form:form>
						</div>
					</div>
				</div>
			</div>
			<!-- Profile Details -->

		</div>
	</div>
</div>
<!-- /Dashbord Student -->
<script type="text/javascript">

$(document).ready(function() {
	/* CKEDITOR.replace(); */
	modeSet();
	initFormValidator();
	
	var cnt = '${fixCnt}';
});

</script>

<script type="text/javascript">
	/* CKEDITOR.replace(); */
	var fix_state = '${notice.top_fixed_yn}';
	//console.log(fix_state);
	
	$("#list_btn").on("click", function(){
		location.href = '<c:url value="/notice/noticeMain/index.do?"/>';
	}); 

	function escapeParsr(a){
	    var b = '';
	    b = a.replace(/&lt;/g, '<');
	    b = b.replace(/&gt;/g,'>');
	    //b = b.replace(/&nbsp;/g,' ');
	    b = b.replace(/&amp;/g, '&');
	    b = b.replace(/&quot;/g, '"');
	    b = b.replace(/<br data-cke-filler="true">/g, "&nbsp;");
	    return b;
	}
	
	function modeSet() {
			var content = $("#contents").val();
			content = escapeParsr(content);
			editor.setData(content);
	}
	
	
	function insertNotice(){
		var title = $("#title").val();
		title = escapeParsr(title);
		var dscr = editor.getData();
		dscr = escapeParsr(dscr)
		$("#contents").val(dscr);
		//contents = escapeParsr(contents);
		//var contents = $("#contents").val(dscr);
		var contents = editor.getData(); 
		contents = escapeParsr(contents);
		editor.setData(contents);
		
		<%-- 유효성 체크 --%>
		initFormValidator();
		var is_valid = $("#submitForm").valid();
		if( is_valid != true  ){
			return;
		}
		if ($("input:checkbox[id='top_fixed_yn']").is(":checked")) {
			
			if(parseInt('${fixCnt}') >= 3){
				alert_error( "고정공지는 3개를 초과할 수 없습니다.", null );
				return;
			}
		}
		
		
		var form = $('#submitForm')[0];
		var form_data = new FormData(form);
		//form_data.set("contents", contents);
		for (var i = 0; i < filesArr.length; i++) {
			if (!filesArr[i].is_delete) {
				form_data.append("files", filesArr[i]);
			}
		}
		for (var i = 0; i < thumbArr.length; i++) {
			/* if (thumbArr[i]) { */
			if (!thumbArr[i].is_delete) {
				form_data.append("thumb_files", thumbArr[i]);
			}
		}
		
		var action = "/notice/noticeInsert.do";
		
		
		var succ_func = function( resData, status ){
			var reload_func = function () {
				location.href = '<c:url value="/notice/noticeMain/index.do?"/>';
			}
			if( status == 'success' ) {
				alert_success( "공지사항이 저장되었습니다.", reload_func );
			} else {
				alert_error( "작업을 정상적으로 수행하지 못하였습니다.", null );
			}
		} 
		
		ajax_form_put( action, form_data, succ_func );
		
	}; 
	
	
	function modifyNotice(){
		var title = $("#title").val();
		title = escapeParsr(title);
		var dscr = editor.getData();
		$("#contents").val(dscr);
		var contents = editor.getData(); 
		contents = escapeParsr(contents);
		editor.setData(contents);
		
		<%-- 유효성 체크 --%>
		initFormValidator();
		var is_valid = $("#submitForm").valid();
		if( is_valid != true  ){
			return;
		}
		if ($("input:checkbox[id='top_fixed_yn']").is(":checked")) {
			if (fix_state != "Y") {
				if(parseInt('${fixCnt}') >= 3){
					alert_error( "고정공지는 3개를 초과할 수 없습니다.", null );
					return;
				}
			}
		}
		
		var form = $('#submitForm')[0];
		var form_data = new FormData(form);
		for (var i = 0; i < filesArr.length; i++) {
			// 삭제되지 않은 파일만 폼데이터에 담기
			if (!filesArr[i].is_delete) {
				form_data.append("files", filesArr[i]);
			}
		}
		for (var i = 0; i < thumbArr.length; i++) {
			// 삭제되지 않은 파일만 폼데이터에 담기
			if (!thumbArr[i].is_delete) {
				form_data.append("thumb_files", thumbArr[i]);
			}
		}
		
		var action = "/notice/noticeModify.do";
		
		
		var succ_func = function( resData, status ){
		
			var reload_func = function () {
				location.href = '<c:url value="/notice/noticeMain/index.do?"/>';
			}
			if( status == 'success' ) {
				alert_success( "공지사항이 수정되었습니다.", reload_func );
			} else {
				alert_error( "작업을 정상적으로 수행하지 못하였습니다.", null );
			}
		} 
		
		ajax_form_put( action, form_data, succ_func );
		
	}; 
	
	
	
	function deleteFile(fileSeq,noticeSeq) {
		
		var confirm_func = function () {
			
			var action = "/notice/noticeDeletefile.do";
			var json = { file_seq: fileSeq, notice_seq:noticeSeq };
			var succ_func = function( resData, status ){
				delete_file(fileSeq);
			};
			ajax_json_delete( action, json, succ_func  );
		}
		confirm_error( "해당파일을 삭제하시겠습니까?", confirm_func, null  );
	}; 
	
	// 파일 삭제시 delete_file_list 에 file_seq 를 지정하고, 해당 파일들은 삭제처리
	function delete_file(file_seq) {
		//deleteFile(file_seq);
		$("<input></input>", {
			type : "hidden",
			name : "delete_files",
			value : file_seq
		}).appendTo($('#submitForm')[0]);
		// 삭제대상 숨김처리
		$("#file_" + file_seq).hide();
		
	} 
	
	
    /** 다중 파일 첨부 **/
    let fileNo = 0;
    let filesArr = new Array();
    let files = new Array();
    
    let thumbArr = new Array();
    let thumb = new Array();

    /* 첨부파일 추가 */
    function addFile(obj){
    	var maxFileCnt = 5;   // 첨부파일 최대 개수
    	var attFileCnt = $("#fileTd li").not("li[style]").length;    // 기존 추가된 첨부파일 개수
    	var remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
    	var curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수
    	// 첨부파일 개수 확인
    	if (curFileCnt + $("#fileTd .fileNames").length  > remainFileCnt) {
    		alert_warning("첨부파일은 최대 " + maxFileCnt + "개 까지 첨부 가능합니다.");
    		$("#thumbInput").val("");
    		return false;
    	}
    	// 첨부파일 확장자 확인
    	for (var i = 0; i < curFileCnt; i++) {
    		files[i] = obj.files[i];
    		var name = files[i].name.split('.').pop().toLowerCase();
    		if ($.inArray(name, [ 'bmp', 'gif', 'jpg' , 'jpeg', 'png', 'tif', 'tiff' ,'hwp','hwpx','doc','docx','xls','xlsx','ppt','pptx','pdf','txt','zip','7z']) == -1) {
    			alert_warning( "첨부할 수 없는 파일입니다.<br/>(첨부 가능한 확장자: bmp, gif, jpeg, jpg, png, tif, tiff, hwp, doc, docx, xls, xlsx, ppt, pptx, pdf, txt, zip, 7z )" , null );
    			$("#thumbInput").val("");
    			$(".fileNames").remove();
    			return false;
    		}
    	}
    	
    	for (var i = 0; i < curFileCnt; i++) {
    		
    		const file = obj.files[i];
    		// 파일 배열에 담기
    		var reader = new FileReader();
    		reader.readAsDataURL(file);
    		$("#ajaxLoad").show();
    		
    		reader.onload = function () {
    			filesArr.push(file);
    			// 목록 추가
    			let htmlData = '';
    			htmlData += '<p id="file' + fileNo + '" class="fileNames" style="margin-bottom: 1px;">';
    			//htmlData += 	'<span><span><img src="' + '<c:url value="/assets/images/ico_file.svg"/>' + '"></span>' + file.name + '</span>';
    			htmlData += 	'<span><span></span>' + file.name + '</span>';
    			//htmlData += 	'<a href="javascript:deletefile('+ fileNo +');"><img src="' + '<c:url value="/assets/images/ico_closecircle.svg"/>' + '" class="ml5"></a>';
    			htmlData += 	'<a href="javascript:deletefile('+ fileNo +');" class="me-0 remove_btn"><i class="far fa-trash-can"></i></a>';
    			htmlData += '</p>';
    			
    			//$("#fileTd input").last().before(htmlData);
    			$("#fileTd #fileInput2").last().before(htmlData);
    			//$("#fileTd li").append(htmlData);
    			fileNo++;
    			
    			$("#ajaxLoad").hide();
    		};
    	}
    	// 초기화
    	$("#fileInput").val("");
    }
	
	
	/* 첨부파일 삭제 */
	function deletefile(num) {
		$("#file"+ num ).remove();
		//$("#file" + num).remove();
		filesArr[num].is_delete = true;
		thumbArr[num].is_delete = true;
	} 

	
	  /* 첨부파일 추가 */
	    function addThumb(obj){
	    	var maxFileCnt = 1;   // 첨부파일 최대 개수
	    	var attFileCnt = $("#thumbTd li").not("li[style]").length;    // 기존 추가된 첨부파일 개수
	    	var remainFileCnt = maxFileCnt - attFileCnt;    // 추가로 첨부가능한 개수
	    	var curFileCnt = obj.files.length;  // 현재 선택된 첨부파일 개수
	    	// 첨부파일 개수 확인
	    	if (curFileCnt + $("#thumbTd .fileNames").length  > remainFileCnt) {
	    		alert_warning("첨부파일은 최대 " + maxFileCnt + "개 까지 첨부 가능합니다.");
	    		$("#fileInput").val("");
	    		return false;
	    	}
	    	// 첨부파일 확장자 확인
	    	for (var i = 0; i < curFileCnt; i++) {
	    		thumb[i] = obj.files[i];
	    		var name = thumb[i].name.split('.').pop().toLowerCase();
	    		if ($.inArray(name, [ 'bmp', 'gif', 'jpg' , 'jpeg', 'png', 'tif', 'tiff']) == -1) {
	    			alert_warning( "첨부할 수 없는 파일입니다.<br/>(첨부 가능한 확장자: bmp, gif, jpeg, jpg, png, tif, tiff)" , null );
	    			$("#fileInput").val("");
	    			$(".fileNames").remove();
	    			return false;
	    		}
	    	}
	    	
	    	for (var i = 0; i < curFileCnt; i++) {
	    		
	    		const file = obj.files[i];
	    		// 파일 배열에 담기
	    		var reader = new FileReader();
	    		reader.readAsDataURL(file);
	    		$("#ajaxLoad").show();
	    		
	    		reader.onload = function () {
	    			thumbArr.push(file);
	    			// 목록 추가
	    			let htmlData = '';
	    			htmlData += '<p id="file' + fileNo + '" class="fileNames">';
	    			//htmlData += 	'<span><span><img src="' + '<c:url value="/assets/images/ico_file.svg"/>' + '"></span>' + file.name + '</span>';
	    			htmlData += 	'<span><span></span>' + file.name + '</span>';
	    			//htmlData += 	'<a href="javascript:deletefile('+ fileNo +');"><img src="' + '<c:url value="/assets/images/ico_closecircle.svg"/>' + '" class="ml5"></a>';
	    			//htmlData += 	'<a href="javascript:deletefile('+ fileNo +');"><img src="' + '<c:url value="/assets/images/ico_closecircle.svg"/>' + '" class="ml5"></a>';
	    			htmlData += 	'<a href="javascript:deletefile('+ fileNo +');" class="me-0 remove_btn"><i class="far fa-trash-can"></i></a>';
	    			htmlData += '</p>';
	    			
	    			$("#thumbTd #thumbInput2").last().before(htmlData);
	    			fileNo++;
	    			
	    			$("#ajaxLoad").hide();
	    		};
	    	}
	    	// 초기화
	    	$("#thumbInput").val("");
	    }
	
	
		<%-- FORM  유효성 체크 --%>
		var _form_validator = null;
		
		function initFormValidator(){
			<%-- VALIDATOR 대상 FORM  --%>
			var _form = $("#submitForm");

			var _form_rules = {
				title: { required:true , maxlength : 100}
				,contents: { required:true }
			 };

			var _form_messages = {
				title: { required:"제목을 입력해 주세요" }
				,contents: { required:"내용을 입력해 주세요" }
			};
			
			
			_form_validator = get_form_validator( _form, _form_rules, _form_messages   );
			
		}

	
	
	
</script>
<!-- Content Wrapper. Contains page content -->
<section style="min-width: 770px;">
	<table class="tabs mgt_70">
	</table>
</section>



<script type="text/x-jquery-tmpl" id="file_choice_tmpl">
  	<a href="javascript:void(0);" class="mr20"
  									data-file-seq="X_FILE_PROMISE"
  									style="background: #fff;padding: 5px 10px;border: 1px solid #bdbdbd;line-height: 42px;">
  		<i class="fas fa-times" style="margin-right: 5px;"></i>\${file_name}
  	</a>
</script>


