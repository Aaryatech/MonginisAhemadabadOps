<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>Bill Credit Note Report PDF</title>
<meta name="description" content="">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Place favicon.ico and apple-touch-icon.png in the root directory -->


<style type="text/css">
table {
	border-collapse: collapse;
	font-size: 10;
	width: 100%;
	page-break-inside: auto !important
}

p {
	color: black;
	font-family: arial;
	font-size: 60%;
	margin-top: 0;
	padding: 0;
}

h6 {
	color: black;
	font-family: arial;
	font-size: 80%;
}

th {
	background-color: #EA3291;
	color: white;
}
</style>
</head>
<body onload="myFunction()">
	<h3 align="center">${FACTORYNAME}</h3>
	<p align="center">${FACTORYADDRESS}</p>
	<div align="center">
		<h5>Bill Credit Note Report &nbsp;&nbsp;&nbsp; From
			&nbsp; ${fromDate} &nbsp;To &nbsp; ${toDate}</h5>
	</div>
	<table align="center" border="1" cellspacing="0" cellpadding="1"
		id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">

				<th>Sr.No.</th>
				<th>Date</th>
				<th>Type</th>
				<th>Document</th>
				<th>Order Ref</th>
				<th>Dr Amt</th>
				<th>Cr Amt</th>
				<th>Balance</th>

			</tr>
		</thead>
		<tbody>


			<c:set var="totalDrAMt" value="${0}" />
			<c:set var="totalCrAMt" value="${0}" />
			<c:set var="bal" value="${0}" />
			<tr>
				<td width="200"><c:out value="${fr.frName}" /></td>

			</tr>
			<c:forEach items="${salesRepFrList}" var="report" varStatus="count">
				<tr>


					<td width="5%"><c:out value="${count.index+1}" /></td>
					<td width="10%"><c:out value="${report.billDate}" /></td>
					<td width="10%"><c:out value="${report.type}" /></td>
					<td width="100"><c:out value="${report.invoiceNo}" /></td>
					<td width="100"><c:out value="${report.orderRef}" /></td>

					<c:choose>
						<c:when test="${report.type eq 'INV'}">

							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2"
									value="${report.grandTotal}" /></td>
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2" value="${0}" /></td>

							<c:set var="totalDrAMt"
								value="${totalDrAMt + report.grandTotal }" />
							<c:set var="bal" value="${bal+report.grandTotal}" />
						</c:when>
						<c:when test="${report.type eq 'RET'}">
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2" value="${0}" /></td>
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2"
									value="${report.grandTotal}" /></td>
							<c:set var="bal" value="${bal-report.grandTotal}" />

							<c:set var="totalCrAMt"
								value="${totalCrAMt + report.grandTotal }" />
						</c:when>
						<c:when test="${report.type eq 'VER'}">
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2" value="${0}" /></td>
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2"
									value="${report.grandTotal}" /></td>
							<c:set var="bal" value="${bal-report.grandTotal}" />

							<c:set var="totalCrAMt"
								value="${totalCrAMt + report.grandTotal }" />
						</c:when>
						<c:otherwise>
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2" value="${0}" /></td>
							<td width="80" align="right"><fmt:formatNumber type="number"
									maxFractionDigits="2" minFractionDigits="2" value="${0}" /></td>
						</c:otherwise>
					</c:choose>

					 
					<td width="80" align="right"><fmt:formatNumber type="number"
							maxFractionDigits="2" minFractionDigits="2" value="${bal}" /></td>
				</tr>

			</c:forEach>

			<tr>

				<td colspan='4'><b>Total</b></td>
				<td></td>

				<td width="100" align="right"><b><fmt:formatNumber
							type="number" maxFractionDigits="2" minFractionDigits="2"
							value="${totalDrAMt}" /></b></td>

				<td width="100" align="right"><b><fmt:formatNumber
							type="number" maxFractionDigits="2" minFractionDigits="2"
							value="${totalCrAMt}" /></b></td>
				<td width="100" align="right"><b><fmt:formatNumber
							type="number" maxFractionDigits="2" minFractionDigits="2"
							value="${totalDrAMt-totalCrAMt}" /></b></td>
				<!--  <td><b>Total</b></td> -->
			</tr>

		</tbody>
	</table>


	<!-- END Main Content -->

</body>
</html>