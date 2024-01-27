<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
/**
* @Class Name : myConn.jsp
* @Description : 소셜 연동하기 컴포넌트
* @Modification Information
*
*   수정일         수정자                   수정내용
*  -------    --------    ---------------------------
*  2023.03.14       최초 생성
*
* author 
*/
%>
<c:set var="kakaoImg" value="/images/egovframework/social/kakao/kakaotalk_sharing_btn_small_ov.png"/>
<c:set var="naverImg" value="/images/egovframework/social/naver/2021_Login_with_naver_guidelines_En/btnG_icon_square.png"/>
<c:set var="facebookImg" value="/images/egovframework/social/facebook/f-Logos-2019-1/f_Logo_Online_04_2019/Color/PNG/f_logo_RGB-Blue_250.png"/>
<c:set var="twitterImg" value="/images/egovframework/social/twitter/twitter-logo-01282021/Twitter logo/PNG/2021 Twitter logo - blue.png"/>
<c:set var="instagramImg" value="/images/egovframework/social/instagram/logo.png"/>
<c:set var="googleImg" value="/images/egovframework/social/google/web/vector/btn_google_dark_normal_ios.svg"/>
<c:set var="imgSrc" value=""/>
<style>
#social_login > div:hover {
    background-color: #fafafa;
    opacity: 1
}
</style>
<body>
	<div id="social_login" class="row">
		<c:forEach var="social" items="${social}">
			<c:choose>
				<c:when test="${social.code eq 'kakao' }"><c:set var="imgSrc" value="${kakaoImg}"/></c:when>
				<c:when test="${social.code eq 'naver' }"><c:set var="imgSrc" value="${naverImg}"/></c:when>
				<c:when test="${social.code eq 'facebook' }"><c:set var="imgSrc" value="${facebookImg}"/></c:when>
				<c:when test="${social.code eq 'twitter' }"><c:set var="imgSrc" value="${twitterImg}"/></c:when>
				<c:when test="${social.code eq 'instagram' }"><c:set var="imgSrc" value="${instagramImg}"/></c:when>
				<c:when test="${social.code eq 'google' }"><c:set var="imgSrc" value="${googleImg}"/></c:when>
			</c:choose>
			<div id="${social.code}" class="form-check form-switch check-on col-lg-4 col-md-6">
				<img title="${social.code}" width="50" height="50" src="${imgSrc}"/>
				<label class="form-check-label" for="_${social.code}_" >${social.code_nm}</label>
				<input type="hidden" id="_${social.code}_connected" value="${social.connected}"/>
				<input id="_${social.code}_" class="form-check-input" type="checkbox" <c:if test="${social.connected eq 'Y' }">checked="true"</c:if> onClick="return;">
			</div>
		</c:forEach>
	</div>
</body>
</html>
<!-- 소셜 로그인 -->
<script>

const socialLogin = document.querySelectorAll('#social_login > div');
for (const social of socialLogin){
	social.style.cursor = 'pointer';
	social.addEventListener('click',function(event){
		let url = '';
		let cmmd = '';

		const loginTp = $(this).closest("div").attr("id");
		const loginTpNm = $(this).closest("div").find("label").text();
		const isConnected = $("#_" + loginTp + "_connected").val();
		console.log($(this).closest("div").find("label"));
		
		if(isConnected == 'N'){
			cmmd = 'I';
			var confirm_func = function () {
				
				// url 정보 ajax로 얻어오기
				$.ajax({
				    url: '/oauth.do',
				    data:{
				    	social : loginTp,
				    	cmmd : cmmd
				    },
				    type: 'POST',
				    async:false,
				    success: function onData (data) {
				        url = data;
				        
						// 기본 값 세팅
						const target = 'socialPop';
						const width  = "960";
					  	const height = "720";
					  	const popupX = Math.ceil(( window.screen.width - width )/2);
					    const popupY = Math.ceil(( window.screen.width - height )/2);
					    
						window.open(url, target, 'status=no, height='+ height + ', width='+ width + ', left='+ popupX + ', top='+ popupY);
				    },
				    error: function onError (error) {
				    	
				    	alert_error('연동 시도하는 중 오류가 발생했습니다. 관리자에게 문의 바랍니다.');
				        console.error('fail', error);
				    }
				});
			}
			
			confirm_info( '소셜 연동(' + loginTpNm + ') 하시겠습니까?', confirm_func );
			
		} else if (isConnected == 'Y') {
			cmmd = 'D';
			var confirm_func = function () {
				
				// url 정보 ajax로 얻어오기
				$.ajax({
				    url: '/oauth/disconnect.do',
				    data:{
				    	social : loginTp,
				    	cmmd : cmmd
				    },
				    type: 'DELETE',
				    async:false,
				    success: function onData (data) {
				    	$("#_" + loginTp + "_connected").val("N");
				    	$('#_' + loginTp + '_').prop("checked",false);
				    	alert_success("연동 해제 되었습니다");
				    },
				    error: function onError (error) {
				    	
				    	alert_error('연동 시도하는 중 오류가 발생했습니다. 관리자에게 문의 바랍니다.');
				        console.error('fail', error);
				    }
				});
				
			}
			
			confirm_warning( '소셜 연동 해제(' + loginTpNm + ') 하시겠습니까?', confirm_func );

		}
		
		event.preventDefault();

	})
}

<!-- 인증 결과 콜백 처리 함수 -->
function authCallBackFn(service,result,uid,connid,msg){
	if(result == 'I'){
		$('#_' + service + '_connected').val('Y');
		$('#_' + service + '_').prop("checked",true);
		alert_success(msg);
	} else {
		alert_warning(msg);
	}
	
}

</script>