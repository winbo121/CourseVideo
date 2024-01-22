<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%-- Summernote --%>
<script type="text/javascript" src="<c:url value='/assets/pc/test/summernote/js/summernote-lite.js'/>"></script>
<script src="<c:url value='/assets/pc/test/summernote/js/lang/summernote-ko-KR.js'/>"></script>

<link rel="stylesheet" href="<c:url value='/assets/pc/test/summernote/css/summernote-lite.css'/>">


<style>

	.kice-sch {
	    padding: 30px 0;
	    background-color: #f6f6f6;
	    text-align: center;
	}
	
	.kice-sch form .sch-int {
	    flex: 1;
	    padding: 5px 8px;
	    height: 37px;
	    width:310px;
	    border: 1px solid #ccc;
	    background-color: #fff;
	    box-sizing: border-box;
	}
	
	.kice-sch form .sch-btn {
	    width: 80px;
	    height: 37px;
	    outline: 0;
	    border: 1px solid #777;
	    background-color: #fff;
	    line-height: 1;
	    vertical-align: bottom;
	    color: #555;
	}

	.item {
		margin-top:30px;
	}
	
	.item input {
		width:310px;
		height: 35px;
		border: 1px solid #ccc;
	}
	
	.item textarea {
		width:800px;
		height:200px;
	}
	
	.item div {
		margin-bottom:10px;
	}

</style>

<script type="text/javascript" >

