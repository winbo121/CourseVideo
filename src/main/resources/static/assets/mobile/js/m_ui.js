$(document).ready(function(e) {
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
		var isMoble = (/(iphone|ipod|ipad|android|blackberry|windows ce|palm|symbian)/i.test(navigator.userAgent)) ? "mobile" : "pc";
		$("body").addClass(isMoble);

		var deviceAgent = navigator.userAgent.toLowerCase();
		var agentIndex = deviceAgent.indexOf('android');

		if(agentIndex != -1) {
			var androidversion = parseFloat(deviceAgent.match(/android\s+([\d\.]+)/)[1]);

			$("body").addClass("android");

			// favicon();

			if(androidversion < 4.1) {
				$("body").addClass("android_old android_ics");
			}
			else if(androidversion < 4.3) {
				$("body").addClass("android_old android_oldjb");
			}
			else if(androidversion < 4.4) {
				$("body").addClass("android_old android_jb");
			}
			else if(androidversion < 5) {
				$("body").addClass("android_old android_kk");
			}
			else if(androidversion < 6) {
				$("body").addClass("android_old");
			}

			if(checkBrowser() == 'Firefox'
				|| checkBrowser() == 'Mozilla') {
				$("body").removeClass("android_ics android_oldjb android_jb android_kk");
			}
			else if(checkBrowser() == "Chrome") {
				var chromeVersion = parseInt(deviceAgent.substring(deviceAgent.indexOf("chrome") + ("chrome").length + 1));

				if(chromeVersion > 40) {
					$("body").removeClass("android_old android_ics android_oldjb android_jb android_kk");
				}
				else {
					$("body").removeClass("android_ics android_oldjb android_jb android_kk");
				}
			}
		}
		else if(deviceAgent.match(/msie 8/) != null || deviceAgent.match(/msie 7/) != null) {
			$("body").addClass("old_ie");
		}
		else if(deviceAgent.match(/iphone|ipod|ipad/) != null) {
			$("body").addClass("ios");
		}
	}

	// check device
	onCheckDevice();

	// ios fixed issue
	if(navigator.userAgent.match(/iPhone|iPod|iPad/) != null) {
		window.fixedTimer = null;

		$(document).on("focus", "select, input, textarea", function(evt) {
			clearTimeout(window.fixedTimer);
			window.fixedTimer = null;
			$("body").addClass("noFixed");
		}).on("blur", "select, input, textarea", function(evt) {
			clearTimeout(window.fixedTimer);
			window.fixedTimer = null;

			var scrollTop = $(window).scrollTop();

			window.fixedTimer = setTimeout(function() {
				$("body").removeClass("noFixed");
				$("html body").scrollTop(scrollTop);
				window.dispatchEvent(new Event('resize'));
			}, 100);
		});
	}


	/*
	if($("body").hasClass("mobile")) {
		$(document).on("focus", "select, input, textarea", function(evt) {
			$("meta[name=viewport]").attr("content", "width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi");
		}).on("blur", "select, input, textarea", function(evt) {
			$("meta[name=viewport]").attr("content", "width=device-width, initial-scale=1.0, maximum-scale=2.0, minimum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi");
		});
	}
	*/

	// css check
	window.checkSupported = function(property) {
		return property in document.body.style;
	}

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

				if($(list).siblings(".txt").find(".val").length > 0) {
					$(list).siblings(".txt").find(".val").text(text);
				}
				else {
					$(list).siblings(".txt").text(text);
				}

				$(list).siblings(".txt").removeClass("on");
				$(checked).parents(".dlst").slideUp(time);
			}).on("click", ".dropLst > a", function(evt) {
				evt.preventDefault();

				var label = $(this);
				var target = $(this).parents(".dropLst").eq(0);
				var list = $(this).siblings(".dlst");
				var openList = $(".dropLst").filter(function() { return $(this).find(".dlst").css("display") != "none" && $(this) != target });

				$(openList).find(".dlst").stop().slideUp(time);
				$(target).find(" > a").removeClass("on").addClass("active");

				$(list).stop().slideToggle(time, function() {
					if($(this).css("display") != "none") $(label).addClass("on");
					else $(label).removeClass("on");

					$(label).removeClass("active");
				});
			}).on("click", ".dropLst li a", function(evt) {
				var target = $(this);
				var value = target.text();

				target.parents(".dlst").eq(0).stop().slideUp(time, function() {
					if(target.attr("target") == undefined) {
						if($(this).siblings(".txt").find(".val").length > 0) {
							$(this).siblings(".txt").find(".val").text(value);
						}
						else {
							$(this).siblings(".txt").text(value);
						}
					}

					$(this).siblings(".txt").focus();
				});

				$(".dropLst > a").removeClass("on");

				if(target.attr("target") == undefined) {
					target.parents(".dlst").eq(0).find("li a").removeClass("on");
					target.addClass("on");
				}
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
			}).on("focus", ".dropLst .dlst label", function(evt) {
				$(this).on("keyup", addEnterKeyEvent);
			}).on("blur", "label", function(evt) {
				$(this).off("keyup", addEnterKeyEvent);
			}).on("click touchstart", function(evt) {
				var evt = evt ? evt : event;
				var target = null;

				if (evt.srcElement) target = evt.srcElement;
				else if (evt.target) target = evt.target;

				var openList = $(".dropLst").filter(function() { return $(this).find(".dlst").css("display") != "none" });
				var activeList = $(".dropLst").filter(function() { return $(this).find(".txt").hasClass("on") === true });
				if($(target).parents(".dropLst").eq(0).length < 1) {
					$(openList).find(".dlst").slideUp(time);
					$(".dropLst > a").removeClass("on").removeClass("active");
				}
				else if(activeList.length > 0) {
					if(evt.type == "click") {
						activeList.find(".txt").removeClass("on").removeClass("active");
					}
				}
			});

			function addEnterKeyEvent(evt) {
				var keyCode = evt.keyCode;
				if(keyCode == 13) {
					$(this).children(".hidradio").prop("checked", true).trigger("change");
					$(this).parents(".dropLst").eq(0).find(".txt").focus();
				}
			}

			// init dropdown list value
			$(".dropLst").each(function(i) {
				var groupName = $(this).find(".hidradio").eq(0).attr("name");
				var radios = $(".hidradio[name=" + groupName + "]");
				var checked = $(radios).filter(function() { return $(this).prop("checked") === true; });
				var list = $(this).find(".dlst");
				var text = null;

				if(radios.length > 0 && checked.length > 0) {
					text = (checked.length > 0) ? $(checked).parents("label").find(".value").text() : radios.eq(0).siblings(".value").text();

					$(list).find("label").removeClass("on").attr("tabindex", 0);
					$(list).find("label input").attr("tabindex", -1);
					if (checked.length > 0) {
						$(checked).parents("label").eq(0).addClass("on");
					}
					else {
						radios.eq(0).parents("label").eq(0).addClass("on");
					}
				}
				else {
					text = (list.find(".value.on").length > 0) ? list.find(".value.on").text() : (($(this).find(".txt .val").length > 0) ? $(this).find(".txt .val").text() : $(this).find(".txt").text());
				}

				if($(list).siblings(".txt").find(".val").length > 0) {
					$(list).siblings(".txt").find(".val").text(text);
				}
				else {
					$(list).siblings(".txt").text(text);
				}
			});
		}

		return {
			init : init
		};
	}());

	dropList.init();


	// file
	window.upFile = (function() {
		function init() {
			// file event
			$(document).on("change", ".hidFile", function(evt) {
				var file = $(this).val().split(/(\\|\/)/g).pop();
				var ext = file.split(".").pop();
				var fileLabel = $(this).siblings(".comText");
				var helpText = fileLabel.attr("title");

				if($(this).attr("readonly")) {
					return false;
				}

				if(file.length > 1) {
					fileLabel.text(file).removeClass("unselect");
				}
				else {
					fileLabel.text(helpText).addClass("unselect");
				}
			}).on("reset", "form", function(evt) {
				$(this).find(".hidFile").each(function(i) {
					var helpText = $(this).siblings(".comText").attr("title");
					$(this).siblings(".comText").text(helpText).addClass("unselect");
				});
			});
		}

		return {
			init : init
		}
	}());

	upFile.init();



	if($("body").find(".footer").length < 1) {
		$("body").addClass("withoutFooter");
	}


	// go top
	goTop.init();

	// gnb
	gnb.init();

	// path
	pageNav.init();

	// title check
	fixTitle.init();

	// calender
	popupCalender.init();

});

