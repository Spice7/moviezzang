<%@page import="java.util.Date"%>
<%@page import="data.dao.UserDAO"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.SeatDAO"%>
<%@ page isELIgnored="true" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" />
<link
	href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap"
	rel="stylesheet" />
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/book/buttonStyle.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
<link rel="stylesheet"href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweet-modal/dist/min/jquery.sweet-modal.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweet-modal/dist/min/jquery.sweet-modal.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
<title>Insert title here</title>
<style type="text/css">
	body {
		font-family: "Noto Sans KR" !important;
	}
	.container {

		display: flex;
		flex-direction: column;
		align-items: center;
	}
	.mainbox {
		display: flex;
		width: 1000px;
	}
	.title {
		margin-top:100px;
		width: 1000px;
	}
	.seatbox {
		width: 600px;
		height: 750px;
		margin-top: 1px;
		border: 1px solid #ccc;
		border-radius: 6px;
	}
	.subject {
		display: flex;
		justify-content: start;
		width: 1000px;
		align-items: center;
	}
	.seatcount {
		background: #434343;
		display: flex;
		align-items: center;
		padding: 10px;
		color:white;
	}
	.seatcount > div {
		display: flex;
		align-items: center;
		margin-left: 70px;
	}
	.seatcount span:first-child {
		margin-right: 10px;
		margin-left: 10px;
	}
	.btn-down-a,
	.btn-down-t,
	.btn-up-a,
	.btn-up-t,
	.adult-inwoncount,
	.teenager-inwoncount {
		height: 30px;
		font-size: 16px;
		padding: 0 10px;
		border: 1px solid #ccc;
		background: white;
		line-height: 30px;
		color: black;
	}
	.btn-down-a,
	.btn-down-t {
		border-right: none;
		border-radius: 10px 0px 0px 10px;
		border-right: 1px solid #888;
	}
	.adult-inwoncount,
	.teenager-inwoncount {
		border-left: none;
		border-right: none;
		align-items: center;
	}
	.btn-up-a,
	.btn-up-t {
		border-left: none;
		border-radius: 0px 10px 10px 0px;
		border-left: 1px solid #888;
	}
	.teenagerseat {
		margin-left: 50px;
	}
	.screen {
		background: #352461;
		text-align: center;
		margin-top: 5px;
		color: white;
		transform : rotateX(-45deg);
		height: 60px;
		line-height: 60px;
		box-shadow: 0px 10px 5px gray;
		font-size: 1.2em;
	}
	.seat {
		border-top: none;
		height: 600px;
		text-align: center;
		margin-top: 40px;
	}
	.seat-row {
		margin-left: 20px;
	}
	button.selseat {
		margin-top: 5px;
	}
	.paybox {
		border: 1px #333 solid;
		background: #434343;
		border-radius: 15px;
		color: #ccc;
		width: 350px;
		height: 660px;
		margin-left: 40px;
		margin-top: 40px;
		padding: 25px;
	}
	.pay-info {
		display: flex;
		justify-content: space-between;
		align-items: flex-end;
	}
	.pay-infoString p {
		margin-bottom: 0px;
	}
	.pay-info > img {
		width: 90px;
		height: 120px;
	}
	p.auditorium,
	p.theater {
		margin-bottom: 0px;
	}
	.seat-choice-info {
		border: 1px gray solid;
		border-radius: 5px;
		height: 250px;
		display: flex;
		width: 100%;
	}
	.legend {
		border-right: 1px gray solid;
		height: 100%;
		width: 50%;
	}
	.myseat {
		width: 50%;
	}
	.myseat > span {
		text-align: center;
		display: block;
		font-weight: bold;
		margin: 15px auto 10px;
	}
	.myseat-show {
		display: grid;
		grid-template-columns: repeat(2, 40px);
		gap: 10px;
		justify-content: center;
		width: fit-content;
		margin: 0 auto;
	}
	.myseat-show > div {
		height: 40px;
		width: 40px;
		border: 1px solid gray;
		text-align: center;
		line-height: 40px;
		box-sizing: border-box;
	}
	.pay {
		position: relative;
		margin-top: 20px;
		margin-bottom: 20px;
		width: 100%;
	}
	.pay > span:first-child {
		color: orange;
		font-weight: bold;
		font-size: 16px;
	}
	.pay > span:last-child {
		color: white;
		font-size: 18px;
		font-weight: bold;
		position: absolute;
		right: 0;
		top: 50%;
		transform: translateY(-50%);
	}
	.pay-btn {
		text-align: center;
		margin-top: 20px;
	}
	.pay-btn .btn-pay {
		width: 240px;
		height: 40px;
		font-size: 16px;
		font-weight: bold;
	}
	.seat-overlay {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(200, 200, 200, 0.7);
		display: flex;
		justify-content: center;
		align-items: center;
		font-size: 20px;
		font-weight: bold;
		z-index: 10;
		display: none;
		pointer-events: none;
		text-align: center;
	}
	.seat-overlay > span {
		padding-top: 30px;
		display: block;
	}
	.btn-seat{
		border-radius: 90px 90px 0px 0px;
	}
