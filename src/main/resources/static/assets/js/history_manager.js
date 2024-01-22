function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

function setupNoCache() {
    $(window).unload(function() {
        var gid = guid();
        history.replaceState(null, null, $.query.set('__gid', gid).toString());
    });
}

function goClear(url) {
    var gid = guid();
    history.replaceState(null, null, $.query.set('__gid', gid).toString());
    window.location = url;
}


/**
 * 게시판 에서 이전글 다음글 등 게시판 내 이동시 back 카운트 증가시키면서 이동
 * @param idx
 */
function goToArticle(idx) {
    var back = $.query.get('_back');
    if(back != "list") {
        if(! back) {
            back = 2;
        } else {
            back = back + 1;
        }
    }

    window.location = "view?idx=" + idx + "&_back=" + back;
}

function goToArticleQuery(queryObj) {
    var back = queryObj.get('_back');
    if(back != "list") {
        if(! back) {
            back = 2;
        } else {
            back = back + 1;
        }
    }
    queryObj = queryObj.set('_back', back);

    window.location = queryObj.toString();
}

/**
 * _back 카운트에 따라 목록까지 이동,
 * _back 이 list 로 설정되는 경우, count 를 이용하지 않고, list 페이지로 바로 이동
 * (list 를 사용하는 경우는 홈 화면 등 외부에서 view 페이지로 바로 진입시에도 목록으로 갈수 있도록 list 를 사용)
 */
function goList() {
    var back = $.query.get('_back');
    if(back == "list") {
        window.location = "list";
        return;
    }
    if(back) {
        window.history.go(- Number(back));
    } else {
        window.history.back();
    }
}