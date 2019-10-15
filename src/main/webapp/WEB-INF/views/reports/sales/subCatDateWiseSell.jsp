<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
<style type="text/css">
.hide-calendar .ui-datepicker-calendar {
	display: none;
}

.table-scroll {
	position: relative;
	margin: auto;
	overflow: hidden;
}

.table-wrap {
	width: 100%;
	overflow: auto;
}

.table-scroll table {
	width: 100%;
	margin: auto;
	border-collapse: collapse;
	border-spacing: 0;
}

.table-scroll th, .table-scroll td {
	padding: 5px 10px;
	border: 1px solid #000;
	background: #fff;
	white-space: nowrap;
	vertical-align: top;
	font-weight: normal;
}

.table-scroll thead, .table-scroll tfoot {
	background: #f9f9f9;
}

.clone {
	position: absolute;
	top: 0;
	left: 0;
	pointer-events: none;
}

.clone th, .clone td {
	visibility: hidden
}

.clone td, .clone th {
	border-color: transparent
}

.clone tbody th {
	visibility: visible;
	color: red;
}

.clone .fixed-side {
	border: 1px solid #000;
	background: #eee;
	visibility: visible;
}

.clone thead, .clone tfoot {
	background: transparent;
}
</style>
<style>
table, th, td {
	border: 1px solid #9da88d;
}
</style>
<!DOCTYPE html>
<html>