<%-- SUMMERNOTE 객체 --%>
function BasicSummerNote() {
	
	<%-- 썸머노트를 로딩할 타겟 (jQuery 식으로 받음 ex. #summernote .summernote input[name='summernote'] ) --%>
	this._target;
	
	<%-- 에디터 높이, MIN/MAX 높이값 설정 --%>
	this._size = { "height" : 300,
					"minHeight" : null,
					"maxHeight" : null
				 };
	
	<%-- 에디터 로딩후 포커스를 맞출지 여부 --%>
	this._focus = true;
	
	this._lang = "ko-KR";
	
	this._placeholder = "";
	
	this._doOpen = function() {
		var editor_size = this._size;
		var target = this._target;
		$( target ).summernote({
			height: editor_size[ "height" ],
			  minHeight: editor_size[ "minHeight" ],
			  maxHeight: editor_size[ "maxHeight" ],
			  focus: this._focus,
			  lang: this._lang,
			  placeholder: this._placeholder
		});
	}
}


$(document).ready (function(){
	
	var basicSummerNote = new BasicSummerNote();
		basicSummerNote._target = ".summernote-textarea";
		basicSummerNote._lang = "ko-KR";
		basicSummerNote._placeholder = "데이터를 입력해 주세요...";
		basicSummerNote._size = { "height" : 300,
									"minHeight" : null,
									"maxHeight" : null,
								};
		basicSummerNote._doOpen();
	
	<%-- 검색 버튼 클릭시 --%>
	$("#btn_search").on( "click", function(){
		bookSeqSearch();
	});
	
	<%-- 등록 버튼 클릭시 --%>
	$("#btn_regist").on( "click", function(){
		
		var confirm_func = function() {
			var form_data = new FormData( $("#regist")[0] );
			var action = "/test/kice/regist.do";
			
			var succ_func = function() {
				var reload_func = function() {
					var url = "/test/kice/data.do";
					move_get( url, null );
				}
				
				alert_success( "자료를 등록하였습니다. [SUCCESS]", reload_func );
			}
			
			ajax_form_post( action, form_data, succ_func );
		}
		
		var cancel_func = function() {
			alert_info( "취소되었습니다.", null );
		}
		
		confirm_warning( "등록하시겠습니까?" , confirm_func, cancel_func );
		
	});
	
	
	$("#search_book_name, #search_publisher").keydown(function(key) {

		if (key.keyCode == 13) {
			bookSeqSearch();
		}

	});
	
});

function bookSeqSearch() {
	var form_data = new FormData( $("#search")[0] );
	var action = "/test/kice/search.do";
	
	var succ_func = function( resData, status ) {
		
		if( status === "success" ) {
			console.log( resData.length, resData );
			var cnt = resData.length;
			 
			if( cnt > 1 && $.isEmptyObject( $( "#search_publisher" ).val() ) ) {
				alert_warning( "동일한 제목이 2권이상 있습니다. <br> 출판사를 입력해서 재조회해 주세요." );
				return false;
			}
			
			if( cnt > 1 && ! $.isEmptyObject( $( "#search_publisher" ).val() ) ) {
				alert_warning( "동일한 제목이 2권이상 있습니다. <br> DB를 확인해 주세요." );
				return false;
			}
			
			
			if( cnt == 0  ) {
				alert_error( "검색 결과가 없습니다. <br> (책 제목을 재확인해 주세요. <br> 재확인 후에도 없으면 DB를 확인해 주세요.)" );
				return false;
			}
			
			var book_seq = resData[0];
			var bookSeqSettings = function() {
				$( "#book_seq" ).val( book_seq );
			}
			
			alert_success( "확인 버튼을 누르면 book_seq가 세팅됩니다. [SUCCESS]",bookSeqSettings );
			
			
			
		} else {
			alert_error( "통신 실패하였습니다.", null );
		}
		
	}
	
	ajax_form_post( action, form_data, succ_func );
}

</script>


<div class="container" id="guidePage">
    <div class="headWrap subWrap">
            <p>평가원 교수·학습 자료</p>
    </div>	
    <div class="containerArea mt220">
        <div class="content typeSub" id="content">
        	<div class="faq-tab">
                <div class="kice-sch">
                       <form id="search">
	                       
	                       <input id="search_book_name" name="search_book_name" type="text" class="sch-int mr20" value="" placeholder="책 제목을 입력해 주세요" />
	                       
	                       <input id="search_publisher" name="search_publisher" type="text" class="sch-int mr5" value="" placeholder="출판사를 입력해 주세요" />
	                       <button type="button" id="btn_search" class="sch-btn">검색<i class="fas fa-search" style="margin-left: 5px;"></i></button>
                       </form>
                       
                       
                </div>
			</div>
        	<form id="regist"> 
	        	<div class="item">
	        		<h2>도서목록순번 ( book_seq )</h2> <br/>
	        		<div>book_seq&nbsp;&nbsp; <input type="text" id="book_seq" name="book_seq" placeholder="book_seq" /> </div>
	        	</div>
	        	<div class="item">
	        		<h2>이 책을 소개하는 이유</h2> <br/>
	        		<div>키워드&nbsp;&nbsp; <input id="book_keyword" name="book_keyword" type="text" placeholder="키워드 입력하세요" /> </div>
			        <textarea class="summernote-textarea" id="intro_reason" name="intro_reason" ></textarea>
		        </div>
		        
		        <div class="item">
	        		<h2>독서 활동 추천</h2> <br/>
	        		<p><strong>박스 안 데이터</strong></p>
			        <textarea class="summernote-textarea" id="book_recomm_rect" name="book_recomm_rect" ></textarea>	<br/>
			        
			        <p><strong>그 외</strong></p>
			        <textarea class="summernote-textarea" id="book_recommend" name="book_recommend"></textarea>	<br/>
		        </div>
		        
		        
		        <div class="item">
	        		<h2>교과 연계 방향</h2> <br/>
			        <textarea class="summernote-textarea" id="textbook_link" name="textbook_link"></textarea>	<br/>
		        </div>
		        
		        
		        <div class="item">
	        		<h2>어휘 학습</h2> <br/>
			        <textarea class="summernote-textarea" id="words_activity" name="words_activity"></textarea>	<br/>
		        </div>
	        </form>
        	
        	<div class="mt10">
       			<button id="btn_regist" type="button" class="btn-modify">등록</button>
        	</div>
        </div>
	</div>
</div>