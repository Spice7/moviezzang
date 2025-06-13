<%@page import="data.dao.MovieDAO"%>
<%@page import="java.io.DataOutput"%>
<%@page import="data.dto.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page isELIgnored="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%
	  //절대경로
	    String root = request.getContextPath();


	    String loginok = (String)session.getAttribute("loginok");

	    if(loginok == null)
	    {
    %>
    	<script type="text/javascript">
    		history.back();
    	</script>
    <%
    	}
    %>
<head>
<meta charset="UTF-8">
<link href="<%=request.getContextPath()%>/book/buttonStyle.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
<style type="text/css">
div.bookcontainer{
	align-items: center;
	  display: flex;
  flex-direction: column;
}

.bookcontainer > div.title {
  margin-top: 100px;
  width: 900px;
}

.bookcontainer div.listbox {
  border: 1px #ccc solid;
  width: 900px;
  height: 600px;
  margin-top : 10px;
  display: flex;
  overflow-y : auto;
  border-radius: 12px;
}

.bookcontainer div.theater-local {
  width: 300px;
  height: 100%;
  border-right: 1px #ccc solid;
  display: flex;
}

.bookcontainer div.movie {
  width: 200px;
  height: 100%;
  border-right: 1px #ccc solid;
  overflow-y: auto;
}

.bookcontainer div.movie ul > li {
  list-style: none;
  text-align: center;
}

.bookcontainer div.movie ul {
  margin-top: 10px;
}

.bookcontainer button.movielist {
  display: flex;
  width: 100%;
  align-items: center;
  justify-content: center;
  padding-bottom: 8px;
}

.bookcontainer div.local {
  width: 50%;
  border-right: 1px solid #ccc;
}

.bookcontainer div.local ul > li {
  list-style: none;
}

.bookcontainer div.local ul {
  margin-top: 40px;
}

.bookcontainer div.movie ul,
.bookcontainer div.local ul {
  padding-left: 0px;
}

.bookcontainer button.btnlocal {
  width: 100%;
}

.bookcontainer div.theater {
  width: 50%;
  margin-top: 78px;
}

.bookcontainer div.theater ul {
  padding: 0px;
}

.bookcontainer div.theater ul > li {
  list-style: none;
}

.bookcontainer button.btntheater {
  width: 100%;
  text-align: center;
}

.bookcontainer div.time {
  border: none;
  width: 400px;
  overflow-y: auto;
}

.bookcontainer div.time ul > li {
  list-style: none;
}

.bookcontainer div.time ul {
  padding: 0px;
}

.bookcontainer button.btntime {
  width: 100%;
}

.bookcontainer .timebox {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 5px 10px;
  box-sizing: border-box;
  border-bottom	: 1px solid #ddd;
}

.bookcontainer .timebox span {
  display: inline-block;
  font-size: 14px;
}

.bookcontainer .timebox .starttime {
  flex: 1;
  text-align: left;
}

.bookcontainer .timebox .movietitle {
  flex: 1;
  text-align: center;
}

.bookcontainer .timebox .screeninfo {
  flex: 1;
  text-align: right;
  font-size: 12px;
  line-height: 1.3;
}

.bookcontainer .showtimes-section {
  overflow-y: auto;
  margin-top: 25px;
}

.bookcontainer .vertical-line {
  width: 1px;
  height: 75%;
  background-color: #ccc;
  margin: auto 10px;
}

.bookcontainer div.listbox h4 {
  margin-top: 30px;
}

.bookcontainer .btn-content {
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  width: 100%;
  box-sizing: border-box;
}

.bookcontainer .btn-content img {
  position: absolute;
  left: 0px;
  width: 24px;
  top: 1px;
}

.bookcontainer .btn-content span {
  width: 100%;
  text-align: center;
  line-height: 1.4;
  word-break: keep-all;
  padding-left: 40px;
}

.bookcontainer div.movielist-section {
  margin-top: 50px;
}
div.seat-info{
	margin-top: 4px;
   border: 1px solid #ccc;
   border-radius: 6px;
   padding: 2px 6px;
   display: inline-block;
/*    font-size: 13px; */
   text-align: center;
   box-sizing: border-box;
}
.remaining-seat{
  color: #480be6;
  font-weight: bold;
}
.btn-date{
margin-right: 5px;
}
.auto-focus {
  box-shadow: 0 0 0 3px rgba(82, 0, 255, 0.5);
  transition: box-shadow 0.4s ease;
}

