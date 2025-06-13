package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import data.dto.TheaterDTO;
import mysql.db.DBConnect;

public class TheaterDAO {
	DBConnect db = new DBConnect();
	private static TheaterDAO dao = new TheaterDAO();

	private TheaterDAO()
	{

	}

	public static TheaterDAO getInstance()
	{
		return dao;
	}

	// insert
	public void insertData()
	{
		System.out.println("저는 인서트에요");
	}

	// delete

	// 전체 데이터 조회
	public List<TheaterDTO> getAllDatas()
	{
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<TheaterDTO> list = new ArrayList<TheaterDTO>();

		String sql = "select * from theater order by id";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while(rs.next())
			{
				TheaterDTO dto = new TheaterDTO();

				dto.setId(rs.getString("id"));
				dto.setRegion(rs.getString("region"));
				dto.setName(rs.getString("name"));
				dto.setAddress(rs.getString("address"));

				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;
	}

	// 지역 정보 출력
	public List<String> getRegions()
	{
		Connection conn = db.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<String> list = new ArrayList<String>();

		String sql = "select distinct region FROM theater ORDER BY FIELD(region, '서울', '경기', '인천', '대전/충청/세종', '부산/대구/경상', '광주/전라', '강원', '제주')";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while(rs.next())
			{
				list.add(rs.getString(1));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;
	}

	// 전체 극장 정보를 지역별로 매핑해서 출력
	public Map<String, List<TheaterDTO>> getTheaterMapByRegion()
	{
	    Map<String, List<TheaterDTO>> map = new LinkedHashMap<>(); // 순서유지
	    												// 처음에 DB에 넣을 때 서울 제주 이렇게 넣어서 순서 조정을 위한 코드
	    String sql = "SELECT * FROM theater ORDER BY FIELD(region, '서울', '경기', '인천', '대전/충청/세종', '부산/대구/경상', '광주/전라', '강원', '제주'), name";
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        while (rs.next())
	        {
	            String region = rs.getString("region");

	            TheaterDTO dto = new TheaterDTO(); // rs로부터 값 세팅
	            dto.setId(rs.getString("id"));
	            dto.setRegion(region);
	            dto.setName(rs.getString("name"));
	            dto.setAddress(rs.getString("address"));

	            // 만약 map의 key중 특정 region이 비어있다면 위에서 구한 region을 넣어주고 이미 있다면 그 key를 사용
	            map.computeIfAbsent(region, k -> new ArrayList<>()).add(dto);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return map;
	}

	//지역에서 상영하는 극장정보 조회
	public List<HashMap<String, String>> getTheaterListWithReserve(String movie_id, String selectDate, String region) {
	    List<HashMap<String, String>> list = new ArrayList<>();
	    Connection conn = db.getConnection();
	    PreparedStatement pst = null;
	    ResultSet rs = null;
	    String sql = "SELECT t.name AS theater_name, " +
	                 "CASE WHEN COUNT(s.id) > 0 THEN 1 ELSE 0 END AS can_reserve " +
	                 "FROM theater t " +
	                 "LEFT JOIN auditorium a ON a.theater_id = t.id " +
	                 "LEFT JOIN screening s ON s.auditorium_id = a.id AND s.movie_id = ? AND DATE(s.start_time) = ? " +
	                 "WHERE t.region = ? " +
	                 "GROUP BY t.id";
	    try {
	        pst = conn.prepareStatement(sql);
	        pst.setString(1, movie_id);
	        pst.setString(2, selectDate);
	        pst.setString(3, region);
	        rs = pst.executeQuery();
	        while(rs.next()) {
	            HashMap<String, String> map = new HashMap<>();
	            map.put("theater_name", rs.getString("theater_name"));
	            map.put("can_reserve", rs.getString("can_reserve"));
	            list.add(map);
	        }
	    } catch (SQLException e) { e.printStackTrace(); }
	    finally { db.dbClose(rs, pst, conn); }
	    return list;
	}
}
