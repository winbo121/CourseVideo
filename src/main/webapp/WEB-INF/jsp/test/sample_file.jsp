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


<%-- 내부 리소스 파일 다운로드 --%>
$("#btn_resource_down").click(function(){

	var type = "HWP_001";
	<%-- 파일 다운로드 성공시 실행되는 함수 --%>
	var succ_func = function( ){};
	<%-- 파일 다운로드 실패시 실행되는 함수 --%>
	var fail_func = function( ){};
	<%-- 파일 다운로드  --%>
	resource_down( type, succ_func, fail_func  );

});


<%-- 파일 추가 --%>
$("#btn_file_upload").click(function(){
	var form = $("#form_add_file")[0];
	var form_data = new FormData( form );

	var action = "/testfile/fileupload.do";
	<%-- AJAX 후처리 함수 (HTTP STATUS 200 인경우만 동작한다.)  --%>
	var succ_func = function( resData, status ){
		 alert( "파일업로드 성공" );
	};

	<%-- AJAX FORM DATA POST 전송 --%>
	ajax_form_post( action, form_data,  succ_func );

});








<%-- 파일 리스트 조회 --%>
$("#btn_file_list").click(function(){
	<%-- 리스트 초기화 --%>
 	$('#file_list > tbody').empty();

 	<%-- AJAX URL  context path 는 comJs.jsp 에서 붙여준다. --%>
	var action = "/testfile/sample_file.do";
	<%-- AJAX 요청값 (JSON) --%>
	var json = {};

	 <%-- AJAX 후처리 함수 (HTTP STATUS 200 인경우만 동작한다.)  --%>
	 var succ_func = function( resData, status ){
		 	var file_list = resData.file_list;
			if( !$.isEmptyObject( file_list ) ){
				$.each( file_list, function(index, file_data ){
					 $('#file_list_tmpl').tmpl( file_data ).appendTo('#file_list > tbody');
				});
			}else{
				$('#file_list_empty').tmpl().appendTo('#file_list > tbody');
			}
	 };

	<%-- AJAX JSON DATA POST 전송  --%>
	 ajax_json_post( action, json, succ_func  );
});



var _table_tbody =  $( "#file_list"  ).children("tbody");
	$( _table_tbody ).on('click', 'a', function () {

		var target_tr = $( this ).parents("tr");
		var file_seq = target_tr.data("file_seq");

		if( $( this ).hasClass( "download" ) ){
			fileDownload( file_seq );
		}else if( $( this ).hasClass( "remove" ) ){
			removeFile( file_seq );
		}

	});


});


function fileDownload( file_seq ){
	<%-- 파일 다운로드 성공시 실행되는 함수 --%>
	var succ_func = function( ){};
	<%-- 파일 다운로드 실패시 실행되는 함수 --%>
	var fail_func = function( ){};
	<%-- 파일 다운로드  --%>

	file_down( file_seq, succ_func, fail_func  );
}


function removeFile( file_seq ){
 	<%-- AJAX URL  context path 는 comJs.jsp 에서 붙여준다. --%>
	var action = "/testfile/fileupload.do";
	<%-- AJAX 요청값 (JSON) --%>
	var json = { file_seq: file_seq };

	 <%-- AJAX 후처리 함수 (HTTP STATUS 200 인경우만 동작한다.)  --%>
	 var succ_func = function( resData, status ){
	 };

	<%-- AJAX JSON DATA DELETE 전송  --%>
	ajax_json_delete( action, json, succ_func  );

}

</script>
</head>

<body>


<a id="btn_resource_down" href="javascript:void(0);" >내부 RESOURCE 파일 다운로드</a>
<br/>
<br/>
<br/>

<div>
	SAMPLE FILE UPLOAD
</div>




