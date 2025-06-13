<%@page import="data.dto.MovieDTO"%>
<%@page import="data.dao.MovieDAO"%>
<%@page import="mysql.db.DBConnect"%>
<%@page import="data.api.YouTube"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

YouTube fetcher = new YouTube();
String trailerId = fetcher.getTrailerVideoId("진격의거인 파이널");
boolean hasTrailer = trailerId != null && !trailerId.trim().isEmpty();

String loginok = (String)session.getAttribute("loginok");

MovieDAO dao = MovieDAO.getInstance();
MovieDTO dto = dao.getMovieById("1");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://cdn.tailwindcss.com/3.4.16"></script>
<script>
	tailwind.config = {
		theme : {
			extend : {
				colors : {
					primary : "#352461",
					secondary : "#503396"
				},
				borderRadius : {
					none : "0px",
					sm : "4px",
					DEFAULT : "8px",
					md : "12px",
					lg : "16px",
					xl : "20px",
					"2xl" : "24px",
					"3xl" : "32px",
					full : "9999px",
					button : "8px",
				},
			},
		},
	};
</script>
<title>Insert title here</title>
</head>
<body>

<% if (hasTrailer) { %>


	<section class="relative w-full aspect-[16/9] overflow-hidden">
		<!-- 영상 재생 iframe 삽입 -->
		<iframe class="absolute inset-0 w-full h-full"
			src="https://www.youtube.com/embed/<%=trailerId%>?autoplay=1&mute=1&controls=0&loop=1&playlist=<%=trailerId%>&enablejsapi=1"
			frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
		</iframe>

		<!-- 반투명 오버레이 -->
		<div class="absolute inset-0 bg-black bg-opacity-40 z-10"></div>

		<!-- 텍스트 콘텐츠 -->
		<div class="absolute inset-0 flex items-center z-20">
			<div class="container mx-auto px-4">
				<h1 class="text-4xl md:text-5xl font-bold text-white mb-4"><%=dto.getTitle()%></h1>
				<p class="text-xl text-white mb-6"></p>
				<div class="flex space-x-4">
					<button
						class="bg-primary text-white px-6 py-3 !rounded-button whitespace-nowrap hover:bg-opacity-90 transition-colors"
						onclick="location.href='?main=movie/movieDetail.jsp?id=<%=dto.getId()%>&name=<%=dto.getTitle()%>'">
						상세정보</button>
					<%if(loginok != null){ %>
					<button
						onclick="location.href='?main=book/booking/bookMain.jsp?movie_id=<%=dto.getId()%>'"
						class="bg-white text-primary px-6 py-3 !rounded-button whitespace-nowrap hover:bg-opacity-90 transition-colors">
						예매하기</button>
						<%}%>
				</div>
			</div>
		</div>
	</section>
<% } else { %>
<!-- 대체 UI (예: 예고편 없음 표시) -->
	<div class="p-6 text-center text-gray-700 pt-[10rem]">
		<h2 class="text-2xl font-bold mb-4"> 예고편을 불러오지 못했습니다 (유튜브 api 할당량초과가능성 )</h2>
		<p>현재 해당 영화의 트레일러를 확인할 수 없습니다.</p>
	</div>
<% } %>
</body>
</html>