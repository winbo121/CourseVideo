<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
.ck-editor__editable_inline {
    min-height: 500px;
}
</style>
<script>

//초기 강좌 콘텐츠 타입
var bf_type = "";

	$(document).ready(function() {
		bf_type = $("#type_seq").val();
		init();
		
		<%-- 콘텐츠 순서 정렬 --%>
		$("#accordion").sortable();
		
		<%-- 모달 액션 --%>
		// 강좌 검색
		$("#btn_modal_course_open").on("click",function(){
			
			// 초기화
			$("div.remodal").remove();
			
    		var action = '/conage/modal/courseEnrollCourse.do';
			var form_data = new FormData();
			var token = "${_csrf.token}";
			form_data.append("_csrf", token );
			
			var succ_func = function(resData, status ) {
				$("#modalBox").html(resData);
				
				var remodal_element =  $('[data-remodal-id=course]');
				
				var input_elements = $( remodal_element ).find("input:text, textarea");
				$( input_elements ).val("");

				<%-- RE MODAL OPEN 성공 이후 후처리 함수 --%>
				var open_succ_func = function(){
					set_data();
				};
				
				basicReModal = new BasicReModal();
				basicReModal._remodal_element = remodal_element;
				basicReModal._open_succ_func = open_succ_func;
				basicReModal.open();	
				
				};
			
			ajax_form_get(action, form_data, succ_func);
			
		});
		
		<%-- 모달 액션 --%>
		// 콘텐츠 검색
		$("#btn_modal_contents_open").on("click",function(){
			
			//초기화
			$("div.remodal").remove();
			
    		var action = '/conage/modal/courseEnrollContents.do';
			var form_data = new FormData();
			var token = "${_csrf.token}";
			form_data.append("_csrf", token );
			
			var succ_func = function(resData, status ) {
				$("#modalBox").html(resData);
				
				var remodal_element =  $('[data-remodal-id=contents]');

				var input_elements = $( remodal_element ).find("input:text, textarea");
				$( input_elements ).val("");
				var type_seq = $("#type_seq").val();

				<%-- RE MODAL OPEN 성공 이후 후처리 함수 --%>
				var open_succ_func = function(){
					if (type_seq == 186){
						$("#chg_type").text("영상시간(초)");
					} else if (type_seq == 187) {
						$("#chg_type").text("WBT");		
					} else {
						$("#chg_type").text("URL");
					}

					set_data();
				};
				
				<%-- 강좌유형 선택은 필수로 진행 --%>
				if(type_seq == 185){
					alert_warning("영상타입 선택 후 진행하시기 바랍니다.");
					return false;
				} else {
				if(type_seq == 188 && $("input[name=get_contents_seqs]").length > 0){
					alert_warning("외부영상 콘텐츠는 1개만 등록할 수 있습니다.<br/>콘텐츠 삭제 후 진행 하시기 바랍니다.");
					return false;
				}
				if(type_seq == 534 && $("input[name=get_contents_seqs]").length > 0){
					alert_warning("유튜브 콘텐츠는 1개만 등록할 수 있습니다.<br/>콘텐츠 삭제 후 진행 하시기 바랍니다.");
					return false;
				}
				if(type_seq != bf_type && $("input[name=get_contents_seqs]").length > 0){
					alert_warning("영상타입 변경을 원하시면 기존 강좌콘텐츠를 삭제 후 진행하시기 바랍니다.");
					return false;
				}
			}
			
				
				basicReModal = new BasicReModal();
				basicReModal._remodal_element = remodal_element;
				basicReModal._open_succ_func = open_succ_func;
				basicReModal.open();	
				
				};
			
			ajax_form_get(action, form_data, succ_func);
			
		});
		
		<%-- FORM VALIDATOR 초기화 --%>
		initFormValidator();
		
		// 강좌 등록
		$("#insert_btn").on("click", function() {
			<%--  더블 클릭 방지 --%>
			if(checkIsRun()) {
				return;
			}
			
			<%-- form validate --%>
			var descr = editor.getData();
			$("#course_descr").val(descr);
			
			var course_round = $("input[name=get_contents_seqs]").length;
			if(course_round == 0){
				course_round = '';
			}
			$("#course_round").val(course_round);
			
			<%-- 유효성 체크 --%>
			var is_valid = $("#course").valid();

			if( is_valid != true  ){
				
				<%-- 더블 클릭 방지 리셋 --%>
				resetIsRun();
				
				$("#result_msg").empty();
				$("#fail_msg").tmpl().appendTo($("#result_msg"));
				return;
 			}
			
			var formdata = $("#course")[0];
			var form_data = new FormData(formdata);
			var succ_func = function(resData, status ) {
				var result = resData.result;
				
				if(result == 'success') {
					var confirm_func = function() {
						$("#result_msg").empty();
						$("#success_msg").tmpl().appendTo($("#result_msg"));
						location.href="/conage/courseEnrollMain/index.do";

					};
					
					alert_success( "등록하였습니다.<br/> 메인화면으로 이동합니다.", confirm_func );
				} else {
					
					<%-- 더블 클릭 방지 리셋 --%>
					resetIsRun();
					
					$("#result_msg").empty();
					$("#fail_msg").tmpl().appendTo($("#result_msg"));
					
					alert_error( resData.msg, null );
				}
			};
			
			ajax_form_post("/conage/courseEnroll/insert.do", form_data, succ_func);
		});
		
		// 강좌 수정
		$("#update_btn").on("click", function() {
			<%--  더블 클릭 방지 --%>
			if(checkIsRun()) {
				return;
			}
			
			<%-- form validate --%>
			var descr = editor.getData();
			$("#course_descr").val(descr);
			
			var course_round = $("input[name=get_contents_seqs]").length;
			if(course_round == 0){
				course_round = '';
			}
			$("#course_round").val(course_round);
			
			<%-- 유효성 체크 --%>
			var is_valid = $("#course").valid();
 
			if( is_valid != true  ){
				
				<%-- 더블 클릭 방지 리셋 --%>
				resetIsRun();
				
				$("#result_msg").empty();
				$("#fail_msg").tmpl().appendTo($("#result_msg"));
				return;
 			}
			
			var formdata = $("#course")[0];
			var form_data = new FormData(formdata);
			
			var succ_func = function(resData, status ) {
				var result = resData.result;
				
				if(result == 'success') {
					var confirm_func = function() {
						$("#result_msg").empty();
						$("#success_msg").tmpl().appendTo($("#result_msg"));
						location.href="/conage/courseEnrollMain/index.do";

					};					
					
					alert_success( "수정하였습니다.<br/> 메인화면으로 이동합니다.", confirm_func );
				} else {
					
					<%-- 더블 클릭 방지 리셋 --%>
					resetIsRun();
					
					$("#result_msg").empty();
					$("#fail_msg").tmpl().appendTo($("#result_msg"));
					
					alert_error( resData.msg, null );
				}
			};
			
			ajax_form_put("/conage/courseEnroll/update.do", form_data, succ_func);
		});
		
		// 강좌 삭제
		$("#delete_btn").on("click", function() {
			<%--  더블 클릭 방지 --%>
			if(checkIsRun()) {
				return;
			}
			
			var confirm_func = function() {
				// 첨부파일도 삭제
				$("input[name=file_seq]").each(function(){
					var seq = $(this).val();
					removeFile(this,seq);	
				});
				
				var formdata = $("#course")[0];
				var form_data = new FormData(formdata);
				
				var succ_func = function(resData, status ) {
					var result = resData.result;
					
					if(result == 'success') {
						var confirm_func = function() {
							location.href="/conage/courseEnrollMain/index.do";
						};
						
						alert_success( "삭제하였습니다.<br/> 메인화면으로 이동합니다.", confirm_func );
					} else {
						
						<%-- 더블 클릭 방지 리셋 --%>
						resetIsRun();
						
						alert_error( resData.msg, null );
					}
				};
				
				ajax_form_delete("/conage/courseEnroll/delete.do", form_data, succ_func);
			};
			
			confirm_warning("해당 강좌를 삭제하시겠습니까?",confirm_func);
		});
		
	});
	
	function init(){
		modeSet();
	}
	
	function modeSet() {
		var mode = "${mode}";
		var $insert = $("#insert_btn");
		var $update = $("#update_btn");
		var $delete = $("#delete_btn");
		var $courseSearch = $("#btn_modal_course_open");
		var $contentsSearch = $("#btn_modal_contents_open");
		var $contentsDelete = $("#delete_contents_btn");
		var $upload = $("#upload_files").parent();
		
		if(mode == 'I') {
			$insert.show();
			$update.hide();
			$delete.hide();
			$courseSearch.show();
			$contentsSearch.show();
			$contentsDelete.show();
		} else if(mode == 'U') {
			$insert.hide();
			$update.show();
			$delete.show();
			$courseSearch.show();
			$contentsSearch.show();
			$contentsDelete.show();
			editor.setData($("#course_descr").val());
			inputValid("input");
			inputValid("category");
			inputValid("type");
		} else if(mode == 'V'){
			$insert.hide();
			$update.hide();
			$delete.hide();
			$courseSearch.hide();
			$contentsSearch.hide();
			$contentsDelete.hide();
			$upload.hide();
			editor.setData($("#course_descr").val());
			editor.enableReadOnlyMode("#editor");
			$("input, select").prop("disabled",true);
			$(".change_btn, .remove_btn, upload_files, .fa-trash-can").prop("disabled",true).css("display","none");
		}
	}
	
	// 재설정 버튼
	$(document).on("click",'.reset_btn',function(){
		$("fieldset").css({
			'display': 'none'
		});
		$("#first").fadeIn('slow');
		
		$("#progressbar > li").each(function(index,item){
			if(index == 0){
				$(this).removeClass('progress-activated').addClass('progress-active');
			} else {
				$(this).removeClass('progress-activated').removeClass('progress-active');
			}
		}); 
	});
	
	// input 값 누락 체크
	function inputValid(type){
		if(type == "input"){
			$("input").each(function(){
				var data = $(this).val();
				if(!isEmpty(data)){
					$(this).css("background","rgba(134, 134, 254, 0.3)");
				} else {
					$(this).css("background","");
				}		
				
			})
		}
		if(type == "category"){
			if($("#category_seq").val() != 508){
				$("#select2-category_seq-container").css("background","rgba(134, 134, 254, 0.3)");
			} else {
				$("#select2-category_seq-container").css("background","");
			}
		}
		if(type == "type"){
			if ($("#type_seq").val() != 185){
				$("#select2-type_seq-container").css("background","rgba(134, 134, 254, 0.3)");
			} else {
				$("#select2-type_seq-container").css("background","");
			}
		}
		
	}
	
	$(document).on("paste, change, keydown, blur","input",function(event){
		inputValid("input");
		inputValid("category");
		inputValid("type");
	});
	
	<%-- FORM VALIDATOR 초기화  --%>
	function initFormValidator(){
		<%-- VALIDATOR 대상 FORM  --%>
		var _form = $("#course");
		
		/** 카테고리 체크  **/
		$.validator.addMethod("category",  function( value, element ) {
			var categoryCheck = RegExp( /(?=.*[0-9])/ );
			return categoryCheck.test( value ) && value != 508;
		});
		
		/** 타입 체크  **/
		$.validator.addMethod("contentType",  function( value, element ) {
			var contentTypeCheck = RegExp( /(?=.*[0-9])/ );
			return contentTypeCheck.test( value ) && value != 185;
		});
		
		/** 다른 콘텐츠 포함여부 체크  **/
		$.validator.addMethod("contentValid",  function( value, element ) {
			let type = $("#type_seq").val();
			let vod_gb = "";
			let isValid = true;
			if(type == 186){
				vod_gb = "M";
			} else if (type == 187){
				vod_gb = "W";
			} else if (type == 188){
				vod_gb = "O";
			} else if (type == 534){
				vod_gb = "Y";
			}
			
			// vod_type check
			$("#accordion").find("table > tbody > tr:nth-child(1) > td:nth-child(2)").each(function(idx,item){
				if(vod_gb != $(item).text()){
					isValid = false;
				}
			});
			
			// use_yn check
			$("#accordion").find("table > tbody > tr:nth-child(5) td:nth-child(2)").each(function(idx,item){
				if($(item).text() == "N"){
					isValid = false;
				}
			});
			
			return isValid;
		});
		
		/** 파일업로드 체크 **/
		$.validator.addMethod("upload", function( value, element ) { 
			var mode = "${mode}";
			var removeFile = $("input[name=del_files_seqs]").length;
			if (mode == 'I'){
				if (isEmpty(value)){
					return false;
				} else {
					return true;
				}
			} else if (mode == 'U'){
				if (removeFile > 0){
					if (isEmpty(value)){
						return false;
					} else {
						return true;
					}	
				}else {
					return true;
				} 			
			}

		});
		

		<%-- FORM 항목에 대한 RULES  --%>
		var _form_rules = {  course_nm: { required:true, maxlength : 100 }
							,course_subject: { required:true, maxlength : 200 }
							,instructor_nm: {required : true, maxlength : 15 }
							,reg_inst_nm: {required : true, maxlength : 20 }
							,course_descr: { required:true }
							,category_seq: { required:true, category:true }
							,type_seq: { required:true, contentType:true }
							,course_round: { required:true, contentValid:true }
						    ,upload_files: { upload:true, extension: 'jpg|png|gif'  }
						};

		<%-- FORM 오류 발생시 메세지 없는경우 comJs.jsp 에 설정된 기분 항목들 --%>
		var _form_messages = {
					  upload_files: { extension: '이미지 파일(jpg|png|gif)만 가능합니다.'  }
					, category_seq : { category: '카테고리 선택은 필수 입니다.'}
					, type_seq : { contentType:'강좌 영상타입을 선택은 필수 입니다.'}
					, upload_files:{ upload:'파일 업로드는 필수 입니다.'}
					, course_round:{ contentValid:"사용중지되거나, 영상타입이 다른 콘텐츠가 포함되어 있습니다."}
		};

		<%-- FORM VALIDATOR 생성   --%>
		var _form_validator = get_form_validator( _form, _form_rules, _form_messages   );
		<%-- FORM VALIDATOR 의 RULES, MESSAGE, SUBMIT HANDLER 변경시 아래와같이 처리
				_form_validator.settings.rules = null;
				_form_validator.settings.messages = null;
				_form_validator.settings.submitHandler = null;

		--%>
		
	}


