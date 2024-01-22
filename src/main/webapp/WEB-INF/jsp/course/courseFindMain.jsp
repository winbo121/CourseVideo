<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
	/* .fa-regular fa-heart fa-solid:hover { */
	.course-design .product .course-share .fa-solid:hover {
    color: #FF5364;
    font-weight:1;
	}
	
</style>


<script type="text/javascript">
	var start_page_no = 1;
	var end_page_no = start_page_no + 4;
	var check_end = 'N';
	var click_val = 'all';
	var pageSize = 9;
	var codeInitVal ='';
	var searchTxt ='';
	var searchSelect = 'c';
	
	$(document).ready(function() {
		codeInitVal = '${codeInitVal}';
		searchTxt = '${searchTxt}';
		set_data();
		
		
		$('#selectSearch').on("change", function() {
			searchSelect = $("#selectSearch").val();
		});

		var con1 = document.getElementById("div1");
		var con2 = document.getElementById("div2");
		$('#course-grid').on("click", function() {

			$('#course-grid').addClass('grid-view active');
			$('#course-list').removeClass('active');
			/* $('#div1'). */
			con1.style.display = '';
			con2.style.display = 'none';
		});

		$('#course-list').on("click", function() {

			$('#course-list').addClass('list-view active');
			$('#course-grid').removeClass('active');
			con2.style.display = '';
			con1.style.display = 'none';

		});

		$("#ajax_search").on("click", function(event) {
			event.preventDefault();
			search_log();
			
			start_page_no = 1;
			end_page_no = start_page_no + 4;
			check_end = 'N';
			set_data();
		});
		
		$("#chkAll").change(function() {
			if ($("#chkAll").is(":checked")) {
				$('input[type="checkbox"][name="select_specialist"]').not($('input[id="chkAll"]')).prop('checked', false);
			} 
		}); 
		$("#chkUser").change(function() {
			if ($("#chkUser").is(":checked")) {
				$('input[type="checkbox"][name="select_user"]').not($('input[id="chkUser"]')).prop('checked', false);
			} 
		}); 

		$("input[name=select_specialist]").change(function() {
			var total = $("input[name=select_specialist]").length;
			var checked = $("input[name=select_specialist]:checked").length;
			var min = total - checked;
			
			if(checked >= 2) {
				$("#chkAll").prop("checked", false);
			} 
		});
		
		$("input[name=select_user]").change(function() {
			//var total = $("input[name=select_user]").length;
			var total = $("input[name=select_user]").length;
			var checked = $("input[name=select_user]:checked").length;
			var instAll = $("input[id=chkUser]");
			var earch = $('input[type="checkbox"][name="select_user"]').not(instAll);
			if (total == 3) {
				if(checked >= 2) {
					$("#chkUser").prop("checked", false);
				} 
				if (checked === parseInt('${courseUser.size()}') && !instAll.prop("checked")){
					if(earch[0].checked || earch[1].checked){
						if(earch[0].checked && earch[1].checked){
							$("#chkUser").prop("checked", true);
							$('input[type="checkbox"][name="select_user"]').not($('input[id="chkUser"]')).prop('checked', false);
						} 
					} else {
						$("#chkUser").prop("checked", true);
						$('input[type="checkbox"][name="select_user"]').not($('input[id="chkUser"]')).prop('checked', false);
					}
				} 
			} else {
				if(checked >= 2) {
					$("#chkUser").prop("checked", false);
				} 
				if (checked === parseInt('${courseUser.size()}')){
					$("#chkUser").prop("checked", true);
					$('input[type="checkbox"][name="select_user"]').not($('input[id="chkUser"]')).prop('checked', false);
				} 
			}
			
		});
		
		
		
		
		

	});
	
	
	function go_result_like(ck_val){
		var likeId = 'like'+ck_val;
		var ulikeId = 'ulike'+ck_val;
		var conLike = document.getElementById(likeId);
		var conULike = document.getElementById(ulikeId);
		
		var html = "";
		var confirm_func = function(){
			  return false;
			 };
		
		if($("#"+likeId).hasClass("fa-solid") === true) {
			
			conLike.classList.remove("fa-solid");
			conULike.classList.remove("fa-solid");
			html="찜하기가 취소되었습니다.";
			alert_info( html, confirm_func  );
		}else if($("#"+likeId).hasClass("fa-solid") === false) {
			
			conLike.classList.add("fa-solid");
			conULike.classList.add("fa-solid");
			html="찜하기가 등록되었습니다.";
			alert_info( html, confirm_func  );
		}
		
		
	}
	
	function search_log(){
		
		var searchType ="2";
		var searchPlace ="2";
		var searchTxt= $('#sellist1').val();
		save_search(searchType,searchPlace,searchTxt);
		
		var search = $('#course_nm').val(); 
		if (search != null && search != "") {
			if (searchSelect == 'c') {
					searchType = "1";
					searchPlace = "2";
					save_search(searchType,searchPlace,search);
			} else if(searchSelect == 'i'){
					searchType = "4";
					searchPlace = "2";
					save_search(searchType,searchPlace,search);
			} else if(searchSelect == 'n'){
					searchType = "3";
					searchPlace = "2";
					save_search(searchType,searchPlace,search);
			} 
		}
	}
	
	
	function enterkey() {
	    if (window.event.keyCode == 13) {
	    	if ($("#course_nm").val() != "" && $("#course_nm").val() != null) {
				search_log();
				start_page_no = 1;
				end_page_no = start_page_no + 4;
				check_end = 'N';
				set_data();
			} else if ($("#course_nm").val() == "" || $("#course_nm").val() == null) {
				alert('검색어를 입력해 주세요.')
				return false;
			}
	    }
	}	
	

	
	function go_detil(courseId) {
		
		var searchType ="7";
		var searchPlace ="2";
		var searchTxt= $('#searchTxt').val(); 
		save_search(searchType,searchPlace,courseId);

		var form_data = new FormData();
		var token = "${_csrf.token}";
		form_data.append("_csrf", token );
		form_data.append("course_seq", courseId );
		var url = '/course/courseFindDetail.do';
		move_post( url, form_data );
	}

	var chk_arr = [];
	function set_data(pageNo) {
		end_page_no = start_page_no + 4;
		
		check_end = 'N';
		//var chk_arr = [];
        
     	// select 요소와 체크박스 요소를 가져옵니다.
        
     	const selectBox = document.getElementById("sellist1");
        const checkboxes = document.querySelectorAll("input[name=select_specialist]");
        const selectedValues = [];
     	// select 요소의 값이 변경되었을 때, 체크박스 요소의 체크 여부를 업데이트합니다.
        selectBox.addEventListener("change", function() {
          const selectedValue = selectBox.value;
          checkboxes.forEach(function(checkbox) {
            if (checkbox.value === selectedValue) {
              checkbox.checked = true;
              chk_arr = [];
              chk_arr.push(checkbox.value);
            } else if (selectedValue == "all") {
            	$("input[name=select_specialist]").prop("checked",false);
                $("input[name=select_specialist][value='all']").prop("checked",true);
            } /* else if (selectedValue == "") {
                //$("input[name=select_specialist]").prop("checked",true);
            	$("input[name=select_specialist][value='all']").prop("checked",true); select2-sellist1-results
            } */ else {
              	checkbox.checked = false;
            }
          });
        });
       
        
     // 체크박스 요소가 변경되었을 때, select 요소의 값을 업데이트합니다.
        checkboxes.forEach(function(checkbox) {
          checkbox.addEventListener("change", function() {
        	  const checkedValues = Array.from(checkboxes)
              .filter(function(checkbox) {
                return checkbox.checked;
              })
              .map(function(checkbox) {
                return checkbox.value;
              });
            if (checkedValues.length === 0) {
	              selectBox.value = "none";
	              selectBox.removeAttribute("data-selected-values");
	              chk_arr = [];
            } else if (checkedValues.length === 1) {
	              selectBox.value = checkedValues[0];
	              selectBox.removeAttribute("data-selected-values");
            } else if (checkedValues.length >= 2) {
	              selectBox.value ="none";
	              selectBox.removeAttribute("data-selected-values");
	             
	             
	              for (var i = 0; i < checkedValues.length; i++) {
					chk_arr.push(checkedValues[i]);
					$("input[name=select_specialist][value='"+checkedValues[i]+"']").prop("checked",true);
					}
	              //$("input[name=select_specialist][value='all']").prop("checked",true);
	              if (checkedValues[0] == "all") {
	            	  selectBox.value = checkedValues[1];
	            	  selectBox.removeAttribute("data-selected-values");
	            	  chk_arr.push(checkedValues[1]);
				  }
	              if(checkedValues.length >= 17){
	            	  $("input[name=select_specialist]").prop("checked",false);
	                  $("input[name=select_specialist][value='all']").prop("checked",true);
	            	  selectBox.removeAttribute("data-selected-values");
	            	  selectBox.value ="all";
		              chk_arr = [];
	              }
       	    } else {
	              selectBox.value = "none";
	              selectBox.removeAttribute("data-selected-values");
	              selectBox.setAttribute("data-selected-values", checkedValues.join(","));
            }
            
            
            selectedValues.length = 0;
            checkboxes.forEach(function(checkbox) {
            	
              if (checkbox.checked) {
                selectedValues.push(checkbox.value);
                chk_arr.push(checkbox.value);
                chk_arr = [...new Set(chk_arr)];
              } else {
                  const index = checkedValues.indexOf(checkbox.value);
                  if (index > -1) {
                    checkedValues.splice(index, 1);
                    chk_arr.splice(index, 1);
                  }
               }
              
            });
          });
        });
		var chk_user = [];
        var checkUser = document.getElementsByName("select_user");
        for (var i = 0; i < checkUser.length; i++) {
            if (checkUser[i].checked) {
            	chk_user.push(checkUser[i].value);
            } 
        } 
        
		
		var course_nm = $('#course_nm').val();
		var action = "/course/courseFindList/jsp_paging.do";

		if (pageNo == '' || pageNo == null) {

			pageNo = 1;
		}

		if (searchTxt != ''){
			course_nm = searchTxt;
			searchTxt = '';
		}
		var form_data = new FormData();
		form_data.append("pageNo", pageNo);
		form_data.append("pageSize", pageSize);
		form_data.append("search_text", course_nm);
		form_data.set("search_select", searchSelect);
		var sel_val = $("#sellist1").val();
		var chk_arr2 = [];
		if (codeInitVal != ''){
			sel_val = codeInitVal;
			codeInitVal = '';
		}
		chk_arr2 = [...new Set(chk_arr)];
		
		form_data.set("search_type", sel_val);
		if (sel_val == "none" && chk_arr2.length == 0 && chk_user.length == 0) {
			form_data.append("search_chk", "none");
		} else if (sel_val == "none" && chk_arr2.length == 1) {
			form_data.append("search_chk", "none");
			$("input[name=select_specialist]").prop("checked",false);
		} else if (sel_val != "none" && sel_val != "all" && sel_val != null){
			form_data.append("search_chk", sel_val);
		} else if (sel_val === null){
			form_data.set("search_type", "all");
			form_data.set("search_chk", "all");
		} else {
			form_data.append("search_chk", chk_arr2);
			if (sel_val == "all") {
				form_data.append("search_chk", "all");
				$("input[name=select_specialist][value='all']").prop("checked",true);
			}
		}
		
		
		if (chk_user.length != 0) {
			if (chk_user.length == 1) {
				form_data.set("search_inst", chk_user);
			} else {
				for (var i = 0; i < chk_user.length; i++) {
					form_data.append("search_user", chk_user[i]);
				}
			}
		}
		
		chk_arr2 = [];
		
		var str = "";
		var str2 = "";
		var str3 = "";
		var str4 = "";
		var page_info = "";

		var succ_func = function(resData, status) {
			var setNo = resData.search.pageNo;
			var rangeCount = resData.search.rangeCount;
			var searchType = resData.search.search_type;
			var searchChk = resData.search.search_chk;
			var totalCount = resData.search.totalCount;
			$("#totalCnt").html(totalCount);

			
			var list = resData.paging.data;
			var listLen = list.length;
			var courseGubun = resData.courseGubun;
			
			str2 += "<option";
			if (searchType == "all"){
				str2 += " selected"
				$("input[name=select_specialist]").prop("checked",false);
				$("input[name=select_specialist][value='all']").prop("checked",true);
			}
			str2 += " value=" + "all" + ">" + "전체";
					+ " </option>";
					
			str2 += "<option";
			if (searchType == "none"){
				str2 += " selected"
				//$("input[name=select_specialist]").prop("checked",false);
				
			}
			str2 += " value=" + "none" + ">" + "선택";
					+ " </option>";
			$.each(courseGubun, function(index, data) {
				str2 += "<option";
				if (searchType == data.code_seq || data.code_seq == codeInitVal ) {
					str2 += " selected"
						if (searchType == data.code_seq) {
							$("input[name=select_specialist]").prop("checked",false);
							$("input[name=select_specialist][value='"+searchType+"']").prop("checked",true);
				              chk_arr = [];
				              chk_arr.push(searchType);
				            } else if (searchType == "all") {
				            	$("input[name=select_specialist]").prop("checked",false);
				                $("input[name=select_specialist][value='all']").prop("checked",true);
				            } else {
				            	$("input[name=select_specialist]").prop("checked",false);
				            }
						
				}
					
				str2 += " value=" + data.code_seq + ">" + data.code_nm
						+ " </option>";

			});
			$("#sellist1").html(str2);
			
			


			if (listLen > 0) {
				$
						.each(
								list,
								function(index, data) {
									str += "<div class='col-lg-4 col-md-6 d-flex'>";
									str += "<div class='course-box course-design d-flex ' >";
									str += "<div class='product'>";
									str += "<div class='product-img'>";
									str += "<a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");'>";
									//str += "<img class='img-fluid' alt='' src='/assets/img/course/course-10.jpg'></a></div>";
									str += "<img class='img-fluid' alt='' src='${rootPath}"+data.file_save_path+data.save_filenm+"' style='max-height: 157.5px; min-height: 157.5px;'  onError='this.src="+'"/images/noimage.png"'+"'></a></div>";
									str += "<div class='product-content'>";
									str += "<div class='course-group d-flex'>";
									str += "<div class='course-group-img d-flex'>";
									//str += "<a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");'><img src='/assets/img/user/user1.jpg' alt='' class='img-fluid'></a>";
									str += "<div class='course-name'>";
									str += "<h4><a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");'> " + data.course_nm
											+ "</a></h4>";
									str += "<p>" + data.reg_inst_nm
											+ "</p></div></div>";
									str += "<div class='course-share d-flex align-items-center justify-content-center'>";
									
									/* 찜하기 */
									if(data.like_yn == 'Y'){
										str += "<a href='javascript:void(0)' onclick='sel_like(" + data.course_seq + ");'><i class='fa-regular fa-heart fa-solid' id='ulike" + data.course_seq + "' ></i></a></div></div>";
										
									}else if(data.like_yn == 'N'){
										str += "<a href='javascript:void(0)' onclick='sel_like(" + data.course_seq + ");'><i class='fa-regular fa-heart'id='ulike" + data.course_seq + "'></i></a></div></div>";
									} 
									str += "<div class='course-info d-flex align-items-center'>";
									str += "<div class='rating-img d-flex align-items-center'>";
									str += "<img src='/assets/img/icon/icon-01.svg' alt=''>";
									str += "<p>" + data.course_round
											+ "차시</p>";
									str += "</div>";
									str += "<div class='course-view d-flex align-items-center'>";
									str += "<img src='/assets/img/icon/icon-02.svg' alt=''>";
									str += "<p>" + data.vod_hour;
									if (data.vod_hour != '')
										str += "시간";
									str += data.vod_min;
									if (data.vod_min != '')
										str += " 분";
									if (data.vod_hour == ''
											&& data.vod_min == '')
										str += "1분미만";
									str += "</p>";
									str += "</div></div>";
									
									if (data.star_point == null) {
										str += "<div class='rating'>";
										//str += "<p>등록된 별점이 없습니다.</p>";
										str += "<span class='d-inline-block average-rating'><span></span>등록된 별점이 없습니다.</span>";
									} else {
										str += "<div class='rating'>";
										//str += "<i class='fa-thin fa-star '></i>";
										//str += '<i class="fas fa-star fa-inverse"></i>';
										//str += '<i class="fa-light fa-star"></i>';
										if (data.star_point == 5) {
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
										} else if(data.star_point >= 4.5){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star-half-alt filled'></i>";
										} else if(data.star_point >= 4){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 3.5){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star-half-alt filled'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 3){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 2.5){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star-half-alt filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if (data.star_point >= 2) {
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 1.5){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star-half-alt filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 1){
											str += "<i class='fas fa-star filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 0.5){
											str += "<i class='fas fa-star-half-alt filled'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										} else {
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
											str += "<i class='fas fa-star'></i>";
										}
										
										str += "<span class='d-inline-block average-rating'><span>"+data.star_point+"</span>"+" ("+ data.review_cnt +")</span>";
									}
									
									//str += "<span class='d-inline-block average-rating'><span>"+data.star_point+"</span>"+" ("+ data.review_cnt +")</span>";
									str += "</div>";
									str += "<div class='all-btn all-category align-items-center tac'>";
									str += "<a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");' class='btn btn-primary'>학습하기</a>";
									str += "</div></div></div></div></div>";
									str3 += "<div class='col-lg-12 col-md-12 d-flex'>";
									str3 += "<div class='course-box course-design list-course d-flex'>";
									str3 += "<div class='product'>";
									str3 += "<div class='product-img' style='max-height: 157.5px; min-height: 157.5px;'>";
									str3 += "<a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");'>";
									str3 += "<img class='img-fluid' alt='' src='${rootPath}"+data.file_save_path+data.save_filenm+"' style='max-height: 157.5px; min-height: 157.5px;' onError='this.src="+'"/images/noimage.png"'+"'></a></div>";
									str3 += "<div class='product-content'>";
									str3 += "<div class='head-course-title'>";
									str3 += "<h3 class='title'><a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");'>"
											+ data.course_nm + "</a></h3>";
									str3 += "<div class='all-btn all-category d-flex align-items-center'>";
									str3 += "<a href='javascript:void(0)' onclick='go_detil(" + data.course_seq + ");' class='btn btn-primary'>학습하기</a></div></div>";
									str3 += "<div class='course-info border-bottom-0 pb-0 d-flex align-items-center'>";
									str3 += "<div class='rating-img d-flex align-items-center'>";
									str3 += "<img src='/assets/img/icon/icon-01.svg' alt=''>";
									str3 += "<p>" + data.course_round
											+ "차시</p></div>";
									str3 += "<div class='course-view d-flex align-items-center'>";
									str3 += "<img src='/assets/img/icon/icon-02.svg' alt=''>";
									str3 += "<p>" + data.vod_hour;
									if (data.vod_hour != '')
										str3 += "시간";
									str3 += data.vod_min;
									if (data.vod_min != '')
										str3 += " 분";
									if (data.vod_hour == ''
											&& data.vod_min == '')
										str3 += "1분미만";
									str3 += "</p>";
									str3 += "</div></div>";
									/* str3 += "<div class='rating'>";
									str3 += "<i class='fas fa-star filled'></i>";
									str3 += "<i class='fas fa-star filled'></i>";
									str3 += "<i class='fas fa-star filled'></i>";
									str3 += "<i class='fas fa-star filled'></i>";
									str3 += "<i class='fas fa-star'></i>"; */
									if (data.star_point == null) {
										//str3 += "<p>등록된 별점이 없습니다.</p>";
										str3 += "<div class='rating'>";
										str3 += "<span class='d-inline-block average-rating'><span></span>등록된 별점이 없습니다.</span>";
									} else {
										str3 += "<div class='rating'>";
										if (data.star_point == 5) {
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
										} else if(data.star_point >= 4.5){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star-half-alt filled'></i>";
										} else if(data.star_point >= 4){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 3.5){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star-half-alt filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 3){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 2.5){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star-half-alt filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if (data.star_point >= 2) {
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 1.5){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star-half-alt filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 1){
											str3 += "<i class='fas fa-star filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else if(data.star_point >= 0.5){
											str3 += "<i class='fas fa-star-half-alt filled'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										} else {
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
											str3 += "<i class='fas fa-star'></i>";
										}
										
										str3 += "<span class='d-inline-block average-rating'><span>"+data.star_point+"</span>"+" ("+ data.review_cnt +")</span>";
									}
									//str3 += "<span class='d-inline-block average-rating'><span>4.0</span> (15)</span>";
									str3 += "</div>";
									str3 += "<div class='course-group d-flex mb-0'>";
									str3 += "<div class='course-group-img d-flex'>";
									//str3 += "<a href='#'><img src='/assets/img/user/user1.jpg' alt='' class='img-fluid'></a>";
									str3 += "<div class='course-name'>";
									//str3 += "<h4><a href='#'> " + data.reg_inst_nm
									//		+ "</a></h4>";
									str3 += "<p>" + data.reg_inst_nm +"</p>";
									str3 += "</div></div>";
									str3 += "<div class='course-share d-flex align-items-center justify-content-center'>";
									/* 찜하기 */
									
									/* 찜하기 */
									if(data.like_yn == 'Y'){
										str3 += "<a href='javascript:void(0)' onclick='sel_like(" + data.course_seq + ");'><i class='fa-regular fa-heart fa-solid' id='like" + data.course_seq + "'></i></a>";
										
									}else if(data.like_yn == 'N'){
										
										
										str3 += "<a href='javascript:void(0)' onclick='sel_like(" + data.course_seq + ");'><i class='fa-regular fa-heart' id='like" + data.course_seq + "'></i></a>";
										
									} 
									
									
									
									str3 += "</div></div></div></div></div></div>";

								})
				page_info += "<ul class='pagination lms-page'>";
				page_info += "<li class='page-item prev'><a class='page-link' href='javascript:void(0)' onclick='before_page();'><i class='fas fa-angle-left'></i></a></li>";

				if (end_page_no >= resData.search.pageCount) {
					end_page_no = resData.search.pageCount;
					check_end = 'Y';
				}

				for (var a = start_page_no; a <= end_page_no; a++) {
					var setNog = resData.paging.page;
					if (a == setNog) {
						var class_name = 'page-item first-page active';
					} else {
						var class_name = 'page-item first-page';
					}
					page_info += "<li class='"+ class_name +"'>";
					page_info += "<a class='page-link' href='javascript:void(0)' onclick='set_data("
							+ a + ");'>" + a + "</a></li>";
				}

				page_info += "<li class='page-item next'><a class='page-link' href='javascript:void(0)' onclick='next_page();'><i class='fas fa-angle-right'></i></a></li>";
				page_info += "</ul>";

				$("#div1").html(str);
				$("#div2").html(str3);
				$("#pagination").html(page_info);

			} else {

				str += "<div style='text-align:center;color: blue;'>	데이터가 존재하지 않습니다. </div>";
				$("#div1").html(str);
				$("#div2").html(str);
				$("#pagination").html(page_info);

			}
		}

		ajax_form_post(action, form_data, succ_func);

	}
