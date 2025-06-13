<%@page import="data.dao.MovieDAO"%>
<%@page import="data.dto.MovieDTO"%>
<%@page import="java.sql.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
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

    .mystory-wrapper {
      display: flex;
      max-width: 1000px;
      margin: 100px auto 50px auto;
      padding: 20px;
      gap: 30px;
    }

    .mystory-content {
      flex: 1;
    }

    .mystory-header {
      background: linear-gradient(to right, #1a1a3c, #181847);
      color: white;
      padding: 20px;
      border-radius: 15px;
      text-align: center;
    }

    .mystory-header h3 {
      margin: 0;
      font-size: 20px;
    }

    .mystory-header .mileage {
      font-size: 20px;
      text-align: right;
      margin-top: 10px;
    }

    .mystory-box {
      display: flex;
      background-color: white;
      border-radius: 10px;
      padding: 20px;
      margin-top: 20px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      color: gray;
      
    }

    .mystory-section h4 {
      margin-top: 30px;
      margin-bottom: 10px;
    }

    .mphoto{
    	width: 200px;
    	height: 300px;
    	object-fit: cover;
    	
    }
	
	.postertd{
		flex-shrink: 0;
		box-shadow: 10px 10px 10px gray;	
		border: 1px solid gray;
		width: 200px;
		height: 300px;
		
	}
  
  .mystory-info {
  margin-left: 30px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  
}
  </style>
</head>
<%






List<HashMap<String, String>> list=dao.getStoryList(userid);
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");


%>
<body>

<div class="mystory-wrapper">
  
  <!-- sideBar -->
<jsp:include page="sideBar.jsp"></jsp:include>



  <!-- Main content -->
  <div class="mystory-content">
    <div class="mystory-header">
        <h4 class="text-2xl font-bold">My MovieStory</h4>
    </div>

    <div class="mystory-section">
      	<%
      		if(list.size()==0)
      		{%>
      			<div style="text-align: center; margin-top: 50px;"><b>등록된 영화가 없습니다.<br>
      					리뷰를 남겨보세요!
      			</b></div>
      		<%}else{
      	%>
      
       

        	<%
        	for(int i=0;i<list.size();i++)
        	{
        		HashMap<String,String> map=list.get(i);
        		String movietitle=map.get("title");
        		
  				String tmdbPath = "https://image.tmdb.org/t/p/w500";
				String originalPath = map.get("poster_url");
				
				  int rating = Integer.parseInt(map.get("rating"));
				   int stars = rating / 2;
				   
				   
				   MovieDAO mdao=MovieDAO.getInstance();
				   MovieDTO mdto=mdao.getMovieBytitle(movietitle);
				   
					StringBuilder starHtml = new StringBuilder();
					for (int j = 0; j < stars; j++) {
					    starHtml.append("⭐");
					}
        	%>
        	<div class="mystory-box">
        		<p class="postertd"><a href="index.jsp?main=movie/movieDetail.jsp?id=<%=mdto.getId() %>&name=<%=mdto.getTitle()%>"><img src="<%=originalPath.startsWith("https://") ? originalPath : tmdbPath + originalPath%>" alt="" class="object-cover rounded mphoto" /></a></p>
        		
        	  <div class="mystory-info">
        	  <div style="margin-left: 70px;">
        	  	영화제목: 
        		<b style="color: black;"><%=map.get("title") %></b>
        		</div>
        		<div style="margin-left: 70px;">
        		영화 평점: 
        		<b style="color: black;"><%=map.get("score") %></b>
        		</div>
        		<div style="margin-left: 70px;">
        		내 관람평:
        		<b style="color: black;"><%=map.get("content") %></b>
        		</div>
        		<div style="margin-left: 70px;">
        		내 별점:
        		<b style="color: black;"><%=starHtml%></b>
        		</div>
        		<div style="margin-left: 70px;">
        		상영날짜:
        		<b style="color: black;"><%=map.get("start_time") %></b>    		
        		</div>
        		<div style="font-size: 10pt; margin-left: 290px;">   		
        			<%=map.get("created_at")%>  작성
        		</div>
        	   </div>
        	</div>
        	<%}
        	%>
        	<%
      		}
        	%>
       
        
    </div>

    
  </div>
</div>

</body>

</html>
