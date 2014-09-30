<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<%@ page import="java.util.List"%>
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
	var $previousBtn = null;

	function getNameAndShowModal(element) {
		debugger;
		var requestModal = $("#updateItem");
		var itemName = $(element).closest("tr").find("td.name").html();
		var itemQuantity = $(element).closest("tr").find("td.quantity").html();
		var itemThreshold = $(element).closest("tr").find("td.threshold")
				.html();
		document.getElementsByName('oldName')[0].value = itemName;
		document.getElementsByName('nameUpdate')[0].value = itemName;
		document.getElementsByName('quantityUpdate')[0].value = itemQuantity;
		document.getElementsByName('thresholdUpdate')[0].value = itemThreshold;
		requestModal.modal('show');

	}
	function makeVisible(element) {
		var $element = $(element);
		var itemQuantity = $(element).closest("tr").find("td.quantity").html();

		if ($previousBtn == null) {
			$previousBtn = $element.parent().parent().find('button');
		} else {
			$previousBtn.css("visibility", "hidden");
		}
		$previousBtn = $element.parent().parent().find('button');
		if (itemQuantity == 0) {
			$previousBtn.css("visibility", "hidden");
		} else {
			$previousBtn.css("visibility", "visible");
			console.log($element.parent().parent().find('button'));
		}
	}

	function validateInput() {
		debugger;
		noItemName.style.display = 'none';
		invalidQuantity.style.display = 'none';
		invalidThreshold.style.display ='none';
		if (!itemForm.itemName.value) {
			noItemName.style.display = 'block';
			invalidQuantity.style.display = 'none';
			invalidThreshold.style.display ='none';
			return false;
		}
		if (isNaN(itemForm.itemQuantity.value) == true || itemForm.itemQuantity.value <= 0) {
			noItemName.style.display = 'none';
			invalidQuantity.style.display = 'block';
			invalidThreshold.style.display ='none';
			return false;
		}
		
		if(isNaN(itemForm.itemThreshold.value) == true || itemForm.itemThreshold.value < 0){
			noItemName.style.display = 'none';
			invalidQuantity.style.display = 'none';
			invalidThreshold.style.display ='block';
			return false;
		}

		$
				.ajax({
					type : "POST",
					dataType : "json",
					url : "http://localhost:8080/InventoryManagement/items",
					data : $('#itemForm').serialize(),
					success : function(msg) {
						if (msg === true) {
							$("#resultContainer")
									.html(
											"<div class='alert alert-success'>Item added successfully</div>");
						} else {
							$("#resultContainer")
									.html(
											"<div class='alert alert-danger'>Item already exists in inventory</div>");
						}
					},
					error : function() {
						$("#resultContainer")
								.html(
										"<div class='alert alert-danger'>Server Error. Item not added, please try again later</div>");
					}
				});
	}
	
	function validateAndSubmitUpdateForm() {
		debugger;
		noItemNameUpdate.style.display = 'none';
		invalidQuantityUpdate.style.display = 'none';
		if (!updateForm.itemNameUpdate.value) {
			noItemNameUpdate.style.display = 'block';
			return false;
		}
		if (isNaN(updateForm.itemQuantityUpdate.value) == true
				|| updateForm.itemQuantityUpdate.value <= 0) {
			noItemNameUpdate.style.display = 'none';
			invalidQuantityUpdate.style.display = 'block';
			return false;
		}

		$
				.ajax({
					type : "POST",
					dataType : "json",
					url : "http://localhost:8080/InventoryManagement/items",
					data : $('#updateForm').serialize(),
					success : function(msg) {
						if (msg === true) {
							$("#resultContainer")
									.html(
											"<div class='alert alert-success'>Item added successfully</div>");
						} else {
							$("#resultContainer")
									.html(
											"<div class='alert alert-danger'>Item already exists in inventory</div>");
						}
					},
					error : function() {
						$("#resultContainer")
								.html(
										"<div class='alert alert-danger'>Server Error. Item not added, please try again later</div>");
					}
				});
	}

	function getLatestItems() {
		debugger;
		window.location.reload();
	}
