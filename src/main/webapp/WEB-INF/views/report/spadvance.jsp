<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>

<!--topLeft-nav-->
<div class="sidebarOuter"></div>
<!--topLeft-nav-->

<!--wrapper-start-->
<div class="wrapper">

	<!--topHeader-->
	<c:url var="getSpAdvance" value="/getSpAdvance" />
	<jsp:include page="/WEB-INF/views/include/logo.jsp"></jsp:include>


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
			<div class="sidebarright">
				<div class="order-left">
					<h2 class="pageTitle">Sp Advance Report</h2>

				</div>
				<form id="validation-form">
					<input type="hidden" value="${gstType}" name="type" id="type" />

					<div class="colOuter">
						<!-- copy div kalpesh -->

						<div class="col-md-1">From Date</div>
						<div class="col-md-2">
							<input id="datepicker" class="texboxitemcode texboxcal"
								value="${cDate}" autocomplete="off" name="from_Date" type="text"
								placeholder="From Date">
						</div>

						<div class="col-md-1">TO</div>
						<div class="col-md-2">
							<input id="datepicker2" class="texboxitemcode texboxcal"
								value="${cDate}" autocomplete="off" name="to_Date" type="text"
								placeholder="To Date">
						</div>

						<div class="col-md-1"></div>
						<div class="col-md-1">
							<button type="button" class="btn  buttonsaveorder"
								onclick="searchSpAdv()">Search</button>
						</div>

						<div class="col-md-1">
							<button type="button" class="btn  buttonsaveorder" id='pdf'
								onclick="genPdf()" disabled>Pdf</button>
							<input type="hidden" name="frId" id="frId" value="${frId}">
						</div>
					</div>

					<!--tabNavigation-->
					<div class="cd-tabs">
						<!--tabMenu-->

						<!--tabMenu-->

						<div id="table-scroll">
							<div id="faux-table" class="faux-table" aria="hidden"
								style="display: none;">
								<div class="table-wrap">
									<table id="table_grid" class="main-table" border="1">
										<thead>
											<tr class="bgpink">
												<!-- <th width="5%" style="text-align: center;">Sr No</th>
												<th style="text-align: center;">Customer Name</th>
												<th style="text-align: center;">Item Name</th>
												<th width="10%" style="text-align: center;">Order Date</th>
												<th width="10%" style="text-align: center;">MRP</th>
												<th width="10%" style="text-align: center;">Advance Amt</th> -->
											</tr>
										</thead>
									</table>
								</div>
							</div>
							<div>
								<table id="table_grid" class="responsive-table" border="1">
									<thead>
										<tr class="bgpink">
											<th width="5%" style="text-align: center;">Sr No</th>
											<th style="text-align: center;">Customer Name</th>
											<th width="10%" style="text-align: center;">Mobile no</th>
											<th style="text-align: center;">Item Name</th>
											<th width="10%" style="text-align: center;">Flavour</th>
											<th width="10%" style="text-align: center;">KG</th>
											<th width="10%" style="text-align: center;">Order Date</th>
											<th width="10%" style="text-align: center;">MRP</th>
											<th width="10%" style="text-align: center;">Advance Amt</th>
											<th width="10%" style="text-align: center;">Del Date</th>

										</tr>
									</thead>
									<tbody>

										<c:forEach items="${grnList}" var="grnList" varStatus="count">
											<tr>
												<td class="col-md-3"><c:out
														value="${grnList.grngvnSrno}" /> <input type="hidden"
													name="headerId" id="headerId"
													value="${grnList.grnGvnHeaderId}"></td>
												<td class="col-md-2" align="left"><c:out
														value="${grnList.grngvnDate}" /></td>
												<td class="col-md-2" style="text-align: right"><c:out
														value="${grnList.taxableAmt}" /></td>
												<td class="col-md-2" style="text-align: right"><c:out
														value="${grnList.taxAmt}" /></td>
												<td class="col-md-2" style="text-align: right"><c:out
														value="${grnList.totalAmt}" /></td>

												<td class="col-md-2" style="text-align: right"><fmt:formatNumber
														type="number" minFractionDigits="2" maxFractionDigits="2"
														value="${grnList.apporvedGrandTotal}" /> <%-- <c:out value="${grnList.taxableAmt}" /> --%></td>
												<c:set var="status" value="a"></c:set>
												<c:choose>
													<c:when test="${grnList.grngvnStatus==1}">
														<c:set var="status" value="Pending"></c:set>

													</c:when>
													<c:when test="${grnList.grngvnStatus==2}">
														<c:set var="status" value="Approved From Dispatch"></c:set>
													</c:when>

													<c:when test="${grnList.grngvnStatus==3}">
														<c:set var="status" value="Reject From Dispatch"></c:set>
													</c:when>

													<c:when test="${grnList.grngvnStatus==4}">
														<c:set var="status" value="Approved From Sales"></c:set>
													</c:when>

													<c:when test="${grnList.grngvnStatus==5}">
														<c:set var="status" value="Reject From Sales"></c:set>
													</c:when>

													<c:when test="${grnList.grngvnStatus==6}">
														<c:set var="status" value="Approved From Account"></c:set>
													</c:when>

													<c:when test="${grnList.grngvnStatus==7}">
														<c:set var="status" value="Reject From Account"></c:set>
													</c:when>

													<c:otherwise>
														<c:set var="status" value="Partially Approved"></c:set>
													</c:otherwise>

												</c:choose>
												<td class="col-md-3"><c:out value="${status}"></c:out></td>
												<c:set var="isCredit" value="a"></c:set>

												<c:choose>
													<c:when test="${grnList.isCreditNote==1}">
														<c:set var="isCredit" value="Yes"></c:set>
													</c:when>
													<c:otherwise>
														<c:set var="isCredit" value="No"></c:set>
													</c:otherwise>
												</c:choose>

												<td class="col-md-1"><c:out value="${isCredit}"></c:out></td>

												<td class="col-md-1"><c:out
														value="${grnList.creditNoteId}"></c:out></td>

												<td class="col-md-2"><a href='#' class='action_btn'
													onclick="getGrnDetail(${grnList.grnGvnHeaderId})"><abbr
														title='Detail'><i class='fa fa-list'></i></abbr></a><a
													href='#' class='action_btn'
													onclick="genPdf(${grnList.grnGvnHeaderId})"><abbr
														title='Pdf'><i class='far fa-file-pdf'></i></abbr></a></td>


												<%-- <td class="col-md-1"><a href='#' class='action_btn'
													onclick="genPdf(${grnList.grnGvnHeaderId})"><abbr
														title='Pdf'><i class='fa fa-list'></i></abbr></a></td> --%>

												<%-- <input type="button" onclick="getGrnDetail(${grnList.grnGvnHeaderId})" id="grnDetailButton" value="Detail"></td> --%>

											</tr>
										</c:forEach>



									</tbody>

								</table>
							</div>
						</div>

						<div class="col-sm-3  controls">
							<input type="button" id="expExcel" class="btn btn-primary"
								value="EXPORT TO Excel" onclick="exportToExcel();"
								disabled="disabled">
						</div>



					</div>
					<!--tabNavigation-->


				</form>
			</div>

			<!--rightSidebar-->

		</div>
		<!--fullGrid-->
	</div>
	<!--rightContainer-->

