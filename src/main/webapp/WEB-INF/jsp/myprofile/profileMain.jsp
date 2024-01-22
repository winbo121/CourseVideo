<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- kakao DAUM API 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.my-student-list ul li a:hover {
	border-bottom: 4px solid #1fa3f1;
}
.form-control:disabled,.form-control[readonly] {
    background-color: #fafafa;
    opacity: 1
}
</style>
<script>
$(document).ready (function(){
	
	<%-- 프로필 사진 업데이트 버튼  --%>
	$(".upload_toggle").on("click",function() {
		$("#imageArea").slideToggle();
	});
	
	<%-- 프로필 사진 수정  --%>

	<%-- 프로필 사진 삭제  --%>
	
	<%-- 숫자만 입력 가능 --%>
	$( "#phone, #age" ).on("keyup",  function( event ){
		 var value = 	$(this).val().replace(/[^0-9]/g,"");
		 $( this ).val( value );
	});
	
	<%-- 모달 액션 --%>
	// 강좌 검색
	$("#btn_modal_reset_password").on("click",function(){
		
		var remodal_element =  $('[data-remodal-id=repass]');
		
		var input_elements = $( remodal_element ).find("input:text, textarea");
		$( input_elements ).val("");

		<%-- RE MODAL OPEN 성공 이후 후처리 함수 --%>
		var open_succ_func = function(){
		};
		
		basicReModal = new BasicReModal();
		basicReModal._remodal_element = remodal_element;
		basicReModal._open_succ_func = open_succ_func;
		basicReModal.open();	
		
	});
	
	<%-- 회원정보 수정 버튼 --%>
	$("#btn_update_user").on("click",function(){
		<%--  더블 클릭 방지 --%>
		if(checkIsRun()) {
			return;
		}
		
		<%-- 유효성 체크 --%>
		var is_valid = $("#userInfo").valid();
		if( is_valid != true  ){
			
			<%-- 더블 클릭 방지 리셋 --%>
			resetIsRun();
			
			return;
		}
		
		var formdata = $("#userInfo")[0];
		var form_data = new FormData(formdata);
		
		var succ_func = function(resData, status ) {
			var result = resData.result;
			
			if(result == 'success') {
				var confirm_func = function() {
					location.href="/myprofile/profileMain/index.do";

				};					
				
				alert_success( "회원정보가 수정되었습니다.", confirm_func );
			} else {
				
				<%-- 더블 클릭 방지 리셋 --%>
				resetIsRun();
				
				alert_error( resData.msg, null );
			}
		};
		
		ajax_form_put("/myprofile/profileMain/update.do", form_data, succ_func);
		
	});	
	
	<%-- FORM VALIDATOR 초기화 --%>
	initFormValidator();
});
</script>
<script>
<%-- FORM  유효성 체크 --%>
var _form_validator = null;

