<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
			request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<title>CRM登录</title>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {


			if (window.top != window) {
				window.top.location=window.location;
			}
			$("#loginAct").focus();
			/*$("#loginAct").val("");*/
			$("#submitBtn").click(login);
			$(window).keydown(fun);

		})
		function login() {

		  var loginAct = $.trim($("#loginAct").val());
		  var loginPwd = $.trim($("#loginPwd").val());


			if (loginAct == "" || loginPwd == "") {
				$("#msg").html("账号密码不能为空");
				return false;
			}


			$.ajax({
				url : "crm/user/login.do",
				data : {
					"loginAct":loginAct,
					"loginPwd":loginPwd
				},
				type : "post",
				dataType : "json",
				success : function (data) {
					if (data) {
						window.location.href = "workbench/index.jsp";
					} else {
						$("#msg").html("账号或密码错误");
					}
				}

			})

		}

		function fun(event) {
			//alert("msg");
          if (event.keyCode==13){
			  login();
		  }
		}



		function change() {
			//alert("change")
			var type = $("#loginPwd").attr("type");
			if (type == "text") {
				//attr：设置或返回被选元素的属性值。
				$("#loginPwd").attr("type", "password");

				//toggleClass：如果存在（不存在）就删除（添加）一个类。
				$("#passwordeye").toggleClass("glyphicon-eye-open");
				$("#passwordeye").toggleClass("glyphicon-eye-close");
			} else {
				$("#loginPwd").attr("type", "text");
				$("#passwordeye").toggleClass("glyphicon-eye-open");
				$("#passwordeye").toggleClass("glyphicon-eye-close");
				$("#passwordeye").toggle()
			}

		}



		function clean() {
			//alert("clean")
		 $("#loginAct").val("");
	     $("#loginAct").focus();
		}


	</script>


<style>
	.form-control-feedback-my {
		position: absolute;
		top: 0;
		right: 0;
		z-index: 2;
		display: block;
		width: 34px;
		height: 34px;
		line-height: 34px;
		text-align: center;
		pointer-events: auto;
		cursor:pointer;
	}
</style>


</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div class="input-group form-group" style="width: 350px;">
						<span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
						<input class="form-control" id="loginAct" type="text" placeholder="用户名"/>
						<span onclick="clean()" class="glyphicon glyphicon-remove-circle form-control-feedback-my" style="padding:7px;font-size: 15px;"></span>
					</div>
					<div class="input-group form-group" style="width: 350px; position: relative;top: 20px;">
						<span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
						<input class="form-control" id="loginPwd" type="password" placeholder="密码"/>
					    <span onclick="change()" id="passwordeye" class="glyphicon glyphicon-eye-close form-control-feedback-my" style="padding:5px;font-size: 18px;"></span>
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

							<span id="msg" style="color: red"></span>

					</div>
					<button id="submitBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录321</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>