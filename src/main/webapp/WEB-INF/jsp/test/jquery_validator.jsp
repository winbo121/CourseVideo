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
	<%-- form submit --%>
	$("#jqueryValidator").submit(function() {
		return false;
	});

	<%-- 초기화 버튼 클릭시 --%>
	$("#btn_init").click(function(){
		$("#jqueryValidator")[0].reset();
	});

	<%-- 유효성 체크 버튼 클릭시 --%>
	$("#btn_validate").click(function(){
		<%-- 유효성 체크 --%>
		var is_valid = $("#jqueryValidator").valid();

		if( is_valid != true  ){
			return;
		}
		alert_success(  "유효성 체크 성공", null );
	});

	<%-- FORM VALIDATOR 초기화 --%>
	initFormValidator();

});

<%-- FORM VALIDATOR 초기화  --%>
function initFormValidator(){
	<%-- VALIDATOR 대상 FORM  --%>
	var _form = $("#jqueryValidator");

	<%-- FORM 항목에 대한 RULES  --%>
	var _form_rules = {  param1: { required:true }
							 ,param2: { required:true ,email:true }
							 ,param3: { required:true ,url:true }
							 ,param4: { required:true ,date:true }
							 ,param5: { required:true ,number:true }
							 ,param6: { required:true ,digits:true }
							 ,param7: { required:true ,maxlength:[3] }
							 ,param8: { required:true ,minlength:[3] }
							 ,param9: { required:true ,rangelength:[3,5] }
							 ,param10: { required:true ,digits:true ,range:[0,10] }
							 ,param11: { required:true ,digits:true ,max:10 }
							 ,param12: { required:true ,digits:true ,min:10 }
							 ,equal1: { required:true }
							 ,equal2: { required:true , equalTo: 'input[name=equal1]'  }

							 ,startDate: { required:true , date:true ,comparedate: '#endDate'  }
							 ,endDate: { required:true , date:true  }


							 ,startDateTime: { required:true , date:true ,comparedate: '#endDateTime'  }
							 ,endDateTime: { required:true , date:true  }

							 ,testFile: { required:true , extension: 'jpg|png|gif'  }
						  };

	<%-- FORM 오류 발생시 메세지 없는경우 comJs.jsp 에 설정된 기분 항목들 --%>
	var _form_messages = {
			equal2:{
				equalTo: '이퀄스1과 같은 값이어야합니다.'
			}
			,testFile: { extension: '이미지 파일만 가능합니다.'  }
	};

	<%-- FORM VALIDATOR 생성   --%>
	var _form_validator = get_form_validator( _form, _form_rules, _form_messages   );
	<%-- FORM VALIDATOR 의 RULES, MESSAGE, SUBMIT HANDLER 변경시 아래와같이 처리
			_form_validator.settings.rules = null;
			_form_validator.settings.messages = null;
			_form_validator.settings.submitHandler = null;

			console.log( _form_validator.settings.submitHandler );
	--%>

}

</script>
</head>

<body>

<br/><br/><br/><br/>
<button id="btn_init" type="button" >
	<i class="fas fa-redo"></i> FORM 초기화
</button>


<button id="btn_validate" type="button" >
	<i class="fas fa-redo"></i> FORM 유효성체크
</button>


<form:form modelAttribute="jqueryValidator" >
	파람1 required:필수
<br>
	param1: { required:true }
<br>
	<form:input  path="param1" id="a"
					data-valid-name="파람1"  />

<br/>
	===========================================================================================
<br/>
   파람2 required:필수 email:이메일 형식
<br>
   param2: { required:true ,email:true }

<br>
	<form:input  path="param2"
					data-valid-name="파람2"  />
<br/>
	===========================================================================================
<br/>
   파람3 required:필수 url:URL 형식
<br>
   param3: { required:true ,url:true }

<br>
	<form:input  path="param3"
					data-valid-name="파람3"  />
<br/>
	===========================================================================================
<br/>
   파람4 required:필수 date: 날짜형식
<br>
   param4: { required:true ,date:true }