</script>


<!-- Breadcrumb -->
<div class="breadcrumb-bar">
	<div class="container">
		<div class="row">
			<div class="col-md-12 col-12">
				<div class="breadcrumb-list">
					<nav aria-label="breadcrumb" class="page-breadcrumb">
						<ol class="breadcrumb">
							<li class="breadcrumb-item"><a href="/">Home</a></li>
							<li class="breadcrumb-item" aria-current="page">온라인 강좌</li>
							<li class="breadcrumb-item active" aria-current="page">강좌 찾기</li>
						</ol>
					</nav>
				</div>
			</div>
		</div>
	</div>
</div>
<!-- /Breadcrumb -->

<!-- Course -->
<section class="course-content">
	<div class="container">
		<div class="row">
			<div class="col-lg-9">

				<!-- Filter -->
				<div class="showing-list">
					<div class="row">
						<div class="col-lg-6">
							<div class="d-flex align-items-center">
								<div class="view-icons">
									<a id="course-grid" class="grid-view active"><i
										class="feather-grid"></i></a> <a id="course-list"
										class="list-view"><i class="feather-list"></i></a>
								</div>
								<div class="show-result">
									<h4>
										9개씩 검색 결과 표시 | 총 건수 <span id="totalCnt">0</span>건 
									</h4>
								</div>
							</div>
						</div>
						<div class="col-lg-6">
							<div class="show-filter add-course-info">
								<div class="row gx-2 align-items-center">
									<div class="col-md-6 col-item" style="width: 90px; padding-right: 0px;">
										<div class=" search-group">
											<select class="form-select select" id="selectSearch">
												<option value="c" selected="selected">강좌명</option>	
												<option value="i">기관명</option>	
												<option value="n">강사명</option>	
											</select>
										</div>
									</div>
									<div class="col-md-6 col-item" style="width: 230px; padding-left: 0px;">
										<div class=" search-group">
											<i class="feather-search"></i>
											 <input type="text"
												class="form-control" placeholder="검색어를 입력하세요"
												id="course_nm" value="${searchTxt}" onkeyup="enterkey();" onsubmit="return false;">
											<i class="feather-search"></i> <input type="hidden"
												class="form-control" placeholder="검색어를 입력하세요"/>
										</div>
									</div>
									<div class="col-md-6 col-lg-6 col-item" style="width: 150px;">
										<div class="form-group select-form mb-0">
											<select class="form-select select" id="sellist1"
												name="sellist1">
												<option value=''>전체</option>
											</select>
										</div>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
				<!-- /Filter -->

				<div class="row" id="div1"></div>

				<div class="row" id="div2" style="display: none"></div>

				<!-- /pagination -->
				<div class="row">
					<div class="col-md-12" id="pagination"></div>
				</div>
				<!-- /pagination -->

			</div>
			<div class="col-lg-3 theiaStickySidebar">
				<div class="filter-clear">
					<div class="clear-filter align-items-center">
						<div class="ticket-btn-grp mo-view">
							<a href="javascript:void(0);" id="ajax_search">조회</a>
						</div>
					</div>

					<!-- Search Filter -->
					<div class="card search-filter pc-view">
						<div class="card-body">
							<div class="filter-widget mb-0">
								<div class="categories-head d-flex align-items-center">
									<h4>카테고리</h4>
									<!-- <i class="fas fa-angle-down"></i> -->
								</div>
								<div id="selectGb" style="overflow: auto; height:309px;"> 
									<div>
										<label class="custom_check" onchange="set_data();"> 
											<input type="checkbox" name="select_specialist" id="chkAll" value="all" checked="checked"> 
											<span class="checkmark"></span>
											<p style="width: 76.94; height: 23; margin: 0;" >전체</p>
										</label>
									</div>
									<c:forEach items="${courseGubun }" var="gb" varStatus="status">
										<div>
											<label class="custom_check" onchange="set_data();"> 
												<input type="checkbox" id="code_${status.index}" name="select_specialist" value="${gb.code_seq }"> 
												<span class="checkmark"></span>
												<p style="width: 76.94; height: 23; margin: 0;" >${gb.code_nm }[${gb.code_cnt }]</p>
											</label>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</div>
					<!-- /Search Filter -->

					<!-- Search Filter -->
					<div class="card search-filter pc-view">
						<div class="card-body">
							<div class="filter-widget mb-0">
								<div class="categories-head d-flex align-items-center">
									<h4>기관</h4>
									<!-- <i class="fas fa-angle-down"></i> -->
								</div>
								<!-- <div id="selectUser" style="overflow: auto; height:309px;"> -->
								<c:if test="${courseUser.size() != 0 }">
									<div id="selectUser" style="overflow: auto; max-height:309px;">
										<div>
											<label class="custom_check" onchange="set_data();"> <input type="checkbox"
												id="chkUser" name="select_user" value="all" checked="checked"> 
												<span class="checkmark"></span>
												전체
											</label>
										</div>
									<c:forEach items="${courseUser }" var="courseUser" varStatus="status">
										<div>
											<label class="custom_check" onchange="set_data();"> <input type="checkbox"
												name="select_user" value="${courseUser.reg_inst_nm }"> <span class="checkmark"></span>
												${courseUser.reg_inst_nm }[${courseUser.cnt }]
											</label>
										</div>
									</c:forEach>
									</div>
								</c:if>
								<c:if test="${courseUser.size() == 0 }">
									<div style='text-align:center;color: blue;'>	데이터가 존재하지 않습니다. </div>
								</c:if>
								<!-- </div> -->
							</div>
						</div>
					</div>
					<!-- /Search Filter -->


					<!-- Latest Posts -->
					<div class="card post-widget">
						<div class="card-body">
							<div class="latest-head">
								<h4 class="card-title">최신 강좌</h4>
							</div>
							<ul class="latest-posts">
								<c:if test="${courseLatest.size() != 0 }">
								<c:forEach items="${courseLatest}" var="list" varStatus="status">
									<li>
										<div class="post-thumb">
											<a href="javascript:void(0)" onclick="go_detil(${list.course_seq});"> 
												<!-- <img class="img-fluid" src="/assets/img/blog/blog-01.jpg" alt=""> -->
												<c:if test="${list.file_save_path != '' }"> 
													<img class="img-fluid" src="${rootPath }${list.file_save_path}${list.save_filenm}" onError="this.src='/images/noimage.png'" alt="" 
															style="max-height: 44.83px; width: 100%;">
												<!-- <img class="img-fluid" onError="this.src='/images/noimage.png'" alt="">  -->
												</c:if>
												<c:if test="${list.file_save_path == '' }"> 
													<img class="img-fluid" src="/images/noimage.png" onError="this.src='/images/noimage.png'" alt="">
												<!-- <img class="img-fluid" onError="this.src='/images/noimage.png'" alt="">  -->
												</c:if>
											</a>
										</div>
										<div class="post-info free-color">
											<h4>
												<%-- <a href="/course/courseFindDetail.do">${list.course_nm }</a> --%>
												<a href='javascript:void(0)' onclick="go_detil(${list.course_seq});">${list.course_nm }
													
												</a>
											</h4>
											<p>${list.reg_inst_nm}</p>
										</div>
									</li>
								</c:forEach>
								</c:if>
								<c:if test="${courseLatest.size() == 0 }">
									<div style='text-align:center;color: blue;'>	데이터가 존재하지 않습니다. </div>
								</c:if>
							</ul>
						</div>
					</div>
					<!-- /Latest Posts -->

				</div>
			</div>
		</div>
	</div>
</section>
<!-- /Course -->

