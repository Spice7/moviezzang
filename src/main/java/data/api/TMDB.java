package data.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
@SuppressWarnings("unchecked")

public class TMDB {
	private String apiKey = "API 키를 여기에 입력";			// API Key
	private Map<Long, String> genreMap = new HashMap<Long, String>();	// id는 숫자가 크지 않지만 json.simple은 number 타입을 long으로 변환한다

	// 생성할 때 장르 ID를 한글로 변환하여 ID<->한글장르명 으로 매핑
	public TMDB()
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

	// 추출한 영화 id를 통해 상세정보 API 호출
	private JSONObject getDetails(Long id)
	{
		// 상세정보 호출하는 API URL
		String detailUrl = "https://api.themoviedb.org/3/movie/" + id + "?api_key=" + apiKey + "&language=ko-KR";
	    URL url;
	    JSONObject resultObj = null;
	    
		try {
			url = new URL(detailUrl);
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
            resultObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
			   
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return resultObj;
	}
	
	// 관람등급 추출	// 얘만 또 다른 API에 있다고 한다..
	private String getCertification(Long id) 
	{
	    String urlStr = "https://api.themoviedb.org/3/movie/" + id + "/release_dates?api_key=" + apiKey;
	    
	    try {
	    	// results로 JSONArray 형태로 받아오는 부분까진 다 동일하다
	        URL url = new URL(urlStr);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("GET");
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
	        StringBuilder sb = new StringBuilder();
	        String line;
	        while ((line = br.readLine()) != null) sb.append(line);
	        br.close();

	        JSONParser parser = new JSONParser();
	        JSONObject resultObj = (JSONObject) parser.parse(new StringReader(sb.toString()));
	        JSONArray results = (JSONArray) resultObj.get("results");
	        
	        // 관람등급 추출
	        for (Object countryObj : results) 
	        {
	            JSONObject country = (JSONObject) countryObj;
	            
	            // 한국에 등록된 정보만 추출
	            if ("KR".equals(country.get("iso_3166_1"))) 
	            {
	            	// release_dates라고 하는 json에 여러 데이터 존재
	                JSONArray releaseDates = (JSONArray) country.get("release_dates");
	                	         
	                // 그 중 관람등급(certification)
	                if (releaseDates.size() > 0) 
	                {
	                    JSONObject certObj = (JSONObject) releaseDates.get(0);
	                    
	                    // 추출한 문자열을 반환한다
	                    return (String) certObj.get("certification");
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    // 위 과정을 통해 추출한 문자열이 없다면 null 반환
	    return null;
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

	            // 영화 id
	            data.put("id", movie.get("id"));
	            
	            // 제목
	            data.put("title", movie.get("title"));

	            // 시놉시스
	            data.put("overview", movie.get("overview"));

	            // 평점
	            data.put("score", movie.get("vote_average"));   
	            
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

	            //-----------------여기서부터 상세정보-------------------
	            // 영화 id를 통해서 각 영화의 상세정보도 받아와야한다
	            JSONObject movieDetails = this.getDetails((Long)movie.get("id"));
	            
	            // 런타임
	            data.put("runtime", movieDetails.get("runtime"));
	            
	            // 개봉일
	            data.put("release_date", movieDetails.get("release_date"));
	            
	            // 제작사/배급사
	            JSONArray companies = (JSONArray) movieDetails.get("production_companies");
	            
	            // 여러개가 나오면 첫번째 요소만 데이터에 추가
	            if (companies.size() > 0) 
	            {
	                JSONObject firstCompany = (JSONObject) companies.get(0);
	                data.put("studio", firstCompany.get("name")); // 첫 제작사/배급사
	            }
	            	            
	            // 관람등급
	            data.put("certification", this.getCertification((Long)movie.get("id")));
	            
	            // JSONArray에 JSON 데이터 추가
	            movieList.add(data);                
	            
	            // API 호출제한
	            Thread.sleep(50);
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

		            // 영화 id
		            data.put("id", movie.get("id"));
		            
		            // 제목
		            data.put("title", movie.get("title"));
		            
		            // 시놉시스
		            data.put("overview", movie.get("overview"));

		            // 평점
		            data.put("score", movie.get("vote_average"));


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

		            //-----------------여기서부터 상세정보-------------------
		            // 영화 id를 통해서 각 영화의 상세정보도 받아와야한다
		            JSONObject movieDetails = this.getDetails((Long)movie.get("id"));
		            
		            // 런타임
		            data.put("runtime", movieDetails.get("runtime"));
		            
		            // 개봉일
		            data.put("release_date", movieDetails.get("release_date"));
		            
		            // 제작사/배급사
		            JSONArray companies = (JSONArray) movieDetails.get("production_companies");
		            
		            // 여러개가 나오면 첫번째 요소만 데이터에 추가
		            if (companies.size() > 0) 
		            {
		                JSONObject firstCompany = (JSONObject) companies.get(0);
		                data.put("studio", firstCompany.get("name")); // 첫 제작사/배급사
		            }
		            		   
		            // 관람등급
		            data.put("certification", this.getCertification((Long)movie.get("id")));
		            
		            movieList.add(data);

		            // API 호출제한
		            Thread.sleep(50);
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return movieList;
	}

}
