<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html>
<head>
<title></title>

<script type="text/javascript">
$(document).ready(function(){
	<%-- search form submit --%>
	$("#search").submit(function() {
		<%-- SEARCH FORM SUBMIT 으로 페이징 리스트 조회시에는 항상 PAGE NO , RANGE NO 를 1로 세팅한다. --%>
		$( this ).find( "#pageNo" ).val("1");
		$( this ).find( "#rangeNo" ).val("1");
	});

	<%-- 엑셀다운로드 --%>
	$("#anchor_excel").click(function(){
		var action = "/test/jsp_excel.do";
		var form_data = new FormData( $( "#search" )[0] );
		excel_down( action, form_data );
	});

	$("#anchor_test").click(function(){
		var action = "/test/jsp_paging.do";


		var succ_func = function(resData, status){
		};

		var form_data = new FormData( );
		form_data.append("search_text", "<script>"  );
		ajax_form_post( action, form_data, succ_func );

		var json = { search_text: "<script>" };
// 		ajax_json_post( action, json , succ_func );

	});






});
</script>

</head>

<body>
JSP PAGING <br/>

<table border="1">
	<thead>
		<tr>
			<th class="dt-center">전체글</th>
			<th class="dt-center">RANGE SIZE</th>
			<th class="dt-center">PAGE SIZE</th>
			<th class="dt-center">RANGE</th>
			<th class="dt-center">PAGE</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td align="center">${search.totalCount}</td>
			<td align="center">${search.rangeSize}</td>
			<td align="center">${search.pageSize}</td>
			<td align="center">
				<b>전체:</b> ${search.rangeCount}
				<b>현재:</b> ${search.rangeNo}
			</td>
			<td align="center">
				<b>전체:</b> ${search.pageCount}
				<b>현재:</b> ${search.pageNo}
			</td>
		</tr>
	</tbody>
</table>

<br/>

<form:form modelAttribute="search" method="GET">
	<form:hidden path="pageNo"/>	<%-- JSP PAGING 현재 페이지 번호 --%>
	<form:hidden path="rangeNo"/> <%-- JSP PAGING 현재 범위 번호 --%>
	<form:hidden path="pageSize"/> <%-- JSP PAGING 페이지 당 레코드 카운트 --%>
	<form:hidden path="rangeSize"/> <%-- JSP PAGING 범위 당 페이지 사이즈   --%>
	<form:hidden path="totalCount"/> <%-- JSP PAGING 현재 검색조건 글의 카운트   --%>
	<form:hidden path="pageCount"/> <%-- JSP PAGING 현재 검색조건 페이지 카운트   --%>
	<form:hidden path="rangeCount"/> <%-- JSP PAGING 현재 검색조건 범위 카운트   --%>

	검색어 유형:
	<form:select path="search_type">
		<form:option value="">없음</form:option>
		<form:option value="test_key">test_key</form:option>
		<form:option value="var1">var1</form:option>
		<form:option value="var2">var2</form:option>
		<form:option value="var3">var3</form:option>
	</form:select>

	검색어:
	<form:input path="search_text"/>
	<form:button> 검색 </form:button>


	<a id="anchor_excel" href="javascript:void(0);">엑셀다운로드</a>

	<a id="anchor_test" href="javascript:void(0);">POST TEST</a>


</form:form>

<br/>

<div style="border-style: solid">
<div>
	<table border="1">
		<thead>
			<tr>
				<th class="dt-center">test_key</th>
				<th class="dt-center">var1</th>
				<th class="dt-center">var2</th>
				<th class="dt-center">var3</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${paging.data}"  var="data">
				<tr>
					<td>${data.test_key}</td>
					<td>${data.var1}</td>
					<td>${data.var2}</td>
					<td>${data.var3}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
 </div>
<div>

<button disabled="disabled" id="btn_first_page">[첫 PAGE]</button>
<button disabled="disabled" id="btn_prev_range">[이전 RANGE]</button>
<button disabled="disabled" id="btn_prev_page">[이전 PAGE]</button>

<c:forEach begin="${paging.startRange}" end="${paging.endRange}" var="idx">
	<c:choose>
			<c:when test="${ idx eq paging.page }">
				<b>${idx}</b>
			</c:when>
			<c:otherwise>
				<a class="ancher_page_no" href="#" > ${idx} </a>
			</c:otherwise>
	</c:choose>
</c:forEach>

<button disabled="disabled" id="btn_next_page">[다음 PAGE]</button>
<button disabled="disabled" id="btn_next_range">[다음 RANGE]</button>
<button disabled="disabled" id="btn_last_page" >[마지막 PAGE]</button>


<script type="text/javascript">
$(document).ready(function(){
	var basic_paging = new BasicPaging();
	basic_paging._method = "GET";
	basic_paging._action = "/test/jsp_paging.do";
	basic_paging._form_id = "search";
	<%-- [필수] 유효성 체크 --%>
	basic_paging.validate();

	<%-- 첫 PAGE BUTTON 활성화 --%>
	<c:if test="${paging.firstPage}">
		$("#btn_first_page").prop('disabled', false);
	</c:if>
	<%-- 이전 RANGE BUTTON 활성화 --%>
	<c:if test="${paging.prevRange}">
		$("#btn_prev_range").prop('disabled', false);
	</c:if>
	<%-- 이전 PAGE BUTTON 활성화 --%>
	<c:if test="${paging.prevPage}">
		$("#btn_prev_page").prop('disabled', false);
	</c:if>

	<%-- 다음 PAGE BUTTON 활성화 --%>
	<c:if test="${paging.nextPage}">
		$("#btn_next_page").prop('disabled', false);
	</c:if>
	<%-- 다음 RANGE BUTTON 활성화 --%>
	<c:if test="${paging.nextRange}">
		$("#btn_next_range").prop('disabled', false);
	</c:if>
		<%-- 마지막 PAGE BUTTON 활성화 --%>
	<c:if test="${paging.lastPage}">
		$("#btn_last_page").prop('disabled', false);
	</c:if>



	$("#btn_first_page").click(function(){
		<%-- 첫 페이지로 이동 --%>
		basic_paging.move_first_page();
	});
	$("#btn_last_page").click(function(){
		<%-- 마지막 페이지로 이동 --%>
		basic_paging.move_last_page();
	});
	$("#btn_prev_range").click(function(){
		<%-- 이전 범위로 이동 --%>
		basic_paging.move_prev_range();
	});
	$("#btn_next_range").click(function(){
		<%-- 다음 범위로 이동 --%>
		basic_paging.move_next_range();
	});
	$("#btn_prev_page").click(function(){
		<%-- 이전 페이지로 이동 --%>
		basic_paging.move_prev_page();
	});
	$("#btn_next_page").click(function(){
		<%-- 다음 페이지로 이동 --%>
		basic_paging.move_next_page();
	});

	$("a.ancher_page_no").click(function(){
		var page_no = $( this ).text();
		if( $.isNumeric( page_no ) ){
			<%-- 선택된 PAGE NO 로 이동 --%>
			basic_paging.move_page_no( page_no );
		}
	});


});


</script>


</div>






</div>

</body>

</html>