</script>

<!-- 파일 업로드 -->			
<script>
<!-- 이미지 미리보기 -->
function setThumbnail(f){
	
	var file = event.target.files[0];
	var fileName = file.name;
	
	var reader = new FileReader();
	reader.onload = function(event){
		var img = document.createElement("img");
		img.setAttribute("src",event.target.result);
		$("#thumbnailImage").html(img);
	}
	
	$("input[name=file_seq]").each(function(){
		var file_seq = $(this).val();
		var name ="del_files_seqs";

		$("<input></input>", {
			type : "hidden",
			name : name,
			value : file_seq
		}).appendTo($('#course')[0]);
		$(this).remove();
	});
	
	reader.readAsDataURL(file);
	$(f).parent().prev().text(fileName);
	$('#delete_file_icon').tmpl().appendTo($(f).parent().prev());

}

<!-- 파일 삭제 -->
function removeFile(e, file_seq ) {
	
	if( file_seq != null ){
		var name ="del_files_seqs";

		$("<input></input>", {
			type : "hidden",
			name : name,
			value : file_seq
		}).appendTo($('#course')[0]);
	}
	
	$("#upload_files").val('');
	$(e).parent().text("등록된 섬네일이 없습니다.(등록 가능 확장자 jpg,png,gif)");
	$("#thumbnailImage").empty();
	$("#empty_image_box").tmpl().appendTo($("#thumbnailImage"));
	


}

