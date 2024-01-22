<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<style>
body{background-color:#fff;text-align:center;*word-break:break-all;-ms-word-break:break-all}
i,em,address{font-style:normal}
hr{display:none}
body { text-align:center;background-color:#f8f8f8; }
#yesWrap { text-align:center; }
#ySHeader .ySHeaderAera { margin:0 auto;width:80%; max-width:960px;height:100px;text-align:left; }
#ySContent { margin:0 auto;padding:60px 0;width:80%; max-width:960px;border:solid 1px #d8d8d8;text-align:center;background-color:#fff; }
#ySContent .ySContRow { margin:0 auto;position:relative; max-width:760px;text-align:left; }
#ySFooter { height:50px;text-align:center; }
#ySFooter .ySFooterAera { margin:0 auto;width:80%; max-width:960px;height:50px;line-height:50px;text-align:center;color:#666; }

#ySContent .error_tit { padding-bottom:30px;line-height:42px;border-bottom:solid 1px #d8d8d8;text-align:center;font-size:30px;color:#333;font-weight:800; }
#ySContent .error_des { line-height:26px;font-size:16px;color:#333;text-align:center; }
#ySContent .error_des p+p { margin-top:20px; }
#ySContent .error_btn { margin-top:40px;text-align:center; }

.btnC.xb_size .bWrap {
    padding: 15px 0;
    height: 28px;
    text-align: center;
}
.btnC.w_220 .bWrap {
    padding-left: 0 !important;
    padding-right: 0 !important;
    width: 218px;
}
.btnC.btn_blue .bWrap {
    border-color: #196ab3;
    border-bottom-color: #165fa1;
    border-right-color: #165fa1;
    background-color: #196ab3;
}
.btnC .bWrap {
    position: relative;
    padding: 0 7px;
    height: 28px;
    text-align: center;
    text-indent: 0;
    border: solid 1px #ebebeb;
    border-bottom-color: #d8d8d8;
    border-right-color: #d8d8d8;
    background-color: #fff;
}
.btnC .bWrap {
    display: -moz-inline-stack;
    display: inline-block;
    zoom: 1;
    *display: inline;
    text-align: center;
    vertical-align: top;
}

.btnC.xb_size .bWrap em.txt {
    padding: 0 10px;
    line-height: 28px;
    font-size: 18px;
    font-weight: 500;
}
.btnC.btn_blue .bWrap em.txt {
    color: #fff !important;
}


.mgt40 {
	margin-top:40px;
}
</style>
<script type="text/javascript">
$(document).ready (function(){
	$( "#btn_go_main" ).click(function(){
		move_get( "/index.do", null );
	});
});
</script>



<hr/>

<div id="yesWrap">
	<div id="ySHeader">
		<div class="ySHeaderAera">
		</div>
	</div>
	<hr/>

	<div id="ySContent">
        <img src="<c:url value='/assets/pc/images/common/cor_logo.png'/>" alt="책열매" style="">
        <div class="ySContRow">
			<div class="error_tit">
				403 Forbidden
			</div>
			<div class="error_des mgt40">
				<p>
					사용자는 현재 페이지의 권한이 존재하지 않습니다.
				</p>
			</div>
			<div class="error_btn">
				<a id="btn_go_main" href="javascript:void(0);" class="btnC w_220 xb_size btn_blue">
					<span class="bWrap"><em class="txt">메인 바로가기</em></span>
				</a>
			</div>
			<div class="error_des mgt40">
				이용에 불편을 드려 죄송합니다.
			</div>
		</div>
	</div>
	<hr/>
	<div id="ySFooter">
		<div class="ySFooterAera">
			<address>
				Copyright &#0169; <strong>KICE</strong> All Rights Reserved.
			</address>
		</div>
	</div>
</div>