<%-- FORM VALIDATOR 초기화  --%>
function initFormValidator(){
	
	<%-- VALIDATOR 대상 FORM  --%>
	var _form = $("#userInfo");
	
	

	
	/** 직업분류 체크  **/
	$.validator.addMethod("job",  function( value, element ) {
		var jobCode = [];
		<c:forEach var="job" items="${job_code}">
		jobCode.push("${job.code}");
		</c:forEach>
		return (jobCode.indexOf(value) != -1) && (value != "*");
	});

	var _form_rules = null;
	var _form_messages = null;
	
	_form_rules = {
			  /* ,user_name: { required:true } */
			 sido_code: { required:true }
			 ,sigungu_code: { required:true }
			 ,zip_code: { required:true }
			 ,user_addr: { required:true }
			 ,user_dtl_addr: { required:true }
			 ,phone: { phoneNumber:true }
			 ,gender: { required:true }
			 ,job_code: { job:true }
			 ,upload_files: { extension: 'jpg|png|gif'  }
		 };

		_form_messages = {
			job_code:{
				job:"직업분류를 선택해주세요."
			}
		};

	if( _form_validator != null ){
		_form_validator.settings.rules = _form_rules;
		_form_validator.settings.messages = _form_messages;
	}else{
		_form_validator = get_form_validator( _form, _form_rules, _form_messages   );
	}

}
</script>

			<!-- Student Header -->
			<%-- <jsp:include page="/WEB-INF/layout/common/mypageBanner.jsp" /> --%>
			<!-- /Student Header -->
						
			<!--Dashbord Student -->
			<div class="page-content">
				<div class="container">
					<div class="row">						
						<!-- Profile Details -->
						<form:form modelAttribute="userInfo" enctype="multipart/form-data" onsubmit="return false;">
						<form:hidden path="sido_code" data-valid-name="주소"/>
						<form:hidden path="sigungu_code" data-valid-name="주소"/>
						<div>	
							<div class="settings-widget profile-details">
								<div class="settings-menu p-0">
									<div class="checkout-form personal-address add-course-info">
										<div class="personal-info-head">
											<h4>회원정보</h4>
										</div>
										<div class="row">
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">아이디</label>
													<div><span>${userInfo.user_id}</span></div>
													<%-- <form:input path="user_id" class="form-control" placeholder="아이디" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">이름</label>
													<div><span>${userInfo.user_name}</span></div>
													<%-- <form:input path="user_name" class="form-control" placeholder="이름" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">권한</label>
													<div><span>${userInfo.role_type}</span></div>
													<%-- <form:input path="role_type" class="form-control" placeholder="권한" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">
														비밀번호
														<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" id="btn_modal_reset_password"><span>변경</span></button>
													</label>
													<div><span>*******</span></div>
													<%-- <form:input path="user_pw" class="form-control" placeholder="회원가입일시" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">회원가입일</label>
													<div><span>${userInfo.user_regist_dt}</span></div>
													<%-- <form:input path="user_regist_dt" class="form-control" placeholder="회원가입일시" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">최초접속일</label>
													<div><span>${userInfo.first_login_dt}</span></div>
													<%-- <form:input path="first_login_dt" class="form-control" placeholder="최초로그인일시" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">최근접속일</label>
													<div><span>${userInfo.last_login_dt}</span></div>
													<%-- <form:input path="last_login_dt" class="form-control" placeholder="최초로그인일시" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">이메일</label>
													<div><span>${userInfo.user_email}</span></div>
													<%-- <form:input path="user_email" class="form-control" placeholder="이메일" readonly="true"/> --%>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">
														우편번호
														<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" onclick="openDaumPostcode()"><span>변경</span></button>
													</label>
													<form:input path="zip_code" class="form-control" placeholder="우편번호" readonly="true" data-valid-name="우편번호"/>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">기본주소</label>
													<form:input path="user_addr" class="form-control" placeholder="기본주소" readonly="true" data-valid-name="기본주소"/>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">상세주소</label>
													<form:input path="user_dtl_addr" class="form-control" placeholder="상세주소" data-valid-name="상세주소"/>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">만 나이</label>
													<form:input path="age" type="number" class="form-control" placeholder="만 나이" min="1" max="200" data-valid-name="만 나이"/>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label class="form-control-label">휴대폰 번호</label>
													<form:input path="phone" class="form-control" placeholder="선택) 휴대폰 번호, 01000000000" maxlength="11" data-valid-name="휴대폰 번호"/>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label  class="form-label">성별</label>
													<form:select path="gender" class="form-select select country-select"  name="sellist1">
														<form:option value="1">남</form:option>
														<form:option value="2">여</form:option>
													</form:select>
												</div>
											</div>
											<div class="col-lg-6">
												<div class="form-group">
													<label  class="form-label">직업분류</label>
													<form:select path="job_code" class="form-select select country-select"  name="sellist1" data-valid-name="직업분류">
														<c:forEach items="${job_code}" var="code">
															<form:option value="${code.code}">${code.code_nm}</form:option>
														</c:forEach>
													</form:select>
												</div>
											</div>
										</div>
										<hr/>
										<div class="personal-info-head">
											<h4>프로필 사진</h4>
										</div>
										<div class="mb-0 d-flex">
											<div class="course-group-img d-flex align-items-center">
												<c:choose>
													<c:when test="${!empty userInfo.img_url}">
														<a href="javascript:void(0);"><img src="${userInfo.img_url}" style="width:100px;height:100px;" alt="" class="img-fluid"></a>
													</c:when>
													<c:otherwise>
														<a href="javascript:void(0);"><img src="/assets/img/instructor/ttl-stud-icon.png" style="width:100px;height:100px;" alt="" class="img-fluid"></a>
													</c:otherwise>
												</c:choose>
												
												<div class="course-name">
													<h4><a href="javascript:void(0);">프로필 사진(사이즈 100px X 100px)</a></h4>
													<p>프로필 사진 정보를 수정 할 수 있습니다.</p>
												</div>
											</div>
											<div class="profile-share d-flex align-items-center justify-content-center">
												<a href="javascript:;" class="btn btn-success upload_toggle">업데이트</a>
											</div>
										</div>
										<div class="course-group mb-0" id="imageArea" style="display:none;">
											<div class="add-course-form">
												<c:if test="${!empty userImg}">
													<div class="form-group">									
														<div class="relative-form">
															<span>
																<input type="hidden" name="file_seq" value="${userImg.file_seq}"/>
																<a href="javascript:fileDownload(${userImg.file_seq});" class="download">${userImg.orgin_filenm}.${userImg.file_ext}</a>
																<a href="javascript:void(0);" onclick="removeFile(this,${userImg.file_seq});" class="me-0"><i class="far fa-trash-can"></i></a>
															</span>
															<label class="relative-file-upload" style="color:#fff;">
																<spring:message code="button.upload"/>
																<input type="file" id="upload_files" name="upload_files" onchange="setThumbnail(this);" data-valid-name="프로필 사진"/>
															</label>
														</div>
													</div>
													<div class="form-group">
														<div class="add-image-box" id="thumbnailImage">
															<img src="${userImg.img_url}"/>
														</div>
													</div>
												</c:if>
												<c:if test="${empty userImg}">
													<div class="form-group">													
														<div class="relative-form">
															<span>등록된 프로필 사진이 없습니다.(등록 가능 확장자 jpg,png,gif)</span>
															<label class="relative-file-upload" style="color:#fff;">
																<spring:message code="button.upload"/> <input type="file" id="upload_files" name="upload_files" onchange="setThumbnail(this);"  data-valid-name="프로필 사진"/>
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
												<button type="button" href="javascript:;" class="btn btn-success upload_toggle">숨기기</button>
											</div>
										</div>
										<hr/>
										<div class="personal-info-head">
											<h4>소셜 연동</h4>
										</div>
										<div class="checkout-form personal-address secure-alert">
											<jsp:include page="../oAuth/myConn.jsp"/>
										</div>
									</div>
								</div>
							</div>
						</div>	
						</form:form>
						<!-- Profile Details -->
						<div class="update-profile">
							<button type="button" class="btn btn-primary" id="btn_update_user">회원정보 수정</button>
						</div>
					</div>
				</div>
			</div>	
			<!-- /Dashbord Student -->
			
