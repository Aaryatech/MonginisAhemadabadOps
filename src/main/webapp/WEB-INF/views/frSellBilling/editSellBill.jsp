<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/include/header.jsp" />

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- <!DOCTYPE html>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport"
	content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">

<title>Monginis</title>


<link
	href="${pageContext.request.contextPath}/resources/css/monginis.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/resources/css/custom.css" rel="stylesheet" type="text/css"/>	
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">	
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/images/feviconicon.png"
	type="image/x-icon" />
	
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>	
	
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/jquery-1.10.2.min.js"></script>

<!--rightNav-->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/menuzord.js"></script>
	
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#menuzord").menuzord({
		align:"left"
	});
});
</script> --%>
<!--rightNav-->
<!--datepicker-->

<c:url var="getSelectedIdForPrint" value="/billDetailPrint" />


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


<!-- </head>
<body>
 -->

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
						<h2 class="pageTitle">Edit Bill Details</h2>
					</div>
				</div>

				<div class="row">

					<div class="col-md-2 from_date">
						<h4 class="pull-left">
							Bill No:- <b>${sellBillNo}</b>
						</h4>
					</div>
					<div class="col-md-2 "></div>
					<div class="col-md-3">
						<h4 class="pull-left">
							Bill Date:- <b> ${billDate}</b>
						</h4>
					</div>
					<div class="col-md-2 "></div>

				</div>
				<br />
	<form name="editSellBill" id="editSellBill" method="post"
					action="${pageContext.request.contextPath}/editSellBill"   	onsubmit="updateBill.disabled = true; if((document.getElementById('remAmt').value)>0){ return confirm('Do you want to update bill?(Paid amount is less than invoice amount)');}else{ return confirm('Do you want to update bill ?');}">
			<input type="hidden" name="sellBillNo" id="sellBillNo" value="${sellBillNo}" />
				<input type="hidden" name="billDate" id="billDate" value="${billDate}" />
				<input type="hidden" name="totalAmount" id="totalAmount" />
				<div class="row">
					<div class="col-md-12">
						<!--table-->
						<div class="table-responsive">
							<div class="shInnerwidth">

							
								<table width="100%" border="0" cellspacing="0" cellpadding="0"
									id="table_grid6" class="table table-bordered">
									<tr class="bgpink">
										<th>Sr</th>
										<th>Item Name
										</th>
										<th>Qty
										</th>
										<th>Edit Qty
										</th>
										<th>MRP Base Rate
										</th>
										<th>Taxable Amount
										</th>
										<th>Tax %
										</th>
										<th>Total Tax
										</th>
										<th>MRP
										</th>

										<th>Total
										</th>


									</tr>
									<tbody>

										<c:set var="taxableSum" value="0"></c:set>
										<c:set var="taxSum" value="0"></c:set>
										<c:set var="totalSum" value="0"></c:set>
										<c:set var="qtySum" value="0"></c:set>


										<c:forEach items="${sellBillDetails}" var="sellBill"
											varStatus="count">

											<tr>
												<td><c:out value="${count.index+1}" /></td>
											
												<td style="text-align:left;"><c:out value="${sellBill.itemName}" /></td><td style="text-align:right;">${sellBill.qty}</td>
												<td style="text-align:center;"><input type="number" min="0"  class="form-control" style="width:90px;" value="${sellBill.qty}" id="qty${sellBill.sellBillDetailNo}" name="qty${sellBill.sellBillDetailNo}"  oninput="onQtyChange(${sellBill.sellBillDetailNo},${sellBillHeader.discountPer},${sellBill.mrpBaseRate},${sellBill.sgstPer},${sellBill.cgstPer},${sellBill.qty},this.value)"      onkeydown="if(event.key==='.'){event.preventDefault();}" onpaste="let pasteData = event.clipboardData.getData('text'); if(pasteData){pasteData.replace(/[^0-9]*/g,'');} "/></td>
												<td style="text-align:right;"><c:out value="${sellBill.mrpBaseRate}" /></td>
												<td style="text-align:right;" id="taxableAmt${sellBill.sellBillDetailNo}"><c:out value="${sellBill.taxableAmt}" /></td>
												<td style="text-align:right;"><c:out
														value="${sellBill.sgstPer+sellBill.cgstPer}" /></td>
												<td style="text-align:right;" id="totalTax${sellBill.sellBillDetailNo}"><c:out value="${sellBill.totalTax}" /></td>
												<td style="text-align:right;" ><c:out value="${sellBill.mrp}" /></td>
												<td style="text-align:right;" id="grandTotal${sellBill.sellBillDetailNo}" class="sum">
													<fmt:formatNumber type="number" minFractionDigits="0"
														maxFractionDigits="0" value="${sellBill.grandTotal}" groupingUsed="false"/>
												</td>
												<%-- <c:out value="${sellBill.grandTotal}" /> --%>
												<c:set var="taxableSum"
													value="${sellBill.taxableAmt +taxableSum}"></c:set>
												<c:set var="taxSum" value="${sellBill.totalTax +taxSum}"></c:set>
												<c:set var="totalSum"
													value="${sellBill.grandTotal +totalSum}"></c:set>
												<c:set var="qtySum" value="${sellBill.qty+qtySum}"></c:set>

											</tr>
										</c:forEach>
									<%-- 	<tr align="right" >
											<td width="100" colspan='3' align="right"><b>Total</b></td>
											
											<td width="100" align="right"><b><fmt:formatNumber
														type="number" maxFractionDigits="0" minFractionDigits="0"
														value="${qtySum}" /></b></td>
														<td></td>
											<td width="100" align="right"><b><fmt:formatNumber
														type="number" maxFractionDigits="0" minFractionDigits="0"
														value="${taxableSum}" /></b></td>
											<td></td>
											<td width="100" align="right"><b><fmt:formatNumber
														type="number" maxFractionDigits="2" minFractionDigits="2"
														value="${taxSum}" /></b></td>
											<td></td>
											<td width="100" align="right"><b><fmt:formatNumber
														type="number" maxFractionDigits="0" minFractionDigits="0"
														value="${totalSum}" /></b></td>
										</tr>
 --%>
									</tbody>

								</table>

							</div>
							</div>
						<!--table end-->

					</div>
				</div>
					<div class="row">
					<div class="col-md-3"><b>Previous Paid Amt : </b>&nbsp;${sellBillHeader.paidAmt}
				</div>
				<div class="col-md-2"><b>Paid Amt : </b>
				</div>
				<div class="col-md-2">
					<input type="number" name="paidAmt" class="form-control" min="0" id="paidAmt" value="${sellBillHeader.paidAmt}" min="0"   oninput="onPaidAmt(${sellBillHeader.paidAmt},${sellBillHeader.remainingAmt},this.value)"/>
				</div>
				<div class="col-md-2"><b>Remaining Amt : </b>
				</div>
				<div class="col-md-1" id="remainingAmt">
				      <fmt:formatNumber type="number" minFractionDigits="0"
														maxFractionDigits="0" value="${sellBillHeader.remainingAmt}" groupingUsed="false" />
				</div>
				<input type="hidden" name="remAmt" class="form-control"  id="remAmt" value="${sellBillHeader.remainingAmt}"/>
				</div>
				 <div align="center" style="margin-top: 2%;">
				<input	name="submit" class="buttonsaveorder" value="Update" id="updateBill" type="submit">
				</div> 
