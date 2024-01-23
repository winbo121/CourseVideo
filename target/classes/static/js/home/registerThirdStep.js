

$(function() {


	// gnb 반응형 처리
	if (matchMedia("screen and (max-width: 896px)").matches) {

		$('.m-top-uli').on('click', function() {
			$(this).toggleClass('active');
		});
		$('.m-top-uli > ul > li').on('click', function() {
			event.stopPropagation();
		});
	}

	else if (matchMedia("screen and (min-width: 1200px)").matches) {
		$('.gnb > ul > li').mouseover(function() {
			$('.header').addClass('active');
			$(this).addClass('active').siblings().removeClass('active');
		});

		$('.header').mouseleave(function() {
			$(this).removeClass('active');
			$('.gnb > ul > li').removeClass('active');
		});
	}

	$('.util .mypage button').on('click', function() {
		$('.util .mypage').toggleClass('active');
	});

	$(document).mouseup(function(e) {
		var myPage = $('.util .mypage');

		if (!$('.util .mypage button').is(e.target) && !myPage.is(e.target) && myPage.has(e.target).length == 0) {
			myPage.removeClass('active');
		}
	});


	$('.btn-menu-toggle').on('click', function() {
		$('.gnb').toggleClass('active');
		$('.header').toggleClass('active');
	});


});
/* lnb */
(function($) {

	var lnbUI = {
		click: function(target, speed) {
			var _self = this,
				$target = $(target);
			_self.speed = speed || 300;

			$target.each(function() {
				if (findChildren($(this))) {
					return;
				}
				$(this).addClass('noDepth');
			});

			function findChildren(obj) {
				return obj.find('> ul').length > 0;
			}

			$target.on('click', 'a', function(e) {
				e.stopPropagation();
				var $this = $(this),
					$depthTarget = $this.next(),
					$siblings = $this.parent().siblings();

				$this.parent('li').find('ul li').removeClass('on');
				$siblings.removeClass('on');
				$siblings.find('ul').slideUp(250);

				if ($depthTarget.css('display') == 'none') {
					_self.activeOn($this);
					$depthTarget.slideDown(_self.speed);
				} else {
					$depthTarget.slideUp(_self.speed);
					_self.activeOff($this);
				}

			})

		},
		activeOff: function($target) {
			$target.parent().removeClass('on');
		},
		activeOn: function($target) {
			$target.parent().addClass('on');
		}
	};

	// Call lnbUI
	$(function() {
		lnbUI.click('.lnb li', 300)
	});

}(jQuery));

/*
$().ready(function() {

	$(".alertStart").click(function() {
		alert("start click")
		Swal.fire({
			icon: 'success',
			title: '중복된 아이디가 없습니다.',
			text: '계속 회원 정보 입력을 진행해 주세요.',
		});
	});

	$(".alertStop").click(function() {
		alert("stop click")
		Swal.fire({
			icon: 'warning',
			title: '아이디가 존재합니다.',
			text: '다른 아이디를 입력해주세요',
		});
	});
	//ToDo 받아야 한다. 중복일 케이스


	$(".alertFail").click(function() {
		Swal.fire({
			icon: 'warning',
			title: '접속에 실패했습니다.',
			text: '회원 정보를 다시 확인해 주세요.',
		});
	});

	$(".alertSuccess").click(function() {
		Swal.fire({
			icon: 'success',
			title: '접속에 성공했습니다.',
			text: '회원 정보가 정확하게 일치합니다.',
		});
	});


	$(".alertComplete").click(function() {
		Swal.fire({
			icon: 'success',
			title: '회원가입이 완료되었습니다.',
			confirmButtonText: '메인으로 바로가기',
		});
	});

});
*/


$(function() {
	$("#confirm").click(function() {
		modalClose();
		//컨펌 이벤트 처리
	});
	$("#modal-open").click(function() {
		$("#popup").css('display', 'flex').hide().fadeIn();
	});
	$("#close").click(function() {
		modalClose();
	});
	function modalClose() {
		$("#popup").fadeOut();
	}
});

function duplicateCheckId() {
	if ($('#user-id').val() == null || $('#user-id').val() == '') {
		window.alert("id를 입력하세요");
		$('#user-id').focus();
		return
	}
	$.ajax({
		url: "/api/id/" + $('#user-id').val() + "/duplicated",
		type: "GET",
		data: {
		},
		contentType: 'application/json',
		dataType: 'json',
		success: function(result) {
			if (result) {
				Swal.fire({
					icon: 'success',
					title: '중복된 아이디가 없습니다.',
					text: '계속 회원 정보 입력을 진행해 주세요.',
				});
				$('#isDuplicatedId').val("Y");
			} else {
				Swal.fire({
					icon: 'warning',
					title: '아이디가 존재합니다.',
					text: '다른 아이디를 입력해주세요',
				});
				$('#isDuplicatedId').val("N");
			}
		},
		error: function(error) {
			window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
		}
	}); //ajax
};

