<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@page import="java.security.Principal"%>
<%@page import="waffle.windows.auth.WindowsAccount"%>
<%@page import="waffle.servlet.WindowsPrincipal"%>
<%@page import="com.sun.jna.platform.win32.Secur32"%>
<%@page import="com.sun.jna.platform.win32.Secur32Util"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/bootstrap-theme.min.css">
<script src="js/jquery-1.11.1.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Inventory Management System</title>
	<style type="text/css">
		.account-wall {
			margin-top: 20px;
		    padding: 40px 0px 20px 0px;
		    background-color: #f7f7f7;
		    -moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
		    -webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
		    box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);		}
	</style>

</head>
<body>
	<%-- Your user id is <b><%=request.getRemoteUser()%></b>. --%>
<%-- 	<form action="authenticate">
		<input type='hidden' name='username' value="<%=request.getRemoteUser()%>" />
		<input type="submit" value="Submit" />
	</form> --%>
		<div class="container">
		<div class="row">
			<h1 class="text-center login-title">IDeaS Inventory Management System</h1>
			<div class="col-sm-6 col-md-4 col-md-offset-4">
				
				<div class="account-wall" style="text-align:center">
					<img class="profile-img" src="https://lh5.googleusercontent.com/-b0-k99FZlyE/AAAAAAAAAAI/AAAAAAAAAAA/eu7opA4byxI/photo.jpg?sz=120" alt="">
					<form class="form-signin" id="signIn" action="authenticate">
						<input type='hidden' name='username' value="<%=request.getRemoteUser()%>" />
						<br><button class="btn btn-lg btn-primary btn-block" type="submit">Proceed to IMS</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>