function fileDownload( file_seq ){
	<%-- 파일 다운로드 성공시 실행되는 함수 --%>
	var succ_func = function( ){};
	<%-- 파일 다운로드 실패시 실행되는 함수 --%>
	var fail_func = function( ){};
	<%-- 파일 다운로드  --%>

	file_down( file_seq, succ_func, fail_func  );
}
</script>

<!-- 콘텐츠 관련 -->
<c:set var="modify"><spring:message code="button.modify"/></c:set>
<c:set var="delete"><spring:message code="button.delete"/></c:set>
<script>
// 콘텐츠 전체 삭제 버튼
$(document).on('click','#delete_contents_btn',function(){
	if($("input[name=get_contents_seqs]").length == 0){
		alert_warning("등록된 콘텐츠가 없습니다.");
		return;
	}
	
	var confirm_func = function() {
		$("#accordion").empty();
		$("#empty_contents_box").tmpl().appendTo($("#accordion"));	
		
	}
	
	confirm_warning("등록된 콘텐츠를 모두 삭제하시겠습니까?",confirm_func);
	
});


// 콘텐츠 개별 수정 버튼
$(document).on('click','.change_btn',function(){
	var seq = $(this).closest(".faq-grid").find("input[name=get_contents_seqs]").val();	
	
	// 팝업창 오픈
	var popup = new BasicWindow();
	popup._action = "/conage/popup/contentDetailPop.do?contents_seq=" + seq;
	popup._pop_name = "modify_contents";
	popup._width = "900px";
	popup._height = "700px";
	popup._left = 50;
	popup._top = 50;
	
	popup.open();
	
});

