package data.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
@SuppressWarnings("unchecked")

public class TMDBtest {
	private String apiKey = "API 키를 여기에 입력";							// API Key
	private Map<Long, String> genreMap = new HashMap<Long, String>();	// id는 숫자가 크지 않지만 json.simple은 number 타입을 long으로 변환한다

	// 생성할 때 장르 ID를 한글로 변환하여 ID<->한글장르명 으로 매핑
	public TMDBtest()
	{
		String urlStr = "https://api.themoviedb.org/3/genre/movie/list?api_key=" + apiKey + "&language=ko-KR";

		System.out.println(apiKey);

		URL url;
		try {
			url = new URL(urlStr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            br.close();

            JSONParser parser = new JSONParser();
            JSONObject resultObj = (JSONObject) parser.parse(new StringReader(sb.toString()));

            JSONArray genres = (JSONArray) resultObj.get("genres");
            for (Object obj : genres)
            {
                JSONObject genre = (JSONObject) obj;
                Long id = (Long) genre.get("id");
                String name = (String) genre.get("name");
                genreMap.put(id, name);
            }

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public JSONArray getMovieDatas()
	{
	    JSONArray movieList = new JSONArray();

	    try {
	        JSONParser parser = new JSONParser();

	        // 1페이지 결과 우선 출력
	        // 1페이지에 전체 페이지 개수 정보가 담겨있음
	        String urlStr = "https://api.themoviedb.org/3/movie/now_playing?api_key=" + apiKey +
	                "&language=ko-KR&region=KR&page=1";

	        // API 요청
	        URL url = new URL(urlStr);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");

	        // 받아온 API 데이터를 문자열로 변환
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = br.readLine()) != null)
	        {
	            sb.append(line);
	        }
	        br.close();

	        // JSONObject로 파싱
	        JSONObject resultObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
	        int totalPages = ((Long) resultObj.get("total_pages")).intValue();

	        // 1페이지 결과 추가
	        JSONArray results = (JSONArray) resultObj.get("results");

	        System.out.println(results.size());
	        for (Object obj : results)
	        {
	        	JSONObject movie = (JSONObject) obj;
	            JSONObject data = new JSONObject();

	            // 제목
	            data.put("title", movie.get("title"));

	            // 평점
	            data.put("vote_average", movie.get("vote_average"));

	            // 시놉시스
	            data.put("overview", movie.get("overview"));

	            // 상영시간	// 영화의 ID를 받아와서 영화의 개별정보로 다시 API를 받아와야한다고 한다...
	            //data.put("runtime", movie.get("runtime"));

	            // 장르(기본적으로 id만 제공)
	            JSONArray genreIds = (JSONArray) movie.get("genre_ids");

	            // 받아온 id를 한글명으로 변환
	            JSONArray genreNames = new JSONArray();
	            for (Object idObj : genreIds)
	            {
	                Long id = (Long) idObj;
	                String name = genreMap.get(id);
	                if (name != null) genreNames.add(name);
	            }

	            data.put("genres", genreNames);

	            // 포스터(사진)
	            data.put("poster", movie.get("poster_path"));

	            // JSONArray에 JSON 데이터 추가
	            movieList.add(data);
	        }

	        // 2페이지부터 totalPages까지 반복
	        // 과정은 1페이지와 같음
	        for (int page = 2; page <= totalPages; page++)
	        {
	            urlStr = "https://api.themoviedb.org/3/movie/now_playing?api_key=" + apiKey +
	                    "&language=ko-KR&region=KR&page=" + page;
	            url = new URL(urlStr);
	            conn = (HttpURLConnection) url.openConnection();
	            conn.setRequestMethod("GET");
	            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	            sb = new StringBuilder();
	            while ((line = br.readLine()) != null)
	            {
	                sb.append(line);
	            }
	            br.close();

	            resultObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
	            results = (JSONArray) resultObj.get("results");
	            for (Object obj : results) {
	            	JSONObject movie = (JSONObject) obj;
		            JSONObject data = new JSONObject();

		            // 제목
		            data.put("title", movie.get("title"));

		            // 평점
		            data.put("vote_average", movie.get("vote_average"));

		            // 시놉시스
		            data.put("overview", movie.get("overview"));

		            // 장르(기본적으로 id만 제공)
		            JSONArray genreIds = (JSONArray) movie.get("genre_ids");

		            // 받아온 id를 한글명으로 변환
		            JSONArray genreNames = new JSONArray();
		            for (Object idObj : genreIds)
		            {
		                Long id = (Long) idObj;
		                String name = genreMap.get(id);
		                if (name != null) genreNames.add(name);
		            }

		            data.put("genres", genreNames);

		            // 포스터(사진)
		            data.put("poster", movie.get("poster_path"));

		            movieList.add(data);

	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return movieList;
	}

}
