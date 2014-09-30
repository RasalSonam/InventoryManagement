<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="testPackage.Item"%>
<%@ page import="testPackage.Request"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	List<Request> requests = (List<Request>) request.getAttribute("requests");
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<title>Inventory List</title>
	<script type="text/javascript">
		var $previousBtn = null;
		function getNameInModal(element,action){
			var requestModal = $("#approveRequestDialog");
			var itemName = $(element).closest("tr").find("td.name").html();
			var requestedOn = $(element).closest("tr").find("td.requestedDate").html();
			var empID = $(element).closest("tr").find("td.employeeId").html();
			var itemQuantity = $(element).closest("tr").find("td.quantity").html();
			document.getElementsByName('name')[0].value = itemName;
			document.getElementsByName('quantity')[0].value = itemQuantity;
			document.getElementsByName('requestedOn')[0].value = requestedOn;
			document.getElementsByName('empId')[0].value = empID;
			document.getElementsByName('action')[0].value = action;
			$.ajax({
            	type: "POST",
            	dataType: "json",
        		url: "http://localhost:8080/InventoryManagement/requests",
        		data: $('#requestForm').serialize(),
             	success: function(msg){
             		 if(msg === true) {
             			refreshPage();
            		 } else {
            			 $("#resultContainer").html("<div class='alert alert-danger'>Request could not be approved. Try again later.</div>");
            			 requestModal.modal('show');
            		 }
                 },
        		error: function(){
       			  $("#resultContainer").html("<div class='alert alert-danger'>Server Error. Request could not be approved, please try again later</div>");
       				requestModal.modal('show');
            	}
           });
			
			
		}
		function makeVisible(element){
			console.log(element);
			var $element = $(element);
			if($previousBtn == null){
				$previousBtn = $element.parent().parent().find('button');
			}else{
				$previousBtn.css("visibility","hidden");
			}
			$previousBtn = $element.parent().parent().find('button');
			$previousBtn.css("visibility","visible");
			console.log($element.parent().parent().find('button'));
//			document.getElementById('approveRequest').style.visibility = 'visible';
		}
		
		function refreshPage(){
			window.location.reload();
		}
	</script>
</head>
<body>
  	<div id="approveRequestDialog" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<div id="resultContainer"></div>
				</div>
				<div class="modal-body">
					<form id="requestForm" method="post">
						<div class= "resultContainer"></div>
					  <div class="form-group">
					    <input type="hidden" class="form-control" name="user" value="employee">
					  </div>
					  <div class="form-group">
					    <input type="hidden" class="form-control" id="itemName" name="name" readonly="readonly">
					  </div>
					  <div class="form-group">
					    <input type="hidden" class="form-control" id="requestedOn" name="requestedOn">
					  </div>
					  <div class="form-group">
					  	<input type="hidden" class="form-control" id="empId" name="empId">
					  </div>
 					  <div class="form-group">
					  	<input type="hidden" class="form-control" id="action" name="action" >
					  </div>
					  <div class="form-group">
					  	<input type="hidden" class="form-control" id="itemQuantity" name="quantity" >
					  </div>
					</form>					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
	<table class="table table-striped">
		<tr>
			<th></th>
			<th>Requested On</th>
			<th>Employee ID</th>
			<th>Item Name</th>
			<th>Requested Quantity</th>
			<th></th>
		</tr>
		<c:forEach var="element" items="${requests}" varStatus="status" >
			<tr>
				<td><input type="radio" name="request" onclick="makeVisible(this)"></td>
				<td class="requestedDate"><c:out value="${element.getRequestedDateTime()}" /></td>
				<td class="employeeId"><c:out value="${element.empId}" /></td>
				<td class="name"><c:out value="${element.item.getName()}" /></td>
				<td class="quantity"><c:out value="${element.item.getQuantity()}" /></td>
				<td><button type="submit" class="btn btn-success btn-mini"  style="visibility:hidden;" onclick="getNameInModal(this,'approveRequest')">Approve</button>
				<button type = "submit" class = "btn btn-danger btn-mini" style="visibility:hidden;" onclick="getNameInModal(this,'rejectRequest')">Reject</button></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>