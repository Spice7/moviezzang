<%@page import="data.dto.UserDTO"%>
<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>


<%@ include file="../../member/login/loginForm.jsp"%>

<%
String loginok = (String) session.getAttribute("loginok");

UserDAO dao = UserDAO.getInstance();

String sessionuserid = (String) session.getAttribute("userid");
String usertype = (String) session.getAttribute("usertype");

String id = dao.getId(sessionuserid);

String currentMain = request.getParameter("main");
%>

<meta charset="UTF-8">
<title>Insert title here</title>

<!--  pt-[72px] -->
</head>
<body
	class="bg-white <%=request.getParameter("main") != null ? "pt-[72px]" : ""%>">
	<header
		class="w-full bg-black text-white fixed top-0 left-0 right-0 z-50">
		<div class="container mx-auto px-4 py-3 bg-black">
			<div class="flex justify-between items-center">
				<nav
					class="hidden md:flex items-center space-x-12 justify-center mx-auto"
					style="padding-left: 13rem">
					<a href="?main=movie/movieList.jsp"
						class="hover:!text-yellow-300 !transition-colors !no-underline <%="movie/movieList.jsp".equals(currentMain) ? "!text-yellow-300" : "!text-white"%>">
						영화 </a>
						<%
						if(loginok !=null){%>
							<a
							href="<%=request.getContextPath()%>/index.jsp?main=book/booking/bookMain.jsp"
							class="hover:!text-yellow-300 !transition-colors !no-underline <%="book/booking/bookMain.jsp".equals(currentMain) ? "!text-yellow-300" : "!text-white"%>">
							예매 </a>
						<%}else{%>
							<a href="#"	id="openLoginModal"
							class="!text-white hover:!text-yellow-300 !transition-colors !no-underline">
							예매</a>
						<%}
 						%>
						<a
						href="<%=request.getContextPath()%>/index.jsp?main=theater/theaterMain.jsp"
						class="hover:!text-yellow-300 !transition-colors !no-underline <%="theater/theaterMain.jsp".equals(currentMain) ? "!text-yellow-300" : "!text-white"%>">
						극장 </a> <a onclick="location.href='<%=request.getContextPath()%>/'"
						class="flex items-center space-x-2 transform transition-transform duration-300 hover:[transform:rotateY(180deg)]">
						<img src="<%=request.getContextPath()%>/resources/moviezzang.png"
						alt="영화짱닷컴" class="cursor-pointer h-12 max-w-none " />
					</a> <a href=""
						class="hover:!text-yellow-300 !text-white !transition-colors !no-underline">스토어</a>
					<a href=""
						class="hover:!text-yellow-300 !text-white !transition-colors !no-underline">이벤트</a>
					<a href=""
						class="hover:!text-yellow-300 !text-white !transition-colors !no-underline">혜택</a>
				</nav>
				<div class="flex items-center space-x-6">
					<div
						class="w-8 h-8 flex items-center justify-center hover:!text-yellow-300 !transition-colors !no-underline !cursor-pointer">
						<!--     <i class="ri-search-line ri-lg"></i> -->
					</div>

					<%
					if (loginok != null && "ADMIN".equalsIgnoreCase(usertype)) {
					%>

					<a id="logout"
						class="!text-white hover:!text-yellow-300 !transition-colors !no-underline"
						href="member/login/logoutAction.jsp"> 로그아웃</a> <a id="logout"
						class="!text-white hover:!text-yellow-300 !transition-colors !no-underline <%= ("indexAdmin.jsp?id=" + id).equals(currentMain) ? "!text-yellow-300" : "!text-white" %>"
						href="?main=indexAdmin.jsp?id=<%=id%>"> 관리자페이지</a> <a
						href="?main=member/mypage/mypageMain.jsp?id=<%=id%>"
						class="!text-sm hover:!text-yellow-300 !transition-colors !text-white !no-underline <%= ("member/mypage/mypageMain.jsp?id=" + id).equals(currentMain) ? "!text-yellow-300" : "!text-white" %>">마이페이지</a>
					<%
					}

					else if (loginok != null) {
					%>
					<a id="logout"
						class="!text-white hover:!text-yellow-300 !transition-colors !no-underline"
						href="member/login/logoutAction.jsp"> 로그아웃</a> <a
						href="?main=member/mypage/mypageMain.jsp?id=<%=id%>"
						class="!text-sm hover:!text-yellow-300 !transition-colors !text-white  !no-underline <%= ("member/mypage/mypageMain.jsp?id=" + id).equals(currentMain) ? "!text-yellow-300" : "!text-white" %>">마이페이지</a>
					<%
					}
					else {
					%>
					<a id="openLoginModal2"
						class="!text-white hover:!text-yellow-300 !transition-colors !no-underline"
						href="#"> 로그인</a> <a href="?main=member/signup/signupForm.jsp"
						class="hover:!text-yellow-300 !transition-colors !text-white !no-underline <%="member/signup/signupForm.jsp".equals(currentMain) ? "!text-yellow-300" : "!text-white"%>">회원가입</a>
					<%
					}
					%>
					<%if(loginok!=null){ %>
					<a href="<%=request.getContextPath()%>/index.jsp?main=book/booking/bookMain.jsp"
						class="!bg-primary !text-white px-6 py-2 !rounded-button whitespace-nowrap !text-sm hover:!bg-opacity-90 !transition-colors !no-underline">빠른예매</a>
					<%}else{%>
					<a href="#" id="openLoginModal3"
						class="!bg-primary !text-white px-6 py-2 !rounded-button whitespace-nowrap !text-sm hover:!bg-opacity-90 !transition-colors !no-underline">빠른예매</a>
					<% }%>

				</div>

			</div>
		</div>
	</header>
</body>
<script>
	document.getElementById('openLoginModal').onclick = function(e) {
		e.preventDefault();
		if (window.openShadowLoginModal) {
			window.openShadowLoginModal();
		} else {
			alert('로그인 모달이 준비되지 않았습니다.');
		}
	};
	document.getElementById('openLoginModal2').onclick = function(e) {
		e.preventDefault();
		if (window.openShadowLoginModal) {
			window.openShadowLoginModal();
		} else {
			alert('로그인 모달이 준비되지 않았습니다.');
		}
	};
	document.getElementById('openLoginModal3').onclick = function(e) {
		e.preventDefault();
		if (window.openShadowLoginModal) {
			window.openShadowLoginModal();
		} else {
			alert('로그인 모달이 준비되지 않았습니다.');
		}
	};
</script>
</html>