</form>
				<%-- <div align="center">
					<a href="${pageContext.request.contextPath}/viewBill"><input
						name="" class="buttonsaveorder" value="Go Back" align="center"
						type="button"></a>
				</div> --%>
			</div>
			<!--rightSidebar-->

		</div>
		<!--fullGrid-->
	</div>
	<!--rightContainer-->
</div>
<script >
	var number = document.getElementById('paidAmt');

	number.onkeydown = function(e) {
	    if(!((e.keyCode > 95 && e.keyCode < 106)
	      || (e.keyCode > 47 && e.keyCode < 58) 
	      || e.keyCode == 8)) {
	        return false;
	    }
	}

function onPaidAmt(paidAmt,remainingAmt,currentPaidAmt)
{
	
	var totalAmount=document.getElementById("totalAmount").value;
	if(parseFloat(currentPaidAmt)<=parseFloat(totalAmount)){
	var remAmt=totalAmount-currentPaidAmt;
	if(remAmt>totalAmount){
	document.getElementById("remainingAmt").innerHTML=0;
	document.getElementById("remAmt").value=0;
	}else
		{
		document.getElementById("remainingAmt").innerHTML=remAmt.toFixed(2);
		document.getElementById("remAmt").value=remAmt.toFixed(2);	
		}
	}else
		{
		alert("Paid amount should not be greator than total bill amount!");
		document.getElementById("paidAmt").value=totalAmount;
		onPaidAmt(paidAmt,remainingAmt,totalAmount);
		document.getElementById("remainingAmt").innerHTML=0;
		document.getElementById("remAmt").value=0;
		}
	
	  if(document.getElementById("remAmt").value<0)
  	{
  	
  	 document.getElementById("updateBill").style.display="none";
  	}else
  		{
     	 document.getElementById("updateBill").style.display="block";

  		}
}
$(document).ready(function() {
    var sum = 0;
    $('.sum').each(function() {
        var tot = $(this);
        sum += parseFloat(tot.text()) ;
    });
    document.getElementById("totalAmount").value=sum;
});
function calcSum() {
    var sum = 0;
    $('.sum').each(function() {
        var tot = $(this);
        sum += parseFloat(tot.text()) ;
    });
    
    document.getElementById("totalAmount").value=sum;

}
</script>
<script>