</div>
<!--wrapper-end-->





<script type="text/javascript">
		function searchSpAdv() {

			$('#table_grid td').remove();

				var fromDate = document.getElementById("datepicker").value;
				var toDate = document.getElementById("datepicker2").value;
				
				//alert(fromDate + toDate);

				$.getJSON('${getSpAdvance}', {

					fromDate : fromDate,
					toDate : toDate,
					ajax : 'true'

				}, function(data) {
					
					var totalAmt=0;
					var totalMrp=0;

					$.each(data, function(key, spAdv) {
						//alert(data);
						
						if(data!=null){
							 document.getElementById("pdf").disabled = false; 
								document.getElementById("expExcel").disabled = false;


						}
						var tr = $('<tr></tr>');
						
				
								
						tr.append($('<td   ></td>').html(key+1));
						tr.append($('<td  style="text-align:left;"></td>').html(spAdv.custName));
						tr.append($('<td  style="text-align:center;"></td>').html(spAdv.spCustMobNo));
						tr.append($('<td  style="text-align:left;"></td>').html(spAdv.itemName));
						tr.append($('<td  style="text-align:left;"></td>').html(spAdv.spfName));
						tr.append($('<td  style="text-align:right;"></td>').html(spAdv.weight));
						tr.append($('<td  ></td>').html(spAdv.orderDate));
						tr.append($('<td   style="text-align:right;"></td>').html(spAdv.totalMrp.toFixed(2)));
						tr.append($('<td   style="text-align:right;"></td>').html(spAdv.advAmt.toFixed(2)));
						tr.append($('<td  ></td>').html(spAdv.delDate));
						
						totalAmt=totalAmt+spAdv.advAmt;
						totalMrp=totalMrp+spAdv.totalMrp;
						
						
					
$('#table_grid tbody')
	.append(
			tr);
			
})

var tr = $('<tr></tr>');
					
				
						tr.append($('<td  ></td>').html(""));
						tr.append($('<td  ></td>').html("Total"));
						tr.append($('<td  ></td>').html(""));
						tr.append($('<td  ></td>').html(""));  
						tr.append($('<td  ></td>').html(""));
						tr.append($('<td  ></td>').html(""));
						tr.append($('<td  ></td>').html(""));
						tr.append($('<td   style="text-align:right;"></td>').html(totalMrp.toFixed(2)));
						tr.append($('<td   style="text-align:right;"></td>').html(totalAmt.toFixed(2)));
						tr.append($('<td  ></td>').html(""));
				
$('#table_grid tbody')
	.append(
			tr);

});
				

			
//}//if block
}
		
