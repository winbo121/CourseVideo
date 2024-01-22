<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
$(document).ready (function(){
	<%-- 회원탈퇴 버튼 --%>
	$("#btn_withdraw_user").on("click",function(){
		<%--  더블 클릭 방지 --%>
		if(checkIsRun()) {
			return;
		}
		
		var confirm_func = function() {
			var form_data = new FormData();
			
			var succ_func = function(resData, status ) {
				var result = resData.result;
				
				if(result == 'success') {
					var confirm_func = function() {
						location.href="/";

					};					
					
					alert_success( "회원탈퇴 되었습니다.<br/> 이용해주셔서 감사합니다. <br/> 메인화면으로 이동합니다.", confirm_func );
				} else {
					
					<%-- 더블 클릭 방지 리셋 --%>
					resetIsRun();
					
					alert_error( resData.msg, null );
				}
			};
			
			ajax_form_delete("/myprofile/profileDelete/delete.do", form_data, succ_func);
		}
		
		var basicConfirm = new BasicConfirm();
		basicConfirm._type = "warning";
		basicConfirm._confirm_text = "탈퇴"
		basicConfirm._html = '회원탈퇴 하시겠습니까?'; basicConfirm._confirm_func = confirm_func;
		basicConfirm.fire();
		
	});
	
	
});
</script>

			<!-- Student Header -->
			<%-- <jsp:include page="/WEB-INF/layout/common/mypageBanner.jsp" /> --%>
			<!-- /Student Header -->
						
			<!--Dashbord Student -->
			<div class="page-content">
				<div class="container">
					<div class="row">						
						<!-- Profile Details -->
						<div>	
							<div class="settings-widget profile-details">
								<div class="settings-menu p-0">
									<div class="profile-heading">
										<h3>계정 탈퇴</h3>
										<p>계정을 탈퇴할 수 있습니다.</p>
									</div>
									<div class="checkout-form personal-address">
										<div class="personal-info-head">
											<h4>계정 탈퇴</h4>
											<p>계정 탈퇴하면, KOTECH LMS 서비스를 더 이상 이용할 수 없습니다.</p>
										</div>
										<div class="un-subscribe p-0">
											<a href="javascript:void(0);" class="btn btn-danger" id="btn_withdraw_user">탈퇴하기</a>
										</div>
									</div>
								</div>
							</div>
						</div>	
						<!-- Profile Details -->
						
					</div>
				</div>
			</div>	
			<!-- /Dashbord Student -->