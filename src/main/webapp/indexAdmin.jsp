<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
	// 관리자 체크
	String userid = (String)session.getAttribute("userid");
	String mContent = request.getParameter("maincontent");
	UserDAO dao = UserDAO.getInstance();
	
	if(userid == null || !dao.getUserType(userid).equals("ADMIN"))
	{
%>
		<script>
			history.back();
		</script>
<%
	}
%>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=42dot+Sans:wght@300..800&family=Black+Han+Sans&family=Dongle&family=Jua&family=Nanum+Myeongjo&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>indexAdmin</title>
<style>
        body {
            background: #f5f6fa;
        }
        
        .sidebar {
            min-width: 180px;
            max-width: 200px;
            background: #23395d;
            color: #fff;
            min-height: 100vh;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        .sidebar .nav-link {
            color: #fff;
            font-size: 1.1rem;
            padding: 20px 15px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            transition: background 0.2s;
        }
        
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: #395886;
            color: #fff;
        }
        
        .header {
            background: #fff;
            border-bottom: 1px solid #e3e3e3;
            padding: 24px 32px 24px 90px;
            display: flex;
            align-items: center;
            position: relative;
            min-height: 80px;
        }
        
        .profile-circle {
		    width: 60px;
		    height: 60px;
		    background: #aac8e4;
		    border-radius: 50%;
		    border: 3px solid #395886;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    overflow: hidden;  		/* 넘치는 부분 자르기 */
		    position: absolute;
		    left: 20px;
		    top: 50%;
		    transform: translateY(-50%);
		}
		
		.profile-circle .profile-img {
		    width: 100%;
		    height: 100%;
		    object-fit: cover;   	/* 비율 유지하며 꽉 채움 */
		    border-radius: 50%;  	/* 혹시 모를 라운딩 보장 */
		    display: block;
		}
		
        .main-content {
            background: #fff;
            border-radius: 18px;
            margin: 24px;
            min-height: 400px;
            box-shadow: 0 2px 12px rgba(35,57,93,0.08);
            padding: 36px;
        }
        
        /* 반응형 */
        @media (max-width: 900px) {
            .sidebar {min-width: 60px; max-width: 60px;}
            .sidebar .nav-link {font-size: 1rem; padding: 14px 8px;}
            .header {padding-left: 80px;}
            .profile-circle {width: 44px; height: 44px; font-size: 1.5rem;}
        }
</style>
</head>
<body>
	<div class="d-flex">
	    <!-- 좌측바 -->
	    <div class="sidebar d-flex flex-column p-0">
	        <div class="flex-grow-1">
	            <a class="nav-link active" href="#" onclick="loadContents('./admin/adminMember.jsp')">회원</a>
	            <a class="nav-link" href="#" onclick="loadContents('./admin/adminTheater.jsp')">극장</a>
	            <a class="nav-link" href="#" onclick="loadContents('./admin/adminScreening.jsp')">상영스케줄</a>
	        </div>
	    </div>
	    <div class="flex-grow-1">
	        <!-- 헤더 -->
	        <div class="header">
	            <div class="profile-circle">
	                <img src="./resources/moviezzang.png" alt="logoImg" class="profile-img">
	            </div>
	            <h4 class="ms-4 mb-0 fw-bold">영화짱 관리자</h4>
	        </div>
	        <!-- 여기가 관리자 컨텐츠 -->
	        <div class="main-content" id="main-content">
	            <h2>관리자 대시보드</h2>
	        </div>
	    </div>
	</div>
</body>
<script>
	function loadContents(content) {
		$("#main-content").load(content);
	}
	
	loadContents('./admin/adminMember.jsp');
	
	$(".sidebar>div>a").on("click", function(){
		$(".sidebar>div>a").removeClass("active");
		$(this).addClass("active");
	});
</script>
</html>