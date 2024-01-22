<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!-- <script type="text/javascript" src="/js/jwplayer/jwplayer.js"></script> -->
<script type="text/javascript"
	src="https://cdn.jwplayer.com/libraries/AIS1juY4.js"></script>

<style>
.jwplayer .jw-controlbar {
	display: none;
}

.jwplayer .jw-display {
	display: none;
}
</style>


<!-- <div id="moviePlayer"> -->

<!-- /Pricing Plan -->

<script type="text/javascript">
			
			
			$(document).ready(function(){
						
					  var url = "/REPOSITORY/FILES/TB_CONTENS_VIDEO/20230427/163808226_e69b5426-b4bd-4d0c-a742-4ab3142952d9";
				      var contents_mapped_seq = '602' ;
				      var contents_seq = '119';
			      
				});
				
			function move_player(idx){
				reset_preview();
				var jw_name = "jw"+idx;
				jwplayer(jw_name).stop();
				var con1 = document.getElementById(jw_name);
				var img_name = "img"+idx;
	    		var con2 = document.getElementById(img_name);
				con2.style.display = '';
				con1.style.display = 'none';
			}
			
			function reset_preview(){
				for(i=0; i<4; i++){
					  jwplayer('jw'+i).stop();
					  var conX = document.getElementById('jw'+i);
					  var conV = document.getElementById('img'+i);
					  conV.style.display = '';
					  conX.style.display = 'none';
					}
				
			}
				
			
			function move_player2(idx, url){
				reset_preview();
				
				var jw_name = "jw"+idx;
				var img_name = "img"+idx;
				
				jwplayerView(jw_name,img_name, idx, url , true, true);
				var con2 = document.getElementById(img_name);
				con2.style.display = 'none';
				
				
				
				
				
			}
			
		
				
				   
				  
				   
				   /*각각 컨텐츠마다 jw플레이어 그리는 함수*/
				   function jwplayerView(jwName,imgName, idx, url, autoPlay, repeat){
					   
					     		 var type = 'mp4';
					     	
					     		
							     url = url+'.mp4';
							     
							     /*jw플레이어 그리기*/
							     jwplayer(jwName).setup({
							    	 flashplayer: "/jwplayer/player.swf",
							          sources: [{
							              file: url,
							              type:type
							            }],
							          heigh:"100%",
							          mute : true,
							          "aspectratio": "16:9",
							          "autostart": true,
							          "controls": true,
							          "preload": "metadata",
							          "primary": "html5"
							            
							       });
									
							     
							     
							    
							     
							     jwplayer(jwName).on('firstFrame', function() {
							    	 $('#'+jwName).mouseout(function() {
										 
											move_player(idx);
								    		 
										});
							     });
							     
							     
							   
							     
				   }
				
			</script>