var loading = {
	show : function(target) {
		var html = '<div class="loadings' + ((target) ? ' inner' : '') + '"><div><i></i></div></div>';

		if(target) {
			if($(target).find("> .loadings").length < 1) $(target).append(html);
		}
		else {
			$("body").append(html);
		}
	},

	hide : function(target) {
		if(target) {
			$(target).find(".loadings").remove();
		}
		else {
			$(".loadings").remove();
		}
	}
}


// gotop
var goTop = (function() {
	var btnWrap = null;
	var btn = null;
	var footer = null;
	var padding = 0;

	function init() {
		if($(".sticky_top").length < 1) return false;

		btnWrap = $(".sticky_top");
		btn = $(".btn_top");
		footer = $(".footer");

		// scroll
//		$(window).scroll(onScroll).resize(onScroll).load(onScroll);
		$(window).scroll(onScroll).resize(onScroll).on('load',onScroll);

		// click
		btn.on("click", function(evt) {
			evt.preventDefault();
			$("html, body").stop().animate({scrollTop:0}, 500, "easeOutExpo");
		});
	}

	function onScroll() {
		var top = $(window).scrollTop();

		if(top > 60) {
			btn.parent().fadeIn(100);

			if(footer.length > 0) {
				var windowh = (window.innerHeight) ? window.innerHeight : $(window).height();
				var footOffset = footer.offset().top - windowh;
				var topPos = footer.offset().top;

				if(top >= footOffset + btn.height()) {
					btnWrap.addClass("off");
				}
				else {
					btnWrap.removeClass("off");
				}
			}
		}
		else {
			btn.parent().fadeOut(100);
		}
	}

	return {
		init : init,
		refresh : onScroll
	}
}());


