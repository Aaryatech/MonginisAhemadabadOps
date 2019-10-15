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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/dropdownmultiple/bootstrap-chosen.css">
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
		$(function() {
			$("#toDateItem").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
		$(function() {
			$("#fromDateItem").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
	</script>
	<!--datepicker-->


	<c:url var="getBillList" value="/getFrSubCatYearlySellReport"></c:url>
	<c:url var="getItemList" value="/getItemYearlySellReport"></c:url>



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
								<h2 class="pageTitle">Sub-Category Month Wise Sell Report</h2>
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


						<br> <br>
						<div class="row">


							<div class="form-group">
								<div class="col-sm-3 col-lg-2	">From Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="fromDate" name="fromDate"
										size="30" type="text" value="${fromDate}" />
								</div>

								<!-- </div>

					<div class="form-group  "> -->

								<div class="col-sm-3 col-lg-2	">To Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="toDate" name="toDate" size="30"
										type="text" value="${toDate}" />
								</div>
							</div>

						</div>

						<br> <br>

						<div class="row">
							<div class="col-md-2">Select Category</div>
							<div class="col-md-4" style="text-align: left;">
								<select data-placeholder="Select Group" name="item_grp1"
									tabindex="-1" onchange="getSubCategoriesByCatId()"
									id="item_grp1" data-rule-required="true"
									data-placeholder="Choose Menus..." class="chosen-select"
									style="text-align: left;" required multiple="multiple">

									<option value="-1">Select All</option>

									<c:forEach items="${mCategoryList}" var="mCategoryList">
										<option value="${mCategoryList.catId}"><c:out
												value="${mCategoryList.catName}"></c:out></option>
									</c:forEach>


								</select>
							</div>

							<div class="col-sm-2 col-lg-2 ">Sub Category</div>
							<div class="col-md-4">
								<select data-placeholder="Select Sub Category"
									class="chosen-select" name="item_grp2" id="item_grp2"
									style="text-align: left;" required multiple="multiple">



								</select>
							</div>

						</div>
						<br> <br>




						<div class="row">
							<div class="form-group">



								<div class="col-sm-12 " style="text-align: center;">
									<input type="button" id="submit" class="btn btn-primary"
										value="Search Report" onclick="searchReport()">
								</div>

							</div>
						</div>

						<br> <br>

					</form>

					<!-- form -->


					<form id="submitItemForm" action="#" method="get">

						<div class="row">
							<div class="col-md-12">
								<h2 class="pageTitle">Item Month Wise Sell Report</h2>
							</div>
						</div>



						<br> <br>



						<div class="row">


							<div class="form-group">
								<div class="col-sm-3 col-lg-2	">From Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="fromDateItem" name="fromDateItem"
										size="30" type="text" value="${fromDate}" />
								</div>


								<div class="col-sm-3 col-lg-2	">To Date</div>
								<div class="col-sm-6 col-lg-4 controls date_select">
									<input class="texboxitemcode texboxcal"
										placeholder="DD-MM-YYYY" id="toDateItem" name="toDateItem"
										size="30" type="text" value="${toDate}" />
								</div>
							</div>

						</div>

						<br> <br>

						<div class="row">
							<div class="col-md-2">Select Category</div>
							<div class="col-md-4" style="text-align: left;">
								<select data-placeholder="Select Group" id="item_grp1Item"
									name="item_grp1Item" tabindex="-1"
									data-placeholder="Choose Category" class="chosen-select"
									style="text-align: left;" required multiple="multiple">

									<option value="-1">Select All</option>

									<c:forEach items="${mCategoryList}" var="mCategoryList">
										<option value="${mCategoryList.catId}"><c:out
												value="${mCategoryList.catName}"></c:out></option>
									</c:forEach>


								</select>
							</div>


						</div>

						<br> <br>

						<div class="row">
							<div class="form-group">



								<div class="col-sm-12 " style="text-align: center;">
									<input type="button" id="submitItem" class="btn btn-primary"
										value="Search Report" onclick="searchItemReport()">
								</div>

							</div>
						</div>


					</form>

					<!-- FORM -->



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
	<!-- <script type="text/javascript"
		src="https://www.gstatic.com/charts/loader.js"></script> -->
	<!--easyTabs-->

	<script
		src="${pageContext.request.contextPath}/resources/dropdownmultiple/chosen.jquery.js"></script>
	<script
		src="${pageContext.request.contextPath}/resources/dropdownmultiple/chosen-active.js"></script>
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

			var from_date = $("#fromDate").val();
			var to_date = $("#toDate").val();

			$('#loader').show();

			$.getJSON('${getBillList}',

			{
				frId : frId,
				subCat_id_list : JSON.stringify(selectedSubCat),
				cat_id_list : JSON.stringify(selectedCat),
				fromDate : from_date,
				toDate : to_date,
				ajax : 'true'

			}, function(data) {

				exportToExcel();

			});
		}
	</script>



	<script>
		function exportToExcel() {

			window.open("${pageContext.request.contextPath}/exportToExcelNew");
			document.getElementById("expExcel").disabled = true;
		}

		function exportToExcelItem() {

			window.open("${pageContext.request.contextPath}/exportToExcelNew");
			document.getElementById("expExcel").disabled = true;
		}
	</script>






	<script type="text/javascript">
		function searchItemReport() {
			//	var isValid = validate();

			var frId = document.getElementById("frId").value;
			var selectedCat = $("#item_grp1Item").val();

			var from_date = $("#fromDateItem").val();
			var to_date = $("#toDateItem").val();

			$('#loader').show();

			$.getJSON('${getItemList}',

			{
				frId : frId,
				cat_id_list : JSON.stringify(selectedCat),
				fromDate : from_date,
				toDate : to_date,
				ajax : 'true'

			}, function(data) {

				exportToExcelItem();

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
								$('.chosen-select').trigger('chosen:updated');

							});
		}
	</script>






</body>
</html>
