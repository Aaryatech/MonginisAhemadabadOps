ProdWiseCreditNote<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
<style>
table, th, td {
	border: 1px solid #9da88d;
}
</style>

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

<c:url var="getHeaders" value="/getDatewiseSales" />
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
						<h2 class="pageTitle">Product Wise Credit Note Report</h2>
					</div>
				</div>
				<input type="hidden" value="${frId}" id="frId" name="frId">
				<div class="row">
					<form action="" class="form-horizontal" method="get"
						id="validation-form">

						<div class="col-md-2 from_date">
							<h4 class="pull-left">From Date:-</h4>
						</div>
						<div class="col-md-2 ">
							<input id="fromdatepicker" autocomplete="off"
								class="texboxitemcode texboxcal" placeholder="DD-MM-YYYY"
								name="fromDate" type="text">
						</div>
						<div class="col-md-1">
							<h4 class="pull-left">To</h4>
						</div>
						<div class="col-md-2 ">
							<input id="todatepicker" autocomplete="off"
								class="texboxitemcode texboxcal" placeholder="DD-MM-YYYY"
								name="toDate" type="text" >
						</div>
						
						<div class="col-md-2">
							<!-- <button class="btn search_btn pull-left" onclick="searchReport()">Search</button> -->
							<input type="button" value="Search" style="display: none;" onclick="searchReport()"
								class="btn search_btn pull-left">
							<button class="btn btn-primary" value="PDF" id="PDFButton"
								onclick="genPdf()">PDF</button>

						</div>
					</form>

				</div>

				<div class="row">
					<div class="clearfix"></div>


					<div id="table-scroll">
						<!-- <div id="faux-table" class="faux-table" aria="hidden">
							<table id="table2" class="main-table" border="1">
								<thead>
									<tr class="bgpink">
										<th>Sr No.</th>

										<th class="col-sm-1"><input type="checkbox"
											onClick="selectBillNo(this)" /></th>
										<th class="col-sm-1" style="text-align: center;">Date</th>
										<th class="col-sm-1" style="text-align: center;">CRN Id</th>
										<th class="col-md-2" style="text-align: center;">Inv. No
										</th>
										<th class="col-md-2" style="text-align: center;">Franchise</th>
										<th class="col-md-1" style="text-align: center;">Taxable
											Amt</th>
										<th class="col-md-2" style="text-align: center;">Tax Amt</th>

										<th class="col-md-2" style="text-align: center;">Amount</th>
										<th class="col-sm-1">Action</th>
									</tr>

								</thead>
								<tbody>
							</table>
						</div> -->
						<div>
							<table id="table1" style="display: none;" class="responsive-table" border="1">
								<thead>
									<tr class="bgpink">

										
										<th width="2%">Sr No.</th>
										<th class="col-sm-1" style="text-align: center;">Date</th>
									<th style="text-align: center;" >Taxable Value</th>
									<th style="text-align: center;" >Tax Value</th>
									<th style="text-align: center;" >Grand Total</th>
									<th style="text-align: center;" >GRN Taxable Value</th>
									<th style="text-align: center;" >GRN Tax Value</th>
									<th  style="text-align: center;">GRN Grand Total</th>
									<th style="text-align: center;" >GVN Taxable Value</th>
									<th style="text-align: center;" >GVN Tax Value</th>
									<th style="text-align: center;" >GVN Grand Total</th>
									<th style="text-align: center;" >NET Taxable Total</th>
									<th style="text-align: center;" >NET Tax Total</th>
									<th style="text-align: center;" >NET Grand Total</th>
									</tr>

								</thead>
								<tbody>
							</table>
							<div class="form-group" style="display: none;"  id="range">
							<div class="col-sm-3  controls">
							<input type="button" id="expExcel" class="btn btn-primary"
								value="EXPORT TO Excel" onclick="exportToExcel();"
								>
						</div>
					</div>

						</div>
						

					</div>
					<!--table end-->
					<br>
					
					
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


<script>

function selectBillNo(source) {
    var checkboxes = document.querySelectorAll('input[type="checkbox"]');
    for (var i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i] != source)
            checkboxes[i].checked = source.checked;
    }
}

/* function Gpdf(){
	
	var fromDate = $("#fromdatepicker").val();
	var toDate = $("#todatepicker").val();
	var frId=$("#frId").val();
	window
	.open('pdfForReport?url=pdf/showSaleBillwiseGrpByDatePdf/'
			+ fromDate
			+ '/'
			+ toDate
			+ '/'
			+ frId
			+ '/' + '00' + '/');
} */

  
function genPdf() {
	var selectedFr = $("#frId").val();
	var routeId = 0;
	var from_date = $("#fromdatepicker").val();
	var to_date = $("#todatepicker").val();

	window
			.open('${pageContext.request.contextPath}/creditNoteReportBetweenDatePdf?fromDate='
					+ from_date
					+ '&toDate='
					+ to_date
					+ '&selectedFr='
					+ selectedFr);

}
	
	function exportToExcel() {

		window
				.open("${pageContext.request.contextPath}/exportToExcelNew");
		document.getElementById("expExcel").disabled = true;
	}
</script>