<jsp:include page="modal/resetPassword.jsp"/>
			
<!-- 다음 API 호출 javascript -->
<script>
  function openDaumPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
    	$("#sido_code").val(data.sigunguCode.slice(0,2));
    	$("#sigungu_code").val(data.sigunguCode);
        $("#zip_code").val(data.zonecode);
        $("#user_addr").val(data.address);
        $("#user_dtl_addr").focus();
      }
    }).open();
  }
  
</script>

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
		}).appendTo($('#userInfo')[0]);
		$(this).remove();
	});
	
	reader.readAsDataURL(file);
	$(f).parent().prev().text(fileName);
	$('#delete_file_icon').tmpl().appendTo($(f).parent().prev());

}

<!-- 파일 다운로드 -->
function fileDownload( file_seq ){
	<%-- 파일 다운로드 성공시 실행되는 함수 --%>
	var succ_func = function( ){};
	<%-- 파일 다운로드 실패시 실행되는 함수 --%>
	var fail_func = function( ){};
	<%-- 파일 다운로드  --%>

	file_down( file_seq, succ_func, fail_func  );
}

<!-- 파일 삭제 -->
function removeFile(e, file_seq ) {
	
	if( file_seq != null ){
		var name ="del_files_seqs";

		$("<input></input>", {
			type : "hidden",
			name : name,
			value : file_seq
		}).appendTo($('#userInfo')[0]);
	}
	
	$("#upload_files").val('');
	$(e).parent().text("등록된 프로필 사진이 없습니다.(등록 가능 확장자 jpg,png,gif)");
	$("#thumbnailImage").empty();
	$("#empty_image_box").tmpl().appendTo($("#thumbnailImage"));
	


}
</script>

<script type="text/x-jquery-tmpl" id="delete_file_icon">
	<a href="javascript:void(0);" onclick="removeFile(this, null);" class="me-0"><i class="far fa-trash-can"></i></a>
</script>

<script type="text/x-jquery-tmpl" id="empty_image_box">
	<a href="javascript:void(0);"><i class="far fa-image"></i></a>
</script>