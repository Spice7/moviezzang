<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<title>회원가입</title>
<%
    String root=request.getContextPath();
    String loginok=(String)session.getAttribute("loginok");

    System.out.println(loginok);
    
    //로그인 했을 경우 회원가입 페이지로 이동 못하게
    if(loginok=="yes")
    {            
%>
    <script type="text/javascript">
    
        //history.back();
        location.href="<%=root%>/index.jsp";
    </script>
<%
}
%>
<script type="text/javascript">
	$(function () {
		
		//아이디 중복체크
		$("#idCheck").click(function () {
			var userid=$("#userid").val();
			//alert(userid);
			
			$.ajax({	
				type:"get",
				url:"member/signup/idCheck.jsp",
				dataType:"json",
				data:{"userid":userid},
				success: function(res){

					//console.log(res.idCheck);
					
					if(res.idCheck==1){
						alert("이미가입된 아이디입니다");
					}else{
						alert("가입가능한 아이디입니다");
					} 
				}	
			});
			
						
		});
		
		// 이름 유효성 검사 (한글/영어)
	    $("#name").on("input", function () {
	        var val = $(this).val();
	        var regex = /^[가-힣a-zA-Z\s]+$/;
	        if (!regex.test(val)) {
	            $("#nameMsg").text("이름은 한글 또는 영어만 입력 가능합니다.");
	        } else {
	            $("#nameMsg").text("");
	        }
	    });
		
		// 이메일선택이벤트
		$("#selecEmail").change(function () {
			
			if($(this).val()=='-') {
				$("#email2").val('');
			}			
			else{
				$("#email2").val($(this).val());
			}
			$("#emailMsg").text(""); // 이메일 메시지 제거 추가
		});
		
		// 이메일 유효성 검사 (email1 + email2 조합)
	    $("#email1, #email2").on("input", function () {
	        var email = $("#email1").val() + "@" + $("#email2").val();
	        var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?$/;
	        if (!regex.test(email)) {
	            $("#emailMsg").text("이메일 형식이 올바르지 않습니다.");
	        } else {
	            $("#emailMsg").text("");
	        }
	    });
		
	 // 전화번호 유효성 검사 (hp2 + hp3 조합)
	    $("#hp2, #hp3").on("input", function () {
	        var hp = $("#hp2").val() + "-" + $("#hp3").val();
	        var regex = /^\d{3,4}-\d{4}$/;
	        if (!regex.test(hp)) {
	            $("#hpMsg").text("연락처 형식이 올바르지 않습니다.");
	        } else {
	            $("#hpMsg").text("");
	        }
	    });
		
	});
		
	
	 function goFocus(hp){
		 if(hp.value.length==4)
			 frm.hp3.focus();
	 }
	 
	 
	
	function check(f) {
			
		// 비밀번호 체크
		if(f.password.value!=f.password2.value){
			alert("비밀번호가 서로 다릅니다");
				f.password.value="";
				f.password2.value="";
				return false;
			}
		
		// 아이디 한글,영문 정규식 검사
			 var nameRegex = /^[가-힣a-zA-Z\s]+$/;
			if (!nameRegex.test(f.name.value)) {
  			 alert("이름은 한글과 영어만 입력 가능합니다.");
  			 f.name.focus();
   			return false;
		};
		
		// 전화번호 정규식 검사
		 var hp2 = f.hp2.value;
			 var hp3 = f.hp3.value;
		if (!/^\d+$/.test(hp2) || !/^\d+$/.test(hp3)) {
 		  alert("전화번호는 숫자만 입력 가능합니다.");
   		return false;
			 };
			
		// 이메일 정규식 검사
		var email = f.email1.value + '@' + f.email2.value;
	    const regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(?:\.[a-zA-Z]{2,})?$/;

	    if (!regex.test(email)) {
	        alert("유효한 이메일 주소를 입력해주세요.");
	        f.email1.focus();
	        return false;
	    }

	    return true;
	}
	
</script>

<style type="text/css">
.wrap {
	width: 820px;
	margin: 0 auto;
	margin-top: 60px;
}

.wrap>form {
	display: flex;
	flex-direction: column;
}

.wrap>form .boxs{
	display: flex;
	flex-direction: row;
	margin-bottom: 30px;
	width: 700px;
	margin-left: 90px;
}

.wrap>form .email {
	height: 40px;
	position: relative;
}

.wrap>form .email>input.email2 {
	width: 140px;
	margin-right: 10px;
}

.wrap>form .email>span.at {
	line-height: 40px; 
	font-weight: bold; 
	margin: 0 5px;
}

.wrap>form .email>input {
	width: 200px;
}

.wrap>form .email>span.emailMsg {
	color:red; 
	font-size:12px;
	position: absolute;
	left: 140px;
	top: 45px; 
}

.wrap>form label {
	margin-right: 20px; 
	display:inline-block;
	text-align:left;
	width: 120px;
}

.wrap>form input {
	width: 350px;
}

.wrap>form .boxs>select {
	width: 150px;
}

.wrap>form button.regis {
	margin: 0 auto;
	width: 180px; 
	margin-bottom: 50px;
}

.wrap>form .gender {
	height:	20px; 
}

