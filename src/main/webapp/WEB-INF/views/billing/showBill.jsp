

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<style>
table, th, td {
	border: 1px solid #9da88d;
}
</style>
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
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/images/feviconicon.png"
	type="image/x-icon" />
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/jquery-1.10.2.min.js"></script>

<link
	href="${pageContext.request.contextPath}/resources/css/monginis.css"
	rel="stylesheet" type="text/css" />
<link
	href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/resources/css/custom.css"
	rel="stylesheet" type="text/css" />

<!--rightNav-->




</head>
<body>
 --%>

<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>


<!--datepicker-->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>
<script>
		$(function() {
			$("#fromdatepicker").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
		$(function() {
			$("#todatepicker").datepicker({
				dateFormat : 'dd-mm-yy'
			});
		});
	</script>
<!--datepicker-->

<!--topLeft-nav-->
<div class="sidebarOuter"></div>
<!--topLeft-nav-->

<!--wrapper-start-->
<div class="wrapper">

	<!--topHeader-->
	<c:url var="findAddOnRate" value="/getAddOnRate" />
	<c:url var="findItemsByCatId" value="/getFlavourBySpfId" />
	<c:url var="findAllMenus" value="/getAllTypes" />
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
				<!-- <div class="order-left">
						<h2 class="pageTitle">Bills</h2>
						<h3 class="pageTitle2">Order Date : 22-02-2017 </h3>
					</div> -->

				<form name="frm_search" id="frm_search" method="post"
					action="${pageContext.request.contextPath}/showBillProcess">
					<input type="hidden" name="mod_ser" id="mod_ser"
						value="search_result">

					
						<div class="col-md -3">
							
								<div class="col1title" align="left"><h3>Purchase Bill Details</h3></div>
						</div>
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title">From Date</div>
						</div>
						<div class="col-md-2">
							<input id="fromdatepicker" class="texboxitemcode texboxcal"
								placeholder="From Date" name="from_datepicker"  autocomplete="off" type="text" value="${fromDate}">

						</div>


						<div class="col-md-2">
							<div class="col1title">To Date</div>
						</div>
						<div class="col-md-2">
							<input id="todatepicker" class="texboxitemcode texboxcal"
								placeholder="To Date" name="to_datepicker" autocomplete="off" type="text" value="${toDate}">

						</div>

						<div align="center">
							<input name="" class="buttonsaveorder" value="Search"
								type="submit" align="center">
						</div>
					</div>

				</form>

				<!--tabNavigation-->
				<!-- <div class="cd-tabs">
						tabMenu

						tabMenu
						<ul class="cd-tabs-content">
							tab1
							<li data-content="tab1" class="selected">
								<div class="table-responsive">
									<div class="shInnerwidth">

										<table width="100%" id="table1"> my table  commment  -->


				<div class="clearfix"></div>
				<div id="table-scroll" >
					<!-- <div id="faux-table" class="faux-table" aria="hidden"></div> -->
					<div> <!-- class="table-wrap"> -->
						<table id="table_grid"  class="responsive-table"><!-- class="main-table" -->

							<thead>
								<tr class="bgpink">
								
									<th class="col-sm-1" style="text-align: center;">Invoice No</th>
									<th class="col-md-1" style="text-align: center;">Date</th>

									<th class="col-md-1" style="text-align: center;">Taxable Amt</th>
									<th class="col-md-1" style="text-align: center;">Tax Amt</th>
									<th class="col-md-1" style="text-align: center;"> Total</th>

									<th class="col-md-1" style="text-align: center;">Status</th>
									<th class="col-md-1" style="text-align: center;">Date & Time</th>
									<th class="col-md-1" style="text-align: center;">Action</th>
								</tr>
							</thead>
							<tbody>

								<c:forEach items="${billHeader}" var="billHeader"
									varStatus="count">
									<tr>
									<%-- 	<td class="col-sm-1"><c:out value="${billHeader.billNo}" /></td> --%>
										<td class="col-sm-1"style="text-align: center;"><c:out value="${billHeader.invoiceNo}" /></td>
										<td class="col-md-1" style="text-align: left;"><c:out
												value="${billHeader.billDate}" /></td>
										<td class="col-md-1" style="text-align: right;"><c:out
												value="${billHeader.taxableAmt}" /></td>
										<td class="col-md-1" style="text-align: right;"><c:out
												value="${billHeader.totalTax}" /></td>
										<td class="col-md-1" style="text-align: right;"><c:out
												value="${billHeader.grandTotal}" /></td>
										<%-- 	<td><c:out value="${billHeader.status}" /></td> --%>
										<c:choose>
											<c:when test="${billHeader.status==1}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-danger"style="font-size: 14px;padding-top: 3px;">
												<c:out value="Pending"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==2}">
												<td style=" text-align: center; ">
												<span class="label label-success"style="font-size: 14px;padding-top: 3px;">
												<c:out value="Received"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==3}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-default"style="font-size: 14px;padding-top: 3px;">
												<c:out value="GVN Apply"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==4}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-primary"style="font-size: 14px;padding-top: 3px;">
												<c:out value="GVN Approve"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==5}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-info"style="font-size: 14px;padding-top: 3px;">
												<c:out value="GRN Apply"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==6}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-warning"style="font-size: 14px;padding-top: 3px;">
												<c:out value="GRN Approve"></c:out></span></td>
											</c:when>
											<c:when test="${billHeader.status==7}">
												<td class="col-md-1" style=" text-align: center; ">
												<span class="label label-default"style="font-size: 14px;padding-top: 3px;">
												<c:out value="Closed"></c:out></span></td>
											</c:when>

										</c:choose>
										<td class="col-md-1" style="text-align: left;">
										<fmt:parseDate var="parsedDate" value="${billHeader.remark}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                       <fmt:formatDate var="newFormattedDateString" value="${parsedDate}" pattern="dd-MM-yyyy hh:mm a"/>
										<c:out value="${newFormattedDateString}" /></td>
										<td class="col-md-1" style="text-align: center;">
												<a
													href="${pageContext.request.contextPath}/showBillDetailProcess/?billNo=${billHeader.billNo}&billDate=${billHeader.billDate}&billStatus=${billHeader.status}&grandTotal=${billHeader.grandTotal}&Inv=${billHeader.invoiceNo}"
													class="fa fa-info"></a>&nbsp;&nbsp;
													 <a
													href="${pageContext.request.contextPath}/billPdf?url=pdf/showBillPdf/By-Road/0/${billHeader.billNo}"	class="fa fa-file-pdf-o" target="_blank"></a>
							 			<!--<input name="" class="buttonsaveorder" value="EXPORT TO EXCEL" type="button">-->
											</td>
										<c:set var="billNo" value="${billHeader.billNo}" />
									</tr>
								</c:forEach>
						</table>

					</div>
				</div>



			</div>
			<!--tabNavigation-->
			<!--<div class="order-btn"><a href="#" class="saveOrder">SAVE ORDER</a></div>-->
			<%-- <div class="order-btn textcenter">
						<a
							href="${pageContext.request.contextPath}/showBillDetailProcess/${billNo}"
							class="buttonsaveorder">VIEW DETAILS</a>
						<!--<input name="" class="buttonsaveorder" value="EXPORT TO EXCEL" type="button">-->
					</div> --%>


		</div>
		<!--rightSidebar-->

	</div>
	<!--fullGrid-->
</div>
<!--rightContainer-->

</div>
<!--wrapper-end-->
<!--easyTabs-->
<!--easyTabs-->
<script src="${pageContext.request.contextPath}/resources/js/main.js"></script>
<!--easyTabs-->


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

</body>
</html>