// 콘텐츠 수정 된 정보 업데이트
function setContent(form_data){
	var data = {};
	form_data.forEach(function(value,key){
		data[key] = value;
	});

	var $header = $("input[name=get_contents_seqs][value=" + data.contents_seq + "]");
	var $table = $("#collapse" + data.contents_seq).find("table");
	window.header = $header;
	window.table = $table;
	
	//contents_nm
	$header.next().children().find("span").text(data.contents_nm);	
	//vod_gb
	$table.children().find("tr:nth-child(1) td:nth-child(2)").text(data.vod_gb);
	//vod_url
	$table.children().find("tr:nth-child(1) td:nth-child(4)").text(data.vod_url);
	//vod_time_sec
	$table.children().find("tr:nth-child(2) td:nth-child(2)").text(data.vod_time_sec);
	// width : height
	$table.children().find("tr:nth-child(2) td:nth-child(4)").text(data.width_size + " : " + data.height_size);
	// use_yn
	$table.children().find("tr:nth-child(5) td:nth-child(2)").text(data.use_yn);
	// contents_descr
	$table.children().find("tr:nth-child(6) td:nth-child(2)").html(data.contents_descr);
	
	
	
}

// 콘텐츠 개별 삭제 버튼
$(document).on('click','.remove_btn',function(){
	
	$(this).closest(".faq-grid").remove();
	
	if($("input[name=get_contents_seqs]").length == 0){
		$("#empty_contents_box").tmpl().appendTo($("#accordion"));	
	}
});