.wrap>form .gender input {
	width: 30px;
	height:	20px;
}

.wrap>form .addr input {
	margin-bottom: 10px;
}

.wrap>form .phone input {
	width: 130px;
}

.wrap>form .phone {
	position: relative;	
}

.wrap>form .phone>span.hpMsg {
	color:red; 
	font-size:12px;
	position: absolute;
	left: 140px;
	top: 45px; 
}

.wrap>form button{
	border: 1px solid #503396;
}

.wrap>form button:hover {
	background-color: #351f67;
	color: white;
}

i.dash {
	color: rgba(0, 0, 0, 1);
	line-height: 40px;
	margin: 0 10px;
}

.wrap>form button.check {
	margin-left: 5px;
}

.wrap>form .namebox {
	position: relative;
}

.wrap>form .nameMsg {
	color:red; 
	font-size:12px;
	position: absolute;
	left: 140px;
	top: 45px; 
}
</style>
<%
	String signupButtonStr = "가입하기";
	String adminChk = "";
		
	if (request.getParameter("adminChk") != null)
	{
		signupButtonStr = "추가하기";
		adminChk = "checked";
	}
	else
	{
		adminChk = "none";
	}
%>
</head>
<body>

<div class="wrap">

<form action="<%=root %>/member/signup/signupAction.jsp?adminChk=<%=adminChk%>" method="post" onsubmit="return check(this)" name="frm">
	
	<div class="boxs">
	<label for="id">아이디</label>
		<input type="text" name="userid" id="userid" class="form-control" required="required" placeholder="아이디를 입력해주세요">
	<button type="button" class="btn check" id="idCheck">중복확인</button>
	</div>
	
	<div class="boxs">
	<label for="password">비밀번호</label>
		<input type="password" name="password" id="password" class="form-control" required="required" placeholder="비밀번호를 입력해주세요">
	</div>
	
	<div class="boxs">
	<label for="password2">비밀번호확인</label>
		<input type="password" name="password2" id="password2" class="form-control" required="required" placeholder="비밀번호를 한번더 입력해주세요">
	</div>
	
	<div class="boxs namebox">
	<label for="name">이름</label>
		<input type="text" name="name" id="name" class="form-control" required="required" placeholder="이름을 입력해주세요">
		<span id="nameMsg" class="nameMsg"></span>
	</div>
	
	<div class="boxs">
	<label for="birth">생년월일</label>
		<input type="date" name="birth" id="birth" class="form-control" value="1990-01-01" required="required">
		<input type="hidden" name="age" id="age">
	</div>
	
	<div class="boxs gender">
	<label for="">성별</label>
		<input type="radio" name="gender" id="gender1" value="M">남
		<input type="radio" name="gender" id="gender2" value="F">여
	</div> 
	
	<div class="boxs addr">
	<label for="zipCode">주소</label>
    	<div class="col-sm-6 mb-3 mb-sm-0">
    		<input type="text" class="form-control form-control-user" id="zipCode" name="zipCode" placeholder="우편번호" readonly onclick="sample4_execDaumPostcode()">
    		<input type="text" class="form-control form-control-user" id="streetAdr" name="streetAdr" placeholder="도로명 주소" readonly>
    		<input type="text" class="form-control form-control-user" id="detailAdr" name="detailAdr" placeholder="상세 주소" onclick="addrCheck()">
    	</div>
    </div>
           
	<div class="boxs phone">
	<label for="hp2">휴대폰</label>		
	<select name="hp1" class="form-control">
		<option>02</option>
		<option>011</option>
		<option>010</option>
	</select>
		<i class="bi bi-dash-lg dash"></i>
		<input type="text" name="hp2" id="hp2" required="required" class="form-control" onkeyup="goFocus(this)">
		<i class="bi bi-dash-lg dash"></i>
		<input type="text" name="hp3" id="hp3" required="required" class="form-control">
		<span id="hpMsg" class="hpMsg"></span>
	</div>
	
	<div class="boxs email">
	<label for="email1">이메일</label>
		<input type="text" name="email1" id="email1" class="form-control" required="required" placeholder="이메일을 입력해주세요">
		<span class="at">@</span>
		<input type="text" name="email2" id="email2" class="form-control email2" required="required">
		<select id="selecEmail" class="form-control">
			<option value="-">직접입력</option>
			<option value="naver.com">naver.com</option>	
			<option value="gmail.com">gmail.com</option>	
			<option value="hanmail.net">hanmail.net</option>					
		</select>
		<span id="emailMsg" class="emailMsg"></span>
	</div>
	
		<button type="submit" class="btn regis" id="register"><%=signupButtonStr%></button>
		
</form>
</div>
<script>
    function sample4_execDaumPostcode(){
        new daum.Postcode({
            oncomplete: function(data) {
            	// 우편번호
                $("#zipCode").val(data.zonecode);
                // 도로명 및 지번주소
                $("#streetAdr").val(data.roadAddress);
            }
        }).open();
    }
</script>
<script type="text/javascript">
    function addrCheck() {
        if($("#zipCode").val() == '' && $("#streetAdr").val() == ''){
            alert("우편번호를 클릭하여 주소를 검색해주세요.");
            $("#zipCode").focus();
        }
    }
</script>

</body>

</html>