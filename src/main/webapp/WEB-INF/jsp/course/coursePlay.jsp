<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
 	<script type="text/javascript" src="/js/jwplayer/jwplayer.js"></script>
	<script>jwplayer.key='iiL9xxalkP7di2nLZ3tPLw0NLBCHdHBe8i3QDQ==';</script>

    <!-- Course Lesson -->
			<section class="page-content course-sec course-lesson">
				<div class="container">
				
					<div class="row">
						<div class="col-lg-4">
							<!-- Course Lesson -->
							<div class="lesson-group">
								<div class="course-card">
									<h6 class="cou-title">
										<a class="collapsed" data-bs-toggle="collapse" href="#collapseOne" aria-expanded="false">${courseInfo.course_nm} <span>${courseInfo.course_cnt} Lessons</span> </a>
									</h6>
									<div id="collapseOne" class="card-collapse collapse" style="">
<%-- 										<sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER')  ">							 --%>
<!-- 											<div class="progress-stip"> -->
<!-- 												<div class="progress-bar bg-success progress-bar-striped active-stip"></div> -->
<!-- 											</div> -->
<!-- 											<div class="student-percent lesson-percent"> -->
<%-- 												<p>${courseInfo.all_secound} / ${courseInfo.watching_time}<span>${courseInfo.course_persent}%</span></p> --%>
<!-- 											</div> -->
<%-- 										</sec:authorize> --%>
<!-- 										<ul> -->
<%-- 											 <c:forEach items="${courseContentsList}"  var="courseContentsList"> --%>
<!-- 												<li> -->
<%-- 													<p class="play-intro"><a href="javascript:jwplayerView(${ courseContentsList.contents_mapped_seq},${ courseContentsList.contents_seq},'${courseContentsList.contents_nm}')">${courseContentsList.contents_nm}</a></p> --%>
<%-- 													${ courseContentsList.contents_watching_time} --%>
<!-- 													<div> -->
<%-- 															${courseContentsList.whatching_yn} --%>
<!-- 													</div> -->
<!-- 												</li> -->
<%-- 											</c:forEach> --%>
<!-- 										</ul> -->
									</div>
								</div>
				
							</div>
							<!-- /Course Lesson -->
							
						</div>	
						<div class="col-lg-8">
						
							<!-- Introduction -->
							<div class="student-widget lesson-introduction">
								<div class="lesson-widget-group">
									<h4 class="tittle" id="setContentNm"></h4>
									<div class="introduct-video" id="moviePlayer">
<!-- 										<a href="https://www.youtube.com/embed/1trvO6dqQUI" class="video-thumbnail" data-fancybox=""> -->
<!-- 											<div class="play-icon"> -->
<!-- 												<i class="fa-solid fa-play"></i> -->
<!-- 											</div> -->
<!-- 											<img class="" src="/assets/img/video-img-01.jpg" alt=""> -->
<!-- 										</a> -->
									</div>
									<div >
										<button  type="button" onclick="videoSpeed(0.5)"><img src="/images/home/ico_out.svg">재생속도(0.5)</button>
										<button  type="button" onclick="videoSpeed(1.0)"><img src="/images/home/ico_out.svg">재생속도(1.0)</button>
										<button  type="button" onclick="videoSpeed(2.0)"><img src="/images/home/ico_out.svg">재생속도(2.0)</button>
										<button  type="button" id="backCourseDetail" style="float: right"><img src="/images/home/ico_out.svg">뒤로가기</button>
									</div>
								</div>
							</div>
							
							<!-- /Introduction -->
						</div>	
						
					</div>	
				</div>
			</section>
			<!-- /Course Lesson -->