function onQtyChange(sellBillDetailNo,discountPer,mrpBaseRate,sgstPer,cgstPer,prevQty,qty){
	var paidAmount=document.getElementById('paidAmt').value;
	var val = parseFloat(qty);
	
	if(parseFloat(qty)>=0){
	var taxableAmt =parseFloat(mrpBaseRate * qty);

	var discAmt = ((taxableAmt * discountPer) / 100);
	taxableAmt = taxableAmt - discAmt;

	var sgstRs = (taxableAmt * sgstPer) / 100;
	var cgstRs = (taxableAmt * cgstPer) / 100;


	var totalTax = sgstRs + cgstRs;

	var grandTotal = totalTax + taxableAmt;
	
	document.getElementById("taxableAmt"+sellBillDetailNo).innerHTML=taxableAmt.toFixed(2);
	document.getElementById("totalTax"+sellBillDetailNo).innerHTML=totalTax.toFixed(2);
	document.getElementById("grandTotal"+sellBillDetailNo).innerHTML=Math.round(grandTotal);
	calcSum();
	var paidAmt=document.getElementById("paidAmt").value;
	var totalAmount=document.getElementById("totalAmount").value;
	var remAmt=totalAmount-paidAmt;
	
		document.getElementById("remainingAmt").innerHTML=remAmt.toFixed(2);
		document.getElementById("remAmt").value=remAmt.toFixed(2);
		  if(remAmt<0)
    	{
    	
    	 document.getElementById("updateBill").style.display="none";
    	}else
    		{
       	 document.getElementById("updateBill").style.display="block";

    		}
	
	}else
		{
		alert("Please enter valid quantity!!");
		document.getElementById("qty"+sellBillDetailNo).value=prevQty;
		onQtyChange(sellBillDetailNo,discountPer,mrpBaseRate,sgstPer,cgstPer,prevQty,prevQty);
		}
}
</script>
<!--wrapper-end-->
<!--easyTabs-->
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
<!--easyTabs-->


</body>
</html>
