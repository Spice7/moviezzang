package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import data.dto.ReservationDTO;
import data.dto.UserDTO;
import mysql.db.DBConnect;

public class UserDAO {
	
	
	DBConnect db=new DBConnect();
	
	public static UserDAO dao=new UserDAO();
	
	private UserDAO() {
		
	}
	
	public static UserDAO getInstance() {
		return dao;
	}
	
	//회원가입
	public void insertMember(UserDTO dto) {
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="insert into user(userid,password,name,gender,age,phone,address,email,birth,signup_at) values(?,?,?,?,?,?,?,?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getUserid());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getName());
			pstmt.setString(4, dto.getGender());
			pstmt.setInt(5, dto.getAge());
			pstmt.setString(6, dto.getPhone());
			pstmt.setString(7, dto.getAddress());
			pstmt.setString(8, dto.getEmail());
			pstmt.setString(9, dto.getBirth());
			
			
			pstmt.execute();
			
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//아이디체크
	public int idCheck(String userid) {
		
		int f=0;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from user where userid=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				f=rs.getInt(1);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
			
		}
		return f;
		
	}
	
	//update
	public void updateMember(UserDTO dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update user set password=?, name=?, gender=?, age=?, phone=?, address=?, email=?, birth=? where id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getPassword());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getGender());
			pstmt.setInt(4, dto.getAge());
			pstmt.setString(5, dto.getPhone());
			pstmt.setString(6, dto.getAddress());
			pstmt.setString(7, dto.getEmail());
			pstmt.setString(8, dto.getBirth());
			pstmt.setString(9, dto.getId());
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
		
	}
	
	// 관리자페이지에서 유저 정보 수정 중 전체를 update하는 것이 아니라 변경 사항이 있는 것만 업데이트
	// 프론트쪽 진행방식은 adminMember 참고
	public void updateMemberByColumns(int id, Map<String, String> colMap)
	{
		// 변경된 내용이 없다면 아무것도 안하고 return
		// 프론트쪽에도 안전장치 있음
		if(colMap == null || colMap.isEmpty())
		{
			return;	
		}
		
	    StringBuilder sql = new StringBuilder("UPDATE user SET ");
	    List<String> cols = new ArrayList<>();
	    List<Object> values = new ArrayList<>();	// Object타입인 것은 value의 자료형이 다양할 것을 고려
	    
	    // 전달받은 map에 따라 sql문을 작성해주는 코드
	    for(Map.Entry<String, String> entry : colMap.entrySet()) 
	    {
	        cols.add(entry.getKey() + "=?");
	        values.add(entry.getValue());
	    }
	    sql.append(String.join(", ", cols)).append(" WHERE id=?");
	    values.add(id);

	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    
	    try {
			pstmt = conn.prepareStatement(sql.toString());
			
			for (int i = 0; i < values.size(); i++)
			{
				pstmt.setObject(i + 1, values.get(i));
			}
			
			pstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//예매내역 리스트
	public List<HashMap<String, String>> getReserveList(String userid)
	{
		String sql="SELECT "
				+ "    res.id, "
				+ "    res.reserved_at, "
				+ "    m.title, "
				+ "    t.name, "
				+ "    s.start_time, "
				+ "    res.lastpay, "
				+ "    res.reserved_count, "
				+ "    GROUP_CONCAT(sr.seat_id ORDER BY sr.seat_id) AS seat_id "
				+ "FROM reservation res "
				+ "JOIN screening s ON res.screening_id = s.id "
				+ "JOIN movie m ON s.movie_id = m.id "
				+ "JOIN auditorium a ON s.auditorium_id = a.id "
				+ "JOIN theater t ON a.theater_id = t.id "
				+ "JOIN user u ON res.user_id = u.id "
				+ "LEFT JOIN seat_reserved sr ON res.id = sr.reservation_id "
				+ "WHERE u.userid =? AND res.booked = 'Y' "
				+ "GROUP BY res.id, res.reserved_at, m.title, t.name, s.start_time, s.price "
				+ "ORDER BY res.reserved_at DESC ";
		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				HashMap<String, String> map=new HashMap<String, String>();
				map.put("id", rs.getString("id"));
				map.put("reserved_at", rs.getString("reserved_at"));
				map.put("title", rs.getString("title"));
				map.put("name", rs.getString("name"));
				map.put("start_time", rs.getString("start_time"));
				map.put("lastpay", rs.getString("lastpay"));
				map.put("reserved_count", rs.getString("reserved_count"));
				map.put("seat_id", rs.getString("seat_id"));
				
				list.add(map);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
			
		}
		
		return list;
	}
	
	//예매취소내역 리스트
		public List<HashMap<String, String>> getCancelList(String userid)
		{
			String sql="SELECT "
					+ "    res.id, "
					+ "    res.reserved_at, "
					+ "    m.title, "
					+ "    t.name, "
					+ "    s.start_time, "
					+ "    res.lastpay, "
					+ "    res.reserved_count, "
					+ "    GROUP_CONCAT(sr.seat_id ORDER BY sr.seat_id) AS seat_id "
					+ "FROM reservation res "
					+ "JOIN screening s ON res.screening_id = s.id "
					+ "JOIN movie m ON s.movie_id = m.id "
					+ "JOIN auditorium a ON s.auditorium_id = a.id "
					+ "JOIN theater t ON a.theater_id = t.id "
					+ "JOIN user u ON res.user_id = u.id "
					+ "LEFT JOIN seat_reserved sr ON res.id = sr.reservation_id "
					+ "WHERE u.userid =? AND res.booked = 'N' "
					+ "GROUP BY res.id, res.reserved_at, m.title, t.name, s.start_time, s.price "
					+ "ORDER BY res.reserved_at DESC ";
			List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();
			
			Connection conn=db.getConnection();
			PreparedStatement pstmt=null;
			ResultSet rs=null;
			
			try {
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, userid);
				
				rs=pstmt.executeQuery();
				
				while(rs.next())
				{
					HashMap<String, String> map=new HashMap<String, String>();
					map.put("id", rs.getString("id"));
					map.put("reserved_at", rs.getString("reserved_at"));
					map.put("title", rs.getString("title"));
					map.put("name", rs.getString("name"));
					map.put("start_time", rs.getString("start_time"));
					map.put("lastpay", rs.getString("lastpay"));
					map.put("reserved_count", rs.getString("reserved_count"));
					map.put("seat_id", rs.getString("seat_id"));
					
					list.add(map);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				db.dbClose(rs, pstmt, conn);
				
			}
			
			return list;
		}
	
	//user시퀀스에 따른 dto
	public UserDTO getData(String id)
	{
		UserDTO dto=new UserDTO();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from user where id="+id;
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				dto.setId(rs.getString("id"));
				dto.setUserid(rs.getString("userid"));
				dto.setPassword(rs.getString("password"));
				dto.setName(rs.getString("name"));
				dto.setGender(rs.getString("gender"));
				dto.setAge(rs.getInt("age"));
				dto.setPhone(rs.getString("phone"));
				dto.setAddress(rs.getString("address"));
				dto.setMileage(rs.getInt("mileage"));
				dto.setUser_type(rs.getString("user_type"));
				dto.setSignup_at(rs.getTimestamp("signup_at"));
				dto.setEmail(rs.getString("email"));
				dto.setBirth(rs.getString("birth"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		
		return dto;
	}
	
	//user 삭제
	public void deleteMember(String id)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from user where id="+id;
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	// 유저 목록을 받아서 삭제 처리
	public void deleteMembersByIds(List<String> ids) 
	{
	    if(ids == null || ids.isEmpty())
	    {
	    	return;	
	    }
	    
	    StringBuilder sql = new StringBuilder("delete from user where id in (");
	    
	    for(int i = 0; i < ids.size(); i++) 
	    {
	        sql.append("?");
	        
	        if(i < ids.size()-1) 
	        {
	        	sql.append(",");
	        }
	    }
	    sql.append(")");
	    
	    Connection conn = db.getConnection();
	    PreparedStatement pstmt = null;
	    
	    try {
			pstmt = conn.prepareStatement(sql.toString());
			
			for(int i = 0; i < ids.size(); i++) 
			{
				pstmt.setString(i+1, ids.get(i));
	        }
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
  
	}
	
	//비밀번호체크
	public boolean EqualPass(String id,String password)
	{
		boolean b=false;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from user where id=? and password=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, password);
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				if(rs.getInt(1)==1)
					b=true;
			}
				
				
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return b;
	}
	
	//아이디,비밀번호 체크
	public boolean userIdCheck(String userid,String password)
	{
		boolean b=false;
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from user where userid=? and password=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			pstmt.setString(2, password);
			rs=pstmt.executeQuery();
			
			if(rs.next())
				b=true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return b;
	}
	
	//전체user List
	public List<UserDTO> getAllMembers()
	{
		List<UserDTO> list=new ArrayList<UserDTO>();
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from user order by id";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				UserDTO dto=new UserDTO();
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setUserid(rs.getString("userid"));
				dto.setPassword(rs.getString("password"));
				dto.setAge(rs.getInt("age"));
				dto.setAddress(rs.getString("address"));
				dto.setGender(rs.getString("gender"));
				dto.setEmail(rs.getString("email"));
				dto.setMileage(rs.getInt("mileage"));
				dto.setPhone(rs.getString("phone"));
				dto.setUser_type(rs.getString("user_type"));
				dto.setSignup_at(rs.getTimestamp("signup_at"));
				dto.setBirth(rs.getString("birth"));
				
				list.add(dto);
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		
		return list;
	}
	
	//userid로 id값 가져오기
	public String getId(String userid)
	{
		String id="";
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select id from user where userid=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				id=rs.getString("id");
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return id;
	}
	
	//예매취소
	public void deleteReserved(String id)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from reservation where id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//예매리스트 좌석수
	public void bookSeatCnt(String id){
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="select seat_id from seat_reserved where reservation_id="+id;
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	//예매 booked N으로 업데이트
	public void updateBookN(String id)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="update reservation set reserved_at=now(), booked='N' where id="+id;
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.execute();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	//무비스토리 리스트
	public List<HashMap<String, String>> getStoryList(String userid)
	{
		//String sql="SELECT DISTINCT "
		//		+ "    re.id, "
		//		+ "    re.created_at, "
		//		+ "    re.content, "
		//		+ "    re.rating, "
		//		+ "    m.title, "
		//		+ "    m.poster_url, "
		//		+ "    m.score, "
		//		+ "    s.start_time "
		//		+ "FROM "
		//		+ "    review re "
		//		+ "JOIN movie m ON re.movie_id = m.id "
		//		+ "JOIN user u ON re.user_id = u.id "
		//		+ "JOIN screening s ON s.movie_id = m.id "
		//		+ "JOIN reservation r ON r.screening_id = s.id AND r.user_id = u.id "
		//		+ "WHERE u.userid=? "
		//		+ "ORDER BY re.created_at DESC ";
		
		String sql = "SELECT re.id, re.created_at, re.content, re.rating, m.title, m.poster_url, m.score, (SELECT s.start_time FROM screening s JOIN reservation r ON r.screening_id = s.id WHERE s.movie_id = m.id AND r.user_id = u.id ORDER BY s.start_time DESC LIMIT 1) as start_time FROM review re JOIN movie m ON re.movie_id = m.id JOIN user u ON re.user_id = u.id WHERE u.userid=? ORDER BY re.created_at DESC";

		List<HashMap<String, String>> list=new ArrayList<HashMap<String,String>>();		
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				HashMap<String, String> map=new HashMap<String, String>();
				map.put("id", rs.getString("id"));
				map.put("created_at", rs.getString("created_at"));
				map.put("content", rs.getString("content"));
				map.put("rating", rs.getString("rating"));
				map.put("title", rs.getString("title"));
				map.put("poster_url", rs.getString("poster_url"));
				map.put("score", rs.getString("score"));
				map.put("start_time", rs.getString("start_time"));
				
				
				
				
				list.add(map);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
			
		}
		
		return list;
	}
	
	//userid로 usertype가져오기
	public String getUserType(String userid)
	{
		String usertype="";
		
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select user_type from user where userid=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				usertype=rs.getString("user_type");
			}
		}catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
			
		}
		
		return usertype;
	}
	
	//예매좌석 삭제
	public void deleteSeatReserve(String reservation_id)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql="delete from seat_reserved where reservation_id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, reservation_id);
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	// 결제 후 마일리지 추가
	public void updateMileage(int mileage, String id)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		
		String sql = "update user set mileage = mileage + ? where id = ?";
		
		try {
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, mileage);
			pstmt.setString(2, id);
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
}