<script type="text/javascript">
	function searchReport() {

		//	alert("in side get Header ");

		var fromDate = $("#fromdatepicker").val();
		var toDate = $("#todatepicker").val();
		var frId=$("#frId").val();
		var valid = true;

		if (fromDate == null || fromDate == "") {
			valid = false;
			alert("Please select from date");
		}

		else if (toDate == null || toDate == "") {
			valid = false;
			alert("Please select to date");
		}

		/* if (fromDate > toDate) {
			valid = false;
			alert("from date greater than todate ");
		} */

		if (valid == true) {

			$
					.getJSON(
							'${getHeaders}',
							{
								fromDate : fromDate,
								toDate : toDate,
								frId	: frId,
								ajax : 'true',

							},
							function(data) {
								//alert(JSON.stringify(data));
								//alert(data.length)
								var len = data.length;

								$('#table1 td').remove();

								
								

								var totalGrnGrandTotal = 0;
								var totalGrnTaxableAmt = 0;
								var totalGrnTax = 0;

								var totalGvnGrandTotal = 0;
								var totalGvnTax = 0;
								var totalGvnTaxableAmt = 0;

								var totalGrandTotal = 0;
								var totalTax = 0;
								var totalTaxableAmt = 0;

								var totalNetGrandTotal = 0;
								var totalNetTax = 0;
								var totalNetTaxableAmt = 0;

								$
										.each(
												data,
												function(key, report) {

													totalGrnGrandTotal = totalGrnGrandTotal
															+ report.grnGrandTotal;
													totalGrnTaxableAmt = totalGrnTaxableAmt
															+ report.grnTaxableAmt;
													totalGrnTax = totalGrnTax
															+ report.grnTotalTax;

													totalGvnGrandTotal = totalGvnGrandTotal
															+ report.gvnGrandTotal;
													totalGvnTaxableAmt = totalGvnTaxableAmt
															+ report.gvnTaxableAmt;
													totalGvnTax = totalGvnTax
															+ report.gvnTotalTax;

													totalGrandTotal = totalGrandTotal
															+ report.grandTotal;
													totalTax = totalTax
															+ report.totalTax;
													totalTaxableAmt = totalTaxableAmt
															+ report.taxableAmt;

													totalNetGrandTotal = totalNetGrandTotal
															+ report.netGrandTotal;
													totalNetTax = totalNetTax
															+ report.netTotalTax;

													totalNetTaxableAmt = totalNetTaxableAmt
															+ report.netTaxableAmt;

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
																			report.billDate));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.taxableAmt
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.totalTax
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.grandTotal
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.grnTaxableAmt
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.grnTotalTax
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.grnGrandTotal
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.gvnTaxableAmt
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.gvnTotalTax
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.gvnGrandTotal
																					.toFixed(2)));

													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.netTaxableAmt
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.netTotalTax
																					.toFixed(2)));
													tr
															.append($(
																	'<td style="text-align:right;"></td>')
																	.html(
																			report.netGrandTotal
																					.toFixed(2)));

													$(
															'#table1 tbody')
															.append(tr);

												})

								var tr = $('<tr></tr>');

								tr.append($('<td></td>').html(""));

								tr
										.append($(
												'<td style="font-weight:bold;"></td>')
												.html("Total"));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalTaxableAmt
																.toFixed(2)));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalTax
																.toFixed(2)));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGrandTotal
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGrnTaxableAmt
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGrnTax
																.toFixed(2)));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGrnGrandTotal
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGvnTaxableAmt
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGvnTax
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalGvnGrandTotal
																.toFixed(2)));

								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalNetTaxableAmt
																.toFixed(2)));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalNetTax
																.toFixed(2)));
								tr
										.append($(
												'<td style="text-align:right;"></td>')
												.html(
														totalNetGrandTotal
																.toFixed(2)));

								$('#table1 tbody').append(tr);

							
								
								
								
							});
		}

	}
</script>

<script type="text/javascript">
	function getCrnDetail(crnId) {
		//alert("HIII");
		//alert("header ID "+headerId)

		//alert("HHHHHH");
		var form = document.getElementById("validation-form");
		form.action = "${pageContext.request.contextPath}/getCrnDetailList/"
				+ crnId;
		form.submit();
	}
</script>

<script>
	function genPdfSingle(selArray) {
		//alert("Inside Gen Pdf ");
		//alert("Inside Gen Pdf " + selArray);

		window
				.open('${pageContext.request.contextPath}/billPdf?url=pdf/getCrnCheckedHeadersNew/'
						+ selArray);

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
	/*
	//  jquery equivalent
	jQuery(document).ready(function() {
	jQuery(".main-table").clone(true).appendTo('#table-scroll .faux-table').addClass('clone');
	jQuery(".main-table.clone").clone(true).appendTo('#table-scroll .faux-table').addClass('clone2'); 
	});
	 */
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

	/* function exportToExcel() {

		window.open("${pageContext.request.contextPath}/exportToExcel");
		document.getElementById("expExcel").disabled = true;
	} */
</script>

<!-- onclick="var checkedVals = $('.chk:checkbox:checked').map(function() { return this.value;}).get();checkedVals=checkedVals.join(',');if(checkedVals==''){alert('No Rows Selected');return false;	}else{   return confirm('Are you sure want to generate pdf');}"
 -->
</body>
</html>