<!-- 창닫기 스크립트 -->
<script type="text/javascript">
	var checkTimeInterval;
	var maxTime;
	var seekYn ="N";
	
	$(document).ready(function(){
			

				
		   jwplayerView('${searchVO.contents_mapped_seq}' ,'${searchVO.contents_seq}','${searchVO.contents_nm}'); 
	      
	      
	      
	      $("#backCourseDetail").on("click", function(e){
	             
	     		var form_data = new FormData();
	    		var token = "${_csrf.token}";
	    		form_data.append("_csrf", token );
	    		form_data.append("course_seq", '${searchVO.course_seq}' );
	    		var url = '/course/courseFindDetail.do';
	    		move_post( url, form_data );
	         
	      });

	});
	
  /*영상속도*/
   function videoSpeed(speed){
	    var video = document.getElementById('moviePlayer')
	    var video_speed = video.getElementsByTagName('video')[0]
	    video_speed.playbackRate=speed;
   };
  
   /*영상 5초마다 시간체크 함수*/
   function checkVideoTime(contents_mapped_seq ){

	    var learn_time = Math.floor(jwplayer("moviePlayer").getPosition());
	   
		if(learn_time > maxTime){
			var json = {}
			maxTime = learn_time;
			json['learn_time'] = learn_time;	
			json['contents_mapped_seq'] = contents_mapped_seq;
			json['progress_yn'] = "N";	
			ajax_json_post("/course/checkVideoTime.do",json);
  
		}
		

   };
   
   function checkStopVideoTime(contents_mapped_seq ,contents_seq ,contents_nm){

	    var learn_time = Math.floor(jwplayer("moviePlayer").getPosition());
	   
	    var succ_func = function(resData, status){
	    	jwplayerView(contents_mapped_seq , contents_seq, contents_nm)
	    };
	    
		if(learn_time > maxTime){
			var json = {}
			maxTime = learn_time;
			json['learn_time'] = learn_time;	
			json['contents_mapped_seq'] = contents_mapped_seq;
			json['progress_yn'] = "N";	
			ajax_json_post("/course/checkVideoTime.do",json,succ_func);
 
		}
		

  };
   
   function reloadProgressRate(resData, vod_gb){
	   
	     var str ='';

	     $( '#collapseOne' ).empty();		
	   
	    <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >   
	    if(vod_gb == 'M'){
	    		str += '<div class="progress-stip">'
		  
		       		str += '<div class="progress-bar bg-success progress-bar-striped active-stip"></div>'
			    	str += '</div>'			   
			    	str += '<div class="student-percent lesson-percent">'
			    	str += '<p>'+resData.courseInfo.watching_time+'/'+ resData.courseInfo.all_secound +'<span>'+resData.courseInfo.course_persent+'%</span></p>'
		    	
			    str += '</div>'
	    } 
	    </sec:authorize>
	   
	   	str += '<ul>'
		for(var i =0; i<resData.courseContentsList.length; i++){
			    	 str += '<li>'
			         str += '<p class="play-intro"><a href="javascript:jwplayerView('+resData.courseContentsList[i].contents_mapped_seq+','+resData.courseContentsList[i].contents_seq+',\''+resData.courseContentsList[i].contents_nm+'\')">'+resData.courseContentsList[i].contents_nm+'</a></p>'
			         <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >
			         if(vod_gb == 'M'){
				         str +=  resData.courseContentsList[i].contents_watching_time			         
				         str += '<div>'
				         str +=  resData.courseContentsList[i].whatching_yn
				         str += '</div>'
			         }
			         </sec:authorize>
				     str += '</li>'   
		}
		str += '</ul>'
			  
		$( '#collapseOne' ).append(str);
			  		     		     
		$( '#collapseOne' ).addClass( 'show' );
		$(".active-stip").css("width",resData.courseInfo.course_persent+"%");
   };
   
   /*각각 컨텐츠마다 jw플레이어 그리는 함수*/
   function jwplayerView(contents_mapped_seq , contents_seq, contents_nm){
	   
	   /*인터벌 함수 초기화*/
	   clearInterval(checkTimeInterval);
	   
	   var json = {};
	   json['course_seq'] = '${searchVO.course_seq}';
	   json['contents_mapped_seq'] = contents_mapped_seq;	
	   json['contents_seq'] = contents_seq;
	   
	   var succ_func = function(resData, status){
		     $("#setContentNm").text(contents_nm);
	     	 var url;
	     	 var type;
	     	 if(resData.courseVideoInfo.vod_gb == 'M'){
	     		url = resData.videoFileList[0].file_url;
	     		type = resData.videoFileList[0].file_ext;
	     	 }else if(resData.courseVideoInfo.vod_gb == 'O'){
	     		url =  resData.courseVideoInfo.vod_url;
	     		type = "";
	     	 }
	     	 
		     reloadProgressRate(resData ,resData.courseVideoInfo.vod_gb);
		     
		     /*jw플레이어 그리기*/
		     jwplayer("moviePlayer").setup({
		          flashplayer: "/jwplayer/player.swf",
		          /* image: "/REPOSITORY/FILES/TB_CONTENS_VIDEO/20230406/130318418_8d42452c-a48e-4239-891b-80d7ccae909f", 썸네일부분 추가요청 논의 */
		          sources: [{
		              file: url,
		              /* label: "144p", 비디오 해상도 추가요청 논의 */
		              type:type
		            }],
		          height: 500,
		          width: 815,
		          skin:"bekle",
		          tracks: [{
		        	  file: "/js/jwplayer/testFiles/testSubKorea",
		              kind: "captions",
		              label: "한글"
		            }
		          	,{
		            	file: "/js/jwplayer/testFiles/testSubEnglish",
		            	kind: "captions",
		              label: "영어"
		            }]
		       });
		     
		     /*로그인 여부에 영상체크 분기처리*/
		     <sec:authorize access=" hasRole('ROLE_ADMIN') || hasRole('ROLE_USER') " >
			     if(resData.courseVideoInfo.vod_gb == 'M'){
			    	 
			    		/*영상 처음 시작전일경우에는 0부터 만약 봤던것이면 그부분부터 볼수 있게 max설정*/
					     if(resData.courseVideoInfo.learn_seq == null){
					    	  maxTime = 0;
					    	  ajax_json_post("/course/insertFirstVideoTime.do",json);
					     }
					     else{
					    	  maxTime=resData.courseVideoInfo.learn_time;	  
					     }
					     
					     /*영상 처음 시작할시*/
				        jwplayer('moviePlayer').on('firstFrame', function() {
							  
				        	  /*영상을 처음 본것인지 아니면 다 본것인지 체크하는 로직*/
					    	  if(Math.floor(jwplayer("moviePlayer").getDuration()) == maxTime || resData.courseVideoInfo.progress_yn == 'Y'){
						      	  jwplayer('moviePlayer').seek(0);		      	  
					    	  }else{
						      	  jwplayer('moviePlayer').seek(maxTime);
						      	 
					    	  }
					    	  checkTimeInterval = setInterval(checkVideoTime,5000,contents_mapped_seq);     						
					      });
					      
				        
					      jwplayer('moviePlayer').on('seek', function(e) {
					    		  seekYn ="Y";        
					      });
					   		
					      var rollbackTime;
					      
					      /*재생 스크롤 뒤로 가는것을 방지*/
					      jwplayer('moviePlayer').on('time', function(e) {
							
								if(seekYn =='Y'){
							         var positionDiff = e.position - maxTime;
									 
							         if (positionDiff > 1) {
							             jwplayer('moviePlayer').seek(rollbackTime);		             
							         }
							         seekYn ="N"
								}else{
									rollbackTime = Math.floor(e.position)
								}
					      });
					      
					      /*영상이 멈출때*/
					      jwplayer('moviePlayer').on('pause', function(e) {
					    	  if(resData.courseVideoInfo.progress_yn != 'Y'){
					    		   	    		  
					    		  checkStopVideoTime(contents_mapped_seq ,contents_seq ,contents_nm); 			    		
					    	  }				    			  				  			    	 
					      });
					      
					      
					      /*영상이 다 보고 끝난 경우*/	
					      jwplayer('moviePlayer').on('complete', function(e) {
			
							    var jsonParm = {}
							    var learn_time = resData.courseVideoInfo.vod_time_sec;	
								
							    var succ_func = function(resData, status){
							    	maxTime = learn_time;
							    	jwplayerView(contents_mapped_seq , contents_seq, contents_nm)
							    	clearInterval(checkTimeInterval);
							    }
							    
								jsonParm['progress_yn'] = "Y";
							    jsonParm['learn_time'] = learn_time; 	
							    jsonParm['contents_mapped_seq'] = contents_mapped_seq; 
							    if(maxTime  != learn_time){
							    	ajax_json_post("/course/checkVideoTime.do",jsonParm,succ_func);	
							    }
						    
					      });
	
			      }
			      else{
			    	  if(resData.courseVideoInfo.learn_seq == null){
				    	  ajax_json_post("/course/insertFirstVideoTime.do",json);
				     }
			      }
		      </sec:authorize>

		}
	   
	   /*상세 컨텐츠 조회*/
	   ajax_json_get("/course/coursePlay.do",json, succ_func);
	   	  
   }
   
       
</script>