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
	<h4 align="center">HSN Date Wise Sell Report</h4>
	<div align="center">
		<h6>${frName}&nbsp;&nbsp;&nbsp;&nbsp;From&nbsp;${fromDate}
			&nbsp;To &nbsp; ${toDate}</h6>
	</div>
	<table align="center" border="1" cellspacing="0" cellpadding="1"
		id="table_grid" class="table table-bordered">
		<thead>
			<tr class="bgpink">

				<th style="text-align: center; width: 20px">Sr.No.</th>
				<th style="text-align: center; width: 100px">Invoice No</th>
				<th style="text-align: center; width: 100px">Invoice Date</th>
				<th style="text-align: center; width: 100px">Party Name</th>
				<th style="text-align: center; width: 100px">GST No</th>
				<th style="text-align: center; width: 100px">HSN Code</th>

				<th style="text-align: center; width: 100px">Billed Qty</th>
				<th style="text-align: center; width: 100px">Taxable Amt</th>
				<th style="text-align: center; width: 100px">Cgst %</th>
				<th style="text-align: center; width: 100px">Cgst Amt</th>
				<th style="text-align: center; width: 100px">Sgst %</th>
				<th style="text-align: center; width: 100px">Sgst Amt</th>
				<th style="text-align: center; width: 100px">Total</th>
				<th style="text-align: center; width: 100px">Bill Amt</th>

			</tr>
		</thead>

		<tbody>
			<c:set var="sumQty" value="${0}" />
			<c:set var="sumTaxableAmount" value="${0}" />
			<c:set var="sumCgstPer" value="${0}" />
			<c:set var="sumCgstRs" value="${0}" />
			<c:set var="sumSgstPer" value="${0}" />
			<c:set var="sumSgstRs" value="${0}" />
			<c:set var="sumTotal" value="${0}" />
			<c:set var="sumBillAmt" value="${0}" />


			<c:forEach items="${reportList}" var="reportList" varStatus="count">
				<tr>
					<td><c:out value="${count.index+1}" /></td>

					<td><c:out value="${reportList.invoiceNo}" /></td>
					<td style="text-align: right;"><c:out
							value="${reportList.billDate}" /></td>
					<td style="text-align: right;"><c:out
							value="${reportList.userName}" /></td>
					<td style="text-align: right;"><c:out
							value="${reportList.userGstNo}" /></td>
					<td style="text-align: right;"><c:out
							value="${reportList.hsnCode}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.qty}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.taxableAmt}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.cgstPer}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.cgstRs}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.sgstPer}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.sgstRs}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.total}" /></td>

					<td style="text-align: right;"><c:out
							value="${reportList.billTotal}" /></td>


					<c:set var="sumQty" value="${sumQty + reportList.qty}" />

					<c:set var="sumTaxableAmount"
						value="${sumTaxableAmount + reportList.taxableAmt}" />

					<c:set var="sumCgstPer" value="${sumCgstPer + reportList.cgstPer}" />

					<c:set var="sumCgstRs" value="${sumCgstRs + reportList.cgstRs}" />

					<c:set var="sumSgstPer" value="${sumSgstPer + reportList.sgstPer}" />

					<c:set var="sumSgstRs" value="${sumSgstRs + reportList.sgstRs}" />

					<c:set var="sumTotal" value="${sumTotal + reportList.total}" />

					<c:set var="sumBillAmt"
						value="${sumBillAmt + reportList.billTotal}" />

				</tr>
			</c:forEach>
			<tr>
				<td></td>
				<td><b>Total</b></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="0" maxFractionDigits="0"
							value="${sumQty}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumTaxableAmount}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumCgstPer}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumCgstRs}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumSgstPer}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumSgstRs}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumTotal}" /></b></td>

				<td style="text-align: right;"><b><fmt:formatNumber
							type="number" minFractionDigits="2" maxFractionDigits="2"
							value="${sumBillAmt}" /></b></td>

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