function duplicateCheckEmail() {
	if ($('#user-email').val() == null || $('#user-email').val() == '') {
		window.alert("이메일을 입력하세요");
		$('#user-email').focus();
		return
	}
	
	let regex = new RegExp("^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
	if(!regex.test($('#user-email').val())) {
		window.alert("이메일 형식이 올바르지 않습니다.");
		$('#user-email').focus();
		return
	}
	
	$.ajax({
		url: "/api/email/" + $('#user-email').val() + "/duplicated",
		type: "GET",
		data: {
		},
		contentType: 'application/json',
		dataType: 'json',
		success: function(result) {
			if (result) {
				Swal.fire({
					icon: 'success',
					title: '중복된 이메일이 없습니다.',
					text: '계속 회원 정보 입력을 진행해 주세요.',
				});
				$('#isDuplicatedEmail').val("Y");
			} else {
				Swal.fire({
					icon: 'warning',
					title: '중복된 이메일이 존재합니다.',
					text: '다른 이메일을 입력해주세요',
				});
				$('#isDuplicatedEmail').val("N");
			}
		},
		error: function(error) {
			window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
		}
	}); //ajax
};

function inputIdChange() {
	$('#isDuplicatedId').val("N");
}

function inputEmailChange() {
	$('#isDuplicatedEmail').val("N");
}

function schoolSearch() {
	$.ajax({
		url: "/api/schools",
		type: "GET",
		data: {
			schoolNm: $('#school-search-input').val()
		},
		contentType: 'application/json',
		dataType: 'json',
		success: function(result) {
			var html = '';
			$('#school-search *').remove();
			if (result.searchList.length > 0) {
				$.each(result.searchList, function(idx) {
					html += '<tr >';
					html += '<td style="cursor:pointer" onClick="setSchool(\'' + this.schoolNm + '\', \'' + this.schoolSeq + '\', \''+ this.cityCode + '\', \'' + this.schoolType + '\')">' + this.schoolNm + '</a></td>'
					html += '<td>' + this.cityNm + '</td>';
					if(this.distNm!=null && this.distNm!=""){
						html += '<td>' +this.distNm  + '</td>';	
					}else{
						html += '<td>-</td>';}
					html += '</tr>';
				})
				
			} else {
				html += '<tr> 검색된 결과가 없습니다. </tr>';
			}

			$('#school-search').append(html);
		},
		error: function(error) {
			window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
		}
	}); //ajax
};

function setSchool(schoolNm, schoolSeq, cityCode, schoolType) {
	$('#school-name-value').val(schoolNm); 
	$('#schoolSeq').val(schoolSeq);
	$('#cityCode').val(cityCode);
	
	if(schoolType!="E"){
		var schoolGrade = '<option value="1">1학년</option>';
		schoolGrade +='<option value="2">2학년</option>';
		schoolGrade +='<option value="3">3학년</option>';
		if(schoolType=="B" || schoolType=="E"){
			schoolGrade +='<option value="4">4학년</option>';
			schoolGrade +='<option value="5">5학년</option>';
			schoolGrade +='<option value="6">6학년</option>';		
		}
	}else{
		var schoolGrade = '<option value="0" readOnly>-</option>';
	}
	$('#grade').empty();
	$('#grade').append(schoolGrade);
	
	$('.school-close').trigger("click");
	
}

function relateSiteLoginBaseCampCheck(p) {
	if ($('#baseCampId').val() == null || $('#baseCampId').val() == '') {
		window.alert("id를 입력하세요");
		$('#baseCampId').focus();
		return
	}
	if ($('#baseCampPasswd').val() == null || $('#baseCampPasswd').val() == '') {
		window.alert("password를 입력하세요");
		$('#baseCampPasswd').focus();
		return
	}

	$.ajax({
		url: "/api/relate/basecamp",
		type: "GET",
		data: {
			mb_id: $('#baseCampId').val(),
			mb_passwd: $('#baseCampPasswd').val(),
			linkPart:p
		},
		contentType: 'application/json',
		dataType: 'json',
		success: function(result) {
			if (result) {
				Swal.fire({
					icon: 'success',
					title: '접속에 성공했습니다.',
					text: '회원 정보가 정확하게 일치합니다.',
				});

				$('#connectionBasecampSuccessYn').val("Y");
				$('#connectionBasecampId').val($('#baseCampId').val());
				$('#connectionBasecampPassword').val($('#baseCampPasswd').val());
				$('#connectionBasecampTestDts').val(new date());

			} else {
				Swal.fire({
					icon: 'warning',
					title: '접속에 실패했습니다.',
					text: '회원 정보를 다시 확인해 주세요.',
				});
				connectionBasecampValueInit();
			}
		},
		error: function(error) {
			window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
		}
	}); //ajax
};

function connectionBasecampValueInit() {
	$('#connectionBasecampSuccessYn').val("N");
	$('#connectionBasecampId').val('');
	$('#connectionBasecampPassword').val('');
	$('#connectionBasecampTestDts').val('');
}

function registerUserValidation() {
	if ($('#isDuplicatedId').val() == 'N') {
		window.alert("ID 중복 확인 후 생성해주세요.");
		$('#user-id').focus();
		return false;
	}
	if ($('#isDuplicatedEmail').val() == 'N') {
		window.alert("이메일 중복 확인 후 생성해주세요.");
		$('#user-email').focus();
		return false;
	}
	if ($('#user-name').val() == null || $('#user-name').val() == '') {
		window.alert("이름을 입력하세요");
		$('#user-name').focus();
		return false;
	}
	if ($('#user-passwd').val() == null || $('#user-passwd').val() == '') {
		window.alert("비밀번호를 입력하세요");
		$('#user-passwd').focus();
		return false;
	}
	if ($('#user-passwd-cfrm').val() == null || $('#user-passwd-cfrm').val() == '') {
		window.alert("비밀번호 확인란을 입력하세요");
		$('#user-passwd-cfrm').focus();
		return false;
	}
	if ($('#user-passwd').val() !== $('#user-passwd-cfrm').val()) {
		window.alert("비밀번호가 일치 하지 않습니다.");
		$('#user-passwd-cfrm').focus();
		return false;
	}
	if ($('#school-name-value').val() == null || $('#school-name-value').val() == '') {
		window.alert("학교를 선택해주세요");
		$('#school-name-value').focus();
		return false;
	}
	if ($('#connectionBasecampSuccessYn').val() == 'Y' &&
		$('#connectionBasecampId').val() == '' &&
		$('#connectionBasecampPassword').val() == '' &&
		$('#connectionBasecampTestDts').val() == '') {
		window.alert("인증을 다시 진행해 주세요");
		$('#connectionBasecampId').focus();
		return false;
	}
	return true;
}


function registerUser() {
	if (!registerUserValidation()) {
		return
	}

	$.ajax({
		url: "/api/user",
		type: "POST",
		data: JSON.stringify({
			userId: $('#user-id').val(),
			password: $('#user-passwd').val(),
			userNm: $('#user-name').val(),
			email: $('#user-email').val(),
			joinDt: 'TCH',
			grade: ($('#grade').val() !== '' ? $('#grade').val() : null),
			schClass: $('#schClass').val(),
			schoolSeq: $('#schoolSeq').val(),
			cityCode: $('#cityCode').val(),
			agree: $('#agree').val(),
			connectionOrganAccounts: [{
				connectSuccessYn: $('#connectionBasecampSuccessYn').val(),
				id: $('#connectionBasecampId').val(),
				password: $('#connectionBasecampPassword').val(),
				connectTestDts: $('#connectionBasecampTestDts').val(),
				linkSite: 'RELATE_SITE_URL_BASE_CAMP'
			}, {
				connectSuccessYn: $('#connectionPlaseduSuccessYn').val(),
				id: $('#connectionPlaseduId').val(),
				password: $('#connectionPlaseduPassword').val(),
				connectTestDts: $('#connectionPlaseduTestDts').val(),
				linkSite: 'RELATE_SITE_URL_PLASEDU'
			}, {
				connectSuccessYn: $('#connectionSbasicSuccessYn').val(),
				id: $('#connectionSbasicId').val(),
				password: $('#connectionSbasicPassword').val(),
				connectTestDts: $('#connectionSbasicTestDts').val(),
				linkSite: 'RELATE_SITE_URL_SBASIC'
			}]
		}),
		contentType: 'application/json',
		dataType: 'json',
		success: function(result) {
			if(result){
				Swal.fire({
					icon: 'success',
					title: '회원가입이 완료되었습니다.',
					confirmButtonText: '메인으로 바로가기',
				}).then((result) => {
					location.href="/user/userLogin.do"
				});
			} else {
				window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
			}
		},
		error: function(error) {
			window.alert("통신중 에러가 발생하였습니다. 관리자에 문의하세요.");
		}
	}); //ajax
}

function schoolDataInit(){
	$('#school-search *').remove();
}
