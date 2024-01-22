<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.div-descr {
		border: 1px solid #e9ecef;
		border-radius: 5px;
		min-height: 100px;
		padding: 15px;
	}
	
	.ck-editor__editable_inline {
	    min-height: 500px;
	}
	
	.red {
		color: red;
	}
</style>

<script type="text/javascript" src="/js/mediainfo-0.1.9.min.js"></script>
<script>
	$(document).ready(function() {
		init();
		
		$("#insert_btn").on("click", function() {
			<%--  더블 클릭 방지 --%>
			if(checkIsRun()) {
				return false;
			}
			
			var descr = editor.getData();
			$("#contents_descr").val(descr);
			
			<%-- 유효성 체크 --%>
			initFormValidator();
			var is_valid = $("#contents").valid();
			if( is_valid != true  ){
				resetIsRun();
				return false;
			}
			
			var formdata = $("#contents")[0];
			var form_data = new FormData(formdata);
			
			//썸네일 append
			if($("#vod_file").val()){
				getThumbnail(form_data);
			}
			
			loading_show();
			var succ_func = function(resData, status ) {
				var result = resData.result;
				
				loading_hidden();
				if(result == 'success') {
					var confirm_func = function() {
						location.href="/conage/contentEnrollMain/index.do";
					};
					
					alert_success( "등록하였습니다.", confirm_func );
				} else {
					alert_error( resData.msg, null );
				}
				resetIsRun();
			};
			
			ajax_form_post("/conage/contentEnroll/insert.do", form_data, succ_func);
		});
		
		$("#update_btn").on("click", function() {
			<%--  더블 클릭 방지 --%>
			if(checkIsRun()) {
				return false;
			}
			
			var descr = editor.getData();
			$("#contents_descr").val(descr);
			
			<%-- 유효성 체크 --%>
			initFormValidator();
			var is_valid = $("#contents").valid();
			if( is_valid != true  ){
				resetIsRun();
				return false;
			}
			
			var formdata = $("#contents")[0];
			var form_data = new FormData(formdata);
			var mode = "${mode}";
			if(mode == 'N') {
				form_data.append("vod_gb", $("#vod_gb").val());
			}
			
			//썸네일 append
			if($("#vod_file").val()){
				getThumbnail(form_data);
			}
			
			loading_show();
			var succ_func = function(resData, status ) {
				var result = resData.result;
				
				loading_hidden();
				if(result == 'success') {
					var confirm_func = function() {
						location.href="/conage/contentEnrollMain/index.do";
					};
					
					alert_success( "수정하였습니다.", confirm_func );
				} else {
					alert_error( resData.msg, null );
				}
				resetIsRun();
			};
			
			ajax_form_put("/conage/contentEnroll/update.do", form_data, succ_func);
		});
		
		$("#cancel_btn").on("click", function() {
			location.href="/conage/contentEnrollMain/index.do";
		});
		
		// 23.04.20 한글자막 1개만 첨부하는 것으로 수정

		$( "#sub_div" ).on('click', 'a', function () {
			var $this = $(this).parent('div');
			$this.remove();
		});
		
		$("#vod_gb").on("change" , function() {
			changeVodGb();
		});
		
		
		//Mediaifo.js : 영상 파일 정보를 위한 라이브러리
		const fileinput = document.getElementById('vod_file')
		const durationOutput = document.getElementById('vod_duration')
		const sizeOutput = document.getElementById('vod_size')
		
		const onChangeFile = (mediainfo) => {
		  const file = fileinput.files[0]
		  if (file) {
			durationOutput.innerText = '로딩중…'
		
			const getSize = () => file.size
		
			const readChunk = (chunkSize, offset) =>
				new Promise((resolve, reject) => {
					const reader = new FileReader()
					reader.onload = (event) => {
					  if (event.target.error) {
						reject(event.target.error)
					  }
					  resolve(new Uint8Array(event.target.result))
					}
					reader.readAsArrayBuffer(file.slice(offset, offset + chunkSize))
				})
		
				mediainfo
					.analyzeData(getSize, readChunk)
					.then((result) => {
						const video = result.media.track[1]
						const duration = Math.floor(video.Duration)
						
						// 텍스트 정보 출력
						durationOutput.innerText = "총 " + Math.floor(duration/60) + "분 " +  (duration%60) + "초"
						sizeOutput.innerText = video.Width + "x" + video.Height
						
						// input 입력
						document.getElementById('vod_time_sec').value = duration
						document.getElementById('width_size').value = video.Width
						document.getElementById('height_size').value = video.Height
						
						// 썸네일 출력.
						const _VIDEO = document.querySelector("#video");
						const _CANVAS = document.querySelector("#thumb_canvas");
			            const _CANVAS_CTX = _CANVAS.getContext("2d");
			            
			            //비디오를 첨부(추가)하면 첨부된 파일을 비디오 태그에 삽입한다
			            _VIDEO.setAttribute('src', URL.createObjectURL(fileinput.files[0]));
			            
			          //비디오 태그의 메타데이터가 들어오면
			            _VIDEO.addEventListener('loadedmetadata', function() {
			                _VIDEO.currentTime = 2; //해당 시간으로 이동
			                setTimeout(()=>{ //바로 출력하면 비디오가 불러오기 전이라 동작이 안됨. 잠깐의 기다림 후 캔버스에 해당 이미지를 그림.
			                  _CANVAS_CTX.drawImage(_VIDEO, 0, 0, video.Width, video.Height);
			                },50);
			              });
						
					})
					.catch((error) => {
						durationOutput.innerText = `에러가 발생했습니다:\n${error.stack}`
					})
			}
		}
		
		MediaInfo({
			format: 'object',
			locateFile: (path, prefix) => prefix + path,
		}, (mediainfo) => {
			fileinput.removeAttribute('disabled')
			fileinput.addEventListener('change', () => onChangeFile(mediainfo))
		});	//Mediainfo.js end
		
		
		initFormValidator();
	});
	
	function init(){
		changeVodGb();
		modeSet();
	}
	
	function modeSet() {
		var mode = "${mode}";
		var $insert = $("#insert_btn");
		var $update = $("#update_btn");
		var $gbNotice = $(".gb_notice");
		
		if(mode == 'I') {
			$insert.show();
			$update.hide();
			$gbNotice.hide();
		} else if(mode == 'U') {
			$insert.hide();
			$update.show();
			$gbNotice.hide();
			
			var content = $("#contents_descr").val();
			editor.setData(content);
			
			var gb = $("#vod_gb").val();
			if(gb == 'M') {
				vodInfoInit();
			}
		} else if(mode == 'N') {
			$insert.hide();
			$update.show();
			$gbNotice.show();
			
			var content = $("#contents_descr").val();
			editor.setData(content);
			
			var gb = $("#vod_gb").val();
			$("#vod_gb").attr("disabled", true);
			if(gb == 'M') {
				vodInfoInit();
			}
		}
	}
	
	function changeVodGb() {
		var gb = $("#vod_gb").val();
		var $file = $(".vod");
		var $url = $(".url");
		$("input[type=file]").val("");
		
		if(gb == 'M') {
			$file.show();
			$url.hide();
			$("#vod_url").val("");
		} else if(gb == 'O') {
			$file.hide();
			$url.show();
			$("#vod_duration").text("");
			$("#vod_size").text("");
		} else if(gb == 'Y') {
			$file.hide();
			$url.show();
			$("#vod_duration").text("");
			$("#vod_size").text("");
		}
	}
	
	function vodInfoInit() {
		var time = $("#vod_time_sec").val();
		var width = $("#width_size").val();
		var height = $("#height_size").val();
		if(time != null && time != "") {
			$("#vod_duration").text("총 " + Math.floor(time/60) + "분 " + (time%60) + "초");
		}
		if(width != null && width != "" && height != null && height != "") {
			$("#vod_size").text(width + "x" + height);
		}
	}
	
	function fileDownload( file_seq ){
		<%-- 파일 다운로드 성공시 실행되는 함수 --%>
		var succ_func = function( ){};
		<%-- 파일 다운로드 실패시 실행되는 함수 --%>
		var fail_func = function( ){};
		<%-- 파일 다운로드  --%>

		file_down( file_seq, succ_func, fail_func  );
	}

	function removeFile( file_seq, file_gb ){
		var name ="";
		
		$('#file_'+file_seq).hide();
		$('#file_'+file_seq).addClass("deleted");
		
		if(file_gb == 'V') {
			//영상 정보 초기화
			if($("#vod_file").val() == '' || $("#vod_file").val() == null) {
				$("#vod_duration").text("");
				$("#vod_size").text("");
				$("#vod_time_sec").val("");
				$("#width_size").val("");
				$("#height_size").val("");
			}
			
			name="del_vod_file_seqs";
		} else if (file_gb == 'S') {
			name="del_sub_file_seqs";
		}
		$("<input></input>", {
			type : "hidden",
			name : name,
			value : file_seq
		}).appendTo($('#contents')[0]);
		
	}
	
	<%-- FORM  유효성 체크 --%>
	var _form_validator = null;
	
	function initFormValidator(){
		<%-- VALIDATOR 대상 FORM  --%>
		var _form = $("#contents");
		
		/** 파일 크기 체크  **/
		$.validator.addMethod("vodFileSize",  function( value, element ) {
			var maxSize  = 1 * 1024 * 1024 * 1024 * 2 -1;	<%-- 2GB --%>
			if(value != '') {
				var size = element.files[0].size;
				if(size > maxSize) {
					return false;
				}
			}
			return true;
		});
		
		$.validator.addMethod("subFileSize",  function( value, element ) {
			var maxSize  = 10 * 1024 * 1024; <%-- 10MB --%>
			if(value != '') {
				var size = element.files[0].size;
				if(size > maxSize) {
					return false;
				}
			}
			return true;
		});
	
		var _form_rules = null;
		var _form_messages = null;

		_form_rules = {
			contents_nm: { required:true }
			,vod_gb: { required:true }
			,use_yn: { required:true }
			,upload_subs:{extension: "srt", subFileSize:true}
		 };

		_form_messages = {
			contents_nm: { required:"이름을 입력해 주세요" }
			,vod_gb: { required:"영상구분을 선택해 주세요" }
			,use_yn: { required:"상태를 선택해 주세요" }
			,upload_subs:{extension:"자막은 srt 파일만 업로드 가능합니다", subFileSize:"10MB 이하 파일만 업로드 가능합니다"}
		};
		
		if($('#vod_gb').val() == 'O' || $('#vod_gb').val() == 'Y') {
			
			_form_rules = $.extend(_form_rules,{vod_url:{required:true, url:true}});
			_form_messages = $.extend(_form_messages,{vod_url:{required:"외부링크를 입력해 주세요", url:"링크형식이 올바르지 않습니다"}});
		} else if ($('#vod_gb').val() == 'M') {
			var file = $("#attached_file>div").not(".deleted").length;
			if(file == 0) {
				_form_rules = $.extend(_form_rules,{upload_files:{ required:true, accept: "mp4", extension:"mp4" , vodFileSize:true }});
				_form_messages = $.extend(_form_messages,{upload_files:{required:"영상을 첨부해 주세요", accept:"영상은 mp4 파일만 업로드 가능합니다", extension:"영상은 mp4 파일만 업로드 가능합니다", vodFileSize:"2GB 이하 파일만 업로드 가능합니다"}});
			}
		}
		
		if( _form_validator != null ){
			_form_validator.settings.rules = _form_rules;
			_form_validator.settings.messages = _form_messages;
		}else{
			_form_validator = get_form_validator( _form, _form_rules, _form_messages   );
		}
		
	}
	
	function getThumbnail(form_data) {
		var canvas = document.querySelector("#thumb_canvas");
		const imgBase64 = canvas.toDataURL('image/jpeg', 'image/octet-stream');
		const decodImg = atob(imgBase64.split(',')[1]);
		let array = [];
		for (let i = 0; i < decodImg .length; i++) {
			array.push(decodImg .charCodeAt(i));
		}
		const file = new Blob([new Uint8Array(array)], {type: 'image/jpeg'});
		
		const fileName = $('#vod_file').get(0).files[0].name.split('.')[0] + '_thumb.jpg';
		form_data.append('upload_images', file, fileName);
	}