</style>
<%
	String screening_id = request.getParameter("screening_id");
	System.out.println(">>> screening_idzz: " + screening_id);
	SeatDAO dao = SeatDAO.getInstance();
	List<HashMap<String,String>> list = dao.getSeatInfo(screening_id);

	if(list == null || list.isEmpty()) {
	    out.println("<h3>좌석 정보를 불러오지 못했습니다. 상영 정보가 없거나 DB 오류입니다.</h3>");
	    return;
	}

	HashMap<String,String> map = list.get(0);
	String title = map.get("movie_title");
	String poster = map.get("poster");
	String auditorium_name = map.get("auditorium_name");
	String theater_name = map.get("theater_name");
	String start_time = map.get("start_time");
	int price = Integer.parseInt(map.get("price"));

	NumberFormat nf2 = NumberFormat.getInstance();
	NumberFormat nf = NumberFormat.getCurrencyInstance();

	//날짜 파싱
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd(E) HH:mm");
	SimpleDateFormat originalFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Date date = originalFormat.parse(start_time);
	String formatDate = sdf.format(date);

	//로그인 ID가져오기
	String userid = (String)session.getAttribute("userid");

	UserDAO udao = UserDAO.getInstance();
	String userNum = udao.getId(userid);


%>
</head>
<script type="text/javascript">
$(function () {

	//----------------------------
	//	결제
	//----------------------------
	$(".btn-pay").on("click", function() {
    var screeningId = "<%=screening_id%>";
    var userNum = "<%=userNum%>";

    let lastPay = $(".last-pay").text().trim();
    lastPay = lastPay.replaceAll(",", "").replaceAll("원","");

    const totalInwon = parseInt($(".adult-inwoncount").text())
        + parseInt($(".teenager-inwoncount").text());

    const seatIds = $(".selseat.select").map(function(){
        return $(this).attr("seat-id");
    }).get();

    if(seatIds.length == 0){
        Swal.fire("좌석 선택", "좌석을 선택해주세요", "warning");
        return;
    }
    if(seatIds.length < totalInwon ){
        Swal.fire("좌석 부족", "좌석을 모두 선택해주세요", "warning");
        return;
    }
	//sweetalert
    Swal.fire({
        title: "결제하시겠습니까?",
        text: "예매가 완료되면 좌석 변경이 불가합니다.",
        icon: "question",
        showCancelButton: true,
        confirmButtonColor: "#352461",
        cancelButtonColor: "#bdbdbd",
        confirmButtonText: "결제",
        cancelButtonText: "취소",
    }).then((result) => {
        if(result.isConfirmed) {
            $.ajax({
                type: "post",
                url: "<%=request.getContextPath()%>/book/payment/payReservationAction.jsp",
                data: {
                    screeningId: screeningId,
                    userNum: userNum,
                    lastPay: lastPay,
                    seatIds: seatIds.join(","),
                    total: totalInwon
                },
                dataType: "json",
                success: function(res) {
                    if(res.result === "success") {
                        Swal.fire({
                            title: "예매 완료!",
                            text: "결제가 정상적으로 처리되었습니다.",
                            icon: "success",
                            showConfirmButton: false,
                            timer: 1500,
                            background: "#f0f7ff"
                        }).then(function(){
                            top.location.href = "<%=request.getContextPath()%>/";
                        });
                    } else {
                        Swal.fire("실패", "예매 중 오류가 발생했습니다.", "error");
                    }
                },
                error: function() {
                    Swal.fire("오류", "서버와의 통신에 실패했습니다.", "error");
                }
            });
        }
    });
});


	  // ---------------------------
	  // Hover (좌석에 마우스 올릴 때)
	  // ---------------------------
	  $(".selseat").on("mouseover", function () {
	      const $this = $(this);
	      if ($this.prop("disabled")) return;

	      const col = parseInt($this.attr("col"));
	      const row = $this.attr("row");
	      const total =
	        parseInt($(".adult-inwoncount").text()) +
	        parseInt($(".teenager-inwoncount").text());
	      const selected = $(".selseat.select").length;
	      const remaining = total - selected;
	      if (!total || isNaN(total) || total === 0) return;

	      // 2자리 연속 hover
	      if (remaining >= 2) {
	        const startCol = col % 2 === 0 ? col - 1 : col;
	        if (startCol < 1) return;
	        const $seat1 = $(`.selseat[row='${row}'][col='${startCol}']`);
	        const $seat2 = $(`.selseat[row='${row}'][col='${startCol + 1}']`);

	        if (
	          $seat1.length === 0 ||
	          $seat2.length === 0 ||
	          $seat1.hasClass("reserved") ||
	          $seat2.hasClass("reserved") ||
	          $seat1.prop("disabled") ||
	          $seat2.prop("disabled")
	        )
	          return;

	        $seat1.addClass("hover");
	        $seat2.addClass("hover");
	      } else if (remaining === 1) {
	        if ($this.hasClass("reserved") || $this.prop("disabled")) return;
	        $this.addClass("hover");
	      }
	    })
	    .on("mouseleave", function () {
	      $(".selseat").removeClass("hover");
	    });

	  // ---------------------------
	  // 좌석선택(클릭)
	  // ---------------------------
	  $(document).on("click", ".selseat", function () {
	    const $this = $(this);
	    if ($this.prop("disabled") || $this.hasClass("reserved")) return;

	    const col = parseInt($this.attr("col"));
	    const row = $this.attr("row");
	    const total = parseInt($(".adult-inwoncount").text()) +
				      parseInt($(".teenager-inwoncount").text());
	    const selectedCount = $(".selseat.select").length;
	    const startCol = col % 2 === 0 ? col - 1 : col;

	    // 이미 선택된 좌석이면 무조건해제
	    if($this.hasClass("select")){
				//----짝수좌석 해제
	    	    if(	$(`.selseat[row='${row}'][col='${startCol}']`).hasClass("select") &&
	    			$(`.selseat[row='${row}'][col='${startCol+1}']`).hasClass("select")
	    		){
	    		  $(`.selseat[row='${row}'][col='${startCol}']`).removeClass("select");
	    	      $(`.selseat[row='${row}'][col='${startCol + 1}']`).removeClass("select");
	    	}else{
				//----단일좌석 해제
				$this.removeClass("select");
	    	}
				updateShowSelSeat();
				updatePrice();
				reservationSeatRule();
				return;
	    }

	 	// **선택되지 않은 좌석을 클릭한 경우**
	    // -- 2명 이상 선택 가능한 경우 (짝수 처리)
	    if (total - selectedCount >= 2) {
	        if (
	          !$(`.selseat[row='${row}'][col='${startCol}']`).hasClass("select") &&
	          !$(`.selseat[row='${row}'][col='${startCol + 1}']`).hasClass("select")
	        ) {
	          $(`.selseat[row='${row}'][col='${startCol}']`).addClass("select");
	          $(`.selseat[row='${row}'][col='${startCol + 1}']`).addClass("select");
	          updateShowSelSeat();
	          updatePrice();
	          reservationSeatRule();
	          return;
	        }
	      }

		 // ------ 단일좌석 처리 ------
		 if (total - selectedCount === 1) {
		   if ($this.hasClass("select")) {
		     $this.removeClass("select");
		   } else {
		        $this.addClass("select");
		   			}
		      updateShowSelSeat();
		      updatePrice();
		      reservationSeatRule();
		    }
	  });

	  // ---------------------------
	  // 성인 인원수 증가/감소
	  // ---------------------------
	  $(".btn-up-a").on("click", function () {
	    const countSpan = $(this).siblings(".adult-inwoncount");
	    let count = parseInt(countSpan.text());
	    const teen = parseInt($(".teenager-inwoncount").text());
	    if (count + teen >= 8) {
	      alert("최대 예약인원은 8명입니다.");
	      return;
	    }
	    countSpan.text(++count);
	  });

	  $(".btn-down-a").on("click", function () {
	    const countSpan = $(this).siblings(".adult-inwoncount");
	    let count = parseInt(countSpan.text());
	    const selectCount = $(".selseat.select").length;
	    const teen = parseInt($(".teenager-inwoncount").text());
	    const totalInwon = count + teen;
	    if (count > 0) {
	      if (selectCount > totalInwon - 1) {
	        alert("선택한 좌석이 인원보다 많습니다.");
	        return;
	      }
	      countSpan.text(--count);
	    }
	  });

	  // ---------------------------
	  // 청소년 인원수 증가/감소
	  // ---------------------------
	  $(".btn-up-t").on("click", function () {
	    const countSpan = $(this).siblings(".teenager-inwoncount");
	    let count = parseInt(countSpan.text());
	    const adult = parseInt($(".adult-inwoncount").text());
	    if (count + adult >= 8) {
	      alert("최대 예약인원은 8명입니다.");
	      return;
	    }
	    countSpan.text(++count);
	  });

	  $(".btn-down-t").on("click", function () {
	    const countSpan = $(this).siblings(".teenager-inwoncount");
	    let count = parseInt(countSpan.text());
	    const adult = parseInt($(".adult-inwoncount").text());
	    const selectCount = $(".selseat.select").length;
	    const totalInwon = adult + count;
	    if (count > 0) {
	      if (selectCount > totalInwon - 1) {
	        alert("선택한 좌석이 인원수보다 많습니다.");
	        return;
	      }
	      countSpan.text(--count);
	    }
	  });

	  // ---------------------------
	  // 인원수 변경시 처리
	  // ---------------------------
	  $(".btn-up-a, .btn-down-a, .btn-up-t, .btn-down-t").on("click", function () {
	    seatLock();
	    updatePrice();
	    reservationSeatRule();
	  });

	  // ---------------------------
	  // 초기화 버튼
	  // ---------------------------
	  $(".btn-reset").on("click", function () {
	    $(".adult-inwoncount").text(0);
	    $(".teenager-inwoncount").text(0);
	    $(".selseat").removeClass("select");
	    seatLock();
	    updatePrice();
	    updateShowSelSeat();
	  });

	  // ---------------------------
	  // 인원수 0일 때 잠금/해제
	  // ---------------------------
	  function seatLock() {
	    const adult = parseInt($(".adult-inwoncount").text());
	    const teen = parseInt($(".teenager-inwoncount").text());
	    const total = adult + teen;
	    if (total === 0) {
	      $(".seat-overlay").show();
	      $(".selseat").prop("disabled", true).css("opacity", "0.5");
	    } else {
	      $(".seat-overlay").hide();
	      $(".selseat").each(function () {
	        if (!$(this).hasClass("reserved")) {
	          $(this).prop("disabled", false).css("opacity", "1");
	        }
	      });
	    }
	  }


	  // ---------------------------
	  // 결제금액 업데이트
	  // ---------------------------
	  function updatePrice() {
	    const adult = parseInt($(".adult-inwoncount").text());
	    const teen = parseInt($(".teenager-inwoncount").text());
	    const adultPrice = <%=price%>;
	    const teenPrice = Math.floor(adultPrice * 0.8);
	    const totalPay = adultPrice * adult + teenPrice * teen;
	    const formatTotalPay = new Intl.NumberFormat("ko-KR").format(totalPay);
	    $(".pay span:last-child").text(formatTotalPay + "원");
	  }

	  // ---------------------------
	  // 선택 좌석 정보 표시
	  // ---------------------------
	  function updateShowSelSeat() {
	    const selectSeats = $(".selseat.select");
	    const $showBox = $(".myseat-show");
	    $showBox.empty();
	    selectSeats.each(function () {
	      const seatNo = $(this).attr("seat-no");
	      $showBox.append("<div class='div-showSeat'>" + seatNo + "</div>");
	    });
	    for (let i = 0; i < 8 - selectSeats.length; i++) {
	      $showBox.append("<div>?</div>");
	    }
	  }

	// ---- 1명 좌석선택일 시 좌석 잠금 -------- //
	//										//
	  function reservationSeatRule() {
		  const totalSeat =
			    parseInt($(".adult-inwoncount").text()) +
			    parseInt($(".teenager-inwoncount").text());
		  const selectCount = $(".selseat.select").length;
	      const remaining = totalSeat - selectCount;
		  if (totalSeat === 0 || isNaN(totalSeat)) return;

		// 1. 모든 temp-reserved 잠금 해제 (선택된 거 아니면)
		  $(".selseat.temp-reserved").each(function () {
		    const $btn = $(this);
		    if (!$btn.hasClass("reserved") && !$btn.hasClass("select")) {
		      $btn.prop("disabled", false)
		        .removeClass("temp-reserved")
		        .text($btn.attr("col"));
		    }
		  });

		  // 2. 남은 좌석이 1개(마지막 한 명)일 때만 아래 룰 적용
		  if (remaining === 1) {
		    $(".selseat").each(function () {
		      const $btn = $(this);
		      if ($btn.hasClass("reserved") || $btn.hasClass("select")) return;
		      const col = parseInt($btn.attr("col"));
		      const row = $btn.attr("row");

		      let shouldLock = false;
			  // 3번 : 5,6선택시 잠김
			  if (col ===3){
				  const $5 = $(`.selseat[row='${row}'][col='5']`);
			      const $6 = $(`.selseat[row='${row}'][col='6']`);
			      if($5.hasClass("select") && $6.hasClass("select")) shouldLock = true;
			  }
		      // 4번: 5,6 선택시만 열림
		      if (col === 4) {
		        const $5 = $(`.selseat[row='${row}'][col='5']`);
		        const $6 = $(`.selseat[row='${row}'][col='6']`);
		        if (!($5.hasClass("select") && $6.hasClass("select"))) shouldLock = true;
		      }
		      //5번 7,8번 선택시 잠김
		      if (col ===5){
				const $7 = $(`.selseat[row='${row}'][col='7']`);
				const $8 = $(`.selseat[row='${row}'][col='8']`);
				if($7.hasClass("select") && $8.hasClass("select")) shouldLock = true;
		      }
		      // 6번: 7,8 선택시만 열림
		      if (col === 6) {
		        const $7 = $(`.selseat[row='${row}'][col='7']`);
		        const $8 = $(`.selseat[row='${row}'][col='8']`);
		        if (!($7.hasClass("select") && $8.hasClass("select"))) shouldLock = true;
		      }
		      // 7번: 9번 10번 선택되면 잠김
		      if (col === 7){
				const $9 = $(`.selseat[row='${row}'][col='9']`);
				const $10 = $(`.selseat[row='${row}'][col='10']`);
				if( $9.hasClass("select") && $10.hasClass("select")) shouldLock= true;
		      }

		      // 8번: 7,8 선택시만 열림
		      if (col === 8) {
		        const $7 = $(`.selseat[row='${row}'][col='7']`);
		        const $8 = $(`.selseat[row='${row}'][col='8']`);
		        const $9 = $(`.selseat[row='${row}'][col='9']`);
		        const $10 = $(`.selseat[row='${row}'][col='10']`);
		        if (!(
		        	($7.hasClass("select") && $8.hasClass("select")) ||
		        	($9.hasClass("select") && $10.hasClass("select"))
		        )) shouldLock = true;
		      }

		      //9번: 11,12번 선택시 잠김
		      if(col === 9){
		    	  const $11 = $(`.selseat[row='${row}'][col='11']`);
			      const $12 = $(`.selseat[row='${row}'][col='12']`);

			      if($11.hasClass("select") && $12.hasClass("select")) shouldLock = true;
		      }

		      // 10번: (9,10 선택시 11만 열림, 11,12 선택시 10만 열림)
		      if (col === 10) {
		        const $9 = $(`.selseat[row='${row}'][col='9']`);
		        const $10 = $(`.selseat[row='${row}'][col='10']`);
		        const $11 = $(`.selseat[row='${row}'][col='11']`);
		        const $12 = $(`.selseat[row='${row}'][col='12']`);
		        // 9,10 선택된 경우에만 11 오픈, 11,12 선택된 경우에만 10 오픈
		        if (
		          !(
		            ($9.hasClass("select") && $10.hasClass("select") && col === 11) ||
		            ($11.hasClass("select") && $12.hasClass("select") && col === 10)
		          )
		        ) {
		          shouldLock = true;
		        }
		      }
		      // 11번: (9,10 선택시 11만 열림, 11,12 선택시 10만 열림)
		      if (col === 11) {
		        const $9 = $(`.selseat[row='${row}'][col='9']`);
		        const $10 = $(`.selseat[row='${row}'][col='10']`);
		        const $11 = $(`.selseat[row='${row}'][col='11']`);
		        const $12 = $(`.selseat[row='${row}'][col='12']`);
		        // 9,10 선택된 경우에만 11 오픈, 11,12 선택된 경우에만 10 오픈
		        if (
		          !(
		            ($9.hasClass("select") && $10.hasClass("select") && col === 11) ||
		            ($11.hasClass("select") && $12.hasClass("select") && col === 10)
		          )
		        ) {
		          shouldLock = true;
		        }
		      }
		      //12번 9번10번 선택되면 잠김
		      if (col ===12){
		    	  const $9 = $(`.selseat[row='${row}'][col='9']`);
			      const $10 = $(`.selseat[row='${row}'][col='10']`);
			      if($9.hasClass("select") && $10.hasClass("select")) shouldLock = true;
		      }

		      // 잠금 처리
		      if (shouldLock) {
		        $btn.prop("disabled", true)
		          .addClass("temp-reserved")
		          .html("<i class='ri-lock-fill' style='color:gray;'></i>");
		      }
		    });
		  }
	  }


	  // ---------------------------
	  // 최초 화면 세팅
	  // ---------------------------
	  seatLock();
	  updatePrice();
	  reservationSeatRule();
	});
