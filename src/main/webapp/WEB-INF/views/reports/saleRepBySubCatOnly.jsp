<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
<%@ page import="com.monginis.ops.constant.Constant"%>



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

<c:url var="getBillList" value="/getSubCatReport"></c:url>

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
						<h2 class="pageTitle">Subcategory Summery Report</h2>
					</div>
				</div>
				<input type="hidden" name="factoryName" id="factoryName"
					value="${Constant.FACTORYNAME}">

				<div class="row">
					<input type="hidden" name="frId" id="frId" value="${frId}">
					<div class="col-md-2 from_date">
						<h4 class="pull-left">From Date:-</h4>
					</div>
					<div class="col-md-2 ">
						<input id="fromdatepicker" autocomplete="off"
							class="texboxitemcode texboxcal" placeholder="DD-MM-YYYY"
							name="fromDate" type="text">
					</div>
					<div class="col-md-1">
						<h4 class="pull-left">To:-</h4>
					</div>
					<div class="col-md-2 ">
						<input id="todatepicker" autocomplete="off"
							class="texboxitemcode texboxcal" placeholder="DD-MM-YYYY"
							name="toDate" type="text">
					</div>
					<div class="col-md-2">
						<button class="btn search_btn pull-left" onclick="searchReport()">Search</button>
						<%-- 		  &nbsp;&nbsp;&nbsp;  <a href='${pageContext.request.contextPath}/pdf?reportURL=showPurchaseTaxBillwiseReportPdf' id="btn_pdf" class="btn search_btn" style="display: none">PDF</a>
 --%>
						<button class="btn btn-primary" value="PDF" id="PDFButton"
							onclick="genPdf()">PDF</button>
					</div>

				</div>

				<div class="row">
					<div class="col-md-12">
						<!--table-->
						<div class="clearfix"></div>


						<div id="table-scroll">
							<div id="faux-table" class="faux-table" aria="hidden"
								style="display: none;">
								<table id="table_grid1" class="main-table" border="1">
									<thead>
										<tr class="bgpink">

											<!-- 							
									<th class="col-md-1">Sr. NO.</th>
									<th class="col-md-1">Party Name</th>
									<th class="col-md-1">GSTIN</th>
									<th class="col-md-1">Bill No</th>
									<th class="col-md-1">Bill Date</th>
									
									<th class="col-md-1">Taxable Amt</th>
									<th class="col-md-1">Tax Rate</th>
									<th class="col-md-1">IGST</th>
									<th class="col-md-1">CGST</th>
									<th class="col-md-1">SGST</th>
									<th class="col-md-1">Bill Amount</th>
									<th class="col-md-1">CESS</th> -->
										</tr>

									</thead>
									<tbody>
								</table>
							</div>
							<div>
								<table id="table_grid" class="responsive-table" border="1">
									<thead>
										<tr class="bgpink">

											<th>Sr.No.</th>
											<th>Sub Category Name</th>
											<th>Pur Qty</th>
											<th>Pur Amt</th>
											<th>Var Qty</th>
											<th>Var Amt</th>
											<th>Ret Qty</th>
											<th>Ret Amt</th>
											<th>Net Qty</th>
											<th>Net Amt</th>
											<th>Ret Amt</th>
										</tr>

									</thead>
									<tbody>
								</table>

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
						<!--table end-->

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
	function searchReport() {
		//	var isValid = validate();
		var from_date = $("#fromdatepicker").val();
		var to_date = $("#todatepicker").val();
		$('#loader').show();

		$.getJSON('${getBillList}',

		{

			fromDate : from_date,
			toDate : to_date,

			ajax : 'true'

		}, function(data) {

			//alert(data);

			$('#table_grid td').remove();
			$('#loader').hide();

			if (data == "") {
				alert("No records found !!");
				document.getElementById("expExcel").disabled = true;
			}

			var totalSoldQty = 0;
			var totalSoldAmt = 0;
			var totalVarQty = 0;
			var totalVarAmt = 0;
			var totalRetQty = 0;
			var totalRetAmt = 0;
			var totalNetQty = 0;
			var totalNetAmt = 0;
			var retAmtPer = 0;

			$.each(data, function(key, report) {

				totalSoldQty = totalSoldQty + report.soldQty;
				totalSoldAmt = totalSoldAmt + report.soldAmt;
				totalVarQty = totalVarQty + report.varQty;
				totalVarAmt = totalVarAmt + report.varAmt;
				totalRetQty = totalRetQty + report.retQty;
				totalRetAmt = totalRetAmt + report.retAmt;
				totalNetQty = totalNetQty + report.netQty;
				totalNetAmt = totalNetAmt + report.netAmt;
				retAmtPer = retAmtPer + report.retAmtPer;

				document.getElementById("expExcel").disabled = false;
				document.getElementById('range').style.display = 'block';
				var index = key + 1;
				//var tr = "<tr>";

				var tr = $('<tr></tr>');

				tr.append($('<td></td>').html(key + 1));

				tr.append($('<td style="text-align:left;"></td>').html(
						report.subCatName));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.soldQty.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.soldAmt.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.varQty.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.varAmt.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.retQty.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.retAmt.toFixed(2)));

				tr.append($('<td style="text-align:right;"></td>').html(
						report.netQty.toFixed(2)));
				tr.append($('<td style="text-align:right;"></td>').html(
						report.netAmt.toFixed(2)));
				tr.append($('<td style="text-align:right;"></td>').html(
						report.retAmtPer.toFixed(2)));

				$('#table_grid tbody').append(tr);

			})

			var tr = $('<tr></tr>');

			tr.append($('<td  ></td>').html(" "));

			tr.append($('<td style="font-weight:bold;" style="text-align:left;"></td>').html("Total"));
			
			tr.append($('<td style="text-align:right;"></td>').html(
					totalSoldQty.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalSoldAmt.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalVarQty.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalVarAmt.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalRetQty.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalRetAmt.toFixed(2)));

			tr.append($('<td style="text-align:right;"></td>').html(
					totalNetQty.toFixed(2)));
			tr.append($('<td style="text-align:right;"></td>').html(
					totalNetAmt.toFixed(2)));

			tr.append($('<td style="text-align:right;"></td>').html(
					retAmtPer.toFixed(2)));

			$('#table_grid tbody').append(tr);

		});

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

		window.open("${pageContext.request.contextPath}/exportToExcelNew");
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
					.open('${pageContext.request.contextPath}/pdf?reportURL=pdf/showSaleReportBySubCatPdf/'
							+ fromDate + '/' + toDate + '/' + frId);
		}
	}
</script>
</body>
</html>