// 콘텐츠 템플릿 추가
function makeContents(data){
	var html = '';
	html += '<div>';
	html += '<div class="faq-grid">';
	html += '	<input type="hidden" name="get_contents_seqs" value="' + data.contents_seq + '"/>';
	html += '	<div class="faq-header">';
	html += '		<a class="collapsed faq-collapse" data-bs-toggle="collapse" href="#collapse' + data.contents_seq + '">';
	html += '			 <i class="fas fa-align-justify"></i><span> ' + data.contents_nm;
	html += '		</span></a>';
	html += '		<div class="faq-right">';
	html += '			<a href="javascript:void(0);" class="change_btn">';
	html += '				<i class="far fa-pen-to-square me-1"></i>';
	html += '			</a>';
	html += '			<a href="javascript:void(0);" class="me-0 remove_btn">';
	html += '				<i class="far fa-trash-can"></i>';
	html += '			</a>';
	html += '		</div>';
	html += '	</div>';
	html += '	<div id="collapse' + data.contents_seq + '" class="collapse" data-bs-parent="#accordion">';
	html += '		<div class="faq-body">';
	html += '		  	<div class="add-article-btns">';
	html += '		  		<a href="javascript:void(0);" class="btn change_btn"><i class="far fa-pen-to-square me-1">${modify}</i></a>';
	html += '		  		<a href="javascript:void(0);" class="btn me-0 remove_btn"><i class="far fa-trash-can">${delete}</i></a>';
	html += '		  	</div>';
	html += '			<table>';
   	html += '				<tbody>';
	html += '					<tr>';
	html += '						<th><spring:message code="contents.vodGb"/></th><td>' + data.vod_gb + '</td><th><spring:message code="contents.vodUrl"/></th><td>' + data.vod_url + '</td>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<th><spring:message code="contents.vodTime"/></th><td>' + data.vod_time_sec + '</td><th><spring:message code="contents.width"/>:<spring:message code="contents.height"/></th><td>' + data.width_size + ' : ' + data.height_size + '</td>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<th><spring:message code="contents.regUser"/></th><td>' + data.reg_user + '</td><th><spring:message code="contents.regDts"/></th><td>' + data.reg_dts + '</td>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<th><spring:message code="contents.updUser"/></th><td>' + data.upd_user + '</td><th><spring:message code="contents.updDts"/></th><td>' + data.upd_dts + '</td>';
	html += '					</tr>';
	html += '					<tr>';
	html += '						<th><spring:message code="contents.useYn"/></th><td>' + data.use_yn + '</td><th><spring:message code="contents.delYn"/></th><td>' + data.del_yn + '</td>';
	html += '					</tr>';
	html += '						<tr>';
	html += '					<th><spring:message code="contents.descr"/></th><td colspan="3">' + data.contents_descr + '</td>';
	html += '					</tr>';
	html += '				</tbody>';	
	html += '			</table>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>';
	html += '</div>';
	return html;
}
</script>

    
   <!-- New Course -->
   		<form:form modelAttribute="course" enctype="multipart/form-data" onsubmit="return false;">
   			<form:hidden path="course_seq"/>
   			<form:hidden path="course_descr" data-valid-name="강좌상세설명"/>
   			<form:hidden path="course_round" data-valid-name="콘텐츠선택"/>
   			<%-- <form:hidden path="display_yn"/> --%>
   			<%-- <form:hidden path="start_dts"/> --%>
   			<%-- <form:hidden path="end_dts"/> --%>
   			
			<section class="page-content course-sec">
				<div class="container">
					<div class="row align-items-center">
						<div class="col-md-12">
							<div class="add-course-header">
								<h2>
									<spring:message code="course"/> 
									<c:if test="${mode eq 'I' }"><spring:message code="button.create"/></c:if>
									<c:if test="${mode eq 'U' }"><spring:message code="button.modify"/></c:if>
									<c:if test="${mode eq 'V' }"><spring:message code="button.view"/></c:if>
								</h2>
								<div class="add-course-btns">
									<ul class="nav">
										<li>
											<a href="javascript:void(0);" class="btn btn-outline-primary" id="btn_modal_course_open" style="display:none;">
												<img src="/assets/img/icon/search-icon.svg"> 
														<spring:message code="course"/> 
														<spring:message code="button.search"/>
											</a>
										</li>
										<li>
											<a href="/conage/courseEnrollMain/index.do" class="btn btn-black"><spring:message code="button.list"/></a>
										</li>
										<li>
											<a href="javascript:void(0);" class="btn btn-success-dark" id="delete_btn" style="display:none;"><spring:message code="button.delete"/></a>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
					<div class="row">
						<div class="col-md-12">
							<div class="card">
								<!-- Course Wizard -->
								<div class="widget-set">
									<div class="widget-setcount">
										<ul id="progressbar">
											<li class="progress-active">
												<p><span></span><spring:message code="course.basic"/></p>											
											</li>
											<li>
												<p><span></span><spring:message code="course.media"/></p>
											</li>
											<li>
												<p><span></span><spring:message code="course.thumbnail"/></p>												
											</li>
										</ul>
									</div>
									<div class="widget-content multistep-form">
										<fieldset id="first">
											<div class="add-course-info">
												<div class="add-course-inner-header">
													<h4><spring:message code="course.basic"/></h4>
												</div>
												<div class="add-course-form">
														<div class="form-group">
															<c:set var="courseName"><spring:message code="course.name"/></c:set>
															<label class="add-course-label">${courseName}</label>
															<form:input path="course_nm" class="form-control" placeholder="${courseName}, 100자 이내" data-valid-name="${courseName}"/>
														</div>
														<%-- 
														<div class="form-group">
															<label class="add-course-label"><spring:message code="course.startDts"/></label>
															<form:input path="start_dts" type="date" class="form-control" placeholder="<spring:message code='course.startDts'/>"/>
														</div>
														<div class="form-group">
															<label class="add-course-label"><spring:message code="course.endDts"/></label>
															<form:input path="end_dts" type="date" class="form-control" placeholder="<spring:message code='course.endDts'/>"/>
														</div>
														<div class="form-group">
															<label class="add-course-label"><spring:message code="course.dispYn"/></label>
															<form:select path="dysplay_yn" class="form-control select">
																<form:option value="">선택</form:option>
																<form:option value="Y">공개</form:option>
																<form:option value="N">비공개</form:option>
															</form:select>
														</div>
														 --%>
														 <div class="form-group">
															<c:set var="courseSubject"><spring:message code="course.subject"/></c:set>
															<label class="add-course-label">${courseSubject}</label>
															<form:input path="course_subject" class="form-control" placeholder="${courseSubject}, 200자 이내" data-valid-name="${courseSubject}"/>
														</div>
														<div class="form-group">
															<c:set var="courseCategory"><spring:message code="course.category"/></c:set>
															<label class="add-course-label">${courseCategory}</label>
															<form:select path="category_seq" class="form-control select" data-valid-name="${courseCategory}">
																<c:forEach items="${categoryCode}" var="code">
																	<form:option value="${code.code_seq}">${code.code_nm}</form:option>
																</c:forEach>
															</form:select>
														</div>
														<div class="form-group">
															<c:set var="courseInstructor"><spring:message code="course.instructor"/></c:set>
															<label class="add-course-label">${courseInstructor}</label>
															<form:input path="instructor_nm" class="form-control" placeholder="${courseInstructor}, 15자 이내" data-valid-name="${courseInstructor}"/>
														</div>
														<div class="form-group">
															<c:set var="courseInstitute"><spring:message code="course.inst"/></c:set>
															<label class="add-course-label">${courseInstitute}</label>
															<form:input path="reg_inst_nm" class="form-control" placeholder="${courseInstitute}, 20자 이내" data-valid-name="${courseInstitute}"/>
														</div>
														<div class="form-group mb-0">
															<label class="add-course-label"><spring:message code="course.descr"/></label>
															<div id="editor"></div>
														</div>
														
												</div>
												<div class="widget-btn">
													<a href="/conage/courseEnrollMain/index.do" class="btn btn-black"><spring:message code="button.list"/></a>
													<a class="btn btn-info-light next_btn"><spring:message code="button.continue"/></a>
												</div>
											</div>
										</fieldset>
										<fieldset class="field-card" id="second">
											<div class="add-course-info">
												<div class="add-course-inner-header">
													<h4><spring:message code="course.media"/></h4>
												</div>
												<div class="add-course-section">
													<div class="form-group">
														 	<c:set var="courseType"><spring:message code="course.type"/></c:set>
															<label class="add-course-label">${courseType}</label>
															<form:select path="type_seq" class="form-control select" data-valid-name="${courseType}">
																<c:forEach items="${typeCode}" var="code">
																	<form:option value="${code.code_seq}">${code.code_nm}</form:option>
																</c:forEach>
															</form:select>
													</div>
													<a href="javascript:void(0);" id="btn_modal_contents_open" class="btn"><img src="/assets/img/icon/search-icon.svg" >
														<spring:message code="contents"/>  
														<spring:message code="button.search"/>
													</a>
												</div>
												<div class="add-course-form">
												<div class="add-course-form">
													<div class="curriculum-grid">
														<div class="curriculum-head">
															<p><spring:message code="course.media"/></p>
															<a href="javascript:void(0);" class="btn" id="delete_contents_btn"><spring:message code="search.all"/> <spring:message code="button.delete"/></a>
														</div>
														<div class="curriculum-info">
															<div id="accordion">
															<%-- Contents 정보 들어온다. --%>
																<c:forEach items="${contents}" var="contents">
																	<div class="faq-grid">
																		<input type="hidden" name="get_contents_seqs" value="${contents.contents_seq}"/>
																		<div class="faq-header">
																			<a class="collapsed faq-collapse" data-bs-toggle="collapse" href="#collapse${contents.contents_seq}">
																				 <i class="fas fa-align-justify"></i><span> ${contents.contents_nm} </span>
																			</a>
																			<div class="faq-right">
																				<a href="javascript:void(0);" class="change_btn">
																					<i class="far fa-pen-to-square me-1"></i>
																				</a>
																				<a href="javascript:void(0);" class="me-0 remove_btn">
																					<i class="far fa-trash-can"></i>
																				</a>
																			</div>
																		</div>
																		<div id="collapse${contents.contents_seq}" class="collapse" data-bs-parent="#accordion">
																			<div class="faq-body">
																			  	<div class="add-article-btns">
																			  		<a href="javascript:void(0);" class="btn change_btn"><i class="far fa-pen-to-square me-1"><spring:message code="button.modify"/></i></a>
																			  		<a href="javascript:void(0);" class="btn me-0 remove_btn"><i class="far fa-trash-can"><spring:message code="button.delete"/></i></a>
																			  	</div>
																	           <table>
																	           	<tbody>
																	           		<tr>
																	           			<th><spring:message code="contents.vodGb"/></th><td>${contents.vod_gb}</td><th><spring:message code="contents.vodUrl"/></th><td>${contents.vod_url}</td>
																	           		</tr>
																	           		<tr>
																	           			<th><spring:message code="contents.vodTime"/></th><td>${contents.vod_time_sec}</td><th><spring:message code="contents.width"/>:<spring:message code="contents.height"/></th><td>${contents.width_size} : ${contents.height_size}</td>
																	           		</tr>
																	           		<tr>
																	           			<th><spring:message code="contents.regUser"/></th><td>${contents.reg_user}</td><th><spring:message code="contents.regDts"/></th><td>${contents.reg_dts}</td>
																	           		</tr>
																	           		<tr>
																	           			<th><spring:message code="contents.updUser"/></th><td>${contents.upd_user}</td><th><spring:message code="contents.updDts"/></th><td>${contents.upd_dts}</td>
																	           		</tr>
																	           		<tr>
																	           			<th><spring:message code="contents.useYn"/></th><td>${contents.use_yn}</td><th><spring:message code="contents.delYn"/></th><td>${contents.del_yn}</td>
																	           		</tr>
																	           		<tr>
																	           			<th><spring:message code="contents.descr"/></th><td colspan="3">${contents.contents_descr}</td>
																	           		</tr>
																	           	</tbody>
																	           </table>
																			</div>
																		</div>
																	</div>
																</c:forEach>
																<c:if test="${contents eq null }"><div class="emptyContents">등록된 강좌 콘텐츠가 없습니다.</div></c:if>
															</div>
														</div>
													</div>
													</div>
												</div>
												<div class="widget-btn">
													<a class="btn btn-black prev_btn"><spring:message code="button.previous"/></a>
													<a class="btn btn-info-light next_btn"><spring:message code="button.continue"/></a>
												</div>
											</div>
										</fieldset>
										<fieldset class="field-card" id="third">
											<div class="add-course-info">
												<div class="add-course-inner-header">
													<c:set var="courseThumbnail"><spring:message code="course.thumbnail"/></c:set>
													<h4>${courseThumbnail}</h4>
												</div>
												<div class="add-course-form">
													<c:if test="${thumbnailFiles ne null }">
														<c:forEach items="${thumbnailFiles}" var="file">
															<div class="form-group">
																<label class="add-course-label">${courseThumbnail}</label>													
																<div class="relative-form">
																	<span>
																		<input type="hidden" name="file_seq" value="${file.file_seq}"/>
																		<a href="javascript:fileDownload(${file.file_seq});" class="download">${file.orgin_filenm}.${file.file_ext}</a>
																		<a href="javascript:void(0);" onclick="removeFile(this,${file.file_seq});" class="me-0"><i class="far fa-trash-can"></i></a>
																	</span>
																	<label class="relative-file-upload">
																		<spring:message code="button.upload"/>
																		<input type="file" id="upload_files" name="upload_files" onchange="setThumbnail(this);" data-valid-name="${courseThumbnail}"/>
																	</label>
																</div>
															</div>
															<div class="form-group">
																<div class="add-image-box" id="thumbnailImage">
																	<img src="${file.img_url}"/>
																</div>
															</div>
														</c:forEach>
													</c:if>
													<c:if test="${empty thumbnailFiles}">
														<div class="form-group">
															<label class="add-course-label">${courseThumbnail}</label>													
															<div class="relative-form">
																<span>등록된 섬네일이 없습니다.(등록 가능 확장자 jpg,png,gif)</span>
																<label class="relative-file-upload">
																	<spring:message code="button.upload"/> <input type="file" id="upload_files" name="upload_files" onchange="setThumbnail(this);"  data-valid-name="${courseThumbnail}"/>
																</label>
															</div>
														</div>
														<div class="form-group">
															<div class="add-image-box" id="thumbnailImage">
																<a href="javascript:void(0);">
																	<i class="far fa-image"></i>
																</a>
															</div>
														</div>
													</c:if>
												</div>
												<div class="widget-btn">
													<a class="btn btn-black prev_btn"><spring:message code="button.previous"/></a>
													<a class="btn btn-primary next_btn" id="update_btn" style="display:none;"><spring:message code="button.modify"/></a>
													<a class="btn btn-success-dark next_btn" id="insert_btn" style="display:none;"><spring:message code="button.create"/></a>
												</div>
											</div>
										</fieldset>
										<fieldset class="field-card" id="last">
											<div class="add-course-info" id="result_msg">
												<div class="widget-btn">
													<a href="/conage/courseEnrollMain/index.do" class="btn btn-black"><spring:message code="button.list"/></a>
												</div>
											</div>
										</fieldset>
									</div>
								</div>
								<!-- /Course Wizard -->

							</div>
						</div>
					</div>
				</div>
			</section>
		</form:form> 
