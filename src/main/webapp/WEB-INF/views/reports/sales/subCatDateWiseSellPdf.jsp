<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sub Category Date wise Sell Report</title>
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
<body>
	<h4 align="center">Sub Category Date Wise Sale Report</h4>
	<div align="center">
		<h6>${frName}&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;${fromDate}
			&nbsp;To &nbsp; ${toDate}</h6>
	</div>
	<table align="center" border="1" cellspacing="0" cellpadding="1"
		id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">

				<th style="text-align: center; width: 20px">Sr.No.</th>
				<th style="text-align: center; width: 100px">Sub Category</th>
				<th style="text-align: center; width: 100px">Qty</th>
				<th style="text-align: center; width: 100px">Taxable Amt</th>
				<th style="text-align: center; width: 100px">Tax Amt</th>
				<th style="text-align: center; width: 100px">Total Amt</th>

			</tr>
		</thead>

		<tbody>
			<c:set var="totalAmount" value="${0}" />
			<c:set var="totalTaxableAmount" value="${0}" />
			<c:set var="totalTaxAmount" value="${0}" />
			<c:set var="totalQty" value="${0}" />


			<c:forEach items="${reportList}" var="reportList" varStatus="count">
				<tr>
					<td><c:out value="${count.index+1}" /></td>
					<%-- 	<td><c:out value="${reportList.sellBillNo}" /></td> --%>
					<td><c:out value="${reportList.subCatName}" /></td>
					<td style="text-align: right;"><c:out
							value="${reportList.soldQty}" /></td>
					<td style="text-align: right;"><c:out value="${reportList.taxableAmt}" /></td>
					<td style="text-align: right;"><c:out value="${reportList.totalTax}" /></td>
					<td style="text-align: right;"><c:out value="${reportList.soldAmt}" /></td>


					<c:set var="totalAmount"
						value="${totalAmount + reportList.soldAmt}" />

					<c:set var="totalTaxableAmount"
						value="${totalTaxableAmount + reportList.taxableAmt}" />

					<c:set var="totalTaxAmount"
						value="${totalTaxAmount + reportList.totalTax}" />

					<c:set var="totalQty" value="${totalQty + reportList.soldQty}" />

				</tr>
			</c:forEach>
			<tr>
				<td></td>
				<td ><b>Total</b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="0" maxFractionDigits="0"
							value="${totalQty}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalTaxableAmount}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalTaxAmount}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalAmount}" /></b></td>

			</tr>
		</tbody>
	</table>


	<!-- <script>
	function print()
	{
		alert("JJ");
		window.print();
		//window.close();
	}
	
	</script> -->
</body>
</html>