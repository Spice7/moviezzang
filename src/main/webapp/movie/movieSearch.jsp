<%@page import="data.dto.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.MovieDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String root = request.getContextPath();
	String keyword = request.getParameter("keyword");
	MovieDAO dao = MovieDAO.getInstance();
	
	List<MovieDTO> list = dao.getDatasByTitle(keyword);
%>
	<input type="hidden" id="searchCount" value="<%=list.size()%>">
<%
	for (MovieDTO dto : list)
	{
%>
	<div class="mCard poster relative flex-shrink-0 w-64">
		<div class="relative">
		<%
			String tmdbPath = "https://image.tmdb.org/t/p/w500";
			String originalPath = dto.getPoster_url();
		%>
			<img src="<%=originalPath.startsWith("https://") ? originalPath : tmdbPath + originalPath%>"
				alt="" class="w-64 h-96 object-cover rounded" />
			<div class="hover-info absolute inset-0 !bg-black !bg-opacity-70 rounded flex flex-col justify-center items-center p-4"  style="width: 256px;">
				<div class="text-white text-center mb-4">
					<p class="font-bold mb-2"><%=dto.getTitle()%></p>
					<p class="text-sm"><%=dto.getRelease_date()%></p>
				</div>
				<button
					class="!bg-primary text-white px-4 py-2 !rounded-button whitespace-nowrap w-full mb-2"
					onclick="location.href='<%=root%>/index.jsp?main=book/booking/bookMain.jsp?movie_id=<%=dto.getId()%>'">
					예매하기</button>
				<button
					class="border border-white text-white px-4 py-2 !rounded-button whitespace-nowrap w-full"
					onclick="location.href='<%=root%>/index.jsp?main=/movie/movieDetail.jsp?id=<%=dto.getId()%>&name=<%=dto.getTitle()%>'">
					상세정보</button>
			</div>
		</div>
		<div class="mt-3">
			<p class="font-bold"><%=dto.getTitle()%></p>
			<div class="flex items-center text-sm text-gray-600 mt-1">
				<span>평점<i class="ri-star-fill"></i> <%=dto.getScore()%></span> <span class="mx-2">|</span> <span><%=dto.getRelease_date()%></span>
			</div>
		</div>
	</div>
<%		
	}
%>