<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
<style>
table, th, td {
	border: 1px solid #9da88d;
}

.hide-calendar .ui-datepicker-calendar {
	display: none;
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


	<c:url var="getBillList" value="/getYearlyFrSubCatSaleReport"></c:url>
	<c:url var="getGroup2ByCatId" value="/getSubCatListByCatId"></c:url>

	<c:url var="getFrListofAllFr" value="/getAllFrList"></c:url>

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
								<h2 class="pageTitle">Item-wise Yearly Purchase Report</h2>
							</div>
						</div>


						<input type="hidden" name="frId" id="frId" value="${frId}">

						<!-- <div class="row">

						<div align="center">
							<button class="btn search_btn" onclick="monthWisePurchase()">HTML
								View</button>
							<button class="btn search_btn" onclick="showChart()">Graph</button>

							<button class="btn btn-primary" value="PDF" id="PDFButton"
								onclick="genPdf()">PDF</button>
						</div>

					</div> -->



						<div class="row">


							<div class="form-group">
								<div class="col-sm-3 col-lg-2	">From Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="fromDate" name="fromDate"
										size="30" type="text" value="${todaysDate}" />
								</div>

								<!-- </div>

					<div class="form-group  "> -->

								<div class="col-sm-3 col-lg-2	">To Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="toDate" name="toDate" size="30"
										type="text" value="${todaysDate}" />
								</div>
							</div>

						</div>

						<br>
						<br>

						<div class="row">
							<div class="col-md-2">Select Category</div>
							<div class="col-md-4" style="text-align: left;">
								<select data-placeholder="Select Group"
									class="form-control chosen" name="item_grp1" tabindex="-1"
									onchange="getSubCategoriesByCatId()" id="item_grp1"
									data-rule-required="true" multiple="multiple">
									<option value="-1">Select All</option>

									<c:forEach items="${mCategoryList}" var="mCategoryList">
										<option value="${mCategoryList.catId}"><c:out
												value="${mCategoryList.catName}"></c:out></option>
									</c:forEach>


								</select>
							</div>

							<div class="col-sm-3 col-lg-2 ">Report Type</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<select data-placeholder="Choose Type"
										class="form-control chosen" id="typeId" name="typeId">

										<option value="1">Consolidated</option>
										<option value="2">Quantity</option>
										<option value="3">Amount</option>
										<option value="4">Taxable Amount</option>

									</select>
								</div>

						</div>
						<br>
						<br>

						<br>
						<br>

						<div class="row">
							<div class="form-group">

								<div class="col-sm-12 " style="text-align: center;">
									<input type="submit" id="submit" class="btn btn-primary"
										value="Search Report">
								</div>

							</div>
						</div>


					</form>

					<!-- form -->



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

			var frId = document.getElementById("frId").value;
			var selectedSubCat = $("#item_grp2").val();
			var selectedCat = $("#item_grp1").val();
			
			var selectedType = $("#typeId").val();

			var from_date = $("#fromDate").val();
			var to_date = $("#toDate").val();

			$('#loader').show();

			$
					.getJSON(
							'${getBillList}',

							{
								fr_id : frId,
								subCat_id_list : JSON.stringify(selectedSubCat),
								cat_id_list : JSON.stringify(selectedCat),
								fromDate : from_date,
								toDate : to_date,
								ajax : 'true'

							},
							function(data) {

								alert("DATA ------------ "
										+ JSON.stringify(data));
								//alert(data.subCatFrReportList);

								$('#table_grid td').remove();
								$('#loader').hide();

								if (data == "") {
									alert("No records found !!");
									document.getElementById("expExcel").disabled = true;
								}

								$
										.each(
												data.frList,
												function(key, fr) {
													var tr = $('<tr></tr>');

													tr.append($('<td></td>')
															.html(fr.frName));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));

													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));
													tr.append($('<td></td>')
															.html(""));

													$('#table_grid tbody')
															.append(tr);

													var totalSoldQty = 0;
													var totalSoldAmt = 0;
													var totalVarQty = 0;
													var totalVarAmt = 0;
													var totalRetQty = 0;
													var totalRetAmt = 0;
													var totalNetQty = 0;
													var totalNetAmt = 0;
													var retAmtPer = 0;

													$
															.each(
																	data.subCatFrReportList,
																	function(
																			key,
																			report) {
																		if (fr.frId == report.frId) {

																			totalSoldQty = totalSoldQty
																					+ report.soldQty;
																			totalSoldAmt = totalSoldAmt
																					+ report.soldAmt;
																			totalVarQty = totalVarQty
																					+ report.varQty;
																			totalVarAmt = totalVarAmt
																					+ report.varAmt;
																			totalRetQty = totalRetQty
																					+ report.retQty;
																			totalRetAmt = totalRetAmt
																					+ report.retAmt;
																			totalNetQty = totalNetQty
																					+ report.netQty;
																			totalNetAmt = totalNetAmt
																					+ report.netAmt;
																			retAmtPer = retAmtPer
																					+ report.retAmtPer;

																			document
																					.getElementById("expExcel").disabled = false;
																			document
																					.getElementById('range').style.display = 'block';
																			var index = key + 1;
																			//var tr = "<tr>";

																			var tr = $('<tr></tr>');

																			tr
																					.append($(
																							'<td></td>')
																							.html(
																									key + 1));

																			tr
																					.append($(
																							'<td></td>')
																							.html(
																									report.subCatName));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.soldQty
																											.toFixed(2)));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.soldAmt
																											.toFixed(2)));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.varQty
																											.toFixed(2)));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.varAmt
																											.toFixed(2)));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.retQty
																											.toFixed(2)));
																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.retAmt
																											.toFixed(2)));

																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.netQty
																											.toFixed(2)));
																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.netAmt
																											.toFixed(2)));
																			tr
																					.append($(
																							'<td style="text-align:right;"></td>')
																							.html(
																									report.retAmtPer
																											.toFixed(2)));

																			$(
																					'#table_grid tbody')
																					.append(
																							tr);

																		}

																	})

													var tr = $('<tr></tr>');

													tr.append($('<td  ></td>')
															.html(" "));

													tr
															.append($(
																	'<td style="font-weight:bold;"></td>')
																	.html(
																			"Total"));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalSoldQty
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalSoldAmt
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalVarQty
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalVarAmt
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalRetQty
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalRetAmt
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalNetQty
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			totalNetAmt
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			retAmtPer
																					.toFixed(2)));

													$('#table_grid tbody')
															.append(tr);

												})

							});
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
			var selectedFr = $("#selectFr").val();
			var selectedSubCatIdList = $("#item_grp2").val();
			var from_date = $("#fromDate").val();
			var to_date = $("#toDate").val();

			window
					.open('${pageContext.request.contextPath}/pdfForReport?url=pdf/showSummeryFrAndSubCatPdf/'
							+ from_date
							+ '/'
							+ to_date
							+ '/'
							+ selectedFr
							+ '/' + selectedSubCatIdList);

		}
	</script>


	<script type="text/javascript">
		function getSubCategoriesByCatId() {
			var catId = $("#item_grp1").val();

			$
					.getJSON(
							'${getGroup2ByCatId}',
							{
								catId : JSON.stringify(catId),
								ajax : 'true'
							},
							function(data) {
								var html = '<option multiple="multiple" value="">Sub Category</option>';

								var len = data.length;

								$('#item_grp2').find('option').remove().end()

								/* $("#item_grp2")
										.append(
												$("<option ></option>").attr(
														"value", "").text(
														"Select Sub Category")); */
								$("#item_grp2").append(
										$("<option></option>")
												.attr("value", -1).text("ALL"));
								for (var i = 0; i < len; i++) {
									$("#item_grp2").append(
											$("<option ></option>").attr(
													"value", data[i].subCatId)
													.text(data[i].subCatName));
								}
								$("#item_grp2").trigger("chosen:updated");
							});
		}
	</script>






</body>
</html>
