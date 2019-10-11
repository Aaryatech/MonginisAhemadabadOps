<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Bill wise Sell Report</title>
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
	<h4 align="center">Billwise Sale Report</h4>
	<div align="center">
		<h6>${frName}&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;${fromDate}
			&nbsp;To &nbsp; ${toDate}</h6>
	</div>
	<table align="center" border="1" cellspacing="0" cellpadding="1"
		id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">


				<th style="text-align: center; width: 60px">Sr no.</th>
				<th style="text-align: center; width: 100px">Invoice No</th>
				<th style="text-align: center; width: 100px">Bill Date</th>
				<th style="text-align: center; width: 100px">Disc%</th>
				<th style="text-align: center; width: 100px">Taxable</th>
				<th style="text-align: center; width: 100px">Total Tax</th>
				<th style="text-align: center; width: 100px">Grand Total</th>
				<th style="text-align: center; width: 100px">Payable AMT</th>
				<th style="text-align: center; width: 100px">Paid AMT</th>
				<th style="text-align: center; width: 100px">Remaining AMT</th>
				<th style="text-align: center; width: 100px">Payment Mode</th>
				<th style="text-align: center; width: 100px">Bill Type</th>



			</tr>
		</thead>

		<tbody>
			<c:set var="totalAmount" value="${0}" />
			<c:set var="totalTaxable" value="${0}" />
			<c:set var="totalTax" value="${0}" />
			<c:set var="totalTPayable" value="${0}" />
			<c:set var="totalPaid" value="${0}" />
			<c:set var="totalRemaining" value="${0}" />

			<c:forEach items="${reportList}" var="reportList" varStatus="count">
				<tr>
					<td><c:out value="${count.index+1}" /></td>

					<td><c:out value="${reportList.invoiceNo}" /></td>

					<td><c:out value="${reportList.billDate}" /></td>

					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.discountPer}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.taxableAmt}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.totalTax}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.grandTotal}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.payableAmt}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.paidAmt}" /></td>
					<td style="text-align: right;"><fmt:formatNumber type="number"
							minFractionDigits="2" maxFractionDigits="2"
							value="${reportList.remainingAmt}" /></td>


					<c:set var="totalAmount"
						value="${totalAmount + reportList.grandTotal}" />
					<c:set var="totalTaxable"
						value="${totalTaxable + reportList.taxableAmt}" />
					<c:set var="totalTax" value="${totalTax + reportList.totalTax}" />
					<c:set var="totalTPayable"
						value="${totalTPayable + reportList.payableAmt}" />
					<c:set var="totalPaid" value="${totalPaid + reportList.paidAmt}" />
					<c:set var="totalRemaining"
						value="${totalRemaining + reportList.remainingAmt}" />


					<c:choose>
						<c:when test="${reportList.paymentMode==1}">

							<td style="text-align: center;"><c:out value="Cash" /></td>
						</c:when>
						<c:when test="${reportList.paymentMode==2}">

							<td style="text-align: center;"><c:out value="Card" /></td>
						</c:when>
						<c:when test="${reportList.paymentMode==3}">

							<td style="text-align: center;"><c:out value="Other" /></td>
						</c:when>
					</c:choose>


					<c:choose>

						<c:when test="${reportList.billType.toString()=='E'}">
							<c:set var="billType" value="Express" />
						</c:when>

						<c:when test="${reportList.billType.toString()=='R'}">
							<c:set var="billType" value="Regular B2C" />
						</c:when>

						<c:when test="${reportList.billType.toString()=='B'}">
							<c:set var="billType" value="Regular B2B" />
						</c:when>

						<c:when test="${reportList.billType.toString()=='S'}">
							<c:set var="billType" value="Special Cake" />
						</c:when>


						<c:when test="${reportList.billType.toString()=='G'}">
							<c:set var="billType" value="Against GRN" />
						</c:when>

					</c:choose>

					<td style="text-align: center;"><c:out value="${billType}" /></td>


				</tr>
			</c:forEach>
			<tr>
				<td colspan='4'><b>Total</b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalTaxable}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalTax}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalAmount}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalTPayable}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalPaid}" /></b></td>
				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${totalRemaining}" /></b></td>
				<td></td>
				<td></td>
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