document.getElementById("pdf").disabled = true;

	</script>


<script type="text/javascript">

function getGrnDetail(headerId){
			//alert("HIII");
			//alert("header ID "+headerId)
			
			var fromDate =$("#datepicker").val();
			var toDate =$("#datepicker2").val();
		    var form = document.getElementById("validation-form");
		    form.action ="getGrnDetailList/"+headerId;
		    form.submit();
		}
</script>

<script type="text/javascript">
		function validate() {
		
			var fromDate =$("#datepicker").val();
			var toDate =$("#datepicker2").val();
			
			var headeIdText=$("#headeIdText").val();
		//	alert(headeIdText);
			
			var isValid = true;
		
			if (fromDate == "" || fromDate == null) {

				isValid = false;
				alert("Please select From Date");
			}
		 else if (toDate == "" || toDate == null) {

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


	</script>
<script type="text/javascript">
	function genPdf() {
		var isValid = validate();
		if (isValid == true) {
			var fromDate = document.getElementById("datepicker").value;
			var toDate = document.getElementById("datepicker2").value;
			var frId = document.getElementById("frId").value;
			window
					.open('${pageContext.request.contextPath}/pdf?reportURL=pdf/getSpAdvPdfPd/'
							+ fromDate + '/' + toDate + '/' + frId);
		}
	}
	function validate() {

		var fromDate = document.getElementById("datepicker").value;
		var toDate = document.getElementById("datepicker2").value;

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

/* function genPdf() {
		 
		    
		    window.open('${pageContext.request.contextPath}/getSpAdvPdf');
		   
	} */
	
function exportToExcel() {

	window.open("${pageContext.request.contextPath}/exportToExcelNew");
	document.getElementById("expExcel").disabled = true;
}
	</script>

</body>
</html>