var pageNav = (function() {
	var mainScrollElement = null;
	var scrolls = [];

	function init() {

		$(window).on('load', function() {
//		$(window).load(function() {
			if($(".page_paths").length > 0) {
				$(".page_paths .scroller").each(function(i) {
					setScroll($(this));

					if($(this).siblings(".btn_show").length > 0) {
						$(this).parent().append("<div class='pathBg'></div>");

						$(this).siblings(".pathBg").on("click", function(evt) {
							var target = $(this).siblings(".scroller").eq(0);
							destroyScoll(target);
						});
					}
				});

				// click
				$(".page_paths .scroller").on("click", "a", function(evt) {
					$(this).parents(".scroller").eq(0).find("a").removeClass("on").attr("title", "");
					$(this).addClass("on").attr("title", "선택됨");

					var target = $(this).parents(".scroller").eq(0);
					reInitScroll(target);
				});

				// click
				$(".page_paths .btn_show").on("click", function(evt) {
					var target = $(this).siblings(".scroller").eq(0);
					destroyScoll(target);
				});

				// resize
				$(window).resize(onRefresh);
			}
		});
	}

	function getScroll() {
		return scrolls;
	}

	function setScroll(target) {
		var sid = target.attr("id");
		var scrollIndex = target.parents("li").eq(0).index();

		var scroll = new FTScroller(document.getElementById(sid), {
			scrollbars : false,
			scrollingY : false,
			scrollingX : true,
			updateOnWindowResize : true,
			bounceDecelerationBezier : "cubic-bezier(0.215, 0.61, 0.355, 1)",
			bounceBezier : "cubic-bezier(0.215, 0.61, 0.355, 1)"
		});

		scrolls[scrollIndex] = scroll;

		setTimeout(function() {
			setCenter(target);
		}, 100);
	}

	function onRefresh() {
		for(var i = 0; i < scrolls.length; i++) {
			if(!$(".page_paths .scroller").eq(i).hasClass("destroy")) {
				scrolls[i].updateDimensions();
				setCenter($(".page_paths .scroller").eq(i));
			}
		}
	}

	function reInitScroll(target) {
		if(!target.hasClass("destroy")) {
			setCenter(target);
		}
		else {
			destroyScoll(target);
		}
	}

	function destroyScoll(target) {
		target.toggleClass("destroy");

		if(!target.hasClass("destroy")) {
			setScroll(target);
		}
		else {
			var scrollIdx = target.parents("li").eq(0).index();

			scrolls[scrollIdx].scrollTo(0, 0);
			scrolls[scrollIdx].destroy();
		}
	}

	function setLeft(target) {
		var scrollIdx = target.parents("li").eq(0).index();
		var activeElement = target.find(".on").parents("li").eq(0);

		if(activeElement.length < 1) return;

		var targetOffset = target.offset().left - activeElement.offset().left;
		var movePos = scrolls[scrollIdx].scrollLeft - targetOffset - (5 * (scrollIdx + 1));

		scrolls[scrollIdx].scrollTo(movePos, 0, 100);
	}

	function setCenter(target) {
		var scrollIdx = target.parents("li").eq(0).index();
		var activeElement = target.find(".on").parents("li").eq(0);

		if(activeElement.length < 1) return;

		var halfPos = parseInt(target.outerWidth() / 2) - parseInt(activeElement.outerWidth() / 2);
		var targetOffset = activeElement.offset().left - target.offset().left;
		var movePos = scrolls[scrollIdx].scrollLeft + targetOffset - halfPos;

		scrolls[scrollIdx].scrollTo(movePos, 0, 100);
	}

	return {
		init : init,
		getScroll : getScroll,
		refresh : onRefresh,
		center : setCenter,
		left : setLeft,
		open : destroyScoll,
		close : reInitScroll
	}
}());


