<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script type="text/javascript" src="https://cdn.jwplayer.com/libraries/RPTbBGeS.js"></script>

<style>
.liHover:hover {
  background-color: #dcdcdc;
}

</style>

<div id="score_remodal2" class="remodal" data-remodal-id="modal" role="dialog" aria-labelledby="modal1Title" aria-describedby="modal1Desc">
  <button id="btn_score_close" data-remodal-action="close" class="remodal-close" aria-label="Close"></button>
  <div>
        <div class="modalForm">
            <h4 id="modal1Title">별점을 선택해주세요</h4>
            <div class="rating">
                 	<form class="mb-3" name="myform" id="myform" method="post">
						<fieldset>
							<!-- <span class="text-bold">별점을 선택해주세요</span> -->
							<input type="hidden" id="my_star_point" value ="${courseInfo.star_point}"/>
							<input type="radio" name="reviewStar" value="5" id="rate1"><label
								for="rate1">★</label>
							<input type="radio" name="reviewStar" value="4" id="rate2"><label
								for="rate2">★</label>
							<input type="radio" name="reviewStar" value="3" id="rate3"><label
								for="rate3">★</label>
							<input type="radio" name="reviewStar" value="2" id="rate4"><label
								for="rate4">★</label>
							<input type="radio" name="reviewStar" value="1" id="rate5"><label
								for="rate5">★</label>
						</fieldset>
					</form>
            </div>
        </div>
  </div>
    <div class="widget-btn" align="right">
   		<button class="btn btn-black prev_btn" data-remodal-action="cancel" class="remodal-cancel" id="btn_score_calcel" >닫기</button> <!-- onclick="closeModal()" -->
		<button class="btn btn-info-light next_btn" data-remodal-action="confirm" id="btn_score_confirm">확인</button>
	</div>
</div>

