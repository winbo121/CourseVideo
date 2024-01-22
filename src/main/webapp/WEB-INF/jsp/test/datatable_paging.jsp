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
	initDatatables();

	<%-- search form submit --%>
	$("#search").submit(function() {
		return false;
	});

	<%-- 검색버튼 클릭 --%>
	$("#btn_search").click(function(){
		localBasicDataTable.reload();
	});

	<%-- 엑셀다운로드 --%>
	$("#anchor_excel").click(function(){
		<%-- AJAX DATA --%>
		var ajax_data = localBasicDataTable.getAjaxData();

		<%-- SEARCH FORM DATA --%>
		var form_data = new FormData( $("#search")[0] );

		var action = "/test/datatable_excel.do";
		excel_down_datatable( action, form_data, ajax_data );
	});

});

<%--  #dd-table 테이블에 대한 DATA TABLE 관리 객체  --%>
var localBasicDataTable;

function initDatatables() {

	var _columns = [
						{data: "test_key" ,name: "A.test_key"}
						,{data: "var1" ,name: "A.var1" }
						,{data: "test_key" ,name: "A.test_key"}
						,{data: "var1" ,name: "A.var1" }
						,{data: "var2" ,name: "A.var2"}
						,{data: "var3" ,name: "A.var3" }
						,{data: "var3" ,name: "A.var3" }
	];

	var _columnDefs = [
		{
			targets: 0,
			visible: true,
			orderable: false,
			className: "dt-center",
			render: function (data, type, row, meta ) {
				var key = data;
				var check_id = '_check_'+key;
				var check_box = '<div class="icheck-primary clearfix">';
					check_box += ' <input type="checkbox" id="'+check_id+'" class="dt-check" value="'+data+'"> ';
					check_box += ' <label for="'+check_id+'"></label> ';
					check_box += '</div>';
				return check_box;
			}
		},
		{
			targets: 1,
			visible: true,
			orderable: false,
			className: "dt-center",
			render: function (data, type, row, meta ) {
				var key = data;
				var check_id = '_check_'+key;
				var check_box = '<div class="icheck-primary clearfix">';
					check_box += ' <input type="checkbox" id="'+check_id+'" class="dt-check" value="'+data+'"> ';
					check_box += ' <label for="'+check_id+'"></label> ';
					check_box += '</div>';

				return check_box;
			}
		},
		{
			targets: 2,
			visible: true,
			orderable: true,
			className: "dt-center",
			render: function (data) {
				return data;
			}
		},
		{
			targets: 3,
			visible: true,
			orderable: true,
			className: "dt-center",
			render: function (data) {
				return data;
			}
		},
		{
			targets: 4,
			visible: true,
			orderable: true,
			className: "dt-center",
			render: function (data) {
				return data;
			}
		},
		{
			targets: 5,
			visible: true,
			orderable: true,
			className: "dt-center",
			render: function (data) {
				return data;
			}
		},
		{
			targets: 6,
			visible: true,
			orderable: false,
			className: "dt-center",
			render: function (data, type, row, meta ) {

				var selectName = row.selectName;
				var selectValue = row.selectValue;
				var select_box = '';
	                select_box += '<select class="form-control selectbox-table width-auto fs-14">';
	                select_box += '<option>전체</option>';
	                select_box += '<option>1111</option>';
	                select_box += '<option>2222</option>';
	                select_box += '<option>3333</option>';
	              	select_box += '</select>';
				return select_box;

			}
		}
	];


	<%-- DOUBLE 클릭 함수  row_data : 더블클릭한 row 의 데이터  --%>
	var _dbclick_func = function( row_data ){
		console.log("double click");
	};


	<%-- DATA TABLE 함수 생성 --%>
	var basicDataTable = new BasicDataTable();
		<%-- DOM 상의 TABLE ID --%>
		basicDataTable._table_id = "dd-table";
		<%-- 페이징 사용 여부 --%>
		basicDataTable._paging = true;
		<%-- <cms:limits> TAG 를 통해서 조회한다.   --%>
		basicDataTable._page_length = 10;
		<%-- <cms:limits> TAG 를 통해서 조회한다. --%>
		basicDataTable._length_menu = [ [10,30,50] ,[10,30,50] ];
		basicDataTable._order =  [  [2, "asc"]  ];
		basicDataTable._columns = _columns;
		basicDataTable._column_defs = _columnDefs
		basicDataTable._ajax_method = "POST";
		basicDataTable._ajax_action =  "/test/datatable_paging.do";

		<%-- 초기화시 데이터 테이블 DRAW 여부 ( default: true ) --%>
		basicDataTable._is_init_table_draw = true;
		<%-- TBODY TR SELECTED 사용 여부 ( default: false )  --%>
		basicDataTable._is_tbody_tr_seleted = true;


		<%-- 드래그앤 드랍 사용 여부 --%>
		basicDataTable._is_dnd = false;

		<%-- AJAX 전송전 유효성 체크 --%>
		basicDataTable._valid_func	= function(){
												return true;
												// return $("#search").valid();
										   };
		<%-- 데이터 테이블 더블클릭 함수  --%>
		basicDataTable._dbclick_func = _dbclick_func;

		<%-- AJAX 전송시 요청 데이터 세팅 함수 --%>
		basicDataTable._ajax_data =  function(){
												<%-- search form 의 데이터를 JSON 객체로 변환한다. --%>
												var req_json = $("#search").serializeObject();
												return req_json;
											};
		<%-- 데이터테이블 초기화 완료 함수 초기화 완료후 1번만 실행된다.  --%>
		basicDataTable._init_complete_func = function( data_table ){

			var value = "0";
			localBasicDataTable.doCheck( 0, value );

			var value2 = "9";
			localBasicDataTable.doCheck( 0, value2 );

		};

		<%-- pageNo, order, limt 의 정보데이터 조회 --%>
		var paged_navi_data = $("#pagedNavi").val();
		<%-- pageNo, order, limt 의 세팅--%>
		var is_succ = basicDataTable.initPageNaviData( paged_navi_data );
		<%-- INIT 한번만 사용되고 삭제된다.
		$("#pagedNavi").val(""); --%>


		<%-- DATA TABLE 초기화  --%>
		basicDataTable.init();

	<%-- 세팅 --%>
	localBasicDataTable = basicDataTable;
}


</script>

</head>

<body>
<br/><br/><br/><br/><br/>
DATA TABLE
<div style="border-style: solid">

	<form:form modelAttribute="search">
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
	<form:button id="btn_search" > 검색 </form:button>

	<a id="anchor_excel" href="javascript:void(0);">엑셀다운로드</a>


	</form:form>



		<table id="dd-table" class="table table-outline dataTable">
			<thead>
				<tr>

				  <th class="sorting_disabled">
                    <div class="icheck-primary">
                      <input type="checkbox" id="all_check">
                      <label for="all_check">체크0</label>
                    </div>
                  </th>
				  <th class="sorting_disabled">
                    <div class="icheck-primary">
                      <input type="checkbox" id="all_check2">
                      <label for="all_check2">체크1</label>
                    </div>
                  </th>
					<th class="dt-center">test_key</th>
					<th class="dt-center">var1</th>
					<th class="dt-center">var2</th>
					<th class="dt-center">var3</th>
					<th class="dt-center">셀렉트박스5</th>
				</tr>
			</thead>
			<tbody>
			</tbody>
		</table>


</div>

</body>

</html>