var gnb = (function() {
	var body = null;
	var btnGnb = null;
	var gnbBg = null;

	var scrollElements = null;
	var scrolls = [];
	var timer = null;

	function init() {
		$(document).ready(function() {
			body = $("body");
			btnGnb = $(".header .btn_gnb");

			scrollElements = $(".header .scroller");

			body.find(".header").append("<div class='gnb_modal gnbBg'></div>");
			body.find(".header .nav_gnb").append("<div class='nbg gnbBg'></div>");
			gnbBg = $(".header .gnbBg");

			// bg
			gnbBg.on("click", function(evt) {
				hideGnb();
			}).on("touchmove", function(evt) {
				return false;
			});

			// gnb close
			$(".gnb_close").on("click", function(evt) {
				evt.preventDefault();
				hideGnb();
			});

			// gnb
			btnGnb.on("click", function(evt) {
				evt.preventDefault();

				if(btnGnb.hasClass("active")) {
					hideGnb();
				}
				else {
					showGnb();
				}
			});

			// gnb click
			$(".gnb_list .gtit").on("click", function(evt) {
				evt.preventDefault();

				var subId = $(this).attr("href").substring(1);

				if($(this).hasClass("active")) {
					$(".gnb_list").removeClass("show_sub");
					$(".gnb_list .gtit").removeClass("active").attr("title", "");
					$(".gnb_list .sub_list").removeClass("active");
				}
				else {
					// check
					$(".gnb_list .gtit").removeClass("active").attr("title", "");
					$(this).addClass("active").attr("title", "선택됨");
					showSub(subId);
				}
			});


			// init
			if($(".gnb_list .gtit.active").length > 0) {
				var subId = $(".gnb_list .gtit.active").attr("href").substring(1);
				showSub(subId);
			}

			// sub page path
			$(".page_title .dropLst .txt").after("<div class='path_bg'></div>");
			var pbg = $(".page_title .path_bg");

			pbg.on("click touchstart", function(evt) {
				evt.preventDefault();
				evt.stopPropagation();

				pbg.siblings(".txt").eq(0).trigger("click");
			});
		});
	}

	function showSub(subId) {
		$(".gnb_list").addClass("show_sub");
		$(".gnb_list #" + subId).addClass("active").siblings(".sub_list").removeClass("active");

		if($(".gnb_list").hasClass("init")) {
			scrolls[1].scrollTo(0, 0);
			refrehGnb();
		}
	}

	function hideGnb() {
		body.removeClass("scroll_off show_gnb");
		btnGnb.removeClass("active");
	}

	function showGnb() {
		body.addClass("scroll_off show_gnb");
		btnGnb.addClass("active");

		if($(".gnb_list").hasClass("init")) {
			refrehGnb();
		}
		else {
			scrollElements.each(function(i) {
				var sid = $(this).attr("id");
				var scroll = new FTScroller(document.getElementById(sid), {
					scrollbars : true,
					scrollingX : false,
					updateOnWindowResize : true,
					bounceDecelerationBezier : "cubic-bezier(0.215, 0.61, 0.355, 1)",
					bounceBezier : "cubic-bezier(0.215, 0.61, 0.355, 1)"
				});

				scrolls.push(scroll);
			});

			$(".gnb_list").addClass("init");
		}
	}

	function getScroll() {
		return scrolls;
	}

	function setHeight() {
		var wh = (window.innerHeight) ? window.innerHeight : $(window).height();
		var offset = scrollElements.eq(1).offset().top;

		$(".header .scroll_content").css("min-height", wh - offset);
	}

	function refrehGnb() {
		if(body.hasClass("show_gnb")) {
			scrolls[0].updateDimensions();
			scrolls[1].updateDimensions();
		}
	}

	return {
		init : init,
		getScroll : getScroll,
		refresh : refrehGnb,
		hide : hideGnb,
		show : showGnb
	}
}());


// fixed title check
var fixTitle = (function() {
	var fixTitle = null;
	var header = null;

	function init() {
		if($(".sticky_title").length < 1) return false;

		header = $(".header");
		fixTitle = $(".sticky_title");

		// scroll
		$(window).scroll(onScroll).resize(onScroll).load(onScroll);
	}

	function onScroll() {
		var top = $(window).scrollTop();

		if((fixTitle.offset().top - top) <= 0) {
			fixTitle.addClass("active");
		}
		else {
			fixTitle.removeClass("active");
		}
	}

	return {
		init : init,
		refresh : onScroll
	}
}());



