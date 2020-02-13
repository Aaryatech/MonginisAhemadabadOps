
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>

<style>
table, th, td {
	border: 1px solid #9da88d;
}
</style>
<body>

	<!--datepicker-->
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>
	<script>
		$(function() {
			$("#todatepicker").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
		$(function() {
			$("#fromdatepicker").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
	</script>
	<!--datepicker-->

	<c:url var="getBilwiselReport" value="/getBilwiselReport" />

	<div class="sidebarOuter"></div>

	<div class="wrapper">

		<!--topHeader-->

		<jsp:include page="/WEB-INF/views/include/logo.jsp">
			<jsp:param name="frDetails" value="${frDetails}" />

		</jsp:include>

		<!--topHeader-->

		<!--rightContainer-->
		<div class="fullGrid center">
			<!--fullGrid-->
			<div class="wrapperIn2">

				<!--leftNav-->

				<jsp:include page="/WEB-INF/views/include/left.jsp">
					<jsp:param name="myMenu" value="${menuList}" />

				</jsp:include>


				<!--leftNav-->
				<!--rightSidebar-->

				<!-- Place Actual content of page inside this div -->
				<div class="sidebarright">


					<div class="row">
						<div class="col-md-12">
							<h2 class="pageTitle">Billwise Sale Report</h2>
						</div>
					</div>

					<div class="colOuter">
						<div align="center">
							<div class="col1">
								<div class="col1title">
									<span class="frm_txt">From</span> <input id="fromdatepicker"
										placeholder="From Date"
										class="texboxitemcode texboxcal float_l" name="from_Date"
										type="text" autocomplete="off" size="35">
								</div>
							</div>
							<div class="col2">
								<div class="col1title">
									<span class="frm_txt">To</span> <input id="todatepicker"
										placeholder="To Date" name="to_Date"
										class="texboxitemcode texboxcal float_l" autocomplete="off"
										type="text" size="35">
								</div>
							</div>
							<input type="hidden" name="frId" id="frId" value="${frId}">
						</div>


						<div align="center" class="right_btn">
							<button class="btn search_btn" onclick="searchSellBill()">HTML
								View</button>

							<%--  <a href='${pageContext.request.contextPath}/pdf?reportURL=showSellBillwiseReportpPdf' id="btn_pdf" class="btn search_btn" style="display: none">PDF</a> --%>
							<button class="btn btn-primary" value="PDF" id="PDFButton"
								onclick="genPdf()">PDF</button>


							<br>
						</div>
					</div>


					<div class="row">
						<div class="col-md-12">
							<!--table-->
							<div class="clearfix"></div>


							<div id="table-scroll" class="responsive-table-one">
								<!--  <div id="faux-table" class="faux-table" aria="hidden">
									<table id="table_grid" class="responsive-table">
									<thead>
											<tr class="bgpink">

												<th style="text-align: center;">Sr.</th>
												<th style="text-align: center;">Invoice No</th>
												<th style="text-align: center;">Bill Date</th>
												<th style="text-align: center;">Disc%</th>
												<th style="text-align: center;">Taxable</th>
												<th style="text-align: center;">Total Tax</th>
												<th style="text-align: center;">Grand Total</th>
												<th style="text-align: center;">Payable Amt</th>
												<th style="text-align: center;">Paid Amt</th>
												<th style="text-align: center;">Remaining Amt</th>
												<th style="text-align: center;">Payment Mode</th>
												<th style="text-align: center;">BillType</th>

											</tr>
										</thead>


									</table>
								</div>  -->
								<div>
									<table id="table_grid" class="responsive-table">
										<thead>
											<tr class="bgpink">

												<th style="text-align: center;">Sr.</th>
												<th style="text-align: center;">Invoice No</th>
												<th style="text-align: center;">Bill Date</th>
												<th style="text-align: center;">Disc%</th>
												<th style="text-align: center;">Taxable</th>
												<th style="text-align: center;">Tax Amt</th>
												<th style="text-align: center;">Total</th>
												<th style="text-align: center;">Payable Amt</th>
												<th style="text-align: center;">Paid Amt</th>
												<th style="text-align: center;">Remaining Amt</th>
												<th style="text-align: center;">Payment Mode</th>
												<th style="text-align: center;">BillType</th>

											</tr>
										</thead>

										<tbody>

										</tbody>

									</table>

								</div>

							</div>
							<!--table end-->
							<br>
							<div class="form-group" style="display: none;" id="range">



								<div class="col-sm-3  controls">
									<input type="button" id="expExcel" class="btn btn-primary"
										value="EXPORT TO Excel" onclick="exportToExcel();"
										disabled="disabled">
								</div>
							</div>
						</div>
					</div>




				</div>
				<!--rightSidebar-->

			</div>
			<!--fullGrid-->
		</div>
		<!--rightContainer-->

	</div>
	<!--wrapper-end-->

	<!--easyTabs-->
	<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
	<!--easyTabs-->


	<script type="text/javascript">
		function searchSellBill() {

			$('#table_grid td').remove();

			var isValid = validate();

			if (isValid) {
				//document.getElementById('btn_pdf').style.display = "block";
				var fromDate = document.getElementById("fromdatepicker").value;
				var toDate = document.getElementById("todatepicker").value;

				$
						.getJSON(
								'${getBilwiselReport}',
								{

									fromDate : fromDate,
									toDate : toDate,
									ajax : 'true',

								},
								function(data) {

									//$('#table_grid td').remove();

									if (data == "") {
										alert("No records found !!");
										document.getElementById("expExcel").disabled = true;
									}

									//	var cashTotal=0;
									//	var cardTotal=0;
									var amtTotal = 0;
									var taxableTotal = 0;
									var taxTotal = 0;
									var payableTotal = 0;
									var paidTotal = 0;
									var remainingTotal = 0;
									//var otherTotal=0;
									$
											.each(
													data,
													function(key, sellBillData) {

														document
																.getElementById("expExcel").disabled = false;
														document
																.getElementById('range').style.display = 'block';

														var tr = $('<tr class="responsive-table"></tr>');

														tr.append($(
																'<td  ></td>')
																.html(key + 1));

														tr
																.append($(
																		'<td   ></td>')
																		.html(
																				sellBillData.invoiceNo));

														tr
																.append($(
																		'<td class="col-md-2"></td>')
																		.html(
																				sellBillData.billDate));

														tr
																.append($(
																		'<td style="text-align:right;"></td>')
																		.html(
																				sellBillData.discountPer
																						.toFixed(2)));
														tr
																.append($(
																		'<td style="text-align:right;"></td>')
																		.html(
																				sellBillData.taxableAmt
																						.toFixed(2)));
														tr
																.append($(
																		'<td style="text-align:right;"></td>')
																		.html(
																				sellBillData.totalTax
																						.toFixed(2)));

														tr
																.append($(
																		'<td   style="text-align:right;"></td>')
																		.html(
																				(sellBillData.grandTotal)
																						.toFixed(2)));
														tr
																.append($(
																		'<td  style="text-align:right;"></td>')
																		.html(
																				(sellBillData.payableAmt)
																						.toFixed(2)));

														tr
																.append($(
																		'<td   style="text-align:right;"></td>')
																		.html(
																				(sellBillData.paidAmt)
																						.toFixed(2)));

														tr
																.append($(
																		'<td   style="text-align:right;"></td>')
																		.html(
																				(sellBillData.remainingAmt)
																						.toFixed(2)));

														amtTotal = amtTotal
																+ sellBillData.grandTotal;
														taxableTotal = taxableTotal
																+ sellBillData.taxableAmt;
														taxTotal = taxTotal
																+ sellBillData.totalTax;
														payableTotal = payableTotal
																+ sellBillData.payableAmt;
														paidTotal = paidTotal
																+ sellBillData.paidAmt;
														remainingTotal = remainingTotal
																+ sellBillData.remainingAmt;
														//	amtTotal=amtTotal + sellBillData.cash + sellBillData.card + sellBillData.other;

														var paymentMode = sellBillData.paymentMode;
														var mode;

														if (paymentMode == 1) {
															mode = "Cash";

														} else if (paymentMode == 2) {
															mode = "Card";

														} else if (paymentMode == 3) {
															mode = "Other";

														}

														tr
																.append($(
																		'<td  style="text-align:center;"></td>')
																		.html(
																				mode));

														var billType;

														if (sellBillData.billType == 'E') {
															billType = "Express";
														} else if (sellBillData.billType == 'R') {
															billType = "Regular B2C";
														} else if (sellBillData.billType == 'S') {
															billType = "Special Cake";
														} else if (sellBillData.billType == 'B') {
															billType = "Regular B2B";
														} else if (sellBillData.billType == 'G') {
															billType = "Against GRN";
														} else if (sellBillData.billType == 'P') {
															billType = "Bill As Per Phy Stock";
														} 

														tr
																.append($(
																		'<td   style="text-align:center;"></td>')
																		.html(
																				billType));

														$('#table_grid tbody')
																.append(tr);

													})

									var tr = "<tr>";
									var total = "<td colspan='4'>&nbsp;&nbsp;&nbsp;<b> Total</b></td>";

									var totalAmt = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (amtTotal).toFixed(2);
									+"</b></td>";

									var taxable = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (taxableTotal).toFixed(2);
									+"</b></td>";

									var tax = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (taxTotal).toFixed(2);
									+"</b></td>";

									var payable = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (payableTotal).toFixed(2);
									+"</b></td>";
									var paid = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (paidTotal).toFixed(2);
									+"</b></td>";
									var remaining = "<td style=text-align:right;>&nbsp;&nbsp;&nbsp;<b>"
											+ (remainingTotal).toFixed(2);
									+"</b></td>";

									var td = "<td></td>";

									var trclosed = "</tr>";

									$('#table_grid tbody').append(tr);
									$('#table_grid tbody').append(tr);
									$('#table_grid tbody').append(total);
									$('#table_grid tbody').append(taxable);
									$('#table_grid tbody').append(tax);
									$('#table_grid tbody').append(totalAmt);
									$('#table_grid tbody').append(payable);
									$('#table_grid tbody').append(paid);
									$('#table_grid tbody').append(remaining);
									$('#table_grid tbody').append(td);
									$('#table_grid tbody').append(td);
									$('#table_grid tbody').append(trclosed);
									$('#table_grid tbody').append(trclosed);
								});

			}
		}
	</script>
	<script type="text/javascript">
		function validate() {

			var fromDate = $("#fromdatepicker").val();
			var toDate = $("#todatepicker").val();

			var isValid = true;

			if (fromDate == "" || fromDate == null) {

				isValid = false;
				alert("Please select From Date");
			} else if (toDate == "" || toDate == null) {

				isValid = false;
				alert("Please select To Date");
			}
			return isValid;

		}
	</script>

	<script>
		(function() {
			var fauxTable = document.getElementById("faux-table");
			var mainTable = document.getElementById("table_grid");
			var clonedElement = table_grid.cloneNode(true);
			var clonedElement2 = table_grid.cloneNode(true);
			clonedElement.id = "";
			clonedElement2.id = "";
			fauxTable.appendChild(clonedElement);
			fauxTable.appendChild(clonedElement2);
		})();

		function exportToExcel() {

			window.open("${pageContext.request.contextPath}/exportToExcel");
			document.getElementById("expExcel").disabled = true;
		}
	</script>
	<script type="text/javascript">
		function genPdf() {
			var isValid = validate();
			if (isValid == true) {
				var fromDate = document.getElementById("fromdatepicker").value;
				var toDate = document.getElementById("todatepicker").value;
				var frId = document.getElementById("frId").value;
				window
						.open('${pageContext.request.contextPath}/pdf?reportURL=pdf/showSellBillwiseReportPdf/'
								+ fromDate + '/' + toDate + '/' + frId);
			}

		}
	</script>
</body>
</html>