</script>
</head>
<body>

	<div id="addItemDialog" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!-- <button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="color:red">X</button> -->
					<div id="resultContainer"></div>
					<div class="alert alert-danger" id="noItemName" style="display: none">
						<strong>Error!</strong> Item name cannot be blank
					</div>
					<div class="alert alert-danger" id="invalidQuantity" style="display: none">
						<strong>Error!</strong> Quantity should be a natural number
					</div>
					<div class="alert alert-danger" id="invalidThreshold" style="display: none">
						<strong>Error!</strong>Threshold should be a number
					</div>
				</div>
				<div class="modal-body">
					<form id="itemForm" method="post">
						<div class="form-group">
							<input type="hidden" class="form-control" name="user"
								value="admin">
						</div>
						<div class="form-group">
							<label for="itemName">Item name</label> <input type="text"
								class="form-control" id="itemName" name="name">
						</div>
						<div class="form-group">
							<label for="itemQuantity">Quantity</label> <input type="text"
								class="form-control" id="itemQuantity" name="quantity">
						</div>
						<div class="form-group">
							<label for="itemThreshold">Threshold</label> <input type="text"
								class="form-control" id="itemThreshold" name="threshold"
								value="0">
						</div>
						<div class="form-group">
					  	<input type="hidden" class="form-control" id="action" name="action" value="addItem">
					  </div>
					</form>
				</div>
				<div class="modal-footer">
					<button id="addItem" type="submit" class="btn btn-primary"
						onclick="validateInput()">Add to Inventory</button>
					<button type="button" class="btn btn-default" data-dismiss="modal"
						onclick="getLatestItems()">Close</button>
				</div>
			</div>
		</div>
	</div>

	<div id="updateItem" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<!-- <button type="button" class="close" data-dismiss="modal" aria-hidden="true" style="color:red">X</button> -->
					<div id="resultContainer"></div>
					<div class="alert alert-danger" id="noItemNameUpdate"
						style="display: none">
						<strong>Error!</strong> Item name cannot be blank
					</div>
					<div class="alert alert-danger" id="invalidQuantityUpdate"
						style="display: none">
						<strong>Error!</strong> Quantity should be a natural number
					</div>
				</div>
				<div class="modal-body">
					<form id="updateForm" method="post" >
						<div class="form-group">
							<input type="hidden" class="form-control" name="user"
								value="admin">
						</div>
						<div class="form-group">
							<input type="hidden"
								class="form-control" id="oldItemName" name="oldName" >
						</div>
						<div class="form-group">
							<label for="itemName">Item name</label> <input type="text"
								class="form-control" id="itemNameUpdate" name="nameUpdate" >
						</div>
						<div class="form-group">
							<label for="itemQuantity">Quantity</label> <input type="text"
								class="form-control" id="itemQuantityUpdate" name="quantityUpdate" >
						</div>
						<div class="form-group">
							<label for="itemThreshold">Threshold</label> <input type="text"
								class="form-control" id="itemThresholdUpdate" name="thresholdUpdate"
								value="0">
						</div>
						<div class="form-group">
					  	<input type="hidden" class="form-control" id="action" name="action" value="updateItem">
					  </div>
					</form>
				</div>
				<div class="modal-footer">
					<button id="updateItem" type="submit" class="btn btn-primary" onclick="validateAndSubmitUpdateForm()"
						>Update</button>
					<button type="button" class="btn btn-default" data-dismiss="modal"
						onclick="getLatestItems()">Close</button>
				</div>
			</div>
		</div>
	</div>


	<br />
	<a data-toggle="modal" data-backdrop="static" href="#addItemDialog"
		class="btn btn-large btn-success glyphicon glyphicon-plus-sign">Add</a>
	<a class="btn btn-primary"
		href="http://localhost:8080/InventoryManagement/requests">View
		Requests</a>
	<br />
	<br />
	<table class="table table-striped table-hover">
		<tr>
			<th></th>
			<th>Sr. No</th>
			<th>Item Name</th>
			<th>Quantity</th>
			<th>Threshold</th>
			<th></th>
		</tr>
		<c:forEach var="element" items="${itemList}" varStatus="status">
			<tr class="${(element.quantity == element.threshold) ? 'danger' :''}">
				<td><input type="radio" name="choice"
					onclick="makeVisible(this)"></td>
				<td><c:out value="${status.index + 1}" /></td>
				<td class="name"><c:out value="${element.name}" /></td>
				<td class="quantity"><c:out value="${element.quantity}" /></td>
				<td class="threshold"><c:out value="${element.threshold}" /></td>
				<td><button type="submit" class="btn btn-primary btn-mini"
						style="visibility: hidden;" onclick="getNameAndShowModal(this)">Update</button></td>
			</tr>
		</c:forEach>

	</table>
</body>
</html>