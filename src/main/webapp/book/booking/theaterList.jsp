<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="data.dao.TheaterDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    String movie_id = request.getParameter("movie_id");
    System.out.println("영화ID: " + movie_id);
    String region = request.getParameter("region");
    String screening_date = request.getParameter("screening_date");
    System.out.println("지역: " + region);
    TheaterDAO dao = TheaterDAO.getInstance();

    List<HashMap<String,String>> list = dao.getTheaterListWithReserve(movie_id,screening_date, region);
    JSONArray arr = new JSONArray();

    for(HashMap<String,String> map : list){
    	JSONObject ob = new JSONObject();
    	ob.put("theater_name", map.get("theater_name"));
    	ob.put("can_reserve",map.get("can_reserve"));
    	arr.add(ob);
    }
    %>
<%=arr.toString()%>