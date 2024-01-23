if (navigator.appVersion.indexOf("Win")!=-1){
	//Windows
	$('head').append('<link rel="stylesheet" href="../../kcase/lib/css/kcase.css"/>');
	$('head').append('<script src="../../kcase/lib/js/kcaseagent.js"></script>');
}
else if (navigator.appVersion.indexOf("Mac")!=-1){
	//MacOS
	$('head').append('<link rel="stylesheet" href="../../kcase/lib/mac_n_linux_lib/css/kcase.css"/>');
	$('head').append('<script src="../../kcase/lib/mac_n_linux_lib/js/kcaseagent_mac.js"></script>');
}
else if (navigator.appVersion.indexOf("Linux")!=-1){
	//Linux
	$('head').append('<link rel="stylesheet" href="../../kcase/lib/mac_n_linux_lib/css/kcase.css"/>');
	$('head').append('<script src="../../kcase/lib/mac_n_linux_lib/js/kcaseagent_linux.js"></script>');
}else if (navigator.appVersion.indexOf("X11")!=-1){
	//UNIX
	if (navigator.oscpu.indexOf("Linux")!=-1) { // CentOS 7 FireFox 에서 appVersion이 X11로 출력됨. 따라서 oscpu 정보로 추가 확인
		//Linux
		$('head').append('<link rel="stylesheet" href="../../kcase/lib/mac_n_linux_lib/css/kcase.css"/>');
		$('head').append('<script src="../../kcase/lib/mac_n_linux_lib/js/kcaseagent_linux.js"></script>');
	}
	else {
		$('head').append('<link rel="stylesheet" href="../../kcase/lib/mac_n_linux_lib/css/kcase.css"/>');
		$('head').append('<script src="../../kcase/lib/mac_n_linux_lib/js/kcaseagent_unix.js"></script>');
	}
}

