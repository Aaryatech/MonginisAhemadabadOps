<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer List</title>

<style type="text/css">
table {
	border-collapse: collapse;
	width: 100%;
}

th, td {
	text-align: left;
	padding: 2px;
	font-size: 10;
}

th {
	background-color: #EA3291;
	color: white;
}
</style>
</head>
<body onload="myFunction()">
	<h4 align="center">Customer List</h4>

	<table align="center" border="1" cellspacing="0" cellpadding="1"
		cellpadding="0" id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">

				<th style="text-align: center;">Sr.No.</th>
				<th style="text-align: center;">Customer Name</th>
				<th style="text-align: center;">Mobile no</th>
				<th style="text-align: center;">GST No.</th>
			</tr>
		</thead>

		<tbody>
		<tbody>
			<c:set var="mrpTotal" value="${0}" />
			<c:set var="advTotal" value="${0}" />

			<c:forEach items="${custList}" var="custList" varStatus="count">
				<tr>
					<td align="center"><c:out value="${count.index+1}" /></td>

					<td><c:out value="${custList.userName}" /></td>
					<td style="text-align: center;"><c:out
							value="${custList.userPhone}" /></td>
					<td>${custList.userGstNo}</td>


				</tr>
			</c:forEach>

		</tbody>
	</table>


</body>
</html>