<body>

	<!--datepicker-->
	<script type="text/javascript"
		src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>
	<script>
		$(function() {
			$("#toDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
		$(function() {
			$("#fromDate").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
	</script>
	<!--datepicker-->


	<c:url var="getBillList" value="/getSubCatDateWiseDataAjax"></c:url>


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


					<form id="submitBillForm"
						action="${pageContext.request.contextPath}/displayYearlyReport"
						method="get">

						<div class="row">
							<div class="col-md-12">
								<h2 class="pageTitle">Sub-Category Wise Sell Report</h2>
							</div>
						</div>


						<input type="hidden" name="frId" id="frId" value="${frId}">




						<div class="row">


							<div class="form-group">
								<div class="col-sm-3 col-lg-2	">From Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal" placeholder="From Date"
										id="fromDate" name="fromDate" size="30" type="text"
										value="${todaysDate}" />
								</div>


								<div class="col-sm-3 col-lg-2	">To Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal" placeholder="To Date"
										id="toDate" name="toDate" size="30" type="text"
										value="${todaysDate}" />
								</div>
							</div>

						</div>

						<br>

						<div class="row">
							<div class="col-md-2">Select Category</div>
							<div class="col-md-4" style="text-align: left;">
								<select data-placeholder="Select Group"
									class="form-control chosen" name="item_grp1" tabindex="-1"
									onchange="getSubCategoriesByCatId()" id="item_grp1"
									data-rule-required="true">
									<option value="-1">Select All</option>

									<c:forEach items="${mCategoryList}" var="mCategoryList">
										<option value="${mCategoryList.catId}"><c:out
												value="${mCategoryList.catName}"></c:out></option>
									</c:forEach>


								</select>
							</div>

							<div class="col-md-3" style="text-align: center;">
								<input type="button" id="submit" class="btn btn-primary"
									value="Search Report" onclick="searchReport()"> <input
									class="btn btn-primary" value="PDF" id="PDFButton"
									onclick="genPdf()" value="PDF" type="button">
							</div>
						</div>


					</form>

					<!-- form -->



					<div class="row">
						<div class="col-md-12">
							<!--table-->
							<div class="clearfix"></div>


							<div id="table-scroll">
								<div>
									<!-- class="table-wrap" -->

									<table id="table_grid" class="responsive-table">
										<thead>
											<tr class="fixed-side">

												<th class="col-sm-1" style="text-align: center;">Sr.No.</th>
												<th class="col-md-3" style="text-align: center;">Sub
													Category</th>
												<th class="col-md-2" style="text-align: center;">Qty</th>
												<th class="col-md-2" style="text-align: center;">Taxable
													Amt</th>
												<th class="col-md-2" style="text-align: center;">Tax
													Amt</th>
												<th class="col-md-2" style="text-align: center;">Total
													Amt</th>

											</tr>
										</thead>

										<tbody>

										</tbody>

									</table>

								</div>

							</div>
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
	<script type="text/javascript"
		src="https://www.gstatic.com/charts/loader.js"></script>
	<!--easyTabs-->



	<script type="text/javascript">
		function validate() {

			var fromDate = $("#txtDate").val();
			var toDate = $("#txtDateto").val();

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

			window.open("${pageContext.request.contextPath}/exportToExcelNew");
			document.getElementById("expExcel").disabled = true;
		}
	</script>








	<script type="text/javascript">
		function searchReport() {
			//	var isValid = validate();

			$('#table_grid td').remove();

			var frId = document.getElementById("frId").value;
			var selectedCat = $("#item_grp1").val();
			var from_date = $("#fromDate").val();
			var to_date = $("#toDate").val();

			$('#loader').show();

			$
					.getJSON(
							'${getBillList}',

							{
								frId : frId,
								cat_id_list : JSON.stringify(selectedCat),
								fromDate : from_date,
								toDate : to_date,
								ajax : 'true'

							},
							function(data) {

								if (data == "") {
									alert("No records found !!");
									document.getElementById("expExcel").disabled = true;
								}

								var qtyTotal = 0;
								var amtTotal = 0;
								var taxableAmtTotal = 0;
								var taxAmtTotal = 0;

								$
										.each(
												data,
												function(key, sellBillData) {

													document
															.getElementById("expExcel").disabled = false;
													document
															.getElementById('range').style.display = 'block';

													var tr = $('<tr></tr>');

													tr
															.append($(
																	'<td class="col-sm-1"></td>')
																	.html(
																			key + 1));

													tr
															.append($(
																	'<td class="col-md-3" style=text-align:left;></td>')
																	.html(
																			sellBillData.subCatName));
													tr
															.append($(
																	'<td class="col-md-2" style=text-align:right;></td>')
																	.html(
																			sellBillData.soldQty));

													qtyTotal = qtyTotal
															+ sellBillData.soldQty;

													tr
															.append($(
																	'<td class="col-md-2" style=text-align:right;></td>')
																	.html(
																			sellBillData.taxableAmt));

													taxableAmtTotal = taxableAmtTotal
															+ sellBillData.taxableAmt;

													tr
															.append($(
																	'<td class="col-md-2" style=text-align:right;></td>')
																	.html(
																			sellBillData.totalTax));

													taxAmtTotal = taxAmtTotal
															+ sellBillData.totalTax;

													tr
															.append($(
																	'<td class="col-md-2" style=text-align:right;></td>')
																	.html(
																			sellBillData.soldAmt));

													amtTotal = amtTotal
															+ sellBillData.soldAmt;

													$('#table_grid tbody')
															.append(tr);

												});

								var tr = "<tr>";
								var blank = "<td class='col-md-1'></td>";
								var total = "<td class='col-md-3' style=text-align:left; ><b> Total</b></td>";

								var totalQty = "<td class='col-md-2' style=text-align:right;><b>"
										+ (qtyTotal) + "</b></td>";

								var totalAmt = "<td class='col-md-2' style=text-align:right;><b>"
										+ (amtTotal).toFixed(2) + "</b></td>";

								var totalTaxableAmt = "<td class='col-md-2' style=text-align:right;><b>"
										+ (taxableAmtTotal).toFixed(2)
										+ "</b></td>";

								var totalTaxAmt = "<td class='col-md-2' style=text-align:right;><b>"
										+ (taxAmtTotal).toFixed(2)
										+ "</b></td>";

								var td = "<td></td>";

								var trclosed = "</tr>";

								$('#table_grid tbody').append(tr);
								$('#table_grid tbody').append(tr);
								$('#table_grid tbody').append(blank);
								$('#table_grid tbody').append(total);
								$('#table_grid tbody').append(totalQty);
								$('#table_grid tbody').append(totalTaxableAmt);
								$('#table_grid tbody').append(totalTaxAmt);
								$('#table_grid tbody').append(totalAmt);
								$('#table_grid tbody').append(trclosed);
								$('#table_grid tbody').append(trclosed);
							});
		}
	</script>



	<script>
		function exportToExcel() {

			window.open("${pageContext.request.contextPath}/exportToExcelNew");
			document.getElementById("expExcel").disabled = true;
		}
	</script>








	<script>
		/* $('.datepicker').datepicker({
			format : {

				format : 'mm/dd/yyyy',
				startDate : '-3d'
			}
		}); */

		function genPdf() {
			var frId = document.getElementById("frId").value;
			var selectedCat = $("#item_grp1").val();
			var from_date = $("#fromDate").val();
			var to_date = $("#toDate").val();

			window
					.open('${pageContext.request.contextPath}/pdf?reportURL=pdf/showSubCatDateWiseSellReportPdf/'
							+ from_date
							+ '/'
							+ to_date
							+ '/'
							+ frId
							+ '/'
							+ selectedCat);

		}
	</script>
</body>
</html>