<%-- <jsp:include page="modal/contentsSearch.jsp"/>
<jsp:include page="modal/courseSearch.jsp"/> --%>
<div id="modalBox"></div>
<!-- /New Course -->
			
<script type="text/x-jquery-tmpl" id="success_msg">
<div class="add-course-msg">
	<i class="fas fa-circle-check"></i>
	<h4>성공했습니다.</h4>
	<p>메인화면으로 이동바랍니다.</p>
</div>
</script>

<script type="text/x-jquery-tmpl" id="fail_msg">
<div class="add-course-msg">
	<i class="fas fa-circle-xmark"></i>
	<h4>실패했습니다.</h4>
	<p><spring:message code="button.reset"/>하여 주시기 바랍니다.</p>
</div>
<a class="btn btn-black reset_btn"><spring:message code="button.reset"/></a>
</script>


<script type="text/x-jquery-tmpl" id="delete_file_icon">
	<a href="javascript:void(0);" onclick="removeFile(this, null);" class="me-0"><i class="far fa-trash-can"></i></a>
</script>

<script type="text/x-jquery-tmpl" id="empty_image_box">
	<a href="javascript:void(0);"><i class="far fa-image"></i></a>
</script>

<script type="text/x-jquery-tmpl" id="empty_contents_box">
	<div class="emptyContents">등록된 강좌 콘텐츠가 없습니다.</div>
