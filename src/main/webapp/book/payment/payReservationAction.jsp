<%@page import="data.dao.UserDAO"%>
<%@page import="data.dao.ReservationDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
ReservationDAO dao = ReservationDAO.getInstance();
UserDAO udao = UserDAO.getInstance();
String userNum = request.getParameter("userNum");
String screeningId = request.getParameter("screeningId");
String seatIds = request.getParameter("seatIds");
String lastPay = request.getParameter("lastPay");
String total = request.getParameter("total"); //reserved_count

int reservationId = dao.insertReserve(screeningId, userNum, lastPay, total);

System.out.println("userNum = " + userNum);
System.out.println("screeningId = " + screeningId);
System.out.println("seatIds = " + seatIds);
System.out.println("reservationId = " + reservationId);
System.out.println("lastPay = " + lastPay);


	if(reservationId > 0)
	{
		String seats [] = seatIds.split(",");
		for(String seatId : seats)
		{
			dao.insertSeatReserve(reservationId, seatId);
		}
		
		// 가격 중 1의자리수가 0이 외에는 들어가지 않기 때문에 int 연산도 문제없다
		// 실제로도 float double 등은 부동소수점 연산에 오차가 있기 때문에 소수점도 int로 따로 표현
		int mileage = (int)(Integer.parseInt(lastPay) * 0.1f);
		System.out.println("적립할 마일리지: " + mileage);
		
		//마일리지 적립
		udao.updateMileage(mileage, userNum);
		out.print("{\"result\":\"success\"}");
	}else{
		 out.print("{\"result\":\"fail\", \"message\":\"예약실패\"}");
	}
%>