﻿$(document).ready(function(e) {
	// browser download link
	if($(document).find(".oldBrowserAlert").length > 0) {
		$(".oldBrowserAlert").delay(100).stop(true, true).animate({"top": 0}, 600);

		$(".oldBrowserAlert").on("click", ".btClose", function(evt) {
			$(".oldBrowserAlert").delay(100).stop(true, true).animate({"top": -500}, 600);
		});
	}

	// favicon icons
	var favicon = function() {
		$("head").append('<link rel="apple-touch-icon" href="/assets/images/72x72.png"/>');
	}

	var checkBrowser = function() {
		var agt = navigator.userAgent.toLowerCase();
		if (agt.indexOf("chrome") != -1) return 'Chrome';
		if (agt.indexOf("opera") != -1) return 'Opera';
		if (agt.indexOf("staroffice") != -1) return 'Star Office';
		if (agt.indexOf("webtv") != -1) return 'WebTV';
		if (agt.indexOf("beonex") != -1) return 'Beonex';
		if (agt.indexOf("chimera") != -1) return 'Chimera';
		if (agt.indexOf("netpositive") != -1) return 'NetPositive';
		if (agt.indexOf("phoenix") != -1) return 'Phoenix';
		if (agt.indexOf("firefox") != -1) return 'Firefox';
		if (agt.indexOf("safari") != -1) return 'Safari';
		if (agt.indexOf("skipstone") != -1) return 'SkipStone';
		if (agt.indexOf("msie") != -1) return 'Internet Explorer';
		if (agt.indexOf("netscape") != -1) return 'Netscape';
		if (agt.indexOf("mozilla/5.0") != -1) return 'Mozilla';
	}

	function onCheckDevice() {
		var deviceAgent = navigator.userAgent.toLowerCase();
		var agentIndex = deviceAgent.indexOf('android');

		if (agentIndex != -1) {
			var androidversion = parseFloat(deviceAgent.match(/android\s+([\d\.]+)/)[1]);

			$("body").addClass("android");

			favicon();

			if (androidversion < 4.1) {
				$("body").addClass("android_old android_ics");
			}
			else if (androidversion < 4.3) {
				$("body").addClass("android_old android_oldjb");
			}
			else if (androidversion < 4.4) {
				$("body").addClass("android_old android_jb");
			}
			else if (androidversion < 5) {
				$("body").addClass("android_old android_kk");
			}

			if(checkBrowser() == "Chrome"
				|| checkBrowser() == 'Firefox'
				|| checkBrowser() == 'Mozilla')
			{
				$("body").removeClass("android_ics android_oldjb android_jb");
			}
		}
		else if(deviceAgent.match(/msie 8/) != null || deviceAgent.match(/msie 7/) != null) {
			$("body").addClass("old_ie");
		}
	}

	onCheckDevice();

	// input tag focus
	$(document).on("focus", ".comText, textarea", function(evt) {
		$(this).parent().addClass("focus");
	}).on("blur", ".comText, textarea", function(evt) {
		$(this).parent().removeClass("focus");
	});

	// css check
	window.checkSupported = function(property) {
		return property in document.body.style;
	}


	// checkbox
	window.chkBox = (function() {
		function init() {
			$(document).on("focus", ".hid_chk", onFocus).on("blur", ".hid_chk", onBlur).on("change", ".hid_chk", onChange);

			$(document).on("reset", "form", function(evt) {
				var chkBg = $(this).find(".hid_chk");

				setTimeout(function() {
					$(chkBg).each(function() {
						onCheckChkbox($(this));
					});
				}, 30);
			});

			var chkBg = $(".hid_chk");
			$(chkBg).each(function() {
				onCheckChkbox($(this));
			});
		}

		function onCheckChkbox(chkBg) {
			if($(chkBg).is(":checked")) {
				$(chkBg).parent().children("label").addClass("on");
				$(chkBg).prop("checked", true);
			}
			else {
				$(chkBg).parent().children("label").removeClass("on");
			}
		}

		function onFocus(evt) {
			if($(this).is(":disabled")) return;

			var lbObj = $(this).parent().children("label");
			lbObj.addClass("focus");
		}

		function onBlur(evt) {
			var lbObj = $(this).parent().children("label");
			lbObj.removeClass("focus");
		}

		function onChange(evt) {
			var lbObj = $(this).parent().children("label");
			if($(this).is(":checked")) lbObj.addClass("on");
			else lbObj.removeClass("on");
		}

		function bindEvent(target) {
			$(target).bind({
				focus : onFocus,
				blur : onBlur,
				change : onChange
			});

			if($(target).is(":checked")) {
				$(target).parent().children("label").addClass("on");
				$(target).prop("checked", true);
			}
		}

		return {
			init : init,
			bindEvent : bindEvent
		}
	}());


	// radio box
	window.rdoBox = (function() {
		function init() {
			$(document).on("focus", ".hid_rdo", onFocus).on("blur", ".hid_rdo", onBlur).on("change", ".hid_rdo", onChange);

			$(document).on("reset", "form", function(evt) {
				var rdoBg = $(this).find(".hid_rdo");

				setTimeout(function() {
					$(rdoBg).each(function() {
						onCheckRdobox($(this));
					});
				}, 30);
			});

			var rdoBg = $(".hid_rdo");
			$(rdoBg).each(function() {
				onCheckRdobox($(this));
			});
		}

		function onCheckRdobox(target) {
			var groupName = $(target).attr("name");
			var rdoObj = $("input.hid_rdo[name='" + groupName + "']:checked");

			if(rdoObj.length > 0) {
				$("input.hid_rdo[name='" + groupName + "']").parent().children("label").removeClass("on");
				$(rdoObj).parent().children("label").addClass("on");
			}
			else {
				$("input.hid_rdo[name='" + groupName + "']").parent().children("label").removeClass("on");
			}
		}

		function onFocus(evt) {
			if($(this).is(":disabled")) return;

			var groupName = $(this).attr("name");
			$("input.hid_rdo[name='" + groupName + "']").parent().children("label").removeClass("focus");
			$(this).parent().children("label").addClass("focus");
		}

		function onBlur(evt) {
			var groupName = $(this).attr("name");
			$("input.hid_rdo[name='" + groupName + "']").parent().children("label").removeClass("focus");
		}

		function onChange(evt) {
			var groupName = $(this).attr("name");
			$("input.hid_rdo[name='" + groupName + "']").parent().children("label").removeClass("on");
			$(this).parent().children("label").addClass("on");
		}

		function bindEvent(target) {
			$(target).bind({
				focus : onFocus,
				blur : onBlur,
				change : onChange
			});

			onCheckRdobox(target);
		}

		return {
			init : init,
			bindEvent : bindEvent
		}
	}());


	chkBox.init();
	rdoBox.init();

	// select
	var selectList = (function() {
		function init() {
			// select
			$(document).on("change", ".selectbox select", function(evt) {
				var text = $(this).find("option:selected").text();
				$(this).siblings(".txt").text(text);
			}).on("keyup", ".selectbox > .txt", function(evt) {
				var keyCode = evt.keyCode;
				var labelText = $(this).text();
				var selectObj = $(this).siblings("select");
				var idx = ($(this).text() == $(selectObj).children("option:selected").text()) ? $(selectObj).children("option:selected").index() : 0;

				if(keyCode == 38 || keyCode == 37) {
					if(idx == 0) $(selectObj).children().eq($(selectObj).children().length - 1).attr("selected", "selected").trigger("change");
					else $(selectObj).children().eq(idx - 1).attr("selected", "selected").trigger("change");
				}
				else if(keyCode == 40 || keyCode == 39) {
					if(idx == ($(selectObj).children().length - 1)) $(selectObj).children().eq(0).attr("selected", "selected").trigger("change");
					else $(selectObj).children().eq(idx + 1).attr("selected", "selected").trigger("change");
				}
			}).on("click", ".selectbox > .txt", function(evt) {
				return false;
			}).on("focus", ".selectbox select", function(evt) {
				$(this).siblings(".txt").addClass("focus");
			}).on("blur", ".selectbox select", function(evt) {
				$(this).siblings(".txt").removeClass("focus");
			}).on("reset", "form", function(evt) {
				var selects = $(this).find(".selectbox select");

				setTimeout(function() {
					$(selects).each(function(i) {
						var text = ($(this).find("option:selected").text().length > 0) ? $(this).find("option:selected").text() : $(this).find("option").eq(0).text();
						$(this).siblings(".txt").text(text);
					});
				}, 30);
			});

			// init select box value
			$(".selectbox select").each(function(i) {
				// var title = $(this).attr("title") + "\n상하 화살표키를 이용해 값을 선택하실 수 있습니다.";
				// $(this).attr("title", title);

				var text = ($(this).find("option:selected").text().length > 0) ? $(this).find("option:selected").text() : $(this).find("option").eq(0).text();
				$(this).siblings(".txt").text(text);
			});

		}

		return {
			init : init
		};
	}());

	// dropdown list
	var dropList = (function() {
		function init() {
			var time = 150;

			// dropdown list
			$(document).on("change", ".dropLst .hidradio", function(evt) {
				var groupName = $(this).attr("name");
				var radios = $(".hidradio[name=" + groupName + "]");
				var checked = radios.filter(function() { return $(this).prop("checked") === true; });
				var text = $(checked).parents("label").find(".value").text();
				var list = $(checked).parents(".dlst").eq(0);

				$(list).find("label").removeClass("on");
				$(checked).parents("label").eq(0).addClass("on");

				$(list).siblings(".txt").text(text).removeClass("on");
				$(checked).parents(".dlst").slideUp(time);
			}).on("click", ".dropLst > a", function(evt) {
				evt.preventDefault();

				var label = $(this);
				var target = $(this).parents(".dropLst").eq(0);
				var list = $(this).siblings(".dlst");
				var openList = $(".dropLst").filter(function() { return $(this).find(".dlst").css("display") != "none" && $(this) != target });

				$(openList).find(".dlst").stop().slideUp(time);
				$(".dropLst > a").removeClass("on");

				$(list).stop().slideToggle(time, function() {
					if($(this).css("display") != "none") $(label).addClass("on");
					else $(label).removeClass("on");
				});
			}).on("click", ".dropLst li a", function(evt) {
				$(this).parents(".dlst").eq(0).stop().slideUp(time, function() {
					$(this).siblings(".txt").focus();
				});

				$(".dropLst > a").removeClass("on");
			}).on("keyup", ".dropLst > a", function(evt) {
				var keyCode = evt.keyCode;

				var target = $(this).parents(".dropLst").eq(0);
				var list = $(this).siblings(".dlst");
				var chkRadio = $(this).siblings(".dlst").find(".hidradio:checked");
				var hoverRadio = $(list).find(".hover");
				var idx = -1;

				if(hoverRadio.length < 1) idx = (chkRadio.parents("li").eq(0).index() > -1) ? chkRadio.parents("li").eq(0).index() : 0;
				else idx = hoverRadio.parents("li").eq(0).index();

				var openList = $(list).filter(function() { return $(this).css("display") != "none" });
				if(openList.length < 1) return false;

				if(keyCode == 13) {
					$(list).find("li").find(".hover").find(".hidradio").prop("checked", true).trigger("change");
					$(list).find("label").removeClass("hover");
				}
				else if(keyCode == 38 || keyCode == 37) {
					$(list).find("label").removeClass("hover");

					if(idx == 0) $(list).find("li").eq($(list).find("li").length - 1).find("label").addClass("hover");
					else $(list).find("li").eq(idx - 1).find("label").addClass("hover");
				}
				else if(keyCode == 40 || keyCode == 39) {
					$(list).find("label").removeClass("hover");

					if(idx == ($(list).find("li").length - 1)) $(list).find("li").eq(0).find("label").addClass("hover");
					else $(list).find("li").eq(idx + 1).find("label").addClass("hover");
				}
			}).on("click touchstart", function(evt) {
				var evt = evt ? evt : event;
				var target = null;

				if (evt.srcElement) target = evt.srcElement;
				else if (evt.target) target = evt.target;

				var openList = $(".dropLst").filter(function() { return $(this).find(".dlst").css("display") != "none" });
				if($(target).parents(".dropLst").eq(0).length < 1) {
					$(openList).find(".dlst").slideUp(time);
					$(".dropLst > a").removeClass("on");
				}
			});

			// init dropdown list value
			$(".dropLst").each(function(i) {
				var groupName = $(this).find(".hidradio").eq(0).attr("name");
				var radios = $(".hidradio[name=" + groupName + "]");
				var checked = $(radios).filter(function() { return $(this).prop("checked") === true; });
				var text = $(checked).parents("label").find(".value").text();
				var list = $(checked).parents(".dlst").eq(0);

				$(list).find("label").removeClass("on");
				$(checked).parents("label").eq(0).addClass("on");

				$(list).siblings(".txt").text(text);
			});
		}

		return {
			init : init
		};
	}());

	selectList.init();
	dropList.init();

	jqDatePicker.init();

	// placeholder
	//$(".comText[type=text]").placeholder();


	// file event
	$(document).on("change", ".file", function(evt) {
		var file = $(this).val().split(/(\\|\/)/g).pop();
		var ext = file.split(".").pop();
		var fileLabel = $(this).siblings(".fileName");
		var helpText = fileLabel.attr("title");

		if(file.length > 1) fileLabel.text(file).addClass("sel_file");
		else fileLabel.text(helpText).removeClass("sel_file");
	}).on("focus", ".file", function(evt) {
		$(this).siblings(".fileName").addClass("focus");
	}).on("blur", ".file", function(evt) {
		$(this).siblings(".fileName").removeClass("focus");
	}).on("reset", "form", function(evt) {
		var form = $(this);
		var length = form.find(".hidFile").length;

		if(length > 0) {
			setTimeout(function() {
				var helpText = (form.find(".file").siblings(".fileName").attr("title")) ? form.find(".file").siblings(".fileName").attr("title").length : "";
				form.find(".file").siblings(".fileName").text(helpText).removeClass("sel_file");
			}, 30);
		}
	});


	// footer link
	$('#footer .family .h6').click(function(evt) {
		evt.preventDefault();

		var list = $('#footer .family ul');
		var time = 200;
		var ease = "easeOutExpo";

		var checkTarget = function(evt) {
			var evt = evt ? evt : event;
			var target = null;

			if (evt.srcElement) target = evt.srcElement;
			else if (evt.target) target = evt.target;

			if(!$(target).is(".h6")) {
				list.stop().hide(time, ease);
			}
		}

		$(document).unbind("click", checkTarget).bind("click", checkTarget);

		if(list.css("display") == "block") {
			list.stop().hide(time, ease);
		}
		else {
			list.stop().show(time, ease);
		}
	});


	// delete button
	$(".textDelete").each(function(i) {
		onDeleteText($(this));
	});

	// textbox delete button;
	function onDeleteText(target) {
		var btnObj = $(target).siblings(".btn_text_del");

		if(target.val().length > 0 && !(target.attr("readonly"))) btnObj.show();

		target.on("keyup", function() {
			if(target.val().length > 0) btnObj.show();
		}).on("focus", function() {
			if(target.val().length > 0 && !(target.attr("readonly"))) btnObj.show();
		});

		btnObj.on("click", function(evt) {
			target.val("");

			target.focus();
			btnObj.hide();
		});
	}


	// common
	kcie_Gnb.init();

	// imagemap
	//$('img[usemap]').rwdImageMaps();
});

