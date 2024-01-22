<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>


<div class="remodal" role="dialog"
	  data-remodal-id="modal">
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


