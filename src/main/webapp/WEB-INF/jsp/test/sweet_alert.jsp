<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<title></title>
<script type="text/javascript" >
$(document).ready (function(){
	<%-- 잘못된 비밀번호 입력시 --%>
	var wrong_password = function(){
		alert("비밀번호 틀림");
	};
	<%-- 맞는 비밀번호 입력시  --%>
	var right_password = function(){
		alert("비밀번호 맞음");
	};
	<%-- 비밀번호 --%>
	var meta_password = "123456";
	 Swal.fire( {
   		 title: '비밀번호를 입력해 주세요',
		    input: "text",
	        inputValue: "",
		    allowOutsideClick: false,
		    confirmButtonText: "확인",
		    cancelButtonText: "취소",
		    showCancelButton: true,
		    inputValidator: function( value ){
		    	var value = $.trim( value );
		    	if( value == "" ){
		    		return '비밀번호를 입력하지 않았습니다!'
		    	}
		    	if( value != meta_password ){
		    		wrong_password();
		    		return "비밀번호가 틀렸습니다.!";
		    	}
		    	right_password();
		    }
	 }).then( function ( result ) {
	 });
	<%-- SIMPLE ALERT 샘플 --%>
	$( "#table_simple_alert > tbody" ).on( "click", "a", function(){
		 <%-- 내용이 없을경우 내용이 출력되지 않는다. --%>
		 var html = "내용 </br> 줄바꿈";
		 <%-- 확인버튼 클릭이후 후처리 함수 --%>
		 var confirm_func = function(){
			alert("SIMPLE ALERT 확인버튼 클릭후 함수 실행");
		 };
		 var text = $( this ).text();
		 if( text == "SUCCESS"  ){
			 alert_success( html, confirm_func );
		 }else if( text == "WARNING" ){
			 alert_warning( html, confirm_func );
		 }else if( text == "ERROR" ){
			 alert_error( html, confirm_func );
		 }else if( text == "INFO" ){
			 alert_info( html, confirm_func );
		 }
	});
	<%-- SIMPLE CONFIRM 샘플 --%>
	$( "#table_simple_confirm > tbody" ).on( "click", "a", function(){
		 <%-- 내용이 없을경우 내용이 출력되지 않는다. --%>
		 var html = "내용 </br> 줄바꿈";
		 <%-- 확인버튼 클릭이후 후처리 함수 --%>
		 var confirm_func = function(){
			alert("SIMPLE CONFIRM 확인버튼 클릭후 함수 실행");
		 };
		 <%-- 취소버튼 클릭이후 후처리 함수 --%>
		 var cancel_func = function(){
			 alert("SIMPLE CONFIRM 취소버튼 클릭후 함수 실행");
		 };
		 var text = $( this ).text();
		 if( text == "SUCCESS"  ){
			 confirm_success( html, confirm_func, cancel_func  );
		 }else if( text == "WARNING" ){
			 confirm_warning( html, confirm_func, cancel_func  );
		 }else if( text == "ERROR" ){
			 confirm_error( html, confirm_func, cancel_func  );
		 }else if( text == "INFO" ){
			 confirm_info( html, confirm_func, cancel_func  );
		 }
	});
	<%-- CUSTOM SWEET ALERT and CONFIRM 샘플 --%>
	$( "#table_sweet_alert > tbody" ).on( "click", "a", function(){
		 var text = $( this ).text();
		 if( text == "ALERT"  ){
			 var basicAlert = new BasicAlert();
			 basicAlert._type = "success";	<%-- success,warning,error,info 이외의 것이면 아이콘이 출력되지 않는다.  --%>
			 basicAlert._title = "ALERT 제목"  <%-- 제목이 없을경우 제목이 출력되지 않는다. --%>
			 basicAlert._html = "내용 </br> 줄바꿈 <input type='text' />  "; <%-- 내용이 없을경우 내용이 출력되지 않는다. --%>
			 basicAlert._confirm_text = "확인버튼TXT"; <%-- 확인 버튼 TEXT --%>
			 basicAlert._confirm_func =  function(){  return false;  }; <%-- 확인버튼 클릭이후 후처리 함수 --%>
			 basicAlert._target_element = $("#focus_element"); <%-- 창닫힌 이후 FOCUS 대상 객체  --%>
			 <%-- ALERT 실행  --%>
			 basicAlert.fire();
		 }else if( text == "CONFIRM" ){
			 var basicConfirm = new BasicConfirm();
			 basicConfirm._type = "success";	<%-- success,warning,error,info 이외의 것이면 아이콘이 출력되지 않는다.  --%>
			 basicConfirm._title = "CONFIRM 제목"  <%-- 제목이 없을경우 제목이 출력되지 않는다. --%>
			 basicConfirm._html = "내용 </br> 줄바꿈"; <%-- 내용이 없을경우 내용이 출력되지 않는다. --%>
			 basicConfirm._confirm_text = "확인버튼TXT"; <%-- 확인 버튼 TEXT --%>
			 basicConfirm._confirm_func =  function(){  alert( "확인 버튼클릭후 함수"  );  }; <%-- 확인버튼 클릭이후 후처리 함수 --%>
			 basicConfirm._cancel_text = "취소버튼TXT"; <%-- 취소 버튼 TEXT --%>
			 basicConfirm._cancel_func =  function(){  alert( "취소 버튼클릭후 함수"  );  }; <%-- 확인버튼 클릭이후 후처리 함수 --%>
			 basicConfirm._target_element = $("#focus_element"); <%-- 창닫힌 이후 FOCUS 대상 객체  --%>
			 <%-- CONFIRM 실행  --%>
			 basicConfirm.fire();
		 }
	});
});
</script>
</head>

<body>
<br/><br/>
<div style="border-style: solid">
<table id="table_simple_alert" border="1">
	<thead>
		<tr>
			<td colspan="4" align="center">
				<b>SIMPLE SWEET ALERT</b>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td> <a href="javascript:void(0);" >SUCCESS</a> </td>
			<td> <a href="javascript:void(0);" >WARNING</a></td>
			<td> <a href="javascript:void(0);" >ERROR</a></td>
			<td> <a href="javascript:void(0);" >INFO</a></td>
		</tr>
	</tbody>
</table>
</div>

<br/><br/>
<div style="border-style: solid">
<table id="table_simple_confirm" border="1">
	<thead>
		<tr>
			<td colspan="4" align="center">
				<b>SIMPLE SWEET CONFIRM</b>
			</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td> <a href="javascript:void(0);" >SUCCESS</a> </td>
			<td> <a href="javascript:void(0);" >WARNING</a></td>
			<td> <a href="javascript:void(0);" >ERROR</a></td>
			<td> <a href="javascript:void(0);" >INFO</a></td>
		</tr>
	</tbody>
</table>
</div>


<br/><br/>
<div style="border-style: solid">
	<input type="text" id="focus_element" >

	<table id="table_sweet_alert" border="1">
		<thead>
			<tr>
				<td colspan="2" align="center">
					<b>CUSTOM SWEET ALERT and CONFIRM </b>
				</td>
			</tr>
		</thead>
	<tbody>
		<tr>
			<td> <a href="javascript:void(0);" >ALERT</a> </td>
			<td> <a href="javascript:void(0);" >CONFIRM</a></td>
		</tr>
	</tbody>
	</table>
</div>

</body>

</html>