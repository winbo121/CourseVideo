<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>
<!-- kakao DAUM API 추가 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript" >
$(document).ready (function(){
	
	
	<%-- 인증코드 확인 버튼 클릭시 --%>
	$("#btn_code_duplicate_check").on( "click", function(){
		
		var at_code = $( "#at_code" ).val();
		var email = $( "#email" ).val();
		
		<%-- 인증코드 체크 --%>
		var action = "/code_duplicate_check.do";
		var json = { "at_code" : at_code, "email" : email};
		
		var succ_func = function( resData, status ){
			var isCodeYn = resData.isCodeYn;
			
			<%-- 이미 사용중일 경우 --%>
			if( isCodeYn == false ) {
				alert_warning( "인증코드가 다릅니다. 인증코드를 다시 확인하십시요.", null );
				return false;
			}
			
			$("#at_code").prop("readonly",true);
			$("#btn_code_duplicate_check").prop('disabled', true);
			$("#is_code_duplicate_check").val( "Y" );
			
			alert_success( "올바른 이메일 인증코드 입니다.", null );
		}
		
		ajax_json_get( action, json, succ_func );
		
		
	});
	
	
	<%-- 아이디 중복 체크 버튼 클릭시 --%>
	$("#btn_id_duplicate_check").on( "click", function(){
		
		var user_id = $( "#user_id" ).val();
		$("#chk_id").val(user_id);
		var chk_id = $( "#user_id" ).val();
		var userIdCheck = RegExp(/^[A-Za-z0-9_\-]{5,20}$/);
		
		var is_valid = userIdCheck.test( user_id );
		if( is_valid != true ) {
			
			alert_warning( "(아이디) 사용자 아이디 형식이 유효하지않습니다.<br> 영문 대/소문자, 숫자, <br> 일부 특수문자(_,-)만 입력 가능하고 <br> 5에서 20자리이여야 합니다.", null );
			return;
		}
		
		
		<%-- 아이디 중복 체크 --%>
		var action = "/id_duplicate_check.do";
		var json = { "user_id" : user_id, "chk_id" : chk_id };
		
		var succ_func = function( resData, status ){
			var is_already_user_id = resData.isAlreadyUserId;
			
			<%-- 이미 사용중일 경우 --%>
			if( is_already_user_id == true ) {
				alert_warning( "이미 사용중인 아이디입니다.", null );
				return false;
			}
			
			$("#user_id").prop("readonly",true);
			$("#btn_id_duplicate_check").prop('disabled', true);
			$("#is_id_duplicate_check").val( "Y" );
			
			alert_success( "사용 가능한 아이디입니다.", null );
		}
		
		ajax_json_get( action, json, succ_func );
	});
	
	
	
	<%-- form submit  --%>
	$("#signup").submit(function() {
		return false;
	});

	<%-- 계정 생성 버튼 클릭시 --%>
	$("#btn_join_submit").on( "click", function( event ){
		event.preventDefault();


		<%-- 유효성 체크 --%>
		var is_valid = $("#signup").valid();
		if( is_valid != true  ){
			return;
		}


		var form = $("#signup")[0];
		var form_data = new FormData( form );

		var action = "/signup.do";
		<%-- AJAX 후처리 함수 (HTTP STATUS 200 인경우만 동작한다.)  --%>
		var succ_func = function( resData, status ){
			
			var move_func = function() {
				<%-- 로그인 페이지로 이동 --%>
				move_get( "/", null );
			}
			
			<%-- 회원가입 성공 알림 문구 --%>
			alert_success( "회원가입이 완료되었습니다.", move_func );

		};
		<%-- AJAX FORM DATA POST 전송 --%>
		ajax_form_post( action, form_data,  succ_func );

	});


	<%-- 비밀번호 보기 --%>
	$("#btn_show_user_pw").on( "click", function( event ){
		event.preventDefault();
		if( $("#user_pw").val() != "" ){
			$("#user_pw").attr("type", "text");
	 		 setTimeout(
			 			function() {
			 				$("#user_pw").attr("type", "password");
			 			}
			 			,4000
				     );
		}
	});

	<%-- 비밀번호 확인 보기 --%>
	$("#btn_show_user_pw_confirm").on( "click", function( event ){
		event.preventDefault();
		if( $("#user_pw_confirm").val() != "" ){
			$("#user_pw_confirm").attr("type", "text");
	 		 setTimeout(
			 			function() {
			 				$("#user_pw_confirm").attr("type", "password");
			 			}
			 			,4000
				     );
		}
	});

	<%-- 숫자만 입력 가능 --%>
	$( "#sch_class, #phone, #age" ).on("keyup",  function( event ){
		 var value = 	$(this).val().replace(/[^0-9]/g,"");
		 $( this ).val( value );
	});
	

	$("#btn_toggle").click(function (){
		if( $(this).is(":checked") ){
			$("#sch_grade").attr("disabled","disabled");
			$("#sch_class").attr("disabled","disabled");
			$("#role_type").val("ROLE_INSTRUCTOR");
		} else {
			$("#sch_grade").removeAttr("disabled");
			$("#sch_class").removeAttr("disabled");
			$("#role_type").val("ROLE_TEACHER");
		}
	});

	<%-- 로그인 링크 클릭시 --%>
	$("._2HSkKzK52EGNdMxxw32hwS").on( "click", function(){
		move_get( "/login/loginMain/index.do", null );
	});

	<%-- FORM VALIDATOR 초기화 --%>
	initFormValidator();

});


