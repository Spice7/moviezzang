<%@page import="data.dto.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.MovieDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../component/menu/headerResources.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=42dot+Sans:wght@300..800&family=Black+Han+Sans&family=Dongle&family=Jua&family=Nanum+Myeongjo&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>movieList</title>
<style>
	div.mListContainer {
		margin: 20px;
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 100%;
	}
	
	div.mCardList {
		display: flex;
		flex-wrap: wrap; /* 줄바꿈 허용 */
		gap: 32px 24px; /* 행/열 여백 */ /* 잘 모르겠다 */
		justify-content: flex-start;
		width: 100%;
		max-width: 1200px; /* 크기는 알아서 다만 이 수치가 기준이 될 것 */
		box-sizing: border-box;
	}
	
	div.mCard {
		flex: 0 0 23%;
		box-sizing: border-box;
		min-width: 220px; /* 필요에 따라 조정 */
		margin-bottom: 20px; /* 하단 여백 */
	}
	
	body {
		font-family: "Noto Sans KR", sans-serif;
	}
	
	.poster:hover .hover-info {
		opacity: 1;
	}
	
	.poster .hover-info {
		opacity: 0;
		transition: opacity 0.3s ease;
	}
	
	#pageLoader {
		width: 100%;
		margin: 32px auto;
		padding: 12px 32px;
		font-size: 1.1rem;
		border-radius: 8px;
		display: block;
	}
	
	div.mListHeader {
		display: flex;
		justify-content: space-between; /* 좌우 끝 정렬 */
		align-items: center;
		width: 100%;
		max-width: 1200px; /* 목록 크기와 마찬가지로 */
		margin-bottom: 24px;
		margin-top: 15px;
		box-sizing: border-box;
	}
	
	div.mSearch {
		display: flex;
		align-items: center;
		width: 220px;
		border: 1px solid #ccc;
		border-radius: 6px;
		background: #fff;
		padding: 0;
		box-sizing: border-box;
		margin-right: 85px;
	}
	
	div.mSearch input {
		border: none;
		outline: none;
		flex: 1;
		padding: 6px 4px;
		font-size: 1rem;
		background: transparent;
	}
	
	div.mSearch button {
		background: none;
		border: none;
		color: #999;
		font-size: 1.3rem;
		padding: 0 8px;
		height: 40px;
		cursor: pointer;
		display: flex;
		align-items: center;
	}
	
	div.mSearch input:focus {
		outline: none;
	}
</style>
<%
	String root = request.getContextPath();
	
	String name = request.getParameter("name");
	
	MovieDAO dao = MovieDAO.getInstance();
	List<MovieDTO> list;
	 
	/* 추천영화가있으면 검색후 띄워주고 없으면 디폴트 전체목록출력 */
	if (name != null && !name.trim().isEmpty()) {
		list = dao.getDatasByTitle(name); // 제목 포함 검색
	} else {
		list = dao.getAllDatas(); // 전체 목록
	}
	
	int contents = 12;
	int perPage = 12;