<script type="text/javascript" >
$(document).ready (function(){

	<%-- 엑셀 다운로드 --%>
	$("#anchor_excel").click(function(){
		var action = "/testfile/excel.do";
		excel_down( action, null );
	});

	<%-- 신규파일 삭제 버튼 클릭시 --%>
	$( "#form_modify_file table tbody tr" ).on('click', 'a', function () {
		var target_td = $(this).parents('td');
		$( target_td ).remove();
	});

	<%-- 신규파일 추가 버튼 클릭 --%>
	$("#btn_file_add").click(function(){
		<%-- 신규 파일 추가 --%>
		var tbody_tr = $("#form_modify_file table tbody tr");
		$('#upload_file_td').tmpl().appendTo( tbody_tr );
	});

	<%-- 파일 수정 --%>
	$("#btn_file_modify").click(function(){

		<%-- 업로드할 파일들 --%>
		var upload_files = $("#form_modify_file input[name='upload_files']");

		<%-- x_file 은 신규 등록되는 파일 이외의 모든 기존 파일은 삭제된다.--%>
		var file_seqs=[];

		<%-- 신규 파일 구분값 --%>
		var x_file = get_x_file_promise();


		var is_valid_file = true;

		if( !$.isEmptyObject( upload_files ) ){
			$.each( upload_files, function( index, upload_file  ){
				var file = $( upload_file );
				if( file.val() != '' ){
					file_seqs.push( x_file );
				}else{
					<%--  이부분은 jquery validator 로 구현하세요. --%>
					is_valid_file = false;
				}
			});
		}

		<%--  이부분은 jquery validator 로 구현하세요. --%>
		if( is_valid_file == false ){
			alert("파일이 존재하지 않음.");
			return;
		}

		var form = $("#form_modify_file")[0];
		var form_data = new FormData( form );

		form_data.append("file_seqs", file_seqs );

		var action = "/testfile/fileupload.do";

		<%-- AJAX 후처리 함수 (HTTP STATUS 200 인경우만 동작한다.)  --%>
		var succ_func = function( resData, status ){
			 alert( "파일수정 성공" );
		};

		<%-- AJAX FORM DATA PUT 전송  --%>
		ajax_form_put( action, form_data, succ_func  );
	});





});


</script>

<!-- <a href="javascript:void(0);" id="anchor_excel">엑셀다운로드</a> -->


<form id="form_modify_file">
<div style="border-style: solid">
	<table border="1">
		<thead>
			<tr>
				<td colspan="3">
					파일수정 샘플
					<a id="btn_file_modify" href="javascript:void(0);" style="color:red;">파일수정</a>
					&nbsp;&nbsp;&nbsp; / &nbsp;&nbsp;&nbsp;
					<a id="btn_file_add" href="javascript:void(0);" style="color:red;">신규파일추가</a>
				</td>
			</tr>
			<tr>
				<td>신규파일</td>
			</tr>
		</thead>
		<tbody>
			<tr>
			</tr>
		</tbody>
	</table>

</div>
</form>


<script type="text/x-jquery-tmpl" id="upload_file_td">
	<td><input type="file" name="upload_files" multiple="multiple" /> <a href="javascript:void(0);">삭제</a> </td>
</script>



<br/><br/>
<div style="border-style: solid">
	파일 리스트 <a id="btn_file_list" href="javascript:void(0);" style="color:red;">조회</a>
	<table border="1" id="file_list">
	<thead>
		<tr>
			<td> file_seq </td>
			<td> file_reg_gb </td>
			<td> tar_info_pk </td>
			<td> orgin_filenm </td>
			<td> save_filenm </td>
			<td> use_img_server </td>
			<td> IMG </td>
			<td colspan="2">  </td>
		</tr>
	</thead>
	<tbody>


	</tbody>
	</table>

</div>


<%-- TEMPLATE --%>


<script type="text/x-jquery-tmpl" id="file_list_tmpl">
	<tr data-file_seq=\${file_seq} >
		<td>\${file_seq}</td>
		<td>\${file_reg_gb}</td>
		<td>\${tar_info_pk}</td>
		<td>\${orgin_filenm}</td>
		<td>\${save_filenm}</td>
		<td>\${use_img_server}</td>
		<td><img width=100" height="70" src="\${img_url}" /></td>
		<td>
			<a href="javascript:void(0);" class="download"   );">다운로드</a>
		</td>
		<td>
			<a href="javascript:void(0);" class="remove"  );">삭제
			</a>
		</td>
	</tr>
</script>

<script type="text/x-tmpl" id="file_list_empty">
<tr>
	<td colspan="11" align="center">파일 없음</td>
</tr>
</script>

</body>

</html>



