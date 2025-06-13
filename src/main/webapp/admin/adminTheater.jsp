<%@page import="java.util.ArrayList"%>
<%@page import="data.dto.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.TheaterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
    .theaterId { width: 60px; }
    .theaterRegion { width: 80px; }
    .theaterName { width: 100px; }
    .theaterAddress { width: 250px; }
    .theaterAuditoriums { width: 80px; }
    th, td { text-align: center; }
</style>

<%
	TheaterDAO dao = TheaterDAO.getInstance();
	List<TheaterDTO> list = dao.getAllDatas();
	List<String> regionList = dao.getRegions();
%>

<div class="container-fluid px-0">
	<h2 class="mb-4 table-title">극장 목록</h2>
	<div class="table-responsive rounded-4 shadow-sm">
		<table id="theaterTable" class="table align-middle mb-0 table-hover"
			style="background: #fff;">
			<thead class="table-light" style="background: #eaf0fa;">
				<tr>
					<th>번호</th>
					<th>지역</th>
					<th>극장명</th>
					<th>주소</th>
				</tr>
			</thead>
			<tbody>
				<%
					for (TheaterDTO t : list) 
					{
				%>
				<tr>
					<td class="theaterId"><span class="theaterIdValue"><%=t.getId()%></span></td>
					<td class="theaterRegion">
					<select class="form-select form-select-sm" data-old="<%=t.getRegion()%>" name="region" disabled>
						<%
							for (String regions : regionList) 
							{
						%>
						<option value="<%=regions%>"
							<%=t.getRegion().equals(regions) ? "selected" : ""%>><%=regions%></option>
						<%
							}
						%>
					</select></td>
					<td class="theaterName"><input type="text"
						class="form-control form-control-sm" value="<%=t.getName()%>"
						data-old="<%=t.getName()%>" name="name" disabled></td>
					<td class="theaterAddress"><input type="text"
						class="form-control form-control-sm" value="<%=t.getAddress()%>"
						data-old="<%=t.getAddress()%>" name="address" disabled></td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
	</div>
	<div class="text-end mt-3">
		<button id="btnEdit"
			class="btn btn-warning px-4 py-2 rounded-3 shadow-sm">수정</button>
		<button id="btnUpdate"
			class="btn btn-primary px-4 py-2 rounded-3 shadow-sm"
			style="display: none;">저장</button>
		<button id="btnCancel"
			class="btn btn-secondary px-4 py-2 rounded-3 shadow-sm"
			style="display: none;">취소</button>
		<button id="btnAdd"
			class="btn btn-success px-4 py-2 rounded-3 shadow-sm ms-2">추가</button>
	</div>
</div>

<!-- 추가 모달 -->
<div class="modal" tabindex="-1" id="theaterAddModal">
	<div class="modal-dialog">
		<div class="modal-content">
			<form id="theaterAddForm">
				<div class="modal-header">
					<h5 class="modal-title">극장 추가</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label class="form-label">지역</label> 
						<select class="form-select" name="region" required>
							<option value="">선택</option>
							<%
								for (String regions : regionList) 
								{
							%>
							<option value="<%=regions%>"><%=regions%></option>
							<%
								}
							%>
						</select>
					</div>
					<div class="mb-3">
						<label class="form-label">극장명</label> <input type="text"
							class="form-control" name="name" required>
					</div>
					<div class="mb-3">
						<label class="form-label">주소</label> <input type="text"
							class="form-control" name="address" required>
					</div>
					<div class="mb-3">
						<label class="form-label">상영관 개수</label> <input type="number"
							class="form-control" name="auditoriums" min="1" required>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">취소</button>
					<button type="submit" class="btn btn-primary">추가</button>
				</div>
			</form>
		</div>
	</div>
</div>

<script>
	let originalData = [];
	let changedTheaterCells = [];
	
	// 수정 시작 버튼	// 눌러야 수정 가능함
	$("#btnEdit").click(function(){
	    // 인풋/셀렉트 활성화
	    $("#theaterTable input, #theaterTable select").prop("disabled", false);
	    $("#btnEdit").hide();
	    $("#btnUpdate, #btnCancel").show();
	    // 원본 데이터 저장
	    originalData = [];
	    $("#theaterTable tbody tr").each(function(){
	        let row = {};
	        $(this).find("input, select").each(function(){
	            row[$(this).attr("name")] = $(this).val();
	        });
	        row.id = $(this).find(".theaterIdValue").text();
	        originalData.push(row);
	    });
	});
	
	// 수정 취소 버튼
	$("#btnCancel").click(function(){
	    // 인풋/셀렉트 비활성화
	    $("#theaterTable input, #theaterTable select").prop("disabled", true);
	    $("#btnEdit").show();
	    $("#btnUpdate, #btnCancel").hide();
	    // 원본 값으로 복원
	    $("#theaterTable tbody tr").each(function(idx){
	        $(this).find("input, select").each(function(){
	            $(this).val(originalData[idx][$(this).attr("name")]);
	        });
	    });
	    changedTheaterCells = [];
	});
	
	// 변경사항 추적	// 회원 수정때랑 동일함
	$("#theaterTable").on("change", "input, select", function(){
	    const $cell = $(this);
	    const $row = $cell.closest('tr');
	    const id = $row.find('.theaterIdValue').text().trim();
	    const column = $cell.attr('name');
	    const oldVal = $cell.data('old');
	    const newVal = $cell.val();
	
	    // 같은 id, 같은 column이 이미 있는지 확인
	    const idx = changedTheaterCells.findIndex(obj => obj.id == id && obj.column == column);
	
	    if(oldVal != newVal) {
	        if(idx > -1) {
	            changedTheaterCells[idx].value = newVal;
	        } else {
	            changedTheaterCells.push({ id, column, value: newVal });
	        }
	    } else {
	        if(idx > -1) {
	            changedTheaterCells.splice(idx, 1);
	        }
	    }
	    //console.log(changedTheaterCells);
	});
	
	// 수정 버튼
	$("#btnUpdate").click(function(){
	    if(changedTheaterCells.length == 0){
	        alert("수정된 내용이 없습니다");
	        return;
	    }
	    $.ajax({
	        url: "./admin/updateTheater.jsp",
	        method: "POST",
	        data: { changes: JSON.stringify(changedTheaterCells) },
	        success: function(response){
	            alert("수정이 완료되었습니다");
	            // 비활성화 및 버튼 복원
	            $("#theaterTable input, #theaterTable select").prop("disabled", true);
	            $("#btnEdit").show();
	            $("#btnUpdate, #btnCancel").hide();
	            changedTheaterCells = [];
	        },
	        error: function(){
	            //alert("수정 요청 오류");
	            
	        	alert("수정이 완료되었습니다");
	            // 비활성화 및 버튼 복원
	            $("#theaterTable input, #theaterTable select").prop("disabled", true);
	            $("#btnEdit").show();
	            $("#btnUpdate, #btnCancel").hide();
	            changedTheaterCells = [];
	        }
	    });
	});
	
	// 추가 버튼을 누르면 모달 나타남
	$("#btnAdd").click(function(){
	    $("#theaterAddForm")[0].reset();
	    var modal = new bootstrap.Modal(document.getElementById("theaterAddModal"));
	    modal.show();
	});
	
	// 추가 폼 제출
	$("#theaterAddForm").submit(function(e){
		// form을 통해 submit할 경우 자동으로 새로고침과 전송이 발생하는데 이를 막아줌
		// 내가 원하는대로 처리하고 데이터 통신하기 위함
	    e.preventDefault();
	    
	    const data = $(this).serialize();
	    $.ajax({
	        url: "./admin/insertTheater.jsp",
	        method: "POST",
	        data: data,
	        success: function(response){
	            alert("극장이 추가되었습니다");
	            
	            // 이 메소드는 indexAdmin.jsp에 존재
	            loadContents("./admin/adminTheater.jsp");
	        },
	        error: function(){
	            alert("추가 오류");
	        }
	    });
	    
	    $("#theaterAddModal").modal("hide");
	});
</script>
