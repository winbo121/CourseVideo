<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
/**
* @Class Name : joinConn.jsp
* @Description : 소셜 연동하기 컴포넌트
* @Modification Information
*
*   수정일         수정자                   수정내용
*  -------    --------    ---------------------------
*  2023.03.14 KOTECH      최초 생성
*
* author KOTECH
*/
%>
	<div class="row" id="social_login">
		<c:set var="kakaoImg" value="/images/egovframework/social/kakao/kakaotalk_sharing_btn_small_ov.png"/>
		<c:set var="naverImg" value="/images/egovframework/social/naver/2021_Login_with_naver_guidelines_En/btnG_icon_square.png"/>
		<c:set var="facebookImg" value="/images/egovframework/social/facebook/f-Logos-2019-1/f_Logo_Online_04_2019/Color/PNG/f_logo_RGB-Blue_250.png"/>
		<c:set var="twitterImg" value="/images/egovframework/social/twitter/twitter-logo-01282021/Twitter logo/PNG/2021 Twitter logo - blue.png"/>
		<c:set var="instagramImg" value="/images/egovframework/social/instagram/logo.png"/>
		<c:set var="googleImg" value="/images/egovframework/social/google/web/vector/btn_google_dark_normal_ios.svg"/>
		<c:set var="imgSrc" value=""/>
		<c:forEach var="social" items="${social}" varStatus="status">
			<c:choose>
				<c:when test="${social.code eq 'kakao' }"><c:set var="imgSrc" value="${kakaoImg}"/></c:when>
				<c:when test="${social.code eq 'naver' }"><c:set var="imgSrc" value="${naverImg}"/></c:when>
				<c:when test="${social.code eq 'facebook' }"><c:set var="imgSrc" value="${facebookImg}"/></c:when>
				<c:when test="${social.code eq 'twitter' }"><c:set var="imgSrc" value="${twitterImg}"/></c:when>
				<c:when test="${social.code eq 'instagram' }"><c:set var="imgSrc" value="${instagramImg}"/></c:when>
				<c:when test="${social.code eq 'google' }"><c:set var="imgSrc" value="${googleImg}"/></c:when>
			</c:choose>
			<div class="mb20" style="flex:50%;text-align:center;" id="${social.code}" style="margin:0 auto;">
				<img title="${social.code}" width="50" height="50" src="${imgSrc}"/>
				<button class="btn btn-light" type="button" aria-disabled="false">
				<c:choose>
					<c:when test="${social.connected eq 'Y' }">
					연동해제
					</c:when>
					<c:otherwise>
					연동하기
					</c:otherwise>
				</c:choose>
				</button>
			</div>
			<%-- 홀수 data css 맞추기 --%>
			<c:if test="${status.last and status.count mod 2 eq 1}">
				<div class="mb20" style="flex:50%;text-align:center;"></div>
			</c:if>
		</c:forEach>	
	</div>
	
<!-- 연계 사이트 정보 -->
<form:input path="kakao_connected"  type="hidden" value="${signup.kakao_connected}"/>
<form:input path="kakao_id"  type="hidden" value="${signup.kakao_id}"/>
<form:input path="kakao_conn_id"  type="hidden" value="${signup.kakao_conn_id}"/>

<form:input path="naver_connected"  type="hidden" value="${signup.naver_connected}"/>
<form:input path="naver_id"  type="hidden" value="${signup.naver_id}"/>
<form:input path="naver_conn_id"  type="hidden" value="${signup.naver_conn_id}"/>

<form:input path="facebook_connected"  type="hidden" value="${signup.facebook_connected}"/>
<form:input path="facebook_id"  type="hidden" value="${signup.facebook_id}"/>
<form:input path="facebook_conn_id"  type="hidden" value="${signup.facebook_conn_id}"/>

<!-- 
<form:input path="twitter_connected"  type="hidden" value="${signup.twitter_connected}"/>
<form:input path="twitter_id"  type="hidden" value="${signup.twitter_id}"/>
<form:input path="twitter_conn_id"  type="hidden" value="${signup.twitter_conn_id}"/>
 -->
 
<form:input path="instagram_connected"  type="hidden" value="${signup.instagram_connected}"/>
<form:input path="instagram_id"  type="hidden" value="${signup.instagram_id}"/>
<form:input path="instagram_conn_id"  type="hidden" value="${signup.instagram_conn_id}"/>

<form:input path="google_connected"  type="hidden" value="${signup.google_connected}"/>
<form:input path="google_id"  type="hidden" value="${signup.google_id}"/>
<form:input path="google_conn_id"  type="hidden" value="${signup.google_conn_id}"/>
<!-- 소셜 로그인 -->
<script>
const socialLogin = document.querySelectorAll('#social_login > div > button');
for (const social of socialLogin){
	social.addEventListener('click',function(event){
		let url = '';
		let cmmd = '';
		
		const loginTp = this.parentElement.getAttribute('id');
		const isConnected = $('#' + loginTp + '_connected').val();
		
		if(isConnected == 'N'){
			cmmd = 'I';
			
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

			
		} else if (isConnected == 'Y') {
			cmmd = 'D';
			var confirm_func = function () {
				$('#' + loginTp + '_connected').val('N');
				$('#' + loginTp + '_id').val('');
				document.getElementById(loginTp).lastElementChild.innerText = '연동하기';
				
				alert_success("연동해제 성공했습니다.");
				
				return false;
			}
			
			confirm_info( '연동해제 하시겠습니까?', confirm_func );

		}

	})
}

<!-- 인증 결과 콜백 처리 함수 -->
function authCallBackFn(service,result,uid,connid,msg){
	const target = document.getElementById(service); 
	if(result == 'I'){
		$('#' + service + '_connected').val('Y');
		$('#' + service + '_id').val(uid);
		$('#' + service + '_conn_id').val(connid);
		document.getElementById(service).lastElementChild.innerText = '연동완료';
		alert_success(msg);
	} else {
		alert_warning(msg);
	}
	
}

</script>