</script>
<body>
	<div class="container">
		<div class="title">
			<h3><b>빠른예매</b></h3>
			<hr>
		</div>
		<div class="subject">
				 	<h5 style="margin-right: 29rem;">좌석예매</h5>
				 	<button type="button" class="btn-mov btn-reset">초기화</button>
				</div>
		<div class="mainbox">
			<div class="seatbox">
				<div class="seatcount">
					<div class="adultseat">
						<span>성인</span>
							<button class="btn-down-a">-</button>
							<span class="adult-inwoncount">0</span>
							<button class="btn-up-a">+</button>
					</div>
					<div class="teenagerseat">
						<span>청소년</span>
						<button class="btn-down-t">-</button>
						<span class="teenager-inwoncount">0</span>
						<button class="btn-up-t">+</button>
					</div>
				</div>
				<div class="screen">
				 <span>screen</span>
				</div>
				<div class="seat-wrapper" style="position: relative;">
					<div class="seat">
					<%
					String[] seatrows ={"A","B","C","D","E","F","G","H","I","J","K","l","M","N"};
					for(int i=1;i<=14;i++){
						String row = seatrows[i-1];
					%>
						<div style="display: flex; align-items: center; height: 40px;" class="seat-row">
							<span style="width: 20px; display: inline-block; text-align: center; margin-right: 15px;"><%=seatrows[i-1] %></span>

						<%for(int j=1;j<=14;j++){
						//버튼에 seat의 열 값 넣어주기위한 col 생성
						String col = String.valueOf(j);
						String reserved = "";
						String seat_id = "";
						//버튼 3번이랑 13번부터 왼쪽 띄워주기 위한 마진
						String margin = (j==3 || j==13)?"20px":"";

							//DAO에서 조회한값으로 seat의 row와 col을 얻는다
							for(HashMap<String,String> m:list){
								String seat_row = m.get("seat_row");
								String seat_col = m.get("seat_col");

								//해당 screening의 seat테이블의 row와 col이 button 버튼의 row와 col 이 일치하고
								//is_reserved의 값이1이면(예약이 되어있으면) reserved -> 버튼을 disabled로 바꿈(버튼 선택불가)
								if(seat_row.equals(row) && seat_col.equals(col)){
									seat_id = m.get("seat_id");
									if("1".equals(m.get("is_reserved"))){
										reserved = "disabled reserved'";
									}
								}
							}
						%>
							<button class="btn-seat selseat <%=reserved.contains("reserved")?" reserved":"" %>" type="button" style="margin-left: <%=margin%>"
								row="<%=row%>" col="<%=col%>" seat-no="<%=seatrows[i-1]%><%=j%>" seat-id="<%=seat_id %>"
								<%=reserved.contains("disabled")?"disabled":"" %>
								>
								<%if(reserved.contains("reserved")){%>
									<i class="ri-close-circle-fill" style="color: crimson;"></i>
								<% }else{%>
								<%=j %>
								<%} %>
							</button>
						<%}%>
						</div>
					<%}
					%>
					</div>
					<div class="seat-overlay">
					<span>인원수를 선택하세요</span>
					</div>
				</div>
		</div>
		<div class="paybox">
			<div class="pay-title">
				<p><%=title %></p>
			</div>
			<hr>
			<div class="pay-info">
				<div class="pay-infosrting">
				<p class="theater"><%=theater_name %></p>
				<p class="auditorium"><%=auditorium_name %></p>
				<p class="date"><%=formatDate%></p>
				</div>
				<%
				String posterUrl = "https://image.tmdb.org/t/p/w500";
				String photo = poster.startsWith("https:")?poster:posterUrl+poster;
				%>
				<img alt="" src="<%=photo%>">
			</div>
			<hr>
			<div class="seat-choice-info">
				<div class="legend" style="padding-top: 80px; padding-left: 10px;">
					 <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
					    <div style="
					      width: 24px;
					      height: 24px;
					      border: 1px solid #352461;
					      display: flex;
					      align-items: center;
					      justify-content: center;
					      border-radius: 4px;
					    ">
					      <i class='ri-lock-fill' style='color: gray; font-size: 16px;'></i>
					    </div>
					    <span>선택불가</span>
					  </div>

					  <!-- 예약된 자리 -->
					  <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
					    <div style="
					      width: 24px;
					      height: 24px;
					      background: #352461;
					      border: 1px solid #352461;
					      display: flex;
					      align-items: center;
					      justify-content: center;
					      border-radius: 4px;
					    ">
					      <i class="ri-close-circle-fill" style="color: crimson; font-size: 16px;"></i>
					    </div>
					    <span>예약된 자리</span>
					  </div>

					  <!-- 선택된 좌석 -->
					  <div style="display: flex; align-items: center; gap: 8px;">
					    <div style="
					      width: 24px;
					      height: 24px;
					      background: #352461;
					      border: 1px solid #352461;
					      border-radius: 4px;
					    "></div>
					    <span>선택된 좌석</span>
					  </div>
					</div>
				<div class="myseat">
					<span>선택좌석</span>
					<div class="myseat-show">
						<div>?</div>
						<div>?</div>
						<div>?</div>
						<div>?</div>
						<div>?</div>
						<div>?</div>
						<div>?</div>
						<div>?</div>
					</div>
				</div>
			</div>
			<br>
			<hr>
			<div class="pay">
			<span>최종결제금액</span>
			<span class="last-pay"></span>
			</div>
			<div class="pay-btn" style="text-align: center; margin-top: 20px;">
				<button class="btn-pay">결제하기</button>
			</div>
		</div>
		</div>
	</div>
</body>
</html>