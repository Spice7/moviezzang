// 경로: src/data/api/YouTube.java
package data.api;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class YouTube {
//	AIzaSyDyIMSjfrxbhv_x8ZDWkN2e24BnGxMUuZ4 #손영덕 메인키
//	AIzaSyAg-aITfIzaj_p1X9zGo779nFMNTN_z85o #팀장님 서브키
    private final String apiKey = "AIzaSyBTSEtxwOZLcgffjhBUAGVUqMTU4OYmpls";

    public YouTube() {
        // 기본 생성자
    }

    public String getTrailerVideoId(String query) {
        try {
            String encodedQuery = URLEncoder.encode(query + "trailer", "UTF-8");
            String urlStr = "https://www.googleapis.com/youtube/v3/search"
                    + "?part=snippet"
                    + "&maxResults=1"
                    + "&q=" + encodedQuery
                    + "&key=" + apiKey
                    + "&type=video";

            URL url = new URL(urlStr);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null)
                sb.append(line);
            br.close();

            JSONParser parser = new JSONParser();
            JSONObject response = (JSONObject) parser.parse(new StringReader (sb.toString()));
            JSONArray items = (JSONArray) response.get("items");

            if (!items.isEmpty()) {
                JSONObject firstItem = (JSONObject) items.get(0);
                JSONObject idObj = (JSONObject) firstItem.get("id");
                return (String) idObj.get("videoId");
            }

        } catch (Exception e) {
        	System.out.println("만료");
            //e.printStackTrace();
        }

        return null; // 에러 시 null
    }
}