<br>
	<form:input  path="param4"
					data-valid-name="파람4"  />
<br/>
	===========================================================================================
<br/>
   파람5 required:필수 number:숫자형식 (음수,소수점가능)
<br>
   param5: { required:true ,number:true }

<br>
	<form:input  path="param5"
					data-valid-name="파람5"  />
<br/>
	===========================================================================================
<br/>
   파람6 required:필수 digits:숫자형식 (양수)
<br>
   param6: { required:true ,digits:true }

<br>
	<form:input  path="param6"
					data-valid-name="파람6"  />
<br/>
	===========================================================================================
<br/>
   파람7 required:필수 maxlength:문자열의 최대길이
<br>
   param7: { required:true ,maxlength:[3] }

<br>
	<form:input  path="param7"
					data-valid-name="파람7"  />
<br/>
	===========================================================================================
<br/>
   파람8 required:필수 minlength:문자열의 최소길이
<br>
   param8: { required:true ,minlength:[3] }

<br>
	<form:input  path="param8"
					data-valid-name="파람8"  />
<br/>
	===========================================================================================
<br/>
   파람9 required:필수 rangelength:문자열의 길이 범위 지정
<br>
   param9: { required:true ,rangelength:[3,5] }
<br>
	<form:input  path="param9"
					data-valid-name="파람9"  />
<br/>
	===========================================================================================
<br/>
   파람10 required:필수 digits:숫자형식 range:사이의값
<br>
   param10: { required:true ,digits:true ,range:[0,10] }
<br>
	<form:input  path="param10"
					data-valid-name="파람10"  />
<br/>
	===========================================================================================
<br/>
   파람11 required:필수 digits:숫자형식 max:최대값
<br>
   param11: { required:true ,digits:true ,max:10 }
<br>
	<form:input  path="param11"
					data-valid-name="파람11"  />
<br/>
	===========================================================================================
<br/>
   파람12 required:필수 digits:숫자형식 min:최소값
<br>
   param12: { required:true ,digits:true ,min:10 }
<br>
	<form:input  path="param12"
					data-valid-name="파람12"  />
<br/>
	===========================================================================================
<br/>
   이퀄스1 required:필수
<br>
   equal1: { required:true }
<br>
	<form:input  path="equal1"
					data-valid-name="이퀄스1"  />
<br/>
	===========================================================================================
<br/>
   이퀄스2 required:필수 equalTo:같은값인지 체크( ex: #equal1 ID로 접근 input[name=equal1] NAME 으로 접근 )
<br>

   equal2: { required:true , equalTo: 'input[name=equal1]'  }
<br>
	<form:input  path="equal2"
					data-valid-name="이퀄스2"  />
<br/>
	===========================================================================================
<br/>
    startDate required:필수 date:날짜형식
<br/>
    endDate required:필수 date:날짜형식 comparedate:날짜비교
<br/>
   startDate: { required:true , date:true ,comparedate: '#endDate'  }

   endDate: { required:true , date:true  }

<br/>
           <form:input path="startDate"  class="flatpickr flatpickr-without-time"
           		data-valid-name="시작일자"/>
           ~
           <form:input path="endDate"  class="flatpickr flatpickr-without-time"
           		data-valid-name="종료일자"/>
<br/>


	===========================================================================================
<br/>
    startDateTime required:필수 date:날짜형식
<br/>
    endDateTime required:필수 date:날짜형식 comparedate:날짜비교
<br/>
   startDateTime: { required:true , date:true ,comparedate: '#endDate'  }

   endDateTime: { required:true , date:true  }

<br/>
           <form:input path="startDateTime"  data-valid-name="시작시간"/>
           ~
           <form:input path="endDateTime"  data-valid-name="종료시간"/>
<br/>


	===========================================================================================
<br/>
   확장자 required:필수 extension : 파일의 확장자 체크
<br>

   testFile: { required:true , extension: 'jpg|png|gif'  }
<br>
	<input type="file" name="testFile" data-valid-name="테스트파일" />
<br/>

<br/>
<br/>


</form:form>

</body>

</html>