<%-- FORM  유효성 체크 --%>
var _form_validator = null;

<%-- FORM VALIDATOR 초기화  --%>
function initFormValidator(){
	<%-- VALIDATOR 대상 FORM  --%>
	var _form = $("#signup");
	var role_type = $("#role_type").val();

	var _form_rules = null;
	var _form_messages = null;
	
	/** 직업분류 체크  **/
	$.validator.addMethod("job",  function( value, element ) {
		var jobCode = [];
		<c:forEach var="job" items="${job_code}">
		jobCode.push("${job.code}");
		</c:forEach>
		return (jobCode.indexOf(value) != -1) && (value != "*");
	});

	if( role_type == "ROLE_USER" ){
		<%-- 일반회원 --%>
		_form_rules = {
				  email: { required:true ,email:true }
				 ,is_certification_email: { valueEqual: "Y" }
				 ,is_id_duplicate_check: { valueEqual: "Y" }
				 ,is_code_duplicate_check: { valueEqual: "Y" }
				 ,user_id: { required:true, userId:true }
				 ,user_name: { required:true }
				 ,user_pw: { required:true, userPassword1:true
					 						, userPassword2:true
					 						, userPassword3:true
					 						, userPassword4:true
					 						, userPassword5:true
					 						, userPassword6:true
					 						, userPassword7:true
					 						, userPassword8:true }
				 ,user_pw_confirm: { required:true , equalTo: 'input[name=user_pw]'  }
				 ,sido_code: { required:true }
				 ,sigungu_code: { required:true }
				 ,zip_code: { required:true }
				 ,user_addr: { required:true }
				 ,user_dtl_addr: { required:true }
				 ,phone: { phoneNumber:true }
				 ,gender: { required:true }
				 ,job_code: { job:true }
			 };
	
			_form_messages = {
				user_pw_confirm:{
					equalTo: '비밀번호와 같아야합니다.'
				}
				,is_certification_email: {
					valueEqual: "이메일 인증을 하지 않았습니다."
				}
				,is_id_duplicate_check: {
					valueEqual: "아이디 중복체크를 하지 않았습니다."
				}
				,is_code_duplicate_check: {
					valueEqual: "이메일 인증코드를 확인 하지 않았습니다."
				}
				,job_code:{
					job:"직업분류를 선택해주세요."
				}
			};
		
	} 

	if( _form_validator != null ){
		_form_validator.settings.rules = _form_rules;
		_form_validator.settings.messages = _form_messages;
	}else{
		_form_validator = get_form_validator( _form, _form_rules, _form_messages   );
	}

}

</script>

<link rel="stylesheet" href="<c:url value='/styles/bootstrap.min.css'/>" >
<link rel="stylesheet" href="<c:url value='/styles/login.css'/>">

