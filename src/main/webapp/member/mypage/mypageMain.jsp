<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="data.dto.UserDTO"%>
<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ include file="../../component/menu/headerResources.jsp" %>
<!DOCTYPE html>
<html>

<%
	String root=request.getContextPath();

	String id=request.getParameter("id");
	String userid=(String)session.getAttribute("userid");
    // 로그인 체크
   // 로그인한 사용자의 시퀀스 번호
    UserDAO dao=UserDAO.getInstance();
    String uid=dao.getId(userid);
     // 주소창에서 전달된 id

    if (userid == null || id == null || !id.equals(uid)) {
    	    
        // 로그인 안 된 사용자        
        %>
        <script type="text/javascript">
        
			//history.back();
			location.href="<%=root%>/component/error/notFound.jsp"
        </script>
        <%
    }
%>
<head>
  <meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

  <title>마이페이지</title>
  <style type="text/css"> 
    body {
      margin: 0;
      padding: 0;
      background-color: white;
      
    }

    .mypage-wrapper {
      display: flex;
      max-width: 1000px;
      margin: 100px auto 50px auto;
      padding: 20px;
      gap: 30px;
    }

    .mypage-content {
      flex: 1;
    }

    .mypage-header {
      background: linear-gradient(to right, #1a1a3c, #181847);
      color: white;
      padding: 20px;
      border-radius: 15px;
    }

    .mypage-header h3 {
      margin: 0;
      font-size: 20px;
    }

    .mypage-header .mileage {
      font-size: 20px;
      text-align: right;
      margin-top: 10px;
    }

    .mypage-box {
      background-color: white;
      border-radius: 10px;
      padding: 20px;
      margin-top: 20px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
    }

    .mypage-section h4 {
      margin-top: 30px;
      margin-bottom: 10px;
    }

    

  
  </style>
</head>
<%



UserDTO dto=dao.getData(id);

List<HashMap<String, String>> list=dao.getReserveList(userid);

int size=list.size();

List<HashMap<String, String>> slist=dao.getStoryList(userid);

int storysize=slist.size();




%>
<body>

<div class="mypage-wrapper">
  
  <!-- sideBar -->
<jsp:include page="sideBar.jsp"></jsp:include>



  <!-- Main content -->
  <div class="mypage-content">
    <div class="mypage-header">
      <h1 class="text-2xl font-bold">안녕하세요! <%=dto.getName() %>(<%=dto.getUserid() %>) 님</h1>
      <h6 style="color: gray;">Welcome!</h6>
      <%-- <div class="mileage">보유 마일리지 (<%=dto.getMileage() %>P)</div> --%>
    </div>
    <%-- <%
    int totalMileage = 0;
    for(int i=0;i<list.size();i++) {
        HashMap<String,String> map=list.get(i);
        int price = Integer.parseInt(map.get("lastpay"));
        totalMileage += (double)(price * 0.1);
    }
    %> --%>

    <div class="mypage-section">
      <h4 class="text-2xl font-bold" style="color: #000080">마일리지</h4>
      <div class="mypage-box">
        <p>보유 마일리지: <%=dto.getMileage() %>P</p>
      </div>
    </div>
    <div class="mypage-section">
      <h4 class="text-2xl font-bold" style="color: #000080">영화 예매 내역</h4>
      <div class="mypage-box">
        <p>총 예매내역: <%=size %>편</p>
      </div>
    </div>

    <div class="mypage-section">
      <h4 class="text-2xl font-bold" style="color: #000080">나의 무비스토리</h4>
      <div class="mypage-box">
        <p>등록된 영화: <%=storysize %>편</p>
      </div>
    </div>
  </div>
</div>

</body>

</html>
