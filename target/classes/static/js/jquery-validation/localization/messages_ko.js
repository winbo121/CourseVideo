(function( factory ) {
	if ( typeof define === "function" && define.amd ) {
		define( ["jquery", "../jquery.validate"], factory );
	} else if (typeof module === "object" && module.exports) {
		module.exports = factory( require( "jquery" ) );
	} else {
		factory( jQuery );
	}
}

(function( $ ) {

/*
 * FORM VALIDATOR 설정
 */
$.validator.setDefaults({
	ignore: 'hidden',
    onkeyup:false,
    onclick:false,
    onfocusout:false,
    onsubmit: false,
    showErrors:function( errorMap, errorList ){
    	if( this.numberOfInvalids() ) {
			var element = errorList[0].element;
			var message = errorList[0].message;

			var valid_name =  $(element).attr("data-valid-name");
			if( !$.isEmptyObject( valid_name ) ){
				message = "("+valid_name+") " + message;
			}

			basicAlert = new BasicAlert();
			basicAlert._type = "warning";
			basicAlert._html = message;
			basicAlert._target_element = element;
			basicAlert.fire();

    	}
    }
});


/** 날짜형식 VALIDATION  **/
$.validator.addMethod("date",  function( value, element ) {
	if( !$.isEmptyObject( value ) ){
		value = value.replace(" ", "T");
	}
	return !/Invalid|NaN/.test( new Date( value ).toString() );
});

/** 날짜비교 VALIDATION **/
$.validator.addMethod("comparedate", function (value, element, param) {
	var param_value = $(param).val();
	if( !$.isEmptyObject( value ) ){
		value = value.replace(" ", "T");
	}
	if( !$.isEmptyObject( param_value ) ){
		param_value = param_value.replace(" ", "T");
	}
    var result = new Date( value ) > new Date( param_value) ? false : true;
    return result;
});

/** 날짜비교 VALIDATION **/
$.validator.addMethod("comparedate2", function (value, element, param) {
	var param_value = $(param).val();
	if( !$.isEmptyObject( value ) ){
		value = value.replace(" ", "T");
	}
	if( !$.isEmptyObject( param_value ) ){
		param_value = param_value.replace(" ", "T");
	}

    var result = new Date(value) >= new Date( param_value ) ? true : false;
    return result;
});

/** 사용자아이디 체크 **/
$.validator.addMethod("userId",  function( value, element ) {
	/** 영문 대.소문자, 숫자 _,-만 입력 가능하고 5에서 20자리 **/
	var userIdCheck = RegExp(/^[A-Za-z0-9_\-]{5,20}$/);
	return userIdCheck.test( value );
});

/** 문자열 빈값 체크 **/
$.validator.addMethod("notBlank",  function( value, element ) {
	/** 공백 제거 **/
	value = $.trim( value );
	
	return $.isEmptyObject( value ) ? false : true; 
});

/** 비밀번호 체크 **/
$.validator.addMethod("userPassword",  function( value, element ) {
	/** 영문, 숫자, 특수문자 조합으로 8~30자 **/
	var hangulcheck = RegExp(  /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/ );
	var empty = RegExp( /\s/ );

	if( hangulcheck.test( value ) ){
		return false;
	}
	if( empty.test( value ) ){
		return false;
	}
	var passwdCheck = RegExp( /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,30}$/ );
	return passwdCheck.test( value );
});

/** 폰넘버 체크(선택) **/
$.validator.addMethod("phoneNumber",  function( value, element ) {
	var phonNumberCheck = RegExp(/^(?:01[0179][0-9]{7,8}|)$/);
	return phonNumberCheck.test( value );
});

/** 값이 같은지 확인 **/
$.validator.addMethod("valueEqual", function(value, element, param) {
	  return value === param;
});


/** 비밀번호 체크 ( 8-30 자리가 아닌경우 ) **/
$.validator.addMethod("userPassword1",  function( value, element ) {
	/** 영문, 숫자, 특수문자 조합으로 8~30자 **/
	var hangulcheck = RegExp(  /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/ );
	var empty = RegExp( /\s/ );

	if( hangulcheck.test( value ) ){
		return false;
	}
	if( empty.test( value ) ){
		return false;
	}
	var passwdCheck = RegExp( /.{8,30}$/ );
	return passwdCheck.test( value );
});


/** 비밀번호 체크 ( 영문 특문 숫자 모두 빠진 경우 ) **/
$.validator.addMethod("userPassword2",  function( value, element ) {
	/** 영문 **/
	var engCheck = RegExp( /(?=.*[a-zA-Z])/ );
	/** 특문 **/
	var specialCharCheck = RegExp( /(?=.*[!@#$%^*+=-])/ );
	/** 숫자 **/
	var numCheck = RegExp( /(?=.*[0-9])/ );
	
	return engCheck.test( value ) || specialCharCheck.test( value ) || numCheck.test( value );
});


/** 비밀번호 체크 ( 특문 숫자 모두 빠진 경우 ) **/
$.validator.addMethod("userPassword3",  function( value, element ) {
	/** 특문 **/
	var specialCharCheck = RegExp( /(?=.*[!@#$%^*+=-])/ );
	/** 숫자 **/
	var numCheck = RegExp( /(?=.*[0-9])/ );
	
	return specialCharCheck.test( value ) || numCheck.test( value );
});


/** 비밀번호 체크 ( 영문 숫자 모두 빠진 경우 ) **/
$.validator.addMethod("userPassword4",  function( value, element ) {
	/** 영문 **/
	var engCheck = RegExp( /(?=.*[a-zA-Z])/ );
	/** 숫자 **/
	var numCheck = RegExp( /(?=.*[0-9])/ );
	
	return engCheck.test( value ) || numCheck.test( value );
});


/** 비밀번호 체크 ( 영문 특문 모두 빠진 경우 ) **/
$.validator.addMethod("userPassword5",  function( value, element ) {
	/** 영문 **/
	var engCheck = RegExp( /(?=.*[a-zA-Z])/ );
	/** 특문 **/
	var specialCharCheck = RegExp( /(?=.*[!@#$%^*+=-])/ );
	
	return engCheck.test( value ) || specialCharCheck.test( value );
});


/** 비밀번호 체크 ( 숫자만 빠진 경우 ) **/
$.validator.addMethod("userPassword6",  function( value, element ) {
	/** 숫자 **/
	var numCheck = RegExp( /(?=.*[0-9])/ );
	
	return numCheck.test( value );
});


/** 비밀번호 체크 ( 특문만 빠진 경우 ) **/
$.validator.addMethod("userPassword7",  function( value, element ) {
	/** 특문 **/
	var specialCharCheck = RegExp( /(?=.*[!@#$%^*+=-])/ );
	
	return specialCharCheck.test( value );
});


/** 비밀번호 체크 ( 영문만 빠진 경우 ) **/
$.validator.addMethod("userPassword8",  function( value, element ) {
	/** 영문 **/
	var engCheck = RegExp( /(?=.*[a-zA-Z])/ );
	
	return engCheck.test( value );
});

/*
 * Translated default messages for the jQuery validation plugin.
 * Locale: KO (Korean; 한국어)
 */
$.extend( $.validator.messages, {
	required: "필수 항목입니다.",
	remote: "항목을 수정하세요.",
	email: "유효하지 않은 E-Mail주소입니다.",
	url: "유효하지 않은 URL입니다.",
	date: "올바른 날짜를 입력하세요.",
	dateISO: "올바른 날짜(ISO)를 입력하세요.",
	number: "유효한 숫자가 아닙니다.",
	digits: "숫자만 입력 가능합니다.",
	creditcard: "신용카드 번호가 바르지 않습니다.",
	equalTo: "같은 값을 다시 입력하세요.",
	extension: "올바른 확장자가 아닙니다.",
	maxlength: $.validator.format( "{0}자를 넘을 수 없습니다. " ),
	minlength: $.validator.format( "{0}자 이상 입력하세요." ),
	rangelength: $.validator.format( "문자 길이가 {0} 에서 {1} 사이의 값을 입력하세요." ),
	range: $.validator.format( "{0} 에서 {1} 사이의 값을 입력하세요." ),
	max: $.validator.format( "{0} 이하의 값을 입력하세요." ),
	min: $.validator.format( "{0} 이상의 값을 입력하세요." ),
	comparedate: "시작날짜가 종료날짜보다 클수 없습니다.",
	comparedate2: "종료날짜가 시작날짜보다 작을수 없습니다.",
	userId: "사용자 아이디 형식이 유효하지않습니다.<br> 영문 대/소문자, 숫자, <br> 일부 특수문자(_,-)만 입력 가능하고 <br> 5에서 20자리이여야 합니다.",
	userPassword: "비밀번호 형식이 유효하지 않습니다.",
	phoneNumber: "핸드폰 번호형식이 유효하지 않습니다.",
	valueEqual: "값이 동일하지 않습니다.",
	notBlank: "공백이 아닌 문자를 반드시 포함해서 입력해 주세요.",
	userPassword1: "영문, 특수 문자, 숫자가 <br> 모두 포함된 8~30자로 <br> 입력해 주셔야 합니다.",
	userPassword2: "영문, 특수 문자, 숫자가 누락되었습니다.",
	userPassword3: "특수 문자, 숫자가 누락되었습니다.",
	userPassword4: "영문, 숫자가 누락되었습니다.",
	userPassword5: "영문, 특수 문자가 누락되었습니다.",
	userPassword6: "숫자가 누락되었습니다.",
	userPassword7: "특수 문자가 누락되었습니다.",
	userPassword8: "영문이 누락되었습니다."

} );

return $;
}));