<div id="app">
	<section class="_1DWYPoRL0QljP7xf5wZdtW">
	
	<form:form modelAttribute="signup">
		<form:hidden path="role_type"/>
		<form:hidden path="terms_yn"/>
		<form:hidden path="consent_yn"/>
		<form:hidden path="is_certification_email"/>
		<form:hidden path="is_id_duplicate_check"/>
		<form:hidden path="is_code_duplicate_check"/>
		<form:hidden path="sido_code"/>
		<form:hidden path="sigungu_code"/>

		<div class="UoHqaUkevwrvJbwERySSt">
			<div class="_38wHjPwZlDoJPr9W-xySh _11sHgd9B8OCSX70aYZL0wk">
					LMS 회원 가입
			</div>
		</div>
		
		<div class="mt20">
			<div class="form-control-lg"> * 필수 사항 정보</div>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="email" placeholder="이메일"  autocomplete="off" cssClass="form-control-lg form-control"
								   data-valid-name="이메일" readonly="true"  />
				</div>
			</div>
			
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="at_code"  placeholder="이메일 인증코드"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="인증코드"  />
					<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" id="btn_code_duplicate_check"><span>인증코드 확인</span></button>
				</div>
			</div>
			

			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="user_id"  placeholder="아이디"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="아이디"  />
								   <input type="hidden" id="chk_id">
					<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" id="btn_id_duplicate_check"><span>중복 체크</span></button>
				</div>
			</div>

			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="user_name" placeholder="이름"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="이름"  />
				</div>
			</div>

			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="Es498bW0OPfYz5F7XmHWV ">
					<form:password path="user_pw"  placeholder="비밀번호 (영문, 숫자, 특수 문자 8-30자)" maxlength="30" cssClass="form-control-lg form-control" aria-autocomplete="list"
										   data-valid-name="비밀번호" />
					<button id="btn_show_user_pw" class="LdqxyFhZIIyIVWZ_NGKj_" tabindex="-1">
						<img src="/styles/passwordViewOff.svg"/></button>
				</div>
			</div>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="Es498bW0OPfYz5F7XmHWV ">
					<form:password path="user_pw_confirm"  placeholder="비밀번호 확인" maxlength="30" cssClass="form-control-lg form-control"
										 data-valid-name="비밀번호 확인"  />
					<button id="btn_show_user_pw_confirm" class="LdqxyFhZIIyIVWZ_NGKj_" tabindex="-1">
						<img src="/styles/passwordViewOff.svg"/></button>
				</div>
			</div>
			
			<%-- 우편번호(검색버튼) --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="zip_code"  placeholder="우편번호"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="우편번호" readonly="true" />
					<button type="button" class="_2z4R_Nq-StthNLprI-eA1f btn btn-primary btn-sm" onclick="openDaumPostcode()"><span>주소 검색</span></button>
				</div>
			</div>
			
			<%-- 우편번호(기본주소) --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="user_addr"  placeholder="기본주소"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="기본주소" readonly="true" />
				</div>
			</div>
			
			<%-- 우편번호(상세주소) --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="user_dtl_addr"  placeholder="상세주소"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="상세주소"  />
				</div>
			</div>
			
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:select path="gender" class="form-control-lg form-control">
					    <option selected>성별 </option>
					    <option value="1">남자</option>
					    <option value="2">여자</option>
					</form:select>
				</div>
			</div>
			
			<%-- 나이 --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="age" type="number"  placeholder="만 나이"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="만 나이" min="1" max="200" />
				</div>
			</div>
			
			<%-- 직업분류 --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:select path="job_code" class="form-control select" data-valid-name="직업분류">
						<c:forEach items="${job_code}" var="code">
							<form:option value="${code.code}">${code.code_nm}</form:option>
						</c:forEach>
					</form:select>
				</div>
			</div>
			
			<hr class="mt20 mb20"/>
			<div class="form-control-lg">선택 사항 정보</div>	
				
			<%-- 휴대폰번호(선택) --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<form:input path="phone" placeholder="휴대폰 번호, 01000000000"  autoComplete="off"  cssClass="form-control-lg form-control"
								   data-valid-name="휴대폰 번호" maxlength="11" />
				</div>
			</div>		
								
			<%-- 소셜 로그인 --%>
			<div class="_3r8UdvnjCUKW78BTIsh43f">
				<div class="_1SEj5DUSRdWttGiLyovDY0">
					<jsp:include page="oAuth/joinConn.jsp"/>
				</div>
			</div>
			
			

			<button type="button" class="_1AX8pEa7feGCxcY5g5z5KN btn btn-primary btn-lg btn-block mt50" id="btn_join_submit">
				<span class="Tmopq5aSmHQftHmuZSsAd">
					<span class="_1lMForvxbNw3au4JG5jdB9"><span>계정 생성</span></span>
				</span>
			</button>

			<div class="Khgcot06J7xIcqTkU4kzX _38xG3sOUag2Xj5TM649sAw">
				<span>이미 계정이 있으세요?</span>
				<a class="_2HSkKzK52EGNdMxxw32hwS" href="javascript:void(0);"><span>로그인</span></a></div>
			</div>

			<p class="_2d-xByT7Z84eA5s0I_vt_e USormlxqXIIh6_cCv9jhX">
				<span>CopyRightⓒ2021 All Rights Reserved.
				</span>
				<a href="/"><span style="color : red;"> 홈으로가기</span></a>
			</p>
	</form:form>
	</section>
</div>


<script type="text/javascript" >
$(document).ready (function(){
	<%-- 학교 검색 모달 버튼 클릭시 --%>
	$("#btn_school_certification").click(function( event ){
		event.preventDefault();

		<%-- 미리지정된 함수 --%>
		var appoint_function = eval( "appoint_school_remodal_open_function" );

		if( $.isFunction( appoint_function ) ){
			appoint_function();
		}else{
			alert("학교 검색 모달 함수가 지정되지 않음.");
		}

	});
});


</script>

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