var jqDatePicker = (function() {
	function init() {
		var dateOption = {
			changeYear: false,
			changeMonth: false,
			autoSize:true,
			showMonthAfterYear:true,
			dateFormat:"yy-mm-dd",
			minDate: "-150y",
			maxDate: "+1y",
			yearRange: "-100:+1",
			showButtonPanel: false,
			closeText: "닫기",
			currentText: 'Today',
			dayNames: ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"],
			dayNamesMin:["일", "월", "화", "수", "목", "금", "토"],
			monthNames:[".01",".02",".03",".04",".05",".06",".07",".08",".09",".10",".11",".12"],
			monthNamesShort: [ "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12" ],
			navigationAsDateFormat: true,
			prevText: '이전달',
			nextText: '다음달',
			beforeShow: function(input, picker) {
				// showPrevNextYearButton($(this));
			},
			onChangeMonthYear: function(input, picker) {
				// showPrevNextYearButton($(this));
			}
		};

		$.datepicker.setDefaults(dateOption);

		$(document).ready(function() {
			$(".txtDate").each(function(i) {
				$(this).datepicker(dateOption);
			});

			$(window).resize(function() {
				$(".txtDate").each(function(i) {
					$(this).datepicker("hide");
				});
			});
		});
	}

	// 달력
	function showPrevNextYearButton($input) {
		setTimeout(function() {
			var header = $input.datepicker('widget').find('.ui-datepicker-header');

			if($input.datepicker('widget').find('.ui-datepicker-header').find(".ui-datepicker-prev").is(".ui-state-disabled") == false) {
				var $prevButton = $('<a title="이전년도" class="ui-datepicker-prevYear ui-corner-all"><span>이전년도</span></a>');
				header.find('a.ui-datepicker-prev').before($prevButton);
				$prevButton.unbind("click").bind("click", function() {
					$.datepicker._adjustDate($input, -1, 'Y');
				});
			}

			// ui-state-disabled
			if($input.datepicker('widget').find('.ui-datepicker-header').find(".ui-datepicker-next").is(".ui-state-disabled") == false) {
				var $nextButton = $('<a title="다음년도" class="ui-datepicker-nextYear ui-corner-all"><span>다음년도</span></a>');
				header.find('a.ui-datepicker-next').after($nextButton);
				$nextButton.unbind("click").bind("click", function() {
					$.datepicker._adjustDate($input, +1, 'Y');
				});
			}
		}, 1);
	};


	// mobile check
	function isMobile() {
		return /(iphone|ipod|ipad|android|blackberry|windows ce|palm|symbian)/i.test(navigator.userAgent);
	}

	return {
		init : init
	};
}());

jqDatePicker.init();


var popupCalender = (function() {
	var calender = null;
	var body = null;

	function init() {
		$(document).ready(function() {
			body = $("body");

			if($("#pcal").length < 1) return;

			var pc = $(".popup_calender").detach();
			body.append(pc);

			calender = $("#pcal").datepicker({
				onSelect : function(input, picker) {
					// console.log("select");
				}
			});

			$(".popup_calender .cal_bg").on("click", onHide);

			$(".popup_calender .cal_bg").on("touchmove", function(evt) {
				evt.preventDefault();
				evt.stopPropagation();
				evt.stopImmediatePropagation();
			});

			$(".btn_show_cal").on("click", function(evt) {
				evt.preventDefault();

				var d = $(this).siblings("input").val();

				if(d.length > 2) {
					calender.datepicker("setDate", d);
				}
				else {
					calender.datepicker("setDate", new Date());
				}

				$(".btn_show_cal").removeClass("active");
				$(this).addClass("active");
				onShow();
			});

			$(".cal_btn").on("click", function(evt) {
				evt.preventDefault();

				if($(this).hasClass("btn_ok")) {
					var date = $.datepicker.formatDate("yy-mm-dd", calender.datepicker("getDate", "yy-mm-dd"));
					$(".btn_show_cal.active").siblings("input").val(date);
					$(".btn_show_cal.active").focus();
				}

				$(".btn_show_cal").removeClass("active");
				onHide();
			});
		});
	}

	function onShow() {
		body.addClass("show_calender");
		return false;
	}

	function onHide() {
		body.removeClass("show_calender");
		return false;
	}

	return {
		init : init,
		show : onShow,
		hide : onHide
	}
}());


