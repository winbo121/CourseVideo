<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="kb" uri="/WEB-INF/tlds/kotechLMS.tld"%>

<script type="text/javascript" >
$(document).ready (function(){
	<%-- 세부 정보 입력으로 진행 버튼 클릭시 --%>
	$("#btn_next_step").on( "click", function( event ){
		event.preventDefault();

		var terms_yn = $("#signup input[name=terms_yn]:checked").val();
		var consent_yn = $("#signup input[name=consent_yn]:checked").val();
		if( terms_yn != "Y" ){
			var html = "이용 약관 동의는 필수입니다. <br/> 동의하여 주세요.";
			<%-- 확인버튼 클릭이후 후처리 함수 --%>
			var confirm_func = function(){
				 $("#signup input[name=terms_yn]").focus();
			};
			alert_warning( html, confirm_func );
			return;
		}

		if(  $.isEmptyObject( consent_yn ) ){
			var html = "개인정보 수집 및 이용 동의를 선택하여 주세요.";
			<%-- 확인버튼 클릭이후 후처리 함수 --%>
			var confirm_func = function(){
				 $("#signup input[name=consent_yn]").focus();
			};
			alert_warning( html, confirm_func );
			return;
		}

		
		var form_data = new FormData( $("#signup")[0] );
		
		var role_type = $( "#role_type" ).val();
		
		
		if( role_type == "ROLE_USER" ) { 
			var url = "authentification_page.do"; 
			move_post( url, form_data ); 
		}
		

	})
});
</script>

<link rel="stylesheet" href="<c:url value='/styles/bootstrap.min.css'/>" >
<link rel="stylesheet" href="<c:url value='/styles/login.css'/>">