</style>
<%
String mov_id = request.getParameter("movie_id");
%>
<script type="text/javascript">
$(function () {
  let currentMovie_id = null;
  let selectedDate = null;

  //  영화 클릭 처리 함수
  function handleMovieClick(movie_id) {
    currentMovie_id = movie_id;

    const regions = [
        "서울", "경기", "인천", "대전/충청/세종",
        "부산/대구/경산", "광주/전라", "강원", "제주"
      ];

    // (1) 항상 지역 버튼 초기화
	  $("button.btnlocal").each(function(idx){
	    $(this).text(regions[idx]);
	    $(this).prop("disabled", true);
	  });
	  $("#theater").empty();
	  $(".showtimes").empty();


    $.ajax({
      type: "get",
      url: "<%=request.getContextPath()%>/book/booking/bookList.jsp",
      dataType: "json",
      data: { movie_id: currentMovie_id,
    	  	  screening_date: selectedDate
      },
      success: function (res) {
    	  const map = {};
          res.forEach(item => map[item.region.trim()] = item.theater_count);
			console.log("요청보낼때:",currentMovie_id, "sdate:",selectedDate);

        $("button.btnlocal").each(function (idx) {
            const region = regions[idx].trim();
            const count = map[region] || 0;

            $(this).text(region + (count > 0 ? `(${count})` : ""));
            $(this).prop("disabled", count === 0);
        });
      }
    });
  }
  //  초기 진입 시 movie_id가 있을 경우 처리
  <% if (mov_id != null) { %>
    currentMovie_id = "<%=mov_id%>";
    const $targetBtn = $(`button.movielist[movie_id='${currentMovie_id}']`);

    if ($targetBtn.length > 0) {
      $targetBtn.addClass("btn-active auto-focus");
      handleMovieClick(currentMovie_id);

      // 스크롤 이동
      $(".movie").animate({
        scrollTop: $targetBtn.offset().top - $(".movie").offset().top + $(".movie").scrollTop() - 100
      }, 300);

      // 포커스 효과 제거
      setTimeout(() => {
        $targetBtn.removeClass("auto-focus");
      }, 1500);
    }
  <% } %>

  //  영화 버튼 클릭 시
  $(document).on("click", "button.movielist", function () {
    $(".movielist").removeClass("btn-active");
    $(".btnlocal").removeClass("btn-active");
    $(".btntheater").removeClass("btn-active");
    $(".btntheater").hide();
    $(this).addClass("btn-active");

    const movie_id = $(this).attr("movie_id");
    handleMovieClick(movie_id);
  });

  // 지역 버튼 클릭 시
  $(document).on("click", "button.btnlocal", function () {
    if (!$(".movielist").hasClass("btn-active")){
		alert("영화를 먼저 선택해주세요!");
		return;
    }

    $(".btnlocal").removeClass("btn-active");
    $(this).addClass("btn-active");

    const region = $(this).text().split("(")[0].trim();

    $.ajax({
      type: "get",
      dataType: "json",
      data: { movie_id: currentMovie_id, region: region,
    	  screening_date: selectedDate
      },
      url: "<%=request.getContextPath()%>/book/booking/theaterList.jsp",
      success: function (res) {
        let h = "";
        $.each(res, function (i, item) {
			const disabled = (item.can_reserve === "1")? "" : "disabled";
          h += `<li><button class='btntheater btn-basiclist' ${disabled}>${item.theater_name}</button></li>`;
        });
        $("#theater").html(h);
      },
      error: function (xhr, status, error) {
        console.log("지역별 극장 요청 실패:", error);
      }
    });
  });

  //  상영관 클릭 시
  $(document).on("click", ".btntheater", function () {
    $(".btntheater").removeClass("btn-active");
    $(this).addClass("btn-active");
    tryAutoLoadShowTimes();
  });

  //  날짜 버튼 자동 생성
  function generateDateButtons() {
    const today = new Date();
    const dayLabels = ['일', '월', '화', '수', '목', '금', '토'];
    let html = "";

    for (let i = 0; i < 7; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);

      const yyyy = date.getFullYear();
      const mm = (date.getMonth() + 1).toString().padStart(2, "0");
      const dd = date.getDate().toString().padStart(2, "0");
      const day = dayLabels[date.getDay()];
      const formattedDate = `${yyyy}-${mm}-${dd}`;
      const label = `${mm}/${dd} (${day})`;
      const isToday = (i === 0) ? " btn-active" : "";

      html += `<button class="btn-date btn-day ${isToday}" data-date="${formattedDate}">${label}</button>`;
    }

    $(".date-selector").html(html);

    $(".btn-date").eq(0).trigger("click");

    selectedDate = today.toISOString().slice(0, 10);
  }

  //  날짜 클릭 시
  $(document).on("click", ".btn-date", function () {
    selectedDate = $(this).data("date");
    $(".btn-date").removeClass("btn-active");
    $(".btnlocal").removeClass("btn-active");
    $(".btntheater").removeClass("btn-active");
    $(".timebox").hide();
    $(this).addClass("btn-active");

    if (currentMovie_id) {
        handleMovieClick(currentMovie_id);   // ★ 추가!
      }
    tryAutoLoadShowTimes();
  });

  //  상영 정보 출력
  function loadShowTimes(theaterName) {
    $.ajax({
      type: "post",
      url: "<%=request.getContextPath()%>/book/booking/showTimes.jsp",
      dataType: "json",
      data: {
        theaterName: theaterName,
        movie_id: currentMovie_id,
        screening_date: selectedDate
      },
      success: function (res) {
        let show = "";
        $.each(res, function (i, item) {
          let start = new Date(item.start_time);
          let runtime = parseInt(item.runtime);
          let end = new Date(start.getTime() + runtime * 60000);
          let startStr = start.getHours().toString().padStart(2, "0") + ":" + start.getMinutes().toString().padStart(2, "0");
          let endStr = end.getHours().toString().padStart(2, "0") + ":" + end.getMinutes().toString().padStart(2, "0");

          show += "<li>" +
            "<form action='<%=request.getContextPath()%>/book/seat/seatForm.jsp' method='post'>" +
            "<input type='hidden' name='screening_id' value='" + item.screening_id + "'>" +
            "<button class='btntime btn-basiclist' type='submit'>" +
            "<div class='timebox'>" +
            "<span class='starttime'><b style='font-size: 1.2em'>" + startStr + "</b>~<br>&nbsp;&nbsp;&nbsp;" + endStr + "</span>" +
            "<span class='movietitle'>" + item.title + "</span>" +
            "<span class='screeninfo'>" +
            item.theater_name + "<br>" +
            item.auditorium_name + "<br>" +
            "<div class='seat-info'>" +
            "<span class='remaining-seat'>" + item.remaining_seat + "</span>/" + item.total_seat +
            "</div>" +
            "</span>" +
            "</div>" +
            "</button>" +
            "</form>" +
            "</li>";
        });

        $(".showtimes").html(show);
      },
      error: function (xhr, status, error) {
        console.log("상영 정보 AJAX 실패:", error);
      }
    });
  }

  //  조건 충족 시 자동 상영 정보 불러오기
  function tryAutoLoadShowTimes() {
    const theaterName = $(".btntheater.btn-active").text();
    if (theaterName && currentMovie_id && selectedDate) {
      loadShowTimes(theaterName);
    }
  }

  //  초기 날짜 버튼 생성
  generateDateButtons();
});
</script>
</head>
<%
MovieDAO dao = MovieDAO.getInstance();
//영화 리스트 구하기
List<MovieDTO> list = dao.getAllDatas();
%>
<body>
	<div class="bookcontainer">
		<div class="title">
			<h3 >빠른예매</h3>
			<hr>
		</div>
		<div class="date-selector" style="margin: 0 0 10px 20px;"></div>
		<div class="listbox">
			<div class="movie">
				<h4>&nbsp;&nbsp;&nbsp;영화</h4>
				<div class="movielist-section">
				<ul>
					<%
					for(int i=0;i<list.size();i++){
					MovieDTO dto = list.get(i);
					String certification = dto.getCertification().contains("전체")?"전체":
										dto.getCertification().contains("12")?"12세":
										dto.getCertification().contains("15")?"15세":"19세";
					%>
						<li>
						<button type="button" class="movielist btn-basiclist" movie_id="<%=dto.getId() %>">
						<div class="btn-content">
						<img src="../../resources/ratingimg/<%=certification %>.png" width="24px;" style="margin-right: 10px;">
						<span><%=dto.getTitle() %></span>
						</div>
						</button></li>
					<%}
					%>
				</ul>
				</div>
			</div>
			<div class="theater-local">
				<div class="local">
					<h4>&nbsp;&nbsp;&nbsp;극장</h4>
					<ul id="locals">
					<li><button class="btnlocal btn-basiclist">서울</button></li>
						<li><button class="btnlocal btn-basiclist">경기</button></li>
						<li><button class="btnlocal btn-basiclist">인천</button></li>
						<li><button class="btnlocal btn-basiclist">대전/충청/세종</button></li>
						<li><button class="btnlocal btn-basiclist">부산/대구/경산</button></li>
						<li><button class="btnlocal btn-basiclist">광주/전라</button></li>
						<li><button class="btnlocal btn-basiclist">강원</button></li>
						<li><button class="btnlocal btn-basiclist">제주</button></li>
					</ul>
				</div>
<!-- 				<div class="vertical-line"></div> -->
					<div class="theater">
						<ul id="theater">
						</ul>
					</div>
			</div>
			<div class="time">
			<h4>&nbsp; &nbsp; &nbsp;시간</h4>
				<div class="showtimes-section">
					<ul class="showtimes">
					</ul>
				</div>
			</div>
		</div>
	</div>
</body>
</html>