</script>

<script type="text/x-jquery-tmpl" id="tmp">
<div class="add-course-form">
													<form action="#">
														<div class="form-group">
															<input type="text" class="form-control" placeholder="Video URL">
														</div>
														<div class="form-group">
															<div class="add-image-box add-video-box">
																<a href="javascript:void(0);">
																	<i class="fas fa-circle-play"></i>
																</a>
															</div>
														</div>
													</form>
												</div>
												<div class="add-course-form">
													<div class="curriculum-grid">
														<div class="curriculum-head">
															<p>Section 1: Introduction</p>
															<a href="javascript:void(0);" class="btn">Add Lecture</a>
														</div>
														<div class="curriculum-info">
															<div id="accordion">
																<div class="faq-grid">
																	<div class="faq-header">
																		<a class="collapsed faq-collapse" data-bs-toggle="collapse" href="#collapseOne">
																			 <i class="fas fa-align-justify"></i> Introduction
																		</a>
																		<div class="faq-right">
																			<a href="javascript:void(0);">
																				<i class="far fa-pen-to-square me-1"></i>
																			</a>
																			<a href="javascript:void(0);" class="me-0">
																				<i class="far fa-trash-can"></i>
																			</a>
																		</div>
																	</div>
																	<div id="collapseOne" class="collapse" data-bs-parent="#accordion">
																		<div class="faq-body">
																		  	<div class="add-article-btns">
																		  		<a href="javascript:void(0);" class="btn">Add Article</a>
																		  		<a href="javascript:void(0);" class="btn me-0">Add Description</a>
																		  	</div>
																		</div>
																	</div>
																</div>
																<div class="faq-grid">
																	<div class="faq-header">
																		<a class="collapsed faq-collapse" data-bs-toggle="collapse" href="#collapseTwo">
																			 <i class="fas fa-align-justify"></i> Installing Development Software
																		</a>
																		<div class="faq-right">
																			<a href="javascript:void(0);">
																				<i class="far fa-pen-to-square me-1"></i>
																			</a>
																			<a href="javascript:void(0);" class="me-0">
																				<i class="far fa-trash-can"></i>
																			</a>
																		</div>
																	</div>
																	<div id="collapseTwo" class="collapse" data-bs-parent="#accordion">
																		<div class="faq-body">
																		  	<div class="add-article-btns">
																		  		<a href="javascript:void(0);" class="btn">Add Article</a>
																		  		<a href="javascript:void(0);" class="btn me-0">Add Description</a>
																		  	</div>
																		</div>
																	</div>
																</div>
																<div class="faq-grid mb-0">
																	<div class="faq-header">
																		<a class="collapsed faq-collapse" data-bs-toggle="collapse" href="#collapseThree">
																			 <i class="fas fa-align-justify"></i> Hello World Project from GitHub
																		</a>
																		<div class="faq-right">
																			<a href="javascript:void(0);">
																				<i class="far fa-pen-to-square me-1"></i>
																			</a>
																			<a href="javascript:void(0);" class="me-0">
																				<i class="far fa-trash-can"></i>
																			</a>
																		</div>
																	</div>
																	<div id="collapseThree" class="collapse" data-bs-parent="#accordion">
																		<div class="faq-body">
																		  	<div class="add-article-btns">
																		  		<a href="javascript:void(0);" class="btn">Add Article</a>
																		  		<a href="javascript:void(0);" class="btn me-0">Add Description</a>
																		  	</div>
																		</div>
																	</div>
																</div>
															</div>
														</div>
													</div>
												</div>

<div class="form-group form-group-tagsinput">
															<label class="add-course-label">Price</label>
															<input type="text" data-role="tagsinput" class="input-tags form-control" name="html" value="jquery, bootstrap" id="html">
														</div>
														<div class="form-group mb-0">
															<label class="add-course-label">Price</label>
															<input type="text" class="form-control" placeholder="10.00">
														</div>
</script>
																
