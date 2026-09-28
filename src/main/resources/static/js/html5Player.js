(function (window) {
	var apis = {};

	function emptyApi() {
		return {
			setup: function () { return this; },
			on: function () { return this; },
			seek: function () {},
			stop: function () {},
			getPosition: function () { return 0; }
		};
	}

	function createApi(container) {
		var video = null;
		var handlers = {};
		var started = false;
		var lockSeek = false;
		var seeking = false;

		function emit(name, event) {
			var list = handlers[name] || [];
			for (var i = 0; i < list.length; i++) {
				list[i](event || {});
			}
		}

		function clearLock() {
			lockSeek = false;
			seeking = false;
		}

		var api = {
			setup: function (options) {
				options = options || {};
				handlers = {};
				started = false;
				clearLock();
				container.innerHTML = "";

				video = document.createElement("video");
				video.setAttribute("playsinline", "");
				video.preload = options.preload || "metadata";
				video.style.width = "100%";
				video.style.display = "block";
				video.style.background = "#000";
				if (options.controls !== false) {
					video.setAttribute("controls", "");
				}
				if (options.aspectratio) {
					video.style.aspectRatio = String(options.aspectratio).replace(":", " / ");
				}
				if (options.image) {
					video.poster = options.image;
				}
				if (options.mute) {
					video.muted = true;
				}

				var sources = options.sources || [];
				if (!sources.length && options.file) {
					sources = [{ file: options.file }];
				}
				if (sources[0] && sources[0].file) {
					video.src = sources[0].file;
				}

				(options.tracks || []).forEach(function (track) {
					var cue = document.createElement("track");
					cue.src = track.file;
					cue.kind = track.kind || "captions";
					cue.label = track.label || "자막";
					cue.srclang = "ko";
					if (track.default !== false) {
						cue.default = true;
					}
					video.appendChild(cue);
				});

				container.appendChild(video);

				if (options.playbackRateControls && options.playbackRateControls.length) {
					var bar = document.createElement("div");
					bar.className = "course-rate-bar";
					options.playbackRateControls.forEach(function (rate) {
						var button = document.createElement("button");
						button.type = "button";
						button.className = "course-rate-btn";
						button.textContent = rate + "x";
						button.onclick = function () {
							video.playbackRate = Number(rate);
							var buttons = bar.querySelectorAll("button");
							for (var i = 0; i < buttons.length; i++) {
								buttons[i].classList.remove("is-active");
							}
							button.classList.add("is-active");
						};
						if (Number(rate) === 1) {
							button.classList.add("is-active");
						}
						bar.appendChild(button);
					});
					container.appendChild(bar);
				}

				video.addEventListener("playing", function () {
					if (started) {
						return;
					}
					started = true;
					emit("firstFrame", {});
				});
				video.addEventListener("timeupdate", function () {
					if (lockSeek) {
						return;
					}
					emit("time", { position: video.currentTime });
				});
				video.addEventListener("seeking", function () {
					seeking = true;
				});
				video.addEventListener("seeked", function () {
					clearLock();
					emit("seek", { offset: video.currentTime, position: video.currentTime });
				});
				video.addEventListener("pause", function () {
					if (video.ended || seeking || lockSeek) {
						return;
					}
					if (isFinite(video.duration) && video.currentTime >= video.duration - 0.5) {
						return;
					}
					emit("pause", {});
				});
				video.addEventListener("ended", function () {
					emit("complete", {});
				});

				if (options.autostart) {
					var playPromise = video.play();
					if (playPromise && playPromise.catch) {
						playPromise.catch(function () {});
					}
				}
				return api;
			},
			on: function (name, fn) {
				if (!handlers[name]) {
					handlers[name] = [];
				}
				handlers[name].push(fn);
				return api;
			},
			seek: function (seconds) {
				if (!video) {
					return;
				}
				var target = Number(seconds) || 0;
				var apply = function () {
					if (Math.abs((video.currentTime || 0) - target) < 0.25) {
						return;
					}
					lockSeek = true;
					try {
						video.currentTime = target;
					} catch (e) {
						clearLock();
					}
					window.setTimeout(clearLock, 1200);
				};
				if (video.readyState >= 1) {
					apply();
				} else {
					video.addEventListener("loadedmetadata", apply, { once: true });
				}
			},
			stop: function () {
				if (!video) {
					return;
				}
				video.pause();
				try {
					video.currentTime = 0;
				} catch (e) {}
			},
			getPosition: function () {
				return video ? video.currentTime : 0;
			}
		};
		return api;
	}

	window.jwplayer = function (divId) {
		var el = document.getElementById(divId);
		if (!el) {
			return emptyApi();
		}
		if (!apis[divId]) {
			apis[divId] = createApi(el);
		}
		return apis[divId];
	};
})(window);