<script type="text/javascript">
	var checkTimeInterval; /*시간 인터벌 시간체크 */
	var maxTime; /*처음 영상 시작할때 지정되는 시간(초)*/
	var saveFirstTime; /*저장된 처음시간을 잠시 저장*/		
	var realTime; /*스크롤이 움직일시 현재시간이 바뀔수 있으므로 원래 현재 시간을 저장*/	
	/*jw플레이어 컨텐츠에따라 동영상 조회되는 공통함수*/
	function jwplayerVideo(divId, contents_seq, playerOptions, controlCourse){
		
		var json ={}; 
		
		/*컨텐츠 정보를 위한 seq파라미터*/
		json['contents_seq'] = contents_seq;
		
		/*성공 함수*/
		var succ_func = function(resData, status){
			
			 var vod_gb = resData.contentsVideo.vod_gb;	 /*컨텐츠 구분*/
			 var vod_url = resData.contentsVideo.vod_url;	 /*컨텐츠 url*/
			 
			 
			 var url;
			 var subtitleUrl;
			 var beforeThumbnailUrl;
			 var thumbnailUrl;
			 playerOptions['flashplayer'] = "/jwplayer/player.swf";
			 /*컨텐츠 구분에 따른 파일 url 가공 분기처리*/
			 if(vod_gb == 'M'){
				 
				 var file_url = resData.videoFileList[0].file_url; /*파일 url*/		 
				 var file_ext = resData.videoFileList[0].file_ext	/*파일 타입*/		 
				 var subtitleFileList =  resData.subtitleFileList  /*자막 파일 리스트*/
				 var thumbnailFileList =  resData.thumbnailFileList /*썸네일 리스트*/
	 		 	 
				 url = file_url+"."+file_ext;
				 
		 	     /*해당 동영상 파일 옵션에 파일 url 가공해서 넣기 */
		 	     var sourseList = [];
			     sourseDic = {};
			     sourseDic['file'] = url;
			     sourseList.push(sourseDic);
			     playerOptions['sources'] = sourseList;      
				 
	 		 	
	 		 	 /*컨텐츠에 자막이 있을시*/
		 		 if(subtitleFileList.length >0){
		 			 
		 			 subtitleUrl = subtitleFileList[0].file_url;
		 			 
		 			 /*자막 부분 옵션에 추가*/
			 	     var subtitleList = [];
			 	     subtitleDic = {};
			 	     subtitleDic['file'] = subtitleUrl;
			 	     subtitleDic['kind'] = "captions";
			 	     subtitleDic['label'] = "한글";
			 	     subtitleList.push(subtitleDic);
				     playerOptions['tracks'] = subtitleList;  
		 		 }
		 		 
		 		 /*컨텐츠에 썸네일이 있을시*/
		 		 if(thumbnailFileList.length>0){
		 			 beforeThumbnailUrl = thumbnailFileList[0].img_url;
		 			 thumbnailUrl = beforeThumbnailUrl.replace(/\\/ig,"/");
		 			 /*썸네일 부분 옵션에 추가*/
		 			 playerOptions['image'] = thumbnailUrl;	
		 		 }
			 }
			 else if(vod_gb == 'Y'){
				url = vod_url;
				playerOptions['file'] = url;   
			 }
			 	        
	 	     
		     


		     /*jw플레이어 옵션에 따라 동영상 그리기*/
		     jwplayer(divId).setup(playerOptions);
		     
		     /*강좌쪽에서 동영상 헨들링에 따라 데이터 저장 및 수정하는 함수인데 선언을 하지 않으면 안쓰게 된다.*/
			 if( $.isFunction( controlCourse ) ){
				 controlCourse();
			 }
		     
		 }
		
		 /*상세 컨텐츠 조회*/
		 ajax_json_get("/course/jwplayerVideo.do",json, succ_func);
	};
	
	/*컨텐츠리스트중 하나 클릭시 발생하는 이벤트*/
    function contentsClick(event,contents_mapped_seq_param,course_seq_param,contents_seq_param){
    	if(event.target.id == 'autoPlayTrue'){
    		jwplayerView(contents_mapped_seq_param,course_seq_param,contents_seq_param,true);
    	}
    	else{
    		jwplayerView(contents_mapped_seq_param,course_seq_param,contents_seq_param,false);
    	}
    }
	
	/*영상 5초마다 시간체크 함수*/
	function checkVideoTime(contents_mapped_seq ){
	
		var learn_time = realTime;
						   
		if(learn_time > maxTime){
			var json = {}
			maxTime = learn_time;
			json['learn_time'] = learn_time;	
			json['contents_mapped_seq'] = contents_mapped_seq;	
			ajax_json_post("/course/checkVideoTime.do",json);
					  
		}
							
	};
	
	/*일시정지를 할 경우 그 시간대를 체크*/
	function checkStopVideoTime(contents_mapped_seq ,course_seq,contents_seq , vod_time_sec){
	
		var learn_time = realTime;
						   
		var succ_func = function(resData, status){
			/*일시 정지할시 다시 옆 메뉴 컨텐츠 리스트 새로고침*/
			jwplayerView(contents_mapped_seq , course_seq,contents_seq)
		};
						    
		if(learn_time > maxTime){
			var json = {}
			maxTime = learn_time;
			json['learn_time'] = learn_time;	
			json['contents_mapped_seq'] = contents_mapped_seq;
			ajax_json_post("/course/checkVideoTime.do",json,succ_func);
					 
		}
						
	 };
	
	/*일시정지 및 동영상 시작과 끝일때 사이드 동영상 메뉴 조회부분을 새로 최신화 해주는 작업*/
	function reloadProgressRate(resData, vod_gb,course_seq,contents_seq){	   
		     var str ='';
	         /*초기화작업*/
		     $( '#collapseOne' ).empty();		
		     var watching_time = resData.courseInfo.watching_time;
		     var all_secound = resData.courseInfo.all_secound;
		     var course_persent = resData.courseInfo.course_persent;
	        
		    <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >   
			    if(vod_gb == 'M'){ /*mp4일 경우 퍼센트 시간 그리는 작업*/
			    		str += '<div class="progress-stip">'						  
				       	str += '<div class="progress-bar bg-success progress-bar-striped active-stip"></div>'
					    str += '</div>'			   
					    str += '<div class="student-percent lesson-percent">'
					    str += '<p>'+watching_time+'/'+ all_secound +'<span>'+course_persent+'%</span></p>'						    	
					    str += '</div>'
			    } 
		    </sec:authorize>
		   
		   	str += '<ul>'
		   	/*컨텐츠 옆 메뉴 그리는 작업*/
			for(var i =0; i<resData.courseContentsList.length; i++){
				
				var contents_mapped_seq_param = resData.courseContentsList[i].contents_mapped_seq;
				var course_seq_param  = resData.courseContentsList[i].course_seq;
				var contents_seq_param = resData.courseContentsList[i].contents_seq;
				var contents_watching_time = resData.courseContentsList[i].contents_watching_time;
				var contents_vod_time_sec = resData.courseContentsList[i].vod_time_sec;
				var contents_nm = resData.courseContentsList[i].contents_nm;
				
				<sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >  
					if(vod_gb == 'M'){/*mp4일 경우*/
						 str += '<li class="liHover" onclick="contentsClick(event,'+contents_mapped_seq_param+','+course_seq_param+','+contents_seq_param+')" style="text-decoration:none; cursor:pointer;">'
						 if(resData.courseContentsList[i].contents_seq == contents_seq){
							 str += '<div>'
						     str += '<text class="play-intro">'+contents_nm+'</text>'
						     str += '</div>'
						     str += '<div>'
						     str += '<text class="play-intro">'+contents_watching_time+'</text>'
							 str += '</div>'
						 }
						 else if(resData.courseContentsList[i].whatching_yn == 'ready' || resData.courseContentsList[i].whatching_yn == 'listening'){
							 str += '<div>'
							 str += '<text class="play-intro" style="color:black;">'+contents_nm+'</text>'
						     str += '</div>'
						     str += '<div>'
							 str += '<text class="play-intro" style="color:black;">'+contents_watching_time+'</text>'
							 str += '</div>'
						 }
						 else if(resData.courseContentsList[i].whatching_yn == 'complete'){
							 str += '<div style="text-decoration:none; cursor:pointer;">'
						     str += '<text class="play-intro" style="color:blue;">'+contents_nm+'</text>'
						     str += '</div>'
						     str += '<div style="text-decoration:none; cursor:pointer;">'
						     str += '<text class="play-intro" style="color:blue;">'+contents_watching_time+'</text>'
							 str += '</div>'
						 }							
	                     str += '<div>'
						 str +=  '<img id="autoPlayTrue" src="/assets/img/icon/play-icon.svg" alt="" >'
						 str += '</div>'
						 str += '</li>'     		 
					}else{
				    	 str += '<li class="liHover" onclick="contentsClick(event,'+contents_mapped_seq_param+','+course_seq_param+','+contents_seq_param+')" style="text-decoration:none; cursor:pointer;">'
				    	 str += '<div>'
						 str += '<text class="play-intro" style="color:black;">'+contents_nm+'</text>'		         
						 str += '</div>'
						 str += '<div>'
	                     str +=  '<img id="autoPlayTrue" src="/assets/img/icon/play-icon.svg" alt="" >'
						 str += '</div>'
						 str += '</li>'   		 
					}
				</sec:authorize>
				<sec:authorize access="! isAuthenticated()">
		    	 	 str += '<li  class="liHover" onclick="contentsClick(event,'+contents_mapped_seq_param+','+course_seq_param+','+contents_seq_param+')" style="text-decoration:none; cursor:pointer;" >'
		    	 	if(resData.courseContentsList[i].contents_seq == contents_seq){
		    	 		 str += '<div>'
						 str += '<text class="play-intro">'+contents_nm+'</text>'
						 str += '</div>'
						 str += '<div>'
						 str += '<text class="play-intro">'+contents_vod_time_sec+'</text>'
						 str += '</div>'
						 str += '<div  id="gts">'
						 str +=  '<img id="autoPlayTrue" src="/assets/img/icon/play-icon.svg" alt="" >'
						 str += '</div>'
		    	 	}
		    	 	else{
		    	 		 str += '<div>'
						 str += '<text class="play-intro" style="color:black;">'+contents_nm+'</text>'
						 str += '</div>'
						 str += '<div>'
						 str += '<text class="play-intro" style="color:black;">'+contents_vod_time_sec+'</text>'
						 str += '</div>'
						 str += '<div>'
				 		 str += '<img id="autoPlayTrue" src="/assets/img/icon/play-icon.svg" alt="" >'
				 		 str += '</div>'
		    	 	}
					 str += '</li>' 
				</sec:authorize>
			}
			str += '</ul>'
			var str2 = '';
			var point = '${courseInfo.star_point}';
			point = Math.floor(parseInt(point));
			if (watching_time == all_secound && watching_time!= null && all_secound != null) {
				str2 += '<div class="course-card">';
		    	str2 += 	'<div class="widget-btn">';
		    	if (resData.courseInfo.star_point != null) {
		    		str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 수정</button>';
		    		str2 += 	'</div>';
		    		str2 += 	'<div class="rating">';
		    		str2 += 	'<p><Strong>내가 등록한 별점 : '; 
		    		if (point == 5) {
		    			str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
					} else if(point >= 4.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
					} else if(point >= 4){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 2.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if (point >= 2) {
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 0.5){
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else {
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					}
		    		str2 +=     '('+point+')';
		    		str2 += 	'</Strong></p></div>';
				} else{
					str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 등록</button>';
					str2 += 	'</div>';
				}
		    	str2 += '</div>';
			} else if('${urlComplete}' === '1'){
				str2 += '<div class="course-card">';
		    	str2 += 	'<div class="widget-btn">';
		    	if (resData.courseInfo.star_point != null) {
		    		str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 수정</button>';
		    		str2 += 	'</div>';
		    		str2 += 	'<div class="rating">';
		    		str2 += 	'<p><Strong>내가 등록한 별점 : '; 
		    		if (point == 5) {
		    			str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
					} else if(point >= 4.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
					} else if(point >= 4){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 2.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if (point >= 2) {
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 0.5){
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else {
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					}
		    		str2 +=     '('+point+')';
		    		str2 += 	'</Strong></p></div>';
				} else{
					str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 등록</button>';
					str2 += 	'</div>';
				}
		    	str2 += '</div>';
				
			} else if('${youtubeComplete}' === '1'){
				str2 += '<div class="course-card">';
		    	str2 += 	'<div class="widget-btn">';
		    	if (resData.courseInfo.star_point != null) {
		    		str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 수정</button>';
		    		str2 += 	'</div>';
		    		str2 += 	'<div class="rating">';
		    		str2 += 	'<p><Strong>내가 등록한 별점 : '; 
		    		if (point == 5) {
		    			str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
					} else if(point >= 4.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
					} else if(point >= 4){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 3){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 2.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if (point >= 2) {
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1.5){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 1){
						str2 += "<i class='fas fa-star filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else if(point >= 0.5){
						str2 += "<i class='fas fa-star-half-alt filled'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					} else {
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
						str2 += "<i class='fas fa-star'></i>";
					}
		    		str2 +=     '('+point+')';
		    		str2 += 	'</Strong></p></div>';
				} else{
					str2 += 	'<button id="btn_score2" class="btn btn-info-light next_btn" style="width: 100%;" onclick="starPoint()"><i class="fas fa-star filled" style="color:yellow; margin-left: -3px; margin-right: 5px;"></i>별점 등록</button>';
					str2 += 	'</div>';
				}
		    	str2 += '</div>';
				
			} else {
				
			}
		    
				  
			$( '#collapseOne' ).append(str);
			//$( '.lesson-group2' ).html(str2);	  
			$( '#star' ).html(str2);	  
			
			$( '#collapseOne' ).addClass( 'show' );
			/*퍼센트 작업*/
			$(".active-stip").css("width",course_persent+"%");
	   };
	   
	function starPoint() {
		<%-- 과거에 내가 준 별점 점수 세팅 --%>
		var my_star_point = Math.round($("#my_star_point").val());
	 	if( my_star_point > 0 ) {
			$( "input[name='reviewStar'][value="+ my_star_point +"]" ).prop( "checked", true );
	 	}
		
		//별점 남기기 remodal OPEN
		var basicRemodal = new BasicReModal();
		 	basicRemodal._remodal_element = $( "#score_remodal2" );
		 	basicRemodal._open_succ_func = function() {
				
		 		//취소 버튼 이벤트 바인딩
		 		$( "#btn_score_calcel, #btn_score_close" ).on( "click", function(){
		 			$( "input[name='reviewStar']:checked" ).each( function(){
		 				$( this ).prop( "checked", false );
		 			});
		 			alert_info( "취소되었습니다.", null );
		 		});
		 		
		 		//저장 버튼 이벤트 바인딩
		 		$( "#btn_score_confirm" ).on( "click", function(){
					var star_point = $( "input[name='reviewStar']:checked" ).val();
					var course_seq = '${firstcourseContents.course_seq}';
					if( $.isEmptyObject( star_point ) ) {
						var reload_func = function() {
							var form_data = new FormData();
							var token = "${_csrf.token}";
							form_data.append("_csrf", token );
							form_data.append("course_seq", course_seq );
							var url = '/course/courseFindDetail.do';
							move_post( url, form_data );
						}
						alert_error( "별점을 선택하지 않았습니다.", reload_func );
						return false;
					}
					
					var confirm_func = function() {
						
						var action = "/course/starReviewInsert.do";
						//var course_seq = '${firstcourseContents.course_seq}';
						var star_memo = $( "#reviewContents" ).val();
						var json = { "course_seq":course_seq, "star_point":star_point };
						
						var succ_func = function( resData, status ) {
							var reload_func = function() {
								var form_data = new FormData();
								var token = "${_csrf.token}";
								form_data.append("_csrf", token );
								form_data.append("course_seq", course_seq );
								var url = '/course/courseFindDetail.do';
								move_post( url, form_data );
							}
							alert_success( "별점을 남겼습니다.", reload_func );
						}
						
						ajax_json_post( action, json, succ_func  );
					}
					
					var cancel_func = function() {
						alert_info( "취소되었습니다.", null );
					}
					
					confirm_warning( "이 강좌의 별점을 <strong>" + star_point + "점</strong> 으로 남기시겠습니까?" , confirm_func, cancel_func );
		 		});
				
		 	}
		 	
		 	basicRemodal.open();
		
	}
	   
	   /*컨텐츠가 url일 경우 */
	   function goUrlLink(url,contents_mapped_seq,learn_seq){
		       <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " > 
		       if ('${urlComplete}' == '0') {
		     		if(learn_seq== null){
						var json = {};
						json['contents_mapped_seq'] = contents_mapped_seq;
						/*url일 경우 데이터 0초로 저장*/
						var succ_func = function(resData, status){
							var reload_func = function () {
								location.reload();
							}
							if( status == 'success' ) {
								alert_success("해당강좌 패스 완료", reload_func );
							} else {
								alert_error("작업을 정상적으로 수행하지 못하였습니다.", null );
								return false;
							}
						}
						
		     		 	ajax_json_post("/course/insertFirstVideoTime.do",json,succ_func);
		     		} 
		        }
	    		</sec:authorize>
	       window.open(url);
	   };
	   
	   
	   /*컨텐츠가 유튜브일 경우 */
	   function goYoutubeLink(url,contents_mapped_seq,learn_seq){
		  
		       <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " > 
		       if ('${youtubeComplete}' == '0') {
		     		if(learn_seq== null){
						var json = {};
						json['contents_mapped_seq'] = contents_mapped_seq;
						/*url일 경우 데이터 0초로 저장*/
						var succ_func = function(resData, status){
							var reload_func = function () {
								location.reload();
							}
							if( status == 'success' ) {
								alert_success("해당강좌 패스 완료", reload_func );
							} else {
								alert_error("작업을 정상적으로 수행하지 못하였습니다.", null );
								return false;
							}
						}
						
		     		 	ajax_json_post("/course/insertFirstVideoTime.do",json,succ_func);
		     		} 
		       } 
		       </sec:authorize>
	       window.open(url);
	   };
	   
	   /*특수문자 깨지는 부분 치환하는 함수*/
	   function fixTitle(str){
		   var useStr=str;
		   
		   if(useStr !== undefined && useStr !== null && useStr !== ''){
			   useStr = useStr.replaceAll('&#39;',"'");
			   useStr = useStr.replaceAll('&quot;','"'); 
		   }
		   return useStr;
	   }
	   
	  /*각각 컨텐츠마다 jw플레이어 그리는 함수*/
	  function jwplayerView(contents_mapped_seq , course_seq,contents_seq, autoPlay){
		   
		   /*인터벌 함수 초기화*/
		   clearInterval(checkTimeInterval);
		   
		   var json = {};
		   json['course_seq'] = course_seq;
		   json['contents_mapped_seq'] = contents_mapped_seq;	
		   json['contents_seq'] = contents_seq;
		   
		   /*상세 조회 ajax성공 부분*/
		   var succ_func = function(resData, status){
			     
			     var vod_gb = resData.courseVideoInfo.vod_gb; /*컨텐츠 구분*/
			     var contents_nm = fixTitle(resData.courseVideoInfo.contents_nm); /*컨텐츠 이름*/
			     var vod_url = resData.courseVideoInfo.vod_url; /*컨텐츠 url*/
			     var vod_time_sec = resData.courseVideoInfo.vod_time_sec; /*컨텐츠 동영상 시간*/
			     var learn_seq = resData.courseVideoInfo.learn_seq; /*컨텐츠 이력 번호*/
			     var learn_time = resData.courseVideoInfo.learn_time; /*컨텐츠 이력 들은시간 초*/
			     
			     /*글자 해더쪽 적용부분*/
			     $("#setContentNm").text(contents_nm);
		     	
			     /*컨텐츠 구분이 mp4일때*/
		     	 if(vod_gb == 'M'){
		     		$("#outerLink").hide();
		     		/*일시정지 및 동영상 시작과 끝일때 사이드 동영상 메뉴 조회부분을 새로 최신화 해주는 작업*/
				     reloadProgressRate(resData ,vod_gb,course_seq,contents_seq);
					 
						
				     var controlCourse = function(){
				    	 
					     /*로그인 여부에 영상체크 분기처리*/
					     <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >
						    	 
						    		/*영상 처음 시작전일경우에는 0부터 만약 봤던것이면 그부분부터 볼수 있게 max설정*/
								     if(learn_seq == null){
								    	  maxTime = 0;
								    	  realTime = 0;
								    	  ajax_json_post("/course/insertFirstVideoTime.do",json);
								    	  
								     }
								     else{ 
								    	  maxTime=learn_time;
								    	  realTime = learn_time;
								     }
						    		
								     saveFirstTime = maxTime;
								     
								     /*영상 처음 시작할시*/
							        jwplayer('moviePlayer').on('firstFrame', function() {
										  
							        	  /*영상을 처음 본것인지 아니면 다 본것인지 체크하는 로직*/
								    	  if(vod_time_sec == learn_time ){
									      	  jwplayer('moviePlayer').seek(0);		      	  
								    	  }
								    	  else if(vod_time_sec < learn_time){ /*컨텐츠가 바뀔경우 다 0부터 저장*/
								    		  jwplayer('moviePlayer').seek(0);
								    		  maxTime=0
								    	  }
								    	  else{
									      	  jwplayer('moviePlayer').seek(maxTime);
									      	 
								    	  }
								    	  checkTimeInterval = setInterval(checkVideoTime,5000,contents_mapped_seq);     						
								      });
								      								      
								      
								      /*재생 스크롤 뒤로 가는것을 방지*/
								      jwplayer('moviePlayer').on('time', function(e) {
								    	    
											if( Math.floor(e.position) >= realTime && Math.floor(e.position) <= realTime+1){
													realTime = Math.floor(e.position)
											}
											else{
 										     	 var positionDiff = e.position - realTime;
	 										     if (positionDiff > 1) {
	 										         jwplayer('moviePlayer').seek(realTime);		             
	 										     }	             									
											}
								      });
								      
								      /*영상이 멈출때*/
								      jwplayer('moviePlayer').on('pause', function(e) {
								    	  
								    	  if(vod_time_sec != learn_time){
								    		   	    		  
								    		  checkStopVideoTime(contents_mapped_seq ,course_seq,contents_seq ,vod_time_sec ); 			    		
								    	  }				    			  				  			    	 
								      });
								      
								      
								      /*영상이 다 보고 끝난 경우*/	
								      jwplayer('moviePlayer').on('complete', function(e) {
								    	    clearInterval(checkTimeInterval);
										    var jsonParm = {}
										    var learn_time = vod_time_sec;	
											
										    var succ_func = function(resData, status){
										    	
										    	maxTime = learn_time;
										    	jwplayerView(contents_mapped_seq , course_seq,contents_seq)											    	
										    }
										    
										    jsonParm['learn_time'] = learn_time; 	
										    jsonParm['contents_mapped_seq'] = contents_mapped_seq; 
										    if(saveFirstTime != learn_time && realTime == learn_time){
										    	ajax_json_post("/course/checkVideoTime.do",jsonParm,succ_func);
										    	alert_success("동영상 시청이 완료 되었습니다.");
										    }
									    
								      });								   
	
					      </sec:authorize>
				     }
				     
				     /*jw플레이어에 따른 옵션 dictionary 만들기*/
		     		 var playerOptions = {};
		     		 
				     /*jw플레이어에 따른 옵션 기능들 추가*/
				     playerOptions['width'] = "100%"; /*가로길이*/
				     playerOptions['aspectratio'] = "16:9"; /*종황비*/
				     playerOptions['skin'] = "bekle"; /*스킨*/
				     playerOptions['playbackRateControls'] =  [0.75, 1, 1.25, 1.5]; /*재생속도*/
				     playerOptions['autostart'] =  autoPlay;	/*자동 플레이 유무*/
				     
				     var divId = 'moviePlayer';
				     
				     /*jw플레이어 핸들링없이 컨텐츠에따라 동영상 조회되는 공통함수*/
				     jwplayerVideo(divId,contents_seq,playerOptions,controlCourse);
		     		
		     	 }else if(vod_gb == 'O'){ /*컨텐츠가 url일 경우*/
		     		var urlLink = "javascript:goUrlLink('"+vod_url+"',"+contents_mapped_seq+","+learn_seq+")";
		     		 $("#urlLinkBtn").show();
		     		 //$("#showDetail").empty();
		     		 $("#lesson-group").hide();
		     		 //$("#player").hide();
		     		 $("#star").show();
		     		 $("#introduction").hide();
		     		 $("#outerLink").show();
		     		 $("#setContentNm").hide();
		     		 $("#urlLinkBtn").attr("onclick", urlLink);
		     		 
		     		 reloadProgressRate(resData, vod_gb,course_seq,contents_seq);
		     	 } else if(vod_gb == 'Y'){ /*컨텐츠가 유튜브일 경우*/
		     		var urlLink = "javascript:goYoutubeLink('"+vod_url+"',"+contents_mapped_seq+","+learn_seq+")";
		     		 $("#youtubeLinkBtn").show();
		     		 //$("#showDetail").empty();
		     		 $("#lesson-group").hide();
		     		 //$("#player").hide();
		     		 $("#star").show();
		     		 $("#introduction").hide();
		     		 $("#outerLink").show();
		     		 $("#setContentNm").hide();
		     		 $("#youtubeLinkBtn").attr("onclick", urlLink);
		     		 
		     		 reloadProgressRate(resData, vod_gb,course_seq,contents_seq);
		     	 }
	
			 }
		   
		   /*상세 컨텐츠 조회*/
		   ajax_json_get("/course/coursePlay.do",json, succ_func);
					   	  
	     }
				
</script>