%>
</head>
<body>
	<div class="mListContainer">
		<div class="mListHeader">
			<span><%=list.size()%>개의 영화가 검색되었습니다</span>
			<div class="mSearch">
				<input type="text" id="movieSearch" placeholder="영화명 검색" />
				<button type="button" id="btnMovieSearch">
					<i class="bi bi-search"></i>
				</button>
			</div>
		</div>
		<div class="mCardList flex" id="mCardList">
			<%
			// 둘 중 작은 수치
			for (int i = 0; i < Math.min(contents, list.size()); i++) {
				MovieDTO dto = list.get(i);
			%>
			<div class="mCard poster relative flex-shrink-0 w-64">
				<div class="relative">
					<%
					String tmdbPath = "https://image.tmdb.org/t/p/w500";
					String originalPath = dto.getPoster_url();
					%>
					<img
						src="<%=originalPath.startsWith("https://") ? originalPath : tmdbPath + originalPath%>"
						alt="" class="w-64 h-96 object-cover rounded" />
					<div
						class="hover-info absolute inset-0 !bg-black !bg-opacity-70 rounded flex flex-col justify-center items-center p-4"
						style="width: 256px;">
						<div class="text-white text-center mb-4">
							<p class="mTitle font-bold mb-2"><%=dto.getTitle()%></p>
							<p class="text-sm"><%=dto.getRelease_date()%></p>
						</div>
						<button
							class="!bg-primary text-white px-4 py-2 !rounded-button whitespace-nowrap w-full mb-2"
							onclick="location.href='<%=root%>/index.jsp?main=book/booking/bookMain.jsp?movie_id=<%=dto.getId()%>'">
							예매하기
						</button>
						<button
							class="border border-white text-white px-4 py-2 !rounded-button whitespace-nowrap w-full"
							onclick="location.href='<%=root%>/index.jsp?main=/movie/movieDetail.jsp?id=<%=dto.getId()%>&name=<%=dto.getTitle()%>'">
							상세정보</button>
					</div>
				</div>
				<div class="mt-3">
					<p class="font-bold"><%=dto.getTitle()%></p>
					<div class="flex items-center text-sm text-gray-600 mt-1">
						<span>평점<i class="ri-star-fill"></i> <%=dto.getScore()%> </span> <span class="mx-2">|</span> <span><%=dto.getRelease_date()%></span>
					</div>
				</div>
			</div>
			<%
			}
			%>
		</div>
		<div class="mCardList">
			<button id="pageLoader" class="btn !bg-primary" style="color: white;">더보기 ▼</button>
		</div>
	</div>
</body>
<script>
	// jsp코드는 script 조건문으로 제어할 수 없다
	let contentAmount = <%=contents%>;
	const appendAmount = <%=perPage%>;
	let total = <%=list.size()%>;
	
	let currentKeyword = "";	// 검색어가 있는지 확인하는 변수	// 어떤 목록을 더보기로 추가할 지 제어하는 용도
	
	function searchMovies(){
		// Minecraft MINECRAFT mInEcRaFt 막 검색해도 다 찾을 수 있도록
	    const keyword = $("#movieSearch").val().toLowerCase();
		currentKeyword = keyword;				// 검색어 기억
		contentAmount = 12;
	    
		// 해당 키워드를 가진 영화 목록을 찾아와서
	    $.get("./movie/movieSearch.jsp", { keyword }, function(data){    	
			// 기존 목록을 지우고
			$("#mCardList").empty();
			
			// append
	        $("#mCardList").append(data);   	// 서버에서 카드 HTML 받아서 추가
	        
	        // 검색으로 찾은 영화 개수	// movieSearch.jsp에서 hidden으로 받아옴
	        total = $("#searchCount").val();
	        console.log(total);

	        $("div.mListHeader>span").text(total + "개의 영화가 검색되었습니다");
	        
	        if(total > contentAmount) {
				$("#pageLoader").show();
			} else {
				$("#pageLoader").hide();
			}
	    });	
	}
	
	 // 엔터를 누르거나 돋보기 버튼 클릭 시 검색
	$("#movieSearch").on("keydown", function(e) {
		if (e.key === "Enter" || e.keyCode === 13) {
		    searchMovies();
		    }
		});
	
	$("#btnMovieSearch").on("click", searchMovies);
	
	// 더보기버튼 클릭 시
	$("#pageLoader").click(function(){
		if(total <= appendAmount){
			return;
		}	
		
		// 검색어가 있다면
		if(currentKeyword){
			$.get("./movie/movieSearchAppend.jsp", { keyword: currentKeyword, contentAmount: contentAmount, appendAmount: appendAmount}, function(data) {
				$("#mCardList").append(data);
				contentAmount += appendAmount;
				
				if(contentAmount >= total) {
					$("#pageLoader").hide();
				}
			});
		} else {	// 없다면
		    $.get("movie/movieListAppend.jsp", { contentAmount, appendAmount }, function(data){
				//console.log(data);
		    	
		        $("#mCardList").append(data);   	// 서버에서 카드 HTML 받아서 추가		// div 조절필ㅇㅅ
		        contentAmount += appendAmount;
		        
		        if (contentAmount >= total) {
		            $("#pageLoader").hide();        // 더이상 없으면 버튼 숨김
		        }
		    });
		}
		
		
	});
	
</script>
</html>
