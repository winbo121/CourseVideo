   퓨ㅡ,B6Y B<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<script type="text/javascript" >
$(document).ready (function(){

	<%-- MODAL OPEN 클릭시 --%>
	$("#btn_modal_open").click(function(){
		console.log("############# btn_modal_open CLICKED...");
		var remodal_element =  $('[data-remodal-id=modal]');

		console.log("INPUT 객체들 초기화");
		var input_elements = $( remodal_element ).find("input:text, textarea");
		$( input_elements ).val("");

		<%-- RE MODAL OPEN 성공 이후 후처리 함수 --%>
		var open_succ_func = function(){
			alert("RE_MODAL OPEN....");
		};

		basicReModal = new BasicReModal();
			basicReModal._remodal_element = remodal_element;
			basicReModal._open_succ_func = open_succ_func;
		basicReModal.open();
		});

});




</script>

<br/><br/><br/><br/><br/>
<div class="container" id="guidePage">
    <div class="headWrap subWrap">
            <p>샘플모달</p>

    </div>
    <div class="containerArea mt220">
        <div class="content typeSub" id="content">
		<section>
	         <article class="pageTab">

				<button id="btn_modal_open" class="write">MODAL_OPEN_1</button>

	         </article>
        </section>
        </div><!-- //content -->
    </div><!-- //containerArea -->
</div>



<div class="remodal" role="dialog"  data-remodal-id="modal">
  <button data-remodal-action="close" class="remodal-close" aria-label="Close"></button>
  <div>
        <div class="modalForm">
            <h4>게시글 작성</h4>
            <p>
                <span><i class="fas fa-angle-right" style="color:#fa9926; margin-right: 5px;"></i>제목</span>
                <span>

                	<input type="text" class="txt" name="" value="">

                </span>
            </p>
            <p class="mt10">
                <span><i class="fas fa-angle-right" style="color:#fa9926; margin-right: 5px;"></i>내용</span>
                <span>
                	<textarea class="txt" rows="4"></textarea>

                </span>
            </p>
            <p class="mt10 upload">
                <span><i class="fas fa-angle-right" style="color:#fa9926; margin-right: 5px;"></i>사진 올리기</span>
                <span>
                    <button class="image-search mgt_5 mr10">파일 찾기</button><i class="mgt_5">image.jpg</i>
                </span>
            </p>
        </div>
  </div>
  <br>
  <button data-remodal-action="cancel" class="remodal-cancel">취소</button>
  <button data-remodal-action="confirm" class="remodal-confirm">입력</button>
</div>


