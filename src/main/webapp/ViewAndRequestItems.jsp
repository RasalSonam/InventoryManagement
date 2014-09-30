<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Date" %>
<%@ page import="testPackage.Item"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	List<Item> itemList = (List<Item>) request.getAttribute("itemList");
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<script src="js/jquery-1.11.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<title>Inventory List</title>
	<script type="text/javascript">
	$( document ).ready(function() {
	    
	});
	var $previousBtn = null;
		function getNameAndShowModal(element){
			var requestModal = $("#placeRequestDialog");
			var itemName = $(element).closest("tr").find("td.name").html();
			var itemQuantity = $(element).closest("tr").find("td.quantity").html();
			if(itemQuantity > 0){
				document.getElementsByName('name')[0].value = itemName;
				requestModal.modal('show');
			}
			else
				refreshPage();
		}
		
		function makeVisible(element){
			var $element = $(element);
			var itemQuantity = $(element).closest("tr").find("td.quantity").html();
			
			if($previousBtn == null){
				$previousBtn = $element.parent().parent().find('button');
			}else{
				$previousBtn.css("visibility","hidden");
			}
			$previousBtn = $element.parent().parent().find('button');
			if(itemQuantity  == 0){
				$previousBtn.css("visibility","hidden");
			}else{
			$previousBtn.css("visibility","visible");
			console.log($element.parent().parent().find('button'));
			}
		}

		function validateInput(){
			invalidQuantity.style.display='none';
			if(isNaN(requestForm.itemQuantity.value) == true || requestForm.itemQuantity.value <= 0){
				invalidQuantity.style.display='block';
				return false;
			}
			$.ajax({
            	type: "POST",
            	dataType: "json",
        		url: "http://localhost:8080/InventoryManagement/requests",
        		data: $('#requestForm').serialize(),
              	success: function(msg){
             		 if(msg === true) {
	                     $("#resultContainer").html("<div class='alert alert-success'>Request sent successfully</div>");
            		 } else {
            			 $("#resultContainer").html("<div class='alert alert-danger'>Requested quantity unavailable</div>");
            		 }
                 },
        		error: function(){
       			  $("#resultContainer").html("<div class='alert alert-danger'>Server Error. Request could not be placed, please try again later</div>");
            	}
            });
		}
		
		function refreshPage(){
			window.location.reload();
		}
	</script>
</head>
<body>
  	<div id="placeRequestDialog" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<div id="resultContainer"></div>
					<div class="alert alert-danger" id="invalidQuantity" style="display:none">
					    <strong>Error!</strong> Quantity should be a natural number
					</div>
				</div>
				<div class="modal-body">
					<form id="requestForm" method="post">
					  <div class="form-group">
					    <input type="hidden" class="form-control" name="user" value="employee">
					  </div>
					  <div class="form-group">
					    <label>Item name</label>
					    <input type="text" class="form-control" id="itemName" name="name" readonly="readonly">
					  </div>
					  <div class="form-group">
					    <label>Quantity</label>
					    <input type="text" class="form-control" id="itemQuantity" name="quantity">
					  </div>
					  <div class="form-group">
					  	<label>Employee ID</label>
					  	<input type="text" class="form-control" id="empId" name="empId" value="<%=request.getAttribute("employeeId")%>">
					  </div>
 					  <div class="form-group">
					  	<input type="hidden" class="form-control" id="requestedOn" name="requestedOn" value="<%=new Date()%>">
					  </div>
 					  <div class="form-group">
					  	<input type="hidden" class="form-control" id="action" name="action" value="placeRequest">
					  </div>
					</form>					
				</div>
				<div class="modal-footer">
					<button id="addItem" type="submit" class="btn btn-primary" onclick="validateInput()">Place Request</button>
					<button type="button" class="btn btn-default" data-dismiss="modal" onclick="refreshPage()">Close</button>
				</div>
			</div>
		</div>
	</div>
	<table class="table table-striped">
		<tr>
			<th></th>
			<th>Sr. No</th>
			<th>Item Name</th>
			<th>Quantity</th>
			<th></th>
		</tr>
		<c:forEach var="element" items="${itemList}" varStatus="status">
			<tr class="${(element.quantity == element.threshold) ? 'danger' :''}">
				<td><input type="radio" name="choice" onclick="makeVisible(this)" ></td>
				<td><c:out value="${status.index + 1}" /></td>
				<td class="name"><c:out value="${element.name}" /></td>
				<td class="quantity"><c:out value="${element.quantity}" /></td>
				<td><button type="submit" class="btn btn-primary btn-mini" style="visibility: hidden;" onclick="getNameAndShowModal(this)">Request</button></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>