<div id="app">
	<section class="_1DWYPoRL0QljP7xf5wZdtW">
	<form:form modelAttribute="signup">
		<form:hidden path="role_type"/>
		<kb:isProfile target_profiles="local"> <%-- 로컬환경, 개발환경에서만 출력 --%>
			 <form:hidden path="profile" value="local"/>
		</kb:isProfile>
		<kb:isProfile target_profiles="dev"> <%-- 개발환경에서만 출력 --%>
			 <form:hidden path="profile" value="dev"/>
		</kb:isProfile>
		<div class="UoHqaUkevwrvJbwERySSt">
		<div class="_38wHjPwZlDoJPr9W-xySh _11sHgd9B8OCSX70aYZL0wk">
					KOTECH LMS 회원 가입 약관
			</div>
			<span class="_29lJFCzQlziDl9ND6FMan8" style="font-size: 13px;">이용 약관 및 개인 정보 수집에 동의해 주시기 바랍니다.</span>
		</div>

		<h5>이용 약관 동의(필수)</h5>
		<div id="text1" tabindex="0" style="overflow:scroll; overflow-x: hidden; width:100%; height:140px; padding:15px; border:1px solid #c8c8c8; font-size: 0.750rem; line-height: 1.5em;">
		      제1장 총칙<br>
		      <br>
		      제1조 (목적)<br>
		       이 약관은 KOTECH SYSTEM이 운영하는 “KOTECH LMS” (이하 ‘당 사이트’)가 제공하는 모든 회원정보 서비스(이하 '서비스')를 이용하는 고객(이하 ‘회원’)과 ‘당 사이트’가 ‘서비스’의 이용에 관한 조건 및 절차와 기타 필요한 사항을 규정하는 것을 목적으로 합니다.<br>
		      제2조 (약관의 효력과 변경)<br>
		      <br>
		       ① 이 약관은 회원 가입 정보 입력화면에서 '회원'이 "동의" 버튼을 클릭함으로써 효력이 발생됩니다.<br>
		       ② ‘당 사이트’는 이 약관을 임의로 변경할 수 있으며, 변경된 약관은 적용일 전 7일간 `회원'에게 공지되고 적용 일에 효력이 발생 됩니다.<br>
		       ③ ‘회원’은 변경된 약관에 동의하지 않을 경우, '서비스' 이용을 중단하고 탈퇴할 수 있습니다. 약관이 변경된 이후에도 계속적으로 ‘서비스’를 이용하는 경우에는 '회원'이 약관의 변경 사항에 동의한 것으로 봅니다.<br>
		      <br>
		      제3조 (약관 외 준칙)<br>
		       이 약관에 명시되지 않은 사항이 관계 법령에 규정되어 있을 경우에는 그 규정에 따릅니다.<br>
		      <br>
		      제2장 회원 가입과 서비스 이용<br>
		      <br>
		      제4조 (이용계약)<br>
		       '서비스' 이용은 '당 홈페이지'가 허락하고 '회원'이 약관 내용에 대해 동의하면 됩니다.<br>
		      제5조 (이용신청)<br>
		      <br>
		       ① 본 서비스를 이용하기 위해서는 '당 사이트'가 정한 소정의 양식에 이용자 정보를 기록해야 합니다.<br>
		       ② 가입신청 양식에 기재된 이용자 정보는 실제 데이터로 간주됩니다. 실제 정보를 입력하지 않은 사용자는 법적인 보호를 받을 수 없습니다.<br>
		      <br>
		      제6조 (이용신청의 승낙)<br>
		      <br>
		       ① '당 사이트'는 '회원'이 모든 사항을 정확히 기재하여 신청할 경우 '서비스' 이용을 승낙합니다. 다만, 아래의 경우는 예외로 합니다.<br>
		        1. 다른 사람의 명의를 사용하여 신청한 경우<br>
		        2. 회원 가입 신청서의 내용을 허위로 기재하였거나 신청하였을 경우<br>
		        3. 사회의 안녕 질서 또는 미풍양속을 저해할 목적으로 신청한 경우<br>
		        4. 다른 사람의 당 사이트 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 경우<br>
		        5. 당 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우<br>
		        6. 기타 당 사이트가 정한 회원 가입 요건이 미비할 경우<br>
		       ② 회원이 입력하는 정보는 아래와 같습니다. 아래의 정보 외에 '당 사이트'는 '회원'에게 추가 정보의 입력을 요구할 수 있습니다.<br>
		        - 필수항목 : 이름, 아이디, 비밀번호, 이메일, 가입인증정보, 학교, 학년, 반, 번호(학생회원)<br>
		        - 선택항목 : 최종학력, 우편주소, 가입이유<br>
		      <br>
		      제7조 (계약 사항의 변경 및 정보 보유/이용기간)<br>
		      <br>
		       ① '회원'은 '서비스' 이용 신청 시 기재한 사항이 변경되었을 경우, 온라인으로 수정을 해야 합니다.<br>
		       ② '회원'으로 등록하는 순간부터 '당 사이트'는 '회원'의 정보를 보유 및 이용할 수 있습니다.<br>
		       ③ '당 사이트'는 회원정보의 최신성과 정확성을 유지하기 위하여 '회원'에게 회원의 정보를 업데이트(갱신)할 것을 요구 내지 유도할 수 있습니다. 
		       ④ '회원'이 '서비스' 이용 신청 시 기재한 사항을 변경하였을 경우, '당 사이트'는 '변경'된 '회원'의 정보를 보유 및 이용할 수 있습니다.
		       ⑤ '회원'이 탈퇴하는 순간부터 당 사이트는 '회원'의 정보를 이용할 수 없습니다. 다만, '당 사이트'는 개인정보보호를 위해 '회원'이 탈퇴하는 순간부터 20일간 '회원'의 정보를 보유할 수 있습니다.<br>
		      <br>
		      제8조 (쿠키에 의한 개인정보 수집)<br>
		      <br>
		       ① '당 사이트'는 사용자마다 특화된 서비스를 제공하기 위해 사용자 개인용 컴퓨터에 쿠키를 전송합니다.<br>
		       ② 사용자가 한 번의 로그인으로 편리하게 이용하기 위해서는 쿠키 수신을 허용해야 합니다.<br>
		       ③ 쿠키는 '당 사이트'를 방문하는 사용자의 특성을 파악하기 위해 사용됩니다.<br>
		       ④ 사용자는 웹브라우저에 있는 옵션기능을 조정하여 쿠키를 선택적으로 받아들일 수 있습니다. 쿠키 수신을 거부할 경우 로그인이 필요한 서비스를 이용할 수 없습니다.<br>
		      <br>
		      제3장 계약해지<br>
		      <br>
		      제9조 (계약해지)<br>
		      <br>
		       ① '회원'은 온라인을 통해 회원정보처리에 관한 불만사항을 개진할 수 있습니다.<br>
		       ② '회원'이 '서비스' 이용 계약을 해지 하고자 할 때는 본인 확인이 가능하도록 이름, 아이디, 생년월일, 연락 가능한 전화번호를 기재하여 전자우편으로 해지 신청을 하거나, 회원정보수정의 '회원탈퇴' 메뉴에서 탈퇴 신청을 해야 합니다.<br>
		      <br>
		      제10조 (자격상실)<br>
		       다음 각항의 사유에 해당하는 경우 '당 사이트'는 사전 통보 없이 이용계약을 해지하거나 기간을 정하여 서비스 이용을 중지할 수 있습니다.<br>
		      <br>
		       ① 제6조 2항의 '기본정보'를 누락시킨 경우<br>
		       ② 가입신청 시 허위 내용으로 등록한 경우<br>
		       ③ 타인의 아이디와 비밀번호를 도용한 경우<br>
		       ④ 당 사이트, 다른 회원 또는 제3자의 지적재산권을 침해하는 경우<br>
		       ⑤ 사회의 안녕과 질서, 미풍양속을 해치는 행위를 하는 경우<br>
		       ⑥ 타인의 명예를 손상시키거나 불이익을 주는 행위를 한 경우<br>
		       ⑦ '신용정보의 이용 및 보호에 관한법률'에 따른 PC통신 및 인터넷 서비스의 신용불량자로 등록되는 경우<br>
		      <br>
		      제4장 책임<br>
		      <br>
		      제11조 ('당 사이트'의 의무)<br>
		      <br>
		       ① '당 사이트'는 '서비스' 제공으로 알게 된 '회원'의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 다만, 다음 각 호에 해당하는 경우에는 예외로 합니다.<br>
		        1. 금융실명거래 및 비밀보장에 관한 법률, 신용정보의 이용 및 보호에 관한 법률, 전기통신기본법, 전기통신 사업법, 지방세법, 소비자보호법, 한국은행법, 형사소송법 등 법령에 특별한 규정이 있는 경우<br>
		        2. 통계작성/학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우<br>
		        3. '당 사이트'는 '회원'의 전체 또는 일부 정보를 업무와 관련 된 통계 자료로 사용하는 경우<br>
		       ② '당 사이트'는 '서비스'가 계속적이고 안정적으로 운영될 수 있도록 노력하며, 부득이한 이유로 '서비스'가 중단되면 지체없이 이를 수리 복구하는 데 최선을 다해 노력합니다. 다만, 천재지변, 비상사태, 시스템 정기점검 및 'KOTECH SYSTEM'이 필요한 경우에는 그 서비스를 일시 중단하거나 중지할 수 있습니다.<br>
		      <br>
		      제 12조(`회원` 정보 사용에 대한 동의)<br>
		      <br>
		       ① KOTECH SYSTEM은 당 사이트 이외에 각종 사이트를 운영하고 있는 바, KOTECH SYSTEM이 운영하는 메인 사이트 및 각종 서브사이트의 서비스 제공을 목적으로 회원의 정보를 수집하며, 수집된 회원의 정보를 사용할 수 있습니다.<br>
		       ② '당 사이트'는 양질의 서비스를 위해 여러 교육 관련 유관 단체 및 비즈니스 사업자와 제휴를 맺어 회원정보를 공유할 수 있습니다. 그럴 경우 '당 사이트'는 본 조에 제휴업체 및 목적, 내용을 약관에 밝혀 `회원`의 동의를 받은 뒤 제휴업체에 제공합니다.<br>
		       ③ 본 조의 규정에 의한 '회원'의 동의는 본 약관 및 회원 가입 정보 입력화면에서 제공하는 정보서비스 이용신청 버튼을 클릭함으로써 그 효력을 발생합니다.<br>
		      <br>
		      제13조 (회원의 의무)<br>
		      <br>
		       ① 아이디와 비밀번호의 관리에 대한 책임은 '회원'에게 있습니다.<br>
		       ② '회원'은 자신의 아이디를 타인에게 양도, 증여, 대여하거나 타인으로 하여금 사용하게 하여서는 아니됩니다.<br>
		       ③ 자신의 아이디(ID)가 부정하게 사용된 경우, '회원'은 반드시 'KOTECH SYSTEM'에 그 사실을 통보해야 합니다.<br>
		       ④ '회원'은 게시물에 등록된 데이터를 이용한 영업활동을 할 수 없습니다.<br>
		       ⑤ '회원'은 '당 사이트'가 보내는 공지 메일을 수신해야 합니다.<br>
		      <br>
		      제14조 (회원의 게시물)<br>
		      <br>
		       ① 게시물이라 함은 '당 사이트'의 각종 게시판에 회원이 올린 글·사진·동영상 등 일체의 콘텐츠를 포함합니다.<br>
		       ② 회원이 게시하는 정보 및 질문과 대답 등으로 인해 발생하는 손실이나 문제는 전적으로 회원 개인의 판단에 따른 책임이며, '당 사이트'의 고의가 아닌 한 '당 사이트'는 이에 대하여 책임지지 않습니다.<br>
		       ③ 회원의 게시물로 인하여 제3자의 '당 사이트'에 대한 청구, 소송, 기타 일체의 분쟁이 발생한 경우 회원은 그 해결에 소요되는 비용을 부담하고 '당 사이트'를 위하여 분쟁을 처리하여야 하며, '당 사이트'가 제3자에게 배상하거나 '당 사이트'에 손해가 발생한 경우 회원은 '당 사이트'에 배상하여야 합니다.<br>
		       ④ ‘당 사이트’는 '회원'의 게시물이 다음 각 항에 해당되는 경우에는 사전통지 없이 삭제합니다. 그러나 '당 사이트'가 게시물을 검사 또는 검열할 의무를 부담하는 것은 아닙니다.<br>
		        1. 제3자를 비방하거나 중상 모략하여 명예를 손상시키는 경우<br>
		        2. 공공질서, 미풍양속에 저해되는 내용인 경우<br>
		        3. '당 사이트'의 저작권, 제3자의 저작권등 기타 권리를 침해하는 내용인 경우<br>
		        4. '당 사이트'에서 규정한 게시기간을 초과한 경우<br>
		        5. 상업성이 있는 게시물이나 돈벌이 광고, 행운의 편지 등을 게시한 경우<br>
		        6. 사이트의 개설취지에 맞지 않을 경우<br>
		        7. 기타 관계 법령을 위반한다고 판단되는 경우<br>
		       ⑤ '당 사이트'는 '회원'이 등록한 게시물을 활용해 가공, 판매, 출판 등을 할 수 있습니다.<br>
		      <br>
		      제5장 정보제공<br>
		      <br>
		      제15조 (정보의 제공)<br>
		       '당 사이트'는 '회원'에게 필요한 정보나 광고를 전자메일이나 서신우편 등의 방법으로 전달할 수 있으며, '회원'은 이를 원하지 않을 경우 가입신청 메뉴와 회원정보수정 메뉴에서 정보수신거부를 할 수 있습니다. 단, 정보 수신 거부한 `회원`에게도 제13조5항의 '당 사이트' 공지 메일을 보낼 수 있습니다.<br>
		      <br>
		      제6장 손해배상 및 면책<br>
		      <br>
		      제16조 (책임)<br>
		      <br>
		       ① '당 사이트'는 '서비스' 이용과 관련하여 '당 사이트'의 고의 또는 중과실이 없는 한 '회원'에게 발생한 어떠한 손해에 대해서도 책임을 지지 않습니다.<br>
		       ② '당 사이트'는 '서비스' 이용과 관련한 정보, 제품, 서비스, 소프트웨어, 그래픽, 음성, 동영상의 적합성, 정확성, 시의성, 신빙성에 관한 보증 또는 담보책임을 부담하지 않습니다.<br>
		      <br>
		      제17조 (면책)<br>
		       'KOTECH SYSTEM'이 천재지변 또는 불가피한 사정으로 '서비스'를 중단할 경우, '회원'에게 발생되는 문제에 대해 책임을 지지 않습니다.<br>
		      제18조 (관할법원)<br>
		       ① '서비스' 이용과 관련하여 소송이 제기될 경우 'KOTECH SYSTEM'의 소재지를 관할하는 법원 또는 대한민국의 민사소송법에 따른 법원을 관할법원으로 합니다.<br>
		       ② 본 약관의 해석과 적용 및 본 약관과 관련한 분쟁의 해결에는 대한민국법이 적용됩니다.<br>
		</div>
		<div style="text-align: right; margin-top:5px;">
			<form:radiobutton path="terms_yn" value="Y" label="동의함" />
			<form:radiobutton path="terms_yn" value="N" label="동의하지 않음"  cssStyle="margin-left: 10px;" />
			<%--
	      <input type="radio" name="agree1" value="Y" id="radio1_y"> <label for="radio1_y">동의함</label>
	      <input type="radio" name="agree1" value="N" id="radio1_n" style="margin-left: 10px;"> <label for="radio1_n">동의하지 않음</label>
			--%>
	    </div>



		<h5>개인 정보 수집 및 이용 동의(선택)</h5>
		<div id="text1" tabindex="0" style="overflow:scroll; overflow-x: hidden; width:100%; height:140px; padding:15px; border:1px solid #c8c8c8; font-size: 0.750rem; line-height: 1.5em;">
		      제1장 총칙<br>
		      <br>
		      제1조 (목적)<br>
		       이 약관은 KOTECH SYSTEM(이하 KOTECH SYSTEM)이 운영하는 “KOTECH LMS” (이하 ‘당 사이트’)가 제공하는 모든 회원정보 서비스(이하 '서비스')를 이용하는 고객(이하 ‘회원’)과 ‘당 사이트’가 ‘서비스’의 이용에 관한 조건 및 절차와 기타 필요한 사항을 규정하는 것을 목적으로 합니다.<br>
		      제2조 (약관의 효력과 변경)<br>
		      <br>
		       ① 이 약관은 회원 가입 정보 입력화면에서 '회원'이 "동의" 버튼을 클릭함으로써 효력이 발생됩니다.<br>
		       ② ‘당 사이트’는 이 약관을 임의로 변경할 수 있으며, 변경된 약관은 적용일 전 7일간 `회원'에게 공지되고 적용 일에 효력이 발생 됩니다.<br>
		       ③ ‘회원’은 변경된 약관에 동의하지 않을 경우, '서비스' 이용을 중단하고 탈퇴할 수 있습니다. 약관이 변경된 이후에도 계속적으로 ‘서비스’를 이용하는 경우에는 '회원'이 약관의 변경 사항에 동의한 것으로 봅니다.<br>
		      <br>
		      제3조 (약관 외 준칙)<br>
		       이 약관에 명시되지 않은 사항이 관계 법령에 규정되어 있을 경우에는 그 규정에 따릅니다.<br>
		      <br>
		      제2장 회원 가입과 서비스 이용<br>
		      <br>
		      제4조 (이용계약)<br>
		       '서비스' 이용은 '당 홈페이지'가 허락하고 '회원'이 약관 내용에 대해 동의하면 됩니다.<br>
		      제5조 (이용신청)<br>
		      <br>
		       ① 본 서비스를 이용하기 위해서는 '당 사이트'가 정한 소정의 양식에 이용자 정보를 기록해야 합니다.<br>
		       ② 가입신청 양식에 기재된 이용자 정보는 실제 데이터로 간주됩니다. 실제 정보를 입력하지 않은 사용자는 법적인 보호를 받을 수 없습니다.<br>
		      <br>
		      제6조 (이용신청의 승낙)<br>
		      <br>
		       ① '당 사이트'는 '회원'이 모든 사항을 정확히 기재하여 신청할 경우 '서비스' 이용을 승낙합니다. 다만, 아래의 경우는 예외로 합니다.<br>
		        1. 다른 사람의 명의를 사용하여 신청한 경우<br>
		        2. 회원 가입 신청서의 내용을 허위로 기재하였거나 신청하였을 경우<br>
		        3. 사회의 안녕 질서 또는 미풍양속을 저해할 목적으로 신청한 경우<br>
		        4. 다른 사람의 당 사이트 서비스 이용을 방해하거나 그 정보를 도용하는 등의 행위를 하였을 경우<br>
		        5. 당 사이트를 이용하여 법령과 본 약관이 금지하는 행위를 하는 경우<br>
		        6. 기타 당 사이트가 정한 회원 가입 요건이 미비할 경우<br>
		       ② 회원이 입력하는 정보는 아래와 같습니다. 아래의 정보 외에 '당 사이트'는 '회원'에게 추가 정보의 입력을 요구할 수 있습니다.<br>
		        - 필수항목 : 이름, 아이디, 비밀번호, 이메일, 가입인증정보, 학교, 학년, 반, 번호(학생회원)<br>
		        - 선택항목 : 최종학력, 우편주소, 가입이유<br>
		      <br>
		      제7조 (계약 사항의 변경 및 정보 보유/이용기간)<br>
		      <br>
		       ① '회원'은 '서비스' 이용 신청 시 기재한 사항이 변경되었을 경우, 온라인으로 수정을 해야 합니다.<br>
		       ② '회원'으로 등록하는 순간부터 '당 사이트'는 '회원'의 정보를 보유 및 이용할 수 있습니다.<br>
		       ③ '당 사이트'는 회원정보의 최신성과 정확성을 유지하기 위하여 '회원'에게 회원의 정보를 업데이트(갱신)할 것을 요구 내지 유도할 수 있습니다. 
		       ④ '회원'이 '서비스' 이용 신청 시 기재한 사항을 변경하였을 경우, '당 사이트'는 '변경'된 '회원'의 정보를 보유 및 이용할 수 있습니다.
		       ⑤ '회원'이 탈퇴하는 순간부터 당 사이트는 '회원'의 정보를 이용할 수 없습니다. 다만, '당 사이트'는 개인정보보호를 위해 '회원'이 탈퇴하는 순간부터 20일간 '회원'의 정보를 보유할 수 있습니다.<br>
		      <br>
		      제8조 (쿠키에 의한 개인정보 수집)<br>
		      <br>
		       ① '당 사이트'는 사용자마다 특화된 서비스를 제공하기 위해 사용자 개인용 컴퓨터에 쿠키를 전송합니다.<br>
		       ② 사용자가 한 번의 로그인으로 편리하게 이용하기 위해서는 쿠키 수신을 허용해야 합니다.<br>
		       ③ 쿠키는 '당 사이트'를 방문하는 사용자의 특성을 파악하기 위해 사용됩니다.<br>
		       ④ 사용자는 웹브라우저에 있는 옵션기능을 조정하여 쿠키를 선택적으로 받아들일 수 있습니다. 쿠키 수신을 거부할 경우 로그인이 필요한 서비스를 이용할 수 없습니다.<br>
		      <br>
		      제3장 계약해지<br>
		      <br>
		      제9조 (계약해지)<br>
		      <br>
		       ① '회원'은 온라인을 통해 회원정보처리에 관한 불만사항을 개진할 수 있습니다.<br>
		       ② '회원'이 '서비스' 이용 계약을 해지 하고자 할 때는 본인 확인이 가능하도록 이름, 아이디, 생년월일, 연락 가능한 전화번호를 기재하여 전자우편으로 해지 신청을 하거나, 회원정보수정의 '회원탈퇴' 메뉴에서 탈퇴 신청을 해야 합니다.<br>
		      <br>
		      제10조 (자격상실)<br>
		       다음 각항의 사유에 해당하는 경우 '당 사이트'는 사전 통보 없이 이용계약을 해지하거나 기간을 정하여 서비스 이용을 중지할 수 있습니다.<br>
		      <br>
		       ① 제6조 2항의 '기본정보'를 누락시킨 경우<br>
		       ② 가입신청 시 허위 내용으로 등록한 경우<br>
		       ③ 타인의 아이디와 비밀번호를 도용한 경우<br>
		       ④ 당 사이트, 다른 회원 또는 제3자의 지적재산권을 침해하는 경우<br>
		       ⑤ 사회의 안녕과 질서, 미풍양속을 해치는 행위를 하는 경우<br>
		       ⑥ 타인의 명예를 손상시키거나 불이익을 주는 행위를 한 경우<br>
		       ⑦ '신용정보의 이용 및 보호에 관한법률'에 따른 PC통신 및 인터넷 서비스의 신용불량자로 등록되는 경우<br>
		      <br>
		      제4장 책임<br>
		      <br>
		      제11조 ('당 사이트'의 의무)<br>
		      <br>
		       ① '당 사이트'는 '서비스' 제공으로 알게 된 '회원'의 신상정보를 본인의 승낙 없이 제3자에게 누설, 배포하지 않습니다. 다만, 다음 각 호에 해당하는 경우에는 예외로 합니다.<br>
		        1. 금융실명거래 및 비밀보장에 관한 법률, 신용정보의 이용 및 보호에 관한 법률, 전기통신기본법, 전기통신 사업법, 지방세법, 소비자보호법, 한국은행법, 형사소송법 등 법령에 특별한 규정이 있는 경우<br>
		        2. 통계작성/학술연구 또는 시장조사를 위하여 필요한 경우로서 특정 개인을 식별할 수 없는 형태로 제공하는 경우<br>
		        3. '당 사이트'는 '회원'의 전체 또는 일부 정보를 업무와 관련 된 통계 자료로 사용하는 경우<br>
		       ② '당 사이트'는 '서비스'가 계속적이고 안정적으로 운영될 수 있도록 노력하며, 부득이한 이유로 '서비스'가 중단되면 지체없이 이를 수리 복구하는 데 최선을 다해 노력합니다. 다만, 천재지변, 비상사태, 시스템 정기점검 및 'KOTECH SYSTEM'이 필요한 경우에는 그 서비스를 일시 중단하거나 중지할 수 있습니다.<br>
		      <br>
		      제 12조(`회원` 정보 사용에 대한 동의)<br>
		      <br>
		       ① KOTECH SYSTEM은 당 사이트 이외에 각종 사이트를 운영하고 있는 바, KOTECH SYSTEM이 운영하는 메인 사이트 및 각종 서브사이트의 서비스 제공을 목적으로 회원의 정보를 수집하며, 수집된 회원의 정보를 사용할 수 있습니다.<br>
		       ② '당 사이트'는 양질의 서비스를 위해 여러 교육 관련 유관 단체 및 비즈니스 사업자와 제휴를 맺어 회원정보를 공유할 수 있습니다. 그럴 경우 '당 사이트'는 본 조에 제휴업체 및 목적, 내용을 약관에 밝혀 `회원`의 동의를 받은 뒤 제휴업체에 제공합니다.<br>
		       ③ 본 조의 규정에 의한 '회원'의 동의는 본 약관 및 회원 가입 정보 입력화면에서 제공하는 정보서비스 이용신청 버튼을 클릭함으로써 그 효력을 발생합니다.<br>
		      <br>
		      제13조 (회원의 의무)<br>
		      <br>
		       ① 아이디와 비밀번호의 관리에 대한 책임은 '회원'에게 있습니다.<br>
		       ② '회원'은 자신의 아이디를 타인에게 양도, 증여, 대여하거나 타인으로 하여금 사용하게 하여서는 아니됩니다.<br>
		       ③ 자신의 아이디(ID)가 부정하게 사용된 경우, '회원'은 반드시 'KOTECH SYSTEM'에 그 사실을 통보해야 합니다.<br>
		       ④ '회원'은 게시물에 등록된 데이터를 이용한 영업활동을 할 수 없습니다.<br>
		       ⑤ '회원'은 '당 사이트'가 보내는 공지 메일을 수신해야 합니다.<br>
		      <br>
		      제14조 (회원의 게시물)<br>
		      <br>
		       ① 게시물이라 함은 '당 사이트'의 각종 게시판에 회원이 올린 글·사진·동영상 등 일체의 콘텐츠를 포함합니다.<br>
		       ② 회원이 게시하는 정보 및 질문과 대답 등으로 인해 발생하는 손실이나 문제는 전적으로 회원 개인의 판단에 따른 책임이며, '당 사이트'의 고의가 아닌 한 '당 사이트'는 이에 대하여 책임지지 않습니다.<br>
		       ③ 회원의 게시물로 인하여 제3자의 '당 사이트'에 대한 청구, 소송, 기타 일체의 분쟁이 발생한 경우 회원은 그 해결에 소요되는 비용을 부담하고 '당 사이트'를 위하여 분쟁을 처리하여야 하며, '당 사이트'가 제3자에게 배상하거나 '당 사이트'에 손해가 발생한 경우 회원은 '당 사이트'에 배상하여야 합니다.<br>
		       ④ ‘당 사이트’는 '회원'의 게시물이 다음 각 항에 해당되는 경우에는 사전통지 없이 삭제합니다. 그러나 '당 사이트'가 게시물을 검사 또는 검열할 의무를 부담하는 것은 아닙니다.<br>
		        1. 제3자를 비방하거나 중상 모략하여 명예를 손상시키는 경우<br>
		        2. 공공질서, 미풍양속에 저해되는 내용인 경우<br>
		        3. '당 사이트'의 저작권, 제3자의 저작권등 기타 권리를 침해하는 내용인 경우<br>
		        4. '당 사이트'에서 규정한 게시기간을 초과한 경우<br>
		        5. 상업성이 있는 게시물이나 돈벌이 광고, 행운의 편지 등을 게시한 경우<br>
		        6. 사이트의 개설취지에 맞지 않을 경우<br>
		        7. 기타 관계 법령을 위반한다고 판단되는 경우<br>
		       ⑤ '당 사이트'는 '회원'이 등록한 게시물을 활용해 가공, 판매, 출판 등을 할 수 있습니다.<br>
		      <br>
		      제5장 정보제공<br>
		      <br>
		      제15조 (정보의 제공)<br>
		       '당 사이트'는 '회원'에게 필요한 정보나 광고를 전자메일이나 서신우편 등의 방법으로 전달할 수 있으며, '회원'은 이를 원하지 않을 경우 가입신청 메뉴와 회원정보수정 메뉴에서 정보수신거부를 할 수 있습니다. 단, 정보 수신 거부한 `회원`에게도 제13조5항의 '당 사이트' 공지 메일을 보낼 수 있습니다.<br>
		      <br>
		      제6장 손해배상 및 면책<br>
		      <br>
		      제16조 (책임)<br>
		      <br>
		       ① '당 사이트'는 '서비스' 이용과 관련하여 '당 사이트'의 고의 또는 중과실이 없는 한 '회원'에게 발생한 어떠한 손해에 대해서도 책임을 지지 않습니다.<br>
		       ② '당 사이트'는 '서비스' 이용과 관련한 정보, 제품, 서비스, 소프트웨어, 그래픽, 음성, 동영상의 적합성, 정확성, 시의성, 신빙성에 관한 보증 또는 담보책임을 부담하지 않습니다.<br>
		      <br>
		      제17조 (면책)<br>
		       'KOTECH SYSTEM'이 천재지변 또는 불가피한 사정으로 '서비스'를 중단할 경우, '회원'에게 발생되는 문제에 대해 책임을 지지 않습니다.<br>
		      제18조 (관할법원)<br>
		       ① '서비스' 이용과 관련하여 소송이 제기될 경우 'KOTECH SYSTEM'의 소재지를 관할하는 법원 또는 대한민국의 민사소송법에 따른 법원을 관할법원으로 합니다.<br>
		       ② 본 약관의 해석과 적용 및 본 약관과 관련한 분쟁의 해결에는 대한민국법이 적용됩니다.<br>
		</div>
		<div style="text-align: right; margin-top:5px;">
			<form:radiobutton path="consent_yn" value="Y" label="동의함" />
			<form:radiobutton path="consent_yn" value="N" label="동의하지 않음"  cssStyle="margin-left: 10px;" />
			<%--
	      <input type="radio" name="agree2" value="Y" id="radio1_y2"> <label for="radio1_y2">동의함</label>
	      <input type="radio" name="agree2" value="N" id="radio1_n2" style="margin-left: 10px;"> <label for="radio1_n2">동의하지 않음</label>
	      --%>
	    </div>

		<div class="mt50">

			<button type="button" class="_1AX8pEa7feGCxcY5g5z5KN btn btn-primary btn-lg btn-block" id="btn_next_step">
				<span class="Tmopq5aSmHQftHmuZSsAd">
					<span class="_1lMForvxbNw3au4JG5jdB9"><span>세부 정보 입력으로 진행</span></span>
				</span>
			</button>
		</div>
		<p class="_2d-xByT7Z84eA5s0I_vt_e USormlxqXIIh6_cCv9jhX">
			<span>CopyRightⓒ2023 KOTECH. All Rights Reserved.
				</span>
				<a href="/"><span style="color : red;"> 홈으로가기</span></a>
		</p>

	</form:form>
		<div>
            <input type="hidden" name="_csrf" value="79c89941-5ac5-4131-a07d-1136855dbbc9" />
        </div>
	</section>
</div>