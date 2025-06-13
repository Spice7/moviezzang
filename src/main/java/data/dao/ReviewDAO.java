package data.dao;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import data.dto.ReviewDTO;
import mysql.db.DBConnect;

public class ReviewDAO {
	DBConnect db = new DBConnect();
	private static ReviewDAO dao = new ReviewDAO();
	
	private ReviewDAO() {
		
	}
	
	public static ReviewDAO getInstance() {
		return dao;
	}
	
	
	
	public int insertReview(ReviewDTO dto) {
	    String sql = "INSERT INTO review (id, movie_id, user_id, content, rating, created_at) VALUES (null, ?, ?, ?, ?, NOW())";

	    try (
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql)
	    ) {
	        pstmt.setString(1, dto.getMovieId());
	        pstmt.setString(2, dto.getUserId());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setInt(4, dto.getRating());
	        return pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return 0;
	}

	
	
	// 리뷰 목록 조회 메서드
	public List<ReviewDTO> getReviewsByMovieId(String movieId) {
	    List<ReviewDTO> list = new ArrayList<>();
	    String sql = "SELECT user_id, content, rating, DATE(created_at) AS created_at FROM review WHERE movie_id = ? ORDER BY created_at DESC";

	    try (
	        Connection conn = db.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql)
	    ) {
	        pstmt.setString(1, movieId);
	        try (ResultSet rs = pstmt.executeQuery()) {
	            while (rs.next()) {
	                ReviewDTO dto = new ReviewDTO();
	                dto.setUserId(rs.getString("user_id"));
	                dto.setContent(rs.getString("content"));
	                dto.setRating(rs.getInt("rating"));
	                dto.setCreatedAt(rs.getTimestamp("created_at"));
	                list.add(dto);
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return list;
	}
		
		//영화 시청여부
		public boolean hasWatchedMovie(String userId, String movieId) {
		    String sql = """
		        SELECT COUNT(*)
		        FROM reservation r
		        JOIN screening s ON r.screening_id = s.id
		        JOIN movie m ON s.movie_id = m.id
		        WHERE r.user_id = ?
		          AND s.movie_id = ?
		          AND r.booked = 'Y'
		          AND now() > (s.start_time + INTERVAL m.runtime MINUTE)
		        """;

		    try (
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = conn.prepareStatement(sql)
		    ) {
		        pstmt.setString(1, userId);
		        pstmt.setString(2, movieId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) {
		                return rs.getInt(1) > 0;
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }

		    return false;
		}
		//리뷰 중복작성방지  
		public boolean hasAlreadyReviewed(String userId, String movieId) {
		    String sql = "SELECT COUNT(*) FROM review WHERE user_id = ? AND movie_id = ?";

		    try (
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = conn.prepareStatement(sql)
		    ) {
		        pstmt.setString(1, userId);
		        pstmt.setString(2, movieId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) {
		                return rs.getInt(1) > 0;
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }

		    return false;
		}
		
		
		// 리뷰 수정  
		public int updateReview(ReviewDTO dto) {
		    String sql = "UPDATE review SET content = ?, rating = ? WHERE user_id = ? AND movie_id = ?";
		    try (
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = conn.prepareStatement(sql)
		    ) {
		        pstmt.setString(1, dto.getContent());
		        pstmt.setInt(2, dto.getRating());
		        pstmt.setString(3, dto.getUserId());
		        pstmt.setString(4, dto.getMovieId());
		        return pstmt.executeUpdate();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return 0;
		}
		// 리뷰 삭제 
		public int deleteReview(String userId, String movieId) {
		    String sql = "DELETE FROM review WHERE user_id = ? AND movie_id = ?";
		    try (
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = conn.prepareStatement(sql)
		    ) {
		        pstmt.setString(1, userId);
		        pstmt.setString(2, movieId);
		        return pstmt.executeUpdate();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return 0;
		}
		
		
		// 본인 작성확인용 
		public ReviewDTO getReviewByUser(String userId, String movieId) {
		    String sql = "SELECT * FROM review WHERE user_id = ? AND movie_id = ?";
		    try (
		        Connection conn = db.getConnection();
		        PreparedStatement pstmt = conn.prepareStatement(sql)
		    ) {
		        pstmt.setString(1, userId);
		        pstmt.setString(2, movieId);

		        try (ResultSet rs = pstmt.executeQuery()) {
		            if (rs.next()) {
		                ReviewDTO dto = new ReviewDTO();
		                dto.setUserId(rs.getString("user_id"));
		                dto.setMovieId(rs.getString("movie_id"));
		                dto.setContent(rs.getString("content"));
		                dto.setRating(rs.getInt("rating"));
		                dto.setCreatedAt(rs.getTimestamp("created_at"));
		                return dto;
		            }
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return null;
		}


	
}