</script>
    
    <!--Dashbord Student -->
			<div class="page-content">
				<div class="container">
					<div class="row">
						<!-- Profile Details -->
						<div class="col-md-12">
							<div class="filter-grp ticket-grp tiket-suport d-flex align-items-center justify-content-between">
								<div>
									<h3>콘텐츠 등록</h3>
								</div>
								<div class="ticket-btn-grp">
									<a href="/conage/contentEnrollMain/index.do">콘텐츠 목록 가기</a>
								</div>
							</div>
							<div class="settings-widget">
								<div class="settings-inner-blk add-course-info new-ticket-blk p-0">
									<form:form modelAttribute="contents" enctype="multipart/form-data">
										<form:hidden path="contents_seq"/>
										<div class="comman-space">
											<h4>새 콘텐츠 등록</h4>
											<div>
												<div class="form-group">
													<label class="form-control-label"><span class="red">*</span>콘텐츠명</label>
													<form:input path="contents_nm" class="form-control" />
												</div>
												<div class="form-group">
													<label  class="form-label"><span class="red">*</span>영상구분</label>
													<form:select path="vod_gb" class="form-select select country-select" >
														<form:option value="M">동영상</form:option>
														<form:option value="O">외부영상</form:option>
														<form:option value="Y">유튜브</form:option>
													</form:select>
													<p class="gb_notice" style="color:red; display:none;">연결된 강좌가 존재하여 변경할 수 없습니다.</p>
												</div>
												<div class="form-group">
													<label class="add-course-label">콘텐츠 설명</label>
													<div id="editor"></div>
													<form:hidden path="contents_descr"/>
												</div>
												<div class="form-group url">
													<label class="add-course-label">외부링크</label>
													<div>
														<form:input class="form-control ht35 mr5" path="vod_url"/>
													</div>
												</div>
												<div class="form-group vod">
													<label class="add-course-label"><span class="red">*</span>동영상 파일</label>
													<div>
														<p id="vod_duration"></p>
														<p id="vod_size"></p>
														<form:hidden path="vod_time_sec"/>
														<form:hidden path="width_size"/>
														<form:hidden path="height_size"/>
														<video id="video" controls style="display:none;"></video>
														<canvas id="thumb_canvas" style="display:none;"></canvas>
													</div>
													<div id="attached_file">
														<c:forEach items="${vodFiles}" var="file">
															<div id="file_${file.file_seq}">
																<a href="javascript:fileDownload(${file.file_seq});" class="download">${file.orgin_filenm}.${file.file_ext}</a>
																<c:if test="${mode ne 'I' }">
																	<a href="javascript:removeFile(${file.file_seq}, 'V');" class="remove">삭제</a>
																</c:if>
															</div>
														</c:forEach>
													</div>
													<div class="file-drop">
														<input type="file" id="vod_file" class="mt5" name="upload_files" accept="video/*"/>
													</div>
													<div class="accept-drag-file">
														<p>첨부 가능한 동영상 확장자: mp4</p>
													</div>
												</div>
												<div class="form-group vod">
													<label class="add-course-label">자막 파일</label>
													<div>
														<c:forEach items="${subFiles}" var="file">
															<div id="file_${file.file_seq}">
																<a href="javascript:fileDownload(${file.file_seq});" class="download">${file.orgin_filenm}.${file.file_ext}</a>
																<a href="javascript:removeFile(${file.file_seq}, 'S');" class="remove">삭제</a>
															</div>
														</c:forEach>
													</div>
													<div id="sub_div">
														<div id="vod_subtitle">
															<input type="file" class="mt5" name="upload_subs"/>
														</div>
													</div>
													<div class="accept-drag-file">
														<p>첨부 가능한 자막 확장자: srt</p>
													</div>
												</div>
												<div class="form-group">
													<label  class="form-label"><span class="red">*</span>상태</label>
													<form:select path="use_yn" class="form-select select country-select">
														<form:option value="Y">사용</form:option>
														<form:option value="N">중지</form:option>
													</form:select>
												</div>
												<div class="submit-ticket">
													<button type="button" class="btn btn-primary" id="insert_btn">등록</button>
													<button type="button" class="btn btn-primary" id="update_btn">수정</button>
													<button type="button" class="btn btn-dark" id="cancel_btn">취소</button>
												</div>
											</div>							
										</div>
									</form:form>
								</div>
							</div>
						</div>	
						<!-- Profile Details -->
						
					</div>
				</div>
			</div>	
			<!-- /Dashbord Student -->