var jqDatePicker = (function() {
	function init() {
		$.datepicker.regional['kr'] = {
			autoSize:true,
			showMonthAfterYear:true,
			dateFormat:"yy.mm.dd",
			minDate: "-100y",
			maxDate: "+1y",
			yearRange: "-100:+0",
			showButtonPanel: false,
			closeText: "닫기",
			currentText: 'Today',
			dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
			dayNamesMin:["일", "월", "화", "수", "목", "금", "토"],
			monthNames:["- 01","- 02","- 03","- 04","- 05","- 06","- 07","- 08","- 09","- 10","- 11","- 12"],
			monthNamesShort: [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12" ]
		};

		$.datepicker.setDefaults($.datepicker.regional['kr']);
		//$.datepicker.setDefaults(dateOption);

		$(".txtDate").datepicker();
	}
	return {
		init : init
	};
}());

var loading = {
	show : function() {
		var html = '<div class="loadings"><div></div></div>';
		$("body").append(html);
	},

	hide : function() {
		$(".loadings").remove();
	}
}

var kcie_Gnb = (function() {
	var nav = null;
	var subNav = null;
	var gnbBg = null;
	var offHeight = 65;
	var ease = "easeOutExpo";

	function init() {
		$(document).ready(function() {
			// gnb navi
			nav = $(".gnb_panel");
			if(nav.length < 1) return false;

			// window event
			//$(window).scroll(onScroll).resize(onResize);

			subNav = nav.find(".sub_nav");
			offHeight = nav.find(".mnu").eq(0).outerHeight();

			//bg1
			$("body").append("<div class='wrapBg'></div>");
			wrapBg = $(".wrapBg");

			// bg2
			$("body").append("<div class='gnbBg'></div>");
			gnbBg = $(".gnbBg");

			// hover
			$(".gnb").on("click", ".mnu", onToggleGnb);
			$( ".gnbBg" ).on( "click", onHideGnb );

			// sub Hover
			$(".nav").on("mouseenter", function(){
				$( ".mnu" ).removeClass( "hover" );
				$(this).children(".mnu").addClass("hover");
			});
			$(".nav").on("mouseleave", function(){
				$(this).children(".mnu").removeClass("hover");
			});
			$(".dep2 > li > a").on("focus", function(){
				$(this).parents(".nav").children(".mnu").addClass("hover");
			});
			$(".dep2 > li > a").on("focusout", function(){
				$(this).parents(".nav").children(".mnu").removeClass("hover");
			});
		});
	}

	// head fixed check
	/*
	function onScroll() {
		var left = $(window).scrollLeft();
		var leftObj = $(".header");
		if(leftObj.length > 0 && leftObj.css("position") == "fixed") {
			leftObj.css("left", (-1 * left) + "px");
		}
		else {
			leftObj.css("left", 0);
		}
	}
	*/
	
	
	function onToggleGnb(e){
		if( $( ".header" ).hasClass( "on" ) == false ) {
			$( ".mnu" ).blur();
			$( ".mnu" ).removeClass( "hover" );
			
			
			$(".header").addClass("on");
			$(".gnbBg").css('display', "block");
			
			return;
		}
		
		$(".nav > li").removeClass("hover");
		$(".header").removeClass("on");
		$(".gnbBg").css('display', "none");
	
	}

	function onShowGnb() {
		$(".header").addClass("on");
		$(".gnbBg").css('display', "block");
		//$(".gnbs_back").addClass("on");
		//$(".sliderArea").addClass("on")
	}

	function onHideGnb() {
		$(".nav > li").removeClass("hover");
		$(".header").removeClass("on");
		$(".gnbBg").css('display', "none");
		//$(".gnbs_back").removeClass("on");
		//$(".sliderArea").removeClass("on");
	}

	return {
		init : init,
		show : onShowGnb,
		hide : onHideGnb,
	}
}());

// Main
$(document).ready(function() {
	$("#main .boards .head a").on("click", function(){
		$("#main .boards article").removeClass("on");
		$(this).parent().parent().addClass("on");
		return false;
	});

	$("#marketingBanner").slick({
		slickPause : true,
		slickPlay : true,
		arrows : false,
		dots : true,
		autoplay: true,
		autoplaySpeed: 3000,
	});
	$("#mainPage .bannerControl .btn_stop").on("click", function(evt){
		$("#marketingBanner").slick("slickPause");
		$(this).removeClass("active");
		$("#mainPage .bannerControl .btn_play").addClass("active");
		return false;
	});
	$("#mainPage .bannerControl .btn_play").on("click", function(evt){
		$("#marketingBanner").slick("slickPlay");
		$(this).removeClass("active");
		$("#mainPage .bannerControl .btn_stop").addClass("active");
		return false;
	});

	$("nav ul.dep2").hide();
	$("nav li.on ul.dep2").show();
	$("nav li.dep1.off > a").on("click", function(evt){
		if($(this).parent().hasClass("active"))
		{
			$("nav li.dep1").removeClass("active");
			$("nav li.off ul.dep2").slideUp();
		}
		else
		{
			$("nav li.dep1").removeClass("active");
			$("nav li.off ul.dep2").slideUp();
			$(this).parent().addClass("active");
			$(this).parent().children("ul.dep2").slideDown();
		};
		return false;
	});
	
	$("nav li.dep1.on > a").on("click", function(evt){
		if($(this).parent().hasClass("active"))
		{
			$("nav li.dep1").removeClass("active");
			$("nav li.dep1.on a").addClass("no-after");
			$("nav li.on ul.dep2").slideUp();
		}
		else
		{
			$("nav li.dep1").removeClass("active");
			$("nav li.dep1.on a").removeClass("no-after");
			$("nav li.on ul.dep2").slideUp();
			$(this).parent().addClass("active");
			$(this).parent().children("ul.dep2").slideDown();
		};
		return false;
	});	
	
});

// popup

$(document).ready(function() {
	$(".popup a.btn_close").on("click", function(){
		var pp = $(this).parents(".popup");
		var popupObj = pp.data("bpopup");
		if(popupObj) {
			popupObj.close();
		} else {
            pp.bPopup().close();
        }
		return false;
	});
	$(".btn_popup").on("click", function(){
		if($(this).hasClass("btn_social"))
		{
			$(".popup_social").bPopup();
		}
		else if ($(this).hasClass("btn_application")){
			$(".popup_application").bPopup();
		}
		else if ($(this).hasClass("btn_video")){
			$(".popup_video").bPopup();
		}
		else if ($(this).hasClass("btn_cardnews")){
			$(".popup_cardnews").bPopup();
		}
		return false;
	});

	$("a.btnTab").on("click", function(){
		$(".pageTab2 ul li").removeClass("on");
		$(this).parent().addClass("on");
		if($(this).hasClass("btnTab01"))
		{
			$(".tab01").show();
			$(".tab02").hide();
		}
		else
		{
			$(".tab02").show();
			$(".tab01").hide();
		}
		return false;
	});

	$(".inputFile").on("change", function(){
		var $val = $(this).val();
		$(this).parent().children(".fileName").text($val);
		return false;
	});

	$(".question a").on("click", function(){
		if($(this).hasClass("active")){
			$(this).removeClass("active");
			$(this).parent().parent().children(".answer").slideUp();
		}
		else
		{
			$(".faqList .box .answer").slideUp();
			$(".question a").removeClass("active");
			$(this).addClass("active");
			$(this).parent().parent().children(".answer").slideDown();
		}
		return false;
	});

	$(".btn_like_d").on("click", function(){
		if($(this).hasClass("active")){
			$(".btn_like_d").removeClass("active");
		}
		else
		{
			$(".btn_like_d").addClass("active");
		}
		return false;
	});

	$(".btn_like").on("click", function(){
		if($(this).hasClass("active")){
			$(this).removeClass("active");
		}
		else
		{
			$(this).addClass("active");
		}
		return false;
	});

	$(".popup_content .btn_open").on("click", function(){
		var $slider = $(this).parent().find(".commentArea")
		if($(this).hasClass("active")){
			$(this).removeClass("active");
			$slider.hide();
		}
		else
		{
			$(this).addClass("active");
			$slider.show();
		}
		$(this).parents(".popup_content").bPopup().reposition();;
		return false;
	});

	// const player = new Plyr('#player', {});

	$('#slickSlider').slick({});
});
// test
/*
$(document).ready(function() {
	//현재 스크롤 탑 위치 채크
	$(window).scroll(function(){
		if($(window).scrollTop() > 669){
			$(".header2").addClass("on");
		}
		else {
			$(".header2").removeClass("on");
		}
	});

	//maxlength 체크
	  function maxLengthCheck(object){
	   if (object.value.length > object.maxLength){
		object.value = object.value.slice(0, object.maxLength);
	   }
	  }
});
*/
