<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sp Advance Report</title>

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
	<h4 align="center">Sp Advance Report</h4>
	<div align="center">
		<h6>${frName}&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;${fromDate}
			&nbsp;To &nbsp; ${toDate}</h6>
	</div>
	<table align="center" border="1" cellspacing="0" cellpadding="1"
		cellpadding="0" id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">

				<th style="text-align: center;">Sr.No.</th>
				<th style="text-align: center;">Customer Name</th>
				<th style="text-align: center;">Mobile no</th>
				<th style="text-align: center;">Item Name</th>
				<th style="text-align: center;">Flavour</th>
				<th style="text-align: center;">KG</th>
				<th style="text-align: center;">Order Date</th>
				<th style="text-align: center;">MRP</th>
				<th style="text-align: center;">Advance Amt</th>
				<th style="text-align: center;">Del Date</th>
			</tr>
		</thead>

		<tbody>
		<tbody>
			<c:set var="mrpTotal" value="${0}" />
			<c:set var="advTotal" value="${0}" />

			<c:forEach items="${reportList}" var="reportList" varStatus="count">
				<tr>
					<td align="center"><c:out value="${count.index+1}" /></td>

					<td><c:out value="${reportList.custName}" /></td>
					<td style="text-align: center;"><c:out
							value="${reportList.spCustMobNo}" /></td>
					<td>${reportList.itemName}</td>

					<c:set var="mrpTotal" value="${mrpTotal + reportList.totalMrp}" />
					<c:set var="advTotal" value="${advTotal + reportList.advAmt}" />

					<td>${reportList.spfName}</td>

					<td style="text-align: right;">${reportList.weight}</td>

					<td style="text-align: center;">${reportList.orderDate}</td>

					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.totalMrp}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.advAmt}" /></td>
					<td style="text-align: center;">${reportList.delDate}</td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan='7'><b>Total</b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${mrpTotal}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${advTotal}" /></b></td>

				<td style="text-align: right;"></td>
				<!--  <td><b>Total</b></td> -->
			</tr>
		</tbody>
	</table>


</body>
</html>