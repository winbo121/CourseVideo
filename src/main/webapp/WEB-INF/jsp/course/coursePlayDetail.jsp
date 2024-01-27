<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS</title>
    
    <link type="text/css" rel="stylesheet" href="/css/home/common.css" />
    <link type="text/css" rel="stylesheet" href="/css/home/layout.css" />
    <link type="text/css" rel="stylesheet" href="/css/home/bf.css" />
    <link type="text/css" rel="stylesheet" href="/css/home/layout_register.css" />

    <link rel="stylesheet" href="/css/home/swiper-bundle.min.css"/>

    <script type="text/javascript" src="/js/home/jquery-3.4.1.min.js"></script>
    <script src="/js/home/swiper-bundle.min.js"></script>



</head>
<body>
    <div class="wrap">

        <div class="player-wrap">
            <div class="accordion">
                <input id="accordion-2" type="checkbox">
                <label for="accordion-2">
                    <h2>강의명 노출</h2>
                </label>
                <div class="accordion-content">
                    <div class="content-answer">
                        <div><span>과정명</span><span>교육과정명 노출</span></div>
                        <div><span>수강기간</span><span>2021-01-01 ~ 2021-01-31</span></div>
                    </div>
                </div>
            </div>

            <!-- 플레이어 영억: 이미지로 대체 -->
            <div class="movie-player">
                <img src="/images/home/player_sample.jpg" style="max-width: 100%;">
            </div>

            <!-- 모바일용 별도 강의명/과정명/수강기간 노출 -->
            <div class="mobile-info">
                <h3>강의명 노출</h3>
                <div>
                    <p><span>과정명</span><span>교육과정명 노출</span></p>
                    <p><span>수강기간</span><span>2021-01-01 ~ 2021-01-31</span></p>
                </div>
            </div>

            <div class="player-btn-wrap-01" id="popupClose">
                <button class="btn-player-01" type="button"><img src="/images/home/ico_out.svg">학습 종료</button>
            </div>

            <div class="player-btn-wrap-02">
                <button class="btn-player-02" type="button"><img src="/images/home/btn_wback.svg">이전 강의</button>
                <button class="btn-player-03" type="button">다음 강의<img src="/images/home/btn_wnext.svg"></button>
            </div>
        </div>




    </div>

</body>


<!-- 창닫기 스크립트 -->
<script language="javascript">
    $("#popupClose").on("click", function(e){
        if (confirm("현재 창을 닫으시겠습니까?")) {
           location.href="/course/courseSearch/index.do";
        }
    });
</script>


</html>




