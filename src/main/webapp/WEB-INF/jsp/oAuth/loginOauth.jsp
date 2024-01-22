<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
/**
* @Class Name : loginOauth.jsp
* @Description : 소셜 로그인 컴포넌트
* @Modification Information
*
*   수정일         수정자                   수정내용
*  -------    --------    ---------------------------
*  2023.03.10            최초 생성
*
* author KOTECH
*/
%>
	<div id="social_login" style="display:flex; justify-content:space-around;">
		<c:set var="kakaoImg" value="/images/egovframework/social/kakao/kakaotalk_sharing_btn_small_ov.png"/>
		<c:set var="naverImg" value="/images/egovframework/social/naver/2021_Login_with_naver_guidelines_En/btnG_icon_square.png"/>
		<c:set var="facebookImg" value="/images/egovframework/social/facebook/f-Logos-2019-1/f_Logo_Online_04_2019/Color/PNG/f_logo_RGB-Blue_250.png"/>
		<c:set var="twitterImg" value="/images/egovframework/social/twitter/twitter-logo-01282021/Twitter logo/PNG/2021 Twitter logo - blue.png"/>
		<c:set var="instagramImg" value="/images/egovframework/social/instagram/logo.png"/>
		<c:set var="googleImg" value="/images/egovframework/social/google/web/vector/btn_google_dark_normal_ios.svg"/>
		<c:set var="imgSrc" value=""/>
		<c:forEach var="social" items="${social}">
			<c:choose>
				<c:when test="${social.code eq 'kakao' }"><c:set var="imgSrc" value="${kakaoImg}"/></c:when>
				<c:when test="${social.code eq 'naver' }"><c:set var="imgSrc" value="${naverImg}"/></c:when>
				<c:when test="${social.code eq 'facebook' }"><c:set var="imgSrc" value="${facebookImg}"/></c:when>
				<c:when test="${social.code eq 'twitter' }"><c:set var="imgSrc" value="${twitterImg}"/></c:when>
				<c:when test="${social.code eq 'instagram' }"><c:set var="imgSrc" value="${instagramImg}"/></c:when>
				<c:when test="${social.code eq 'google' }"><c:set var="imgSrc" value="${googleImg}"/></c:when>
			</c:choose>
			<div>
				<img title="${social.code}" width="50" height="50" src="${imgSrc}"/>
			</div>
		</c:forEach>
	</div>
<!-- 소셜 로그인 -->
<script>
const socialLogin = document.querySelectorAll('#social_login > div');
for (const social of socialLogin){
	social.style.cursor = 'pointer';
	social.addEventListener('click',function(event){
		let url = '';
		const login_type = this.querySelector("img").title;
		
		// url 정보 ajax로 얻어오기
		$.ajax({
		    url: '/oauth.do',
		    data:{
		    	social : login_type,
		    	cmmd : 'L',
		    	_csrf : "${_csrf.token}"
		    },
		    type: 'POST',
		    async:false,
		    success: function onData (data) {
		        console.log('success', data);
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
		        console.error('fail', error);
		    }
		});

	})
}

<!-- 인증 결과 콜백 처리 함수 -->
function authCallBackFn(service,result,uid,connid,msg){
	if(result == 'L'){
		
		var confirm_func = function() {
			location.href="/";	
		}
		alert_success(msg,confirm_func);
		
	} else {
		alert_warning(msg);
	}
}

</script>