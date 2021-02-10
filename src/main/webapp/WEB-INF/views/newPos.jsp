
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title>Monginis</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport"
	content="width=device-width; initial-scale=1.0; maximum-scale=1.0" />
<meta name="keywords" content="Monginis" />
<meta name="description" content="Monginis" />
<meta name="author" content="Monginis">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/newpos/css/monginis.css"
	type="text/css" />
<link rel="icon"
	href="${pageContext.request.contextPath}/resources/images/feviconicon.png"
	type="images/png" sizes="32x32">

<link
	href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700&display=swap"
	rel="stylesheet">
<!--font-family: 'Source Sans Pro', sans-serif;-->

<!--commanJS-->
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/js/jquery-1.10.2.min.js"></script>

<!-- jQuery Popup Overlay -->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/js/jquery.popupoverlay.js"></script>

<!--fancy scroll js-->
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/js/jquery.mousewheel.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/js/jquery.classyscroll.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/js/jquery.classyscroll.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/resources/newpos/alertify/alertify.min.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/newpos/alertify/css/alertify.min.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/newpos/alertify/css/themes/bootstrap.min.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/newpos/alertify/css/themes/default.min.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/customerBill/chosen.css">
<style>
<!--
-->
#preloader {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #fff;
	z-index: 99;
	height: 100%;
}

#status {
	width: 200px;
	height: 200px;
	position: absolute;
	left: 50%;
	top: 50%;
	background-image:
		url(${pageContext.request.contextPath}/resources/images/loader1.gif);
	background-repeat: no-repeat;
	background-position: center;
	margin: -100px 0 0 -100px;
}
</style>
<div id="preloader" style="display: none;">
	<div id="status"></div>
</div>
<!-- custom scrollbar stylesheet -->
<style>
#multi_menu {
	width: 100%;
	height: auto /* 600px */;
	overflow: hidden;
}
/* @keyframes carousel {
from { transform: translate3d(0, 0, 0); }
to { transform: translate3d(-2900px, 0, 0); }
} */
#multi_ul {
	width: 100% /* 5800px */;
	height: auto /* 600px */;
	transform: translate3d(0, 0, 0);
	animation: carousel 90s linear infinite;
}

#multi_ul li {
	display: block;
	float: left;
}

.active_list {
	display: inline-block;
	margin: 13px 0 0 25px;
}

.marquee_select {
	display: inline-block;
	background: #fd54a0;
	color: #FFF;
	padding: 6px 10px;
	border-radius: 5px;
	margin: 0 0 0 5px;
}

.pending_row {
	
}

.switch {
	position: relative;
	display: inline-block;
	width: 60px;
	height: 34px;
}

.switch input {
	display: none;
}

.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
}

.slider:before {
	position: absolute;
	content: "";
	height: 26px;
	width: 26px;
	left: 4px;
	bottom: 4px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(26px);
	-ms-transform: translateX(26px);
	transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 34px;
}

.slider.round:before {
	border-radius: 50%;
}

label:before {
	border: 0px solid #ccc;
}

.onoff_btn {
	display: inline-block;
	vertical-align: top;
	padding: 8px 0 0 0;
	margin: 0;
}
</style>
</head>

<body>
	<input type="hidden" id="sellBillNo">
	<c:url value="/addItemInBillLIst" var="addItemInBillLIst"></c:url>
	<c:url value="/getBillItemList" var="getBillItemList"></c:url>
	<c:url value="/getCustomerList" var="getCustomerList"></c:url>
	<c:url value="/addCustomer" var="addCustomer"></c:url>
	<c:url value="/deleteItem" var="deleteItem"></c:url>
	<c:url value="/genrateSellBill" var="genrateSellBill"></c:url>
	<c:url value="/getItemList" var="getItemList"></c:url>
	<c:url value="/cancelBill" var="cancelBill"></c:url>
	<c:url var="cancelFromHoldBill" value="/cancelFromHoldBill" />
	<c:url var="billOnHold" value="/billOnHold" />
	<c:url var="revertHoldBillOnCurrent" value="/revertHoldBillOnCurrent" />
	<c:url var="getAllItemList" value="/getAllItemList" />
	<div style="display: none;">
		<a href="${pageContext.request.contextPath}/newPos" id="relod"></a>
	</div>
	<form action="" method="get">
		<input type="hidden" id="SubCatForSearch" name="SubCatForSearch"
			value="0">

		<!--wrapper-start-->
		<div class="wrapper">

			<header>
				<div class="logo">
					<img
						src="${pageContext.request.contextPath}/resources/images/minlogo.png"
						alt="mini_logo">
				</div>
				<div class="drop_menu">
					<select name="holdBillNo" id="holdBillNo"
						data-placeholder="Select Bill No" class="input_add chosen-select"
						onchange="revertHoldBillOnCurrent()">
						<option value="" disabled="disabled" selected>Select Bill
							No</option>
						<c:forEach items="${holdingList}" var="holdingList">
							<c:choose>
								<c:when test="${holdingList.key==key}">
									<option value="${holdingList.key}" style="text-align: left;"
										selected>${holdingList.value.tempCustomerName}</option>
								</c:when>
								<c:otherwise>
									<option value="${holdingList.key}" style="text-align: left;">${holdingList.value.tempCustomerName}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>

					</select>
				</div>
				<div class="clr"></div>
			</header>





			<section class="main_container">
				<!--right-side-box-->
				<div class="cat_l">

					<div class="left_menus">
						<div class="menu_left">

							<div id="demo">
								<div id="examples" class="snap-scrolling-example">
									<div id="content-1" class="horizontal-images">
										<div class="multi_menu">
											<ul id="multi_ul">

												<li onclick="selectBySubCatId(0);subCatForSrch(0);"
													value="All" id="1"><a href="#" class="scroll_menu"
													onclick="SlectedCat(this.innerHTML)">All</a></li>
												<c:forEach items="${subCatList}" var="subCat"
													varStatus="count">

													<li
														onclick="selectBySubCatId(${subCat.subCatId});subCatForSrch(${subCat.subCatId});"
														value="${count.index+2}"><a href="#"
														class="scroll_menu" onclick="SlectedCat(this.innerHTML)">${subCat.subCatName}</a></li>
												</c:forEach>



											</ul>
										</div>
									</div>
								</div>
							</div>





						</div>
						<div class="menu_search">
							<input name="myInput1" id="myInput1" type="text"
								class="input_cat" onkeyup="myFunction1()"
								placeholder="Search Item..." autocomplete="off" />
						</div>
						<div class="clr"></div>
					</div>
					<div class="row">

						<span
							style="padding-top: 0px; float: left; margin-top: 13px; margin-left: 13px; font-size: 16px;">
							<p class="onoff_btn">SMS:</p> <i class="fa fa-envelope-o"
							style="color: yellow"> </i> <label class="switch"> <input
								type="checkbox" name='isSMS' id='isSMS' onchange="SliderAlert()" />
								<span class="slider round"></span>
						</label>

						</span>

						<c:choose>
							<c:when test="${calStock==1}">
								<span
									style="padding-top: 0px; float: left; margin-top: 13px; margin-left: 13px; font-size: 16px; display: none;"><p
										class="onoff_btn">Check Stock</p> <i class="fa fa-envelope-o"
									style="color: yellow"> <label class="switch"> <input
											type="checkbox" name='checkStock' id='checkStock'
											onchange="cancelBill(0)" checked="checked" /> <span
											class="slider round"></span>
									</label></i> </span>
							</c:when>
							<c:otherwise>
								<span
									style="padding-top: 0px; float: left; margin-top: 13px; margin-left: 13px; font-size: 16px; display: none;"><p
										class="onoff_btn">Check Stock</p> <i class="fa fa-envelope-o"
									style="color: yellow"> <label class="switch"> <input
											type="checkbox" name='checkStock' id='checkStock'
											onchange="cancelBill(0)" /> <span class="slider round"></span>
									</label></i> </span>
							</c:otherwise>
						</c:choose>

						<div class="active_list">
							<span class="marquee_select" id="selected_subcat">All</span> <input
								type="hidden" name="hiddenSelectedCatId"
								id="hiddenSelectedCatId" value="0">
						</div>

					</div>

					<!--listing box start here-->
					<div class="cat_list_bx">

						<div class="cat_list">
							<div class="carlist_scrollbars">

								<div class="new_bx">
									<ul id="itemUl">

									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div class="cat_r">

					<!--top-buttons row-->
					<div class="pending_row">
						<!-- <a href="#" class="pending_btn initialism slide_open">Pending
							Amt : <span>550.00000</span>
						</a> -->

						<!--pending amount popup-->
						<div id="slide" class="pending_pop">
							<button class="slide_close">
								<i class="fa fa-times" aria-hidden="true"></i>
							</button>
							<div style="overflow-x: auto;">
								<table class="pending_tab">
									<tr>
										<th>First Name</th>
										<th>Last Name</th>
										<th>Points</th>
										<th>Points</th>
										<th>Points</th>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Eve</td>
										<td>Jackson</td>
										<td>94</td>
										<td>94</td>
										<td>94</td>
									</tr>
									<tr>
										<td>Adam</td>
										<td>Johnson</td>
										<td>67</td>
										<td>67</td>
										<td>67</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Eve</td>
										<td>Jackson</td>
										<td>94</td>
										<td>94</td>
										<td>94</td>
									</tr>
									<tr>
										<td>Adam</td>
										<td>Johnson</td>
										<td>67</td>
										<td>67</td>
										<td>67</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>
									<tr>
										<td>Eve</td>
										<td>Jackson</td>
										<td>94</td>
										<td>94</td>
										<td>94</td>
									</tr>
									<tr>
										<td>Adam</td>
										<td>Johnson</td>
										<td>67</td>
										<td>67</td>
										<td>67</td>
									</tr>
									<tr>
										<td>Jill</td>
										<td>Smith</td>
										<td>50</td>
										<td>50</td>
										<td>50</td>
									</tr>


								</table>
							</div>
						</div>
						<script type="text/javascript">
							$(document).ready(function() {
								$('#slide').popup({
									focusdelay : 400,
									outline : true,
									vertical : 'top'
								});
							});
						</script>



						<!--<a href="#" class="pending_btn initialism addcust_open">Advance Amt : <span>550.00000</span></a>-->

						<!--pending amount popup-->
						<div id="addcust" class="add_customer">

							<button class="addcust_close close_popup">
								<i class="fa fa-times" aria-hidden="true"></i>
							</button>
							<h3 class="pop_head">Add Customer</h3>

							<div class="add_frm">
								<div class="add_frm_one">
									<div class="add_customer_one">Customer Name</div>
									<div class="add_input">
										<input name="custName" id="custName" type="text"
											class="input_add" />
									</div>
									<span id="name_error" style="display: none; color: red"
										class="text-danger">Please Enter Customer Name</span>
									<div class="clr"></div>
								</div>
								<div class="add_frm_one">
									<div class="add_customer_one">Mobile Number</div>
									<div class="add_input">
										<input name="custMob" id="custMob" type="text"
											class="input_add" maxlength="10" minlength="1"
											oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" />
									</div>
									<span id="mob_error" style="display: none; color: red"
										class="text-danger">Please Enter Mob No</span> <span
										id="mob_error2" style="display: none; color: red"
										class="text-danger">Enter10 Digits </span>
									<div class="clr"></div>
								</div>
								<div class="add_frm_one">
									<div class="add_customer_one">GST NO</div>
									<div class="add_input">
										<input name="custGst" id="custGst" type="text"
											class="input_add" />
									</div>
									<span id="gst_error" style="display: none; color: red"
										class="text-danger">Please Enter Gst No.</span>
									<div class="clr"></div>
								</div>

							</div>

							<div class="pop_btns">
								<div class="close_l">
									<button class="addcust_close close_btn" id="clsAddCust">Close</button>
								</div>
								<div class="close_r" id="saveBtn">
									<a href="#" onclick="addCust()">Save</a>
								</div>
								<div class="clr"></div>
							</div>

							<!--<button class="slide_close"><i class="fa fa-times" aria-hidden="true"></i></button>-->
						</div>
						<script type="text/javascript">
							$(document).ready(function() {
								$('#addcust').popup({
									focusdelay : 400,
									outline : true,
									vertical : 'top'
								});
							});
						</script>


						<!-- <a href="#" class="pending_btn">Total Amt : <span>550.00000</span></a> -->
					</div>

					<!--customer drop down here-->
					<div class="add_customer_bx">
						<!--customer row 1-->
						<div class="customer_row">
							<div class="customer_one">Customer</div>
							<div class="customer_two small_size">
								<%-- <input name="selectCust" list="templates" id="selectCust"
									type="text" class="input_add" placeholder="Add Customer"
									value="${holdBill.tempCustomerName}"
									onchange="getCustInfo(this.value)" /> <span
									id="error_customer" style="display: none; color: red">Please
									Select Customer</span>

								<datalist id="templates">

								</datalist> --%>

								<select name="custId" id="custId"
									data-placeholder="Select Bill No"
									class="input_add chosen-select">
									<option value="" disabled="disabled" selected>Select
										Customer</option>


								</select>
							</div>
							<div class="customer_three increase_size">
								<button class="plus_btn addcust_open">
									<i class="fa fa-plus" aria-hidden="true"></i>
								</button>
							</div>
							<input id="key" name="key" value="${key}" type="hidden">
							<div class="clr"></div>
						</div>

					</div>
					<c:set var="totalItemCount" value="0"></c:set>
					<c:set var="totalTaxableAmt" value="0"></c:set>
					<c:set var="totalTaxAmt" value="0"></c:set>
					<c:set var="totalAmt" value="0"></c:set>
					<!--product table-->
					<div class="total_table_one">
						<div class="scrollbars">

							<div>
								<table id="itemTable">
									<thead>
										<tr>
											<th style="text-align: center;" width="2%">Sr</th>
											<th style="text-align: center;">Product</th>
											<th style="text-align: center;" width="10%">Qty</th>
											<th style="text-align: center;" width="13%">Price</th>
											<th style="text-align: center;" width="13%">Total</th>
											<th style="text-align: center;" width="2%">Del</th>
										</tr>
									</thead>
									<tbody>


										<c:forEach items="${holdBill.itemList}" var="itemList"
											varStatus="count">
											<c:set var="totalItemCount" value="${totalItemCount+1}"></c:set>
											<tr>
												<td>${count.index+1}</td>
												<td style=""><div
														style="width: 100%; white-space: normal;">${itemList.itemName}</div></td>
												<td style="text-align: right;"
													onclick="opnItemPopup('${itemList.itemId}','${itemList.itemName}','${itemList.catId}','${itemList.aviableQty}','${itemList.itemTax}','${itemList.itemTax}','${itemList.itemMrp}','${itemList.itemUom}',0)">

													${itemList.itemQty}</td>
												<td style="text-align: right;"><fmt:formatNumber
														type="number" groupingUsed="false"
														value="${itemList.itemMrp}" maxFractionDigits="2"
														minFractionDigits="2" /></td>
												<td style="text-align: right;"><fmt:formatNumber
														type="number" groupingUsed="false"
														value="${itemList.calPrice}" maxFractionDigits="2"
														minFractionDigits="2" /></td>
												<td style="text-align: center;"><a href="#"
													title="Delete" onclick="deleteItem(${itemList.itemId})"><i
														class="fa fa-trash"></i></a></td>
											</tr>
											<c:set var="totalTaxableAmt"
												value="${totalTaxableAmt+itemList.payableAmt}"></c:set>
											<c:set var="totalTaxAmt"
												value="${totalTaxAmt+itemList.payableTax}"></c:set>
											<c:set var="totalAmt" value="${totalAmt+itemList.payableAmt}"></c:set>
										</c:forEach>

									</tbody>


								</table>
							</div>
							<div>
								<span style="display: none; color: red" id="empty_itemList">*Select
									Atleast One Item To Genrate Bill!!!!</span>
							</div>
						</div>
					</div>
					<script>
						$(document).ready(function() {
							$('.scrollbars').ClassyScroll();
						});
					</script>

					<!--total-table start here-->
					<div class="total_tab">
						<table width="100%">
							<tr bgcolor="#ffe5e6">
								<td>Total Items :</td>
								<td id="totalCnt">${totalItemCount}</td>
								<td>Total :</td>
								<td align="right" style="text-align: right;" id="totalAmt"><fmt:formatNumber
										type="number" groupingUsed="false" value="${totalTaxableAmt}"
										maxFractionDigits="2" minFractionDigits="2" /></td>
							</tr>
							<tr bgcolor="#ffe5e6" style="border-top: 1px solid #f4f4f4;">
								<td>Discount :</td>
								<td>(0.00) 0.00</td>
								<td>Order Tax :</td>
								<td align="right" style="text-align: right;" id="totalTax"><fmt:formatNumber
										type="number" groupingUsed="false" value="${totalTaxAmt}"
										maxFractionDigits="2" minFractionDigits="2" /></td>
							</tr>
							<tr bgcolor="#fefcd5" style="border-top: 1px solid #f4f4f4;">
								<td style="font-weight: 600;">Total Payable :</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td style="font-weight: 600; text-align: right;" align="right"
									id="finalAmount"><fmt:formatNumber type="number"
										groupingUsed="false" value="${totalAmt+totalTaxAmt}"
										maxFractionDigits="2" minFractionDigits="2" /></td>
							</tr>
						</table>
					</div>


					<!--five button here-->
					<div class="buttons_row">
						<div class="button_one">
							<a href="#" class="hold hold_btn" onclick="billOnHold()">Hold</a>
							<a href="#" class="hold can_btn"
								onclick="cancelFromHoldBill(${key})">Cancel Hold Bill</a>
							<!-- onclick="cancelBill(1)" -->
						</div>
						<div class="button_one">
							<button id="payment1"
								class="hold print_btn   initialism payment_open"
								style="display: none;">Payment</button>
							<a href="#" class="hold print_btn  initialism  "
								onclick="paymentClick()">Payment</a>
							<!-- 	<a href="#" class="hold print_btn"  >Print Order</a>  -->
							<!-- <button  id="payment1" class="hold bill_btn   "  style="display: none;">Print Bill</button> -->
							<a href="#" class="hold bill_btn" onclick="printBillClick()">Print
								Bill</a>
						</div>
						<div class="button_two">
							<!-- 	<button  id="payment1" class="hold pay_btn  initialism payment_open"  style="display: none;">Payment</button>
							<a href="#"   class="hold pay_btn  initialism " onclick="paymentClick()">Payment</a> -->
							<a href="#" class="hold pay_btn  initialism "
								onclick="billClick()">Bill</a>
						</div>

					</div>


				</div>

				<script>
					$(document).ready(function() {
						$('.carlist_scrollbars').ClassyScroll();
					});
				</script>

			</section>

		</div>

		<div id="quantity" class="category_popup">
			<h3 class="pop_head">Quantity</h3>

			<div class="add_frm">

				<div class="add_row">
					<div class="add_row_l">
						<span class="add_txt">Kg wise</span> <input name="" type="text"
							class="input_add" />
					</div>
					<div class="add_row_r">
						<span class="add_txt">Rate wise</span> <input name="" type="text"
							class="input_add" />
					</div>
					<div class="clr"></div>
				</div>

				<div class="add_row add_row_marg">
					<div class="add_row_l">
						<span class="add_txt">Kg wise : 1</span>
					</div>
					<div class="add_row_r">
						<span class="add_txt">Rate wise : 100.00</span>
					</div>
					<div class="clr"></div>
				</div>

			</div>

			<div class="pop_btns">
				<div class="close_l">
					<button class="quantity_close close_btn">Close</button>
				</div>
				<div class="close_r">
					<a href="#">Save</a>
				</div>
				<div class="clr"></div>
			</div>

			<!--<button class="slide_close"><i class="fa fa-times" aria-hidden="true"></i></button>-->
		</div>
		<div id="payment" class="add_customer">
			<input type="hidden" id="hiddenCustName" name="hiddenCustName">
			<input type="hidden" id="hiddenCustMob" name="hiddenCustMob">


			<h3 class="pop_head">Payment</h3>

			<div class="add_frm">
				<div class="add_customer_one">Discount %</div>
				<div class="add_input" id="discountPopup">
					<input type="text" name="discPer" id="discPer" step="0.01"
						oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
						onchange="itemDiscPerCalculation(1)"
						onkeyup="itemDiscPerCalculation(1)" class="form-control" value="0"
						placeholder="Disc %"
						style="text-align: center; width: 90px; border-radius: 20px;" />
					<label for="discAmtLabel"
						style="font-weight: 700; padding-left: 5px;">&nbsp;Disc
						Amt&nbsp;</label> <input type="text" name="discAmt" id="discAmt"
						oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
						onchange="itemDiscPerCalculation(2)"
						onkeyup="itemDiscPerCalculation(2)" class="form-control"
						value="${discAmt}" placeholder="Disc Amt"
						style="text-align: center; width: 90px; border-radius: 20px;" />
				</div>


				<div class="clr"></div>
				<div class="add_frm_one">
					<div class="add_customer_one">Type</div>
					<div class="add_input">

						<div class="dropdown popup_drop">
							<div class="select">
								<span>Cash</span>
							</div>
							<input type="hidden" name="payMode" id="payMode" value="1">

							<ul class="dropdown-menu">
								<li id="1">Cash</li>
								<li id="2">Card</li>
								<li id="3">E-pay</li>
							</ul>
						</div>

					</div>
					<span id="payMode_error" style="display: none; color: red">Please
						Select Payment Mode</span>
					<div class="clr"></div>
				</div>
				<div class="add_frm_one">
					<div class="add_customer_one">Amount</div>
					<div class="add_input">
						<input
							oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
							name="pAmt" id="pAmt" type="text" class="input_add"
							disabled="disabled" />
					</div>
					<div class="clr"></div>
				</div>


				<label style="font-weight: 700; padding-left: 5px;">Paid&nbsp;</label>
				<input type="text" name="paidAmt" id="paidAmt"
					oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
					onchange="amtReturnCal()" onkeyup="amtReturnCal()"
					class="form-control" value="" placeholder="Amount"
					style="text-align: center; width: 90px; border-radius: 20px;" />



				&nbsp;&nbsp; <label style="font-weight: 700; padding-left: 5px;">Return&nbsp;</label>
				<input type="text" name="rAmt" id="rAmt" readonly="readonly"
					class="form-control" value="" placeholder="Amount"
					style="text-align: center; width: 90px; border-radius: 20px;" /> <span
					id="paidAmt_error" style="display: none; color: red">Please
					Enter Paid Amount</span>

			</div>



			<div class="pop_btns">
				<div class="close_l">
					<button class="payment_close close_btn" id="closePay">Close</button>
					&nbsp;
					<button class="payment_close close_btn" onclick="printAndSubmit()"
						href="#">Print & Submit</button>
				</div>
				<div class="close_l"></div>
				<div class="close_r">
					<a onclick="submitPayment()" href="#">Submit</a>
				</div>
				<div class="clr"></div>
			</div>

		</div>
		<div id="addcust1" class="add_customer calcy">
			<input type="hidden" name="itemNameHidden" id="itemNameHidden">
			<input type="hidden" name="itemUomHidden" id="itemUomHidden">
			<input type="hidden" name="itemIdHidden" id="itemIdHidden"> <input
				type="hidden" name="itemTaxHidden" id="itemTaxHidden"> <input
				type="hidden" name="itemMrp" id="itemMrp"> <input
				type="hidden" name="itemCatId" id="itemCatId"> <input
				type="hidden" name="itemTax1Hidden" id="itemTax1Hidden"> <input
				type="hidden" name="itemTax2Hidden" id="itemTax2Hidden"> <input
				type="hidden" name="aviableQty" id="aviableQty">






			<div class="calcy_bx">
				<div class="calcy_1">
					<div class="calculator_bx">
						<div class="cal_quan">
							<div class="qty_l">QTY</div>
							<div class="qty_m">
								<!-- onkeyup="checkAviableQty(1)" -->
								<input type="text" class="qty_one numberOnly" placeholder="QTY"
									value="1" name="enterQty" id="enterQty">
							</div>
							<div class="qty_r">
								<button type="submit" class="go_btn" onclick="calPad(1,10)"></button>
							</div>
							<div class="clr"></div>
						</div>

						<div class="calc_no">
							<div class="calc_no_l">
								<ul>
									<li><a href="#" onclick="calPad(1,7)">7</a></li>
									<li><a href="#" onclick="calPad(1,8)">8</a></li>
									<li><a href="#" onclick="calPad(1,9)">9</a></li>
									<li><a href="#" onclick="calPad(1,4)">4</a></li>
									<li><a href="#" onclick="calPad(1,5)">5</a></li>
									<li><a href="#" onclick="calPad(1,6)">6</a></li>
									<li><a href="#" onclick="calPad(1,1)">1</a></li>
									<li><a href="#" onclick="calPad(1,2)">2</a></li>
									<li><a href="#" onclick="calPad(1,3)">3</a></li>
									<li><a href="#" onclick="calPad(1,0)">0</a></li>
									<li style="visibility: hidden;"><a href="#">.</a></li>
									<li><a href="#" onclick="calPad(1,10)"><img
											src="${pageContext.request.contextPath}/resources/newpos/images/next_arrow_one.png"
											alt="next_arrow_one"> </a></li>
								</ul>
							</div>
							<div class="calc_no_r">
								<!-- <a href="#" onclick="addItem(1)" > -->
								<a href="#" onclick="checkAviableQty(1)"><img
									src="${pageContext.request.contextPath}/resources/newpos/images/right_arrow_one.png"
									alt="right_arrow_one"></a>
							</div>
							<div class="clr"></div>
						</div>

					</div>
				</div>
				<%-- <div class="calcy_2">
																<div class="calculator_bx">
																	<div class="cal_quan">
																		<div class="qty_l">AMT</div>
																		<div class="qty_m">
																			<input type="text" class="qty_one">
																		</div>
																		<div class="qty_r">
																			<button type="submit" class="go_btn"></button>
																		</div>
																		<div class="clr"></div>
																	</div>

																	<div class="calc_no">
																		<div class="calc_no_l">
																			<ul>
																				<li><a href="#">7</a></li>
																				<li><a href="#">8</a></li>
																				<li><a href="#">9</a></li>
																				<li><a href="#">4</a></li>
																				<li><a href="#">5</a></li>
																				<li><a href="#">6</a></li>
																				<li><a href="#">1</a></li>
																				<li><a href="#">2</a></li>
																				<li><a href="#">3</a></li>
																				<li><a href="#">0</a></li>
																				<li><a href="#">.</a></li>
																				<li><a href="#"><img
																						src="${pageContext.request.contextPath}/resources/newpos/images/next_arrow_one.png"
																						alt="next_arrow_one"> </a></li>
																			</ul>
																		</div>
																		<div class="calc_no_r">
																			<a href="#"><img
																				src="${pageContext.request.contextPath}/resources/newpos/images/right_arrow_one.png"
																				alt="right_arrow_one"></a>
																		</div>
																		<div class="clr"></div>
																	</div>

																</div>
															</div> --%>
				<div class="clr"></div>
			</div>


			<div class="pop_btns">
				<div class="close_l">
					<button class="addcust1_close close_btn" id="closeAddcust">Close</button>
				</div>
				<div class="close_r">
					<a href="#" onclick="checkAviableQty(1)">Submit</a>
				</div>
				<div class="clr"></div>
			</div>

		</div>

	</form>
	<script type="text/javascript">
									$(document).ready(function() {
										$('#quantity').popup({
											focusdelay : 400,
											outline : true,
											vertical : 'top'
										});
									});
									$(document).ready(function() {
										$('#payment').popup({
											focusdelay : 400,
											outline : true,
											vertical : 'top'
										});
									});
								</script>
	<script type="text/javascript">
		/*Dropdown Menu*/
		$('.dropdown').click(function() {
			$(this).attr('tabindex', 1).focus();
			$(this).toggleClass('active');
			$(this).find('.dropdown-menu').slideToggle(300);
		});
		$('.dropdown').focusout(function() {
			$(this).removeClass('active');
			$(this).find('.dropdown-menu').slideUp(300);
		});
		$('.dropdown .dropdown-menu li').click(
				function() {
					$(this).parents('.dropdown').find('span').text(
							$(this).text());
					$(this).parents('.dropdown').find('input').attr('value',
							$(this).attr('id'));
				});
		/*End Dropdown Menu*/
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/customerBill/chosen.jquery.js"
		type="text/javascript"></script>
	<script
		src="${pageContext.request.contextPath}/resources/customerBill/init.js"
		type="text/javascript" charset="utf-8"></script>
	<!-- custom scrollbar plugin -->
	<script
		src="${pageContext.request.contextPath}/resources/newpos/js/jquery.mCustomScrollbar.concat.min.js"></script>

	<script>
		(function($) {
			$(window).on(
					"load",
					function() {

						/*
						get snap amount programmatically or just set it directly (e.g. "273")
						in this example, the snap amount is list item's (li) outer-width (width+margins)
						 */
						var amount = Math.max.apply(Math, $("#content-1 li")
								.map(function() {
									return $(this).outerWidth(true);
								}).get());

						$("#content-1").mCustomScrollbar({
							axis : "x",
							theme : "inset",
							advanced : {
								autoExpandHorizontalScroll : true
							},
							scrollButtons : {
								enable : true,
								scrollType : "stepped"
							},
							keyboard : {
								scrollType : "stepped"
							},
							snapAmount : amount,
							mouseWheel : {
								scrollAmount : amount
							}
						});

					});
		})(jQuery);
	</script>

	<script type="text/javascript">
	$(document).ready(function() {
		 $('#addcust1').popup({
		        focusdelay: 400,
		        outline: true,
		        vertical: 'top'
		    }); 
		 var custId  = '${holdBill.custId}';
		 //alert(custId)
		getAllItemList();
		getCustomerList(custId);
		 alertify.set('notifier','position', 'top-right'); 
	});
	
	function getAllItemList(){
		 
		 		$.getJSON('${getAllItemList}',{ajax:true},function(data){
		 			var jsonStr= data;
		 			
		 			var divStr =" ";
		 			document.getElementById("itemUl").innerHTML="";
		 			for(var i=0 ; i <  jsonStr.length ; i++){
		 				 
		 			 divStr=divStr+'<li class="itemDummyClass" onclick="opnItemPopup('+jsonStr[i].itemId+',\'' + jsonStr[i].itemName + '\',' + jsonStr[i].catId + ',' + jsonStr[i].totalRegStock + ',' + jsonStr[i].itemTax1 + ',' + jsonStr[i].itemTax2 + ',' + jsonStr[i].mrp + ',\'' + jsonStr[i].uom + '\','+1+')"><div id="itemDiv">'+
		 							'<div class="new_cake_bx" >'+
		 								'<a href="#" class="initialism  addcust1_open  " title="'+jsonStr[i].itemName+'">'+
		 									'<div class="cake_picture">'+
		 										'<p>'+jsonStr[i].mrp+'</p>'+
		 										'<img src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg" alt="">'+
		 										'<span>'+jsonStr[i].totalRegStock+'</span>'+
		 									'</div>'+
		 								'<div class="cake_name">'+jsonStr[i].itemName+'</div>'+
		 							'</a> </div> </div> <div class="hiddenSubCatId" style="display: none;">'+jsonStr[i].subCatId+'</div></li>';
		 									
		 									
		 					//	alert(iList[i].itemName);	
		 				}
		 			document.getElementById("itemUl").innerHTML=divStr;
		 			 myFunction1();
		 		});
		 		 
	 }
	function myFunction1() {
		
		var hiddenSelectedCatId = $("#hiddenSelectedCatId").val();
		
		$(".scrollbar-content").css("top", "0");
		 $(".scrollbar-handle").css("top", "0");
	    $('.itemDummyClass').hide();
	    var txt = $('#myInput1').val();
	    
	    if(hiddenSelectedCatId==0){
	    	$('.itemDummyClass').each(function(){
	 	       if($(this).text().toUpperCase().indexOf(txt.toUpperCase()) != -1){
	 	           $(this).show();
	 	       }
	 	    });
	    }else{
	    	$('.itemDummyClass').each(function(index){
	    		
	    		var catId = parseFloat(document
 						.getElementsByClassName("hiddenSubCatId")[index].innerHTML);
	    		
	 	       if($(this).text().toUpperCase().indexOf(txt.toUpperCase()) != -1 && catId==parseInt(hiddenSelectedCatId)){ 
	 	           
	 		           $(this).show();
	 		       
	 	       }
	 	    });
	    }
	    
	     
	} 
	 
	function selectBySubCatId(id){
		$("#hiddenSelectedCatId").val(parseInt(id));
		  
		$(".scrollbar-content").css("top", "0");
		 $(".scrollbar-handle").css("top", "0");
	    $('.itemDummyClass').hide(); 
	    
	    var txt = $('#myInput1').val();
	    
	    $('.itemDummyClass').each(function(index){
	    	
	    	
	    	if(parseInt(id)==0){ 
	 	 	       if($(this).text().toUpperCase().indexOf(txt.toUpperCase()) != -1){
	 	 	           $(this).show();
	 	 	       } 
	    	}else{
	    		var catId = parseFloat(document
						.getElementsByClassName("hiddenSubCatId")[index].innerHTML);
	    		if($(this).text().toUpperCase().indexOf(txt.toUpperCase()) != -1 && catId==parseInt(id)){
	 	           $(this).show();
	 	       }
	    	}
	    	
	       
	    });
	    
	}
	 
	function subCatForSrch(val){
		//alert("FUNC"+val);
		document.getElementById("SubCatForSearch").value=val;
		//var s=document.getElementById("SubCatForSearch").value;
		//alert(s);
	}
	
	function SlectedCat(val){
		document.getElementById("selected_subcat").innerHTML=val;
	}
	
	
	
	
	
	function calPad(side,value) {
		var qty =  $('#enterQty').val() ;
		var rate =  $('#enterRate').val() ;
	

		 if(side==1){
			 
			 if(qty=="NaN"){
				 qty="";
			 }
			 
			  if(value=="."){
				 qty += value
				 qty = qty.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); 
				 
			 }else if(value==10){
				  
				 if(qty.length!=0){
					 
					 qty  = qty.substring(0, qty.length - 1);
				 }
				  
			 }else{
				 qty += value
			 }
			 document.getElementById("enterQty").value = qty;
			 itemRateCalculation(1);
			 $("#enterQty").focus(); 
			 
		 }else if(side==2){
			 
			  
			 if(rate=="NaN"){ 
				 rate="";
			 } 
			 if(value=="."){ 
				  rate += value
				  rate = rate.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1'); 
				 
			 }else if(value==10){
				  
				 if(rate.length!=0){
					 
					 rate  = rate.substring(0, rate.length - 1);
				 }
				  
			 }else{
				 rate += value
			 }
			 document.getElementById("enterRate").value = rate;
			 itemRateCalculation(2);
			 $("#enterRate").focus(); 
		 }
		 
		 if(value==11){
			 document.getElementById("enterQty").value = 1;
			 document.getElementById("enterRate").value = "";
		 }
		 
	}
	
	
function opnItemPopup(itemId,itemName,catId,aviableQty,itemTax1,itemTax2,itemMrp,uom,flag){
	 
	if(flag>0){
		document.getElementById("itemTaxHidden").value = itemTax1+itemTax2;
	}else{
		document.getElementById("itemTaxHidden").value = itemTax1;
	}

	 document.getElementById("itemNameHidden").value = itemName;
	document.getElementById("itemUomHidden").value = uom;
	document.getElementById("itemIdHidden").value = itemId;
	
	document.getElementById("itemMrp").value = itemMrp; 
	document.getElementById("itemTax1Hidden").value = itemTax1;
	document.getElementById("itemTax2Hidden").value = itemTax2;
	document.getElementById("itemCatId").value = catId;
	document.getElementById("aviableQty").value=aviableQty;
	
	
}
 
	
	
	function addItem(flag){
		 
		if(flag>0){
			var qty= document.getElementById("enterQty").value;
		}else{
			var qty= document.getElementById("tblQty").value;
			
		}
		
		
		jQuery("#status").fadeOut();
		 
		var itemName =document.getElementById("itemNameHidden").value;
		var itemId = document.getElementById("itemIdHidden").value;
		var itemMrp=document.getElementById("itemMrp").value;
		var itemTax =document.getElementById("itemTaxHidden").value;
		var itemUom= document.getElementById("itemUomHidden").value;
		//var catId = document.getElementById("itemUomHidden").value;
		var tax1 = document.getElementById("itemTax1Hidden").value;
		var tax2= document.getElementById("itemTax1Hidden").value;
		var catId= document.getElementById("itemCatId").value;
	var aviableQty=	document.getElementById("aviableQty").value;
		var price= (qty*itemMrp).toFixed(2);
		var paybeleTax=((price*100)/(100+itemTax)).toFixed(2);
		var paybeleAmt=(price-paybeleTax).toFixed(2);
		
		 //alert(itemId);
		//alert(itemTax);
		//alert(paybeleTax);
		//alert(paybeleAmt);
		var fd=new FormData();
		fd.append('itemName',itemName);
		fd.append('itemId',itemId);
				fd.append('itemMrp',itemMrp);
				fd.append('itemTax',itemTax);
			fd.append('tax1',tax1);
					fd.append('tax2',tax2);
				fd.append('catId',catId);
								fd.append('aviableQty',aviableQty);
					fd.append('itemUom',itemUom);
									fd.append('qty',qty);
								fd.append('price',price);
								fd.append('paybeleTax',paybeleTax);
									fd.append('paybeleAmt',paybeleAmt);
		
		  $.ajax({
		       url: '${pageContext.request.contextPath}/addItemInBillLIst',
		       type: 'POST',
		       data: fd,
		       dataType: 'json',
		       processData: false,
		       contentType: false,
		       async:false,
		       success: function(data, textStatus, jqXHR)
		       {
		    	   var itemCnt = data.itemList.length;
					var total = 0;
					var tax = 0;
					var finalAmt =0;
					var payableAmt=0;
					
					//alert(data.length);
					
					if(data.error==false){
						alertify.success(data.msg);
					}else{
						alertify.error(data.msg);
					}
						document.getElementById("enterQty").value=1;
						document.getElementById("closeAddcust").click();
						$('#itemTable tr').remove();
						
						var mainTrStr = '<tr>'
							+'<th style="text-align: center;" width="2%">Sr</th>'
							+'<th style="text-align: center;">Product</th>'
							+'<th style="text-align: center;" width="10%">QTY</th>' 
							+'<th style="text-align: center;" width="13%">Price</th>' 
							+'<th style="text-align: center;" width="13%">Total</th>'
							+'<th style="text-align: center;" width="2%">Del</th>'
							+'</tr>';
						var mainTr = $(mainTrStr);
						$('#itemTable tbody').append(
								mainTr);
						
						$
						.each(
								data.itemList,
								function(key, item) {
						
									 
							
							//alert(JSON.stringify(item))
							finalAmt += parseFloat(item.payableAmt);
							total += parseFloat(item.calPrice);
							tax += parseFloat(item.payableTax);
							payableAmt += parseFloat(item.payableAmt);
							var tr=$('<tr></tr>');
							tr
							.append($(
									'<td ></td>')
									.html(key+1));
								tr.append($('<td  ></td>').html('<div style="width: 100%; white-space: normal;">'+item.itemName+'</div>'));
								tr.append($('<td   style="text-align: right;"  class="initialism addcust1_open"  onclick="opnItemPopup('+item.itemId+',\'' + item.itemName + '\','+item.catId+','+item.aviableQty+',' + item.itemTax + ',' + item.itemTax + ',' + item.itemMrp + ',\'' + item.itemUom + '\','+0+')" > </td>').html(item.itemQty));
								tr.append($('<td style="text-align: right;"></td>').html(item.itemMrp.toFixed(2)));
								tr.append($('<td style="text-align: right;" ></td>').html(item.calPrice.toFixed(2)));
								tr.append($('<td style="text-align: center;"></td>').html('<a href="#" class="trash_icon" onclick="deleteItem('+item.itemId+')" ><i class="fa fa-trash-o" aria-hidden="true"></i></a>'));
								
								
								$('#itemTable tbody').append(tr);
								
								
						});
						getAllItemList();
						
						 //alert(itemCnt);
						document.getElementById("totalCnt").innerHTML=itemCnt;
						//alert(total);
						document.getElementById("totalAmt").innerHTML=payableAmt.toFixed(2);
						//alert(tax);
						document.getElementById("totalTax").innerHTML=tax.toFixed(2);
						//alert(finalAmt);
						document.getElementById("finalAmount").innerHTML=total.toFixed(2);
						document.getElementById("tblQty").value="";
						jQuery("#preloader").delay(0).fadeOut("slow");
						
						 },
		       error: function(jqXHR, textStatus, errorThrown)
		       {
		           console.log('ERRORS: ' + textStatus);
		       }
		   });
		  
	}
	
	function getCustomerList(val) {
		 //alert(val);
			$.getJSON('${getCustomerList}', {
			}, function(data) {

			//alert(data.length);

			$('#custId').find('option').remove().end()

			for (var i = 0; i < data.length; i++) {
 
				var dataValue=data[i].userName+"~"+data[i].phoneNo+"~"+data[i].gstNo;
				
				if(val==data[i].phoneNo){
					$("#custId").append($("<option selected></option>").attr("value",data[i].phoneNo).text(dataValue));
				}else{
					$("#custId").append($("<option ></option>").attr("value",data[i].phoneNo).text(dataValue));
				}
				
			}
			$("#custId").trigger("chosen:updated");

		});

	}

 function getCustInfo(val){
	 
	var phoneno = /^\d{10}$/;
	if(val.match(phoneno)){
		document.getElementById("custMob").value=val;
	}
 }
 
 function addCust() {
	var name=document.getElementById("custName").value;
	var mob =document.getElementById("custMob").value;
	var gst =document.getElementById("custGst").value;
	var isError=false;
	
	if(!name){
		isError=true;
		$('#name_error').show()
		
	}else {
	 
		$('#name_error').hide();
	}
	if(!mob){
		isError=true;
		$('#mob_error').show()
		
	}else{
		 
		$('#mob_error').hide();
		var phoneno = /^\d{10}$/;
		if(!mob.match(phoneno)){
			isError=true;
			$('#mob_error2').show()
		}else{
			isError=false;
			$('#mob_error2').hide();
		}
	}
	if(!gst){
		isError=true;
		$('#gst_error').show()
		
	}else{
		 
		$('#gst_error').hide();
	}
	
	if(isError){
		//alert("In If");
	}else {	 
		
		var fd=new FormData();
		fd.append('name',name);
		fd.append('mob',mob);
		fd.append('gst',gst);
		 $.ajax({
		       url: '${pageContext.request.contextPath}/addCustomer',
		       type: 'POST',
		       data: fd,
		       dataType: 'json',
		       processData: false,
		       contentType: false,
		       async:false,
		       success: function(data, textStatus, jqXHR)
		       {
		    	   if(data.error==false){
						getCustomerList((data.message));
							alertify.success("Customer addeed.");
							document.getElementById("clsAddCust").click();
							//document.getElementById("selectCust").value=name+"~"+mob+"~"+gst;
							document.getElementById("custName").value="";
							document.getElementById("custMob").value="";
							document.getElementById("custGst").value="";
						}else{
							alertify.error("Unable To Add Customer");
						}
				
		       },
		       error: function(jqXHR, textStatus, errorThrown)
		       {
		           console.log('ERRORS: ' + textStatus);
		           alertify.error("Unable To Add Customer");
		       }
		   });
		
		
		
		 
		
		
		
	}
		
}
 
 
 

 
 function deleteItem(id){
	 
	 
	 var fd=new FormData();
		fd.append('id',id);
	
		 $.ajax({
		       url: '${pageContext.request.contextPath}/deleteItem',
		       type: 'POST',
		       data: fd,
		       dataType: 'json',
		       processData: false,
		       contentType: false,
		       async:false,
		       success: function(data, textStatus, jqXHR)
		       {//alert(JSON.stringify(data));
					var itemCnt = data.length;
					var total = 0;
					var tax = 0;
					var finalAmt =0;
					var payableAmt=0;
					//alert(data.length);
					$(".scrollbar-content").css("top", "0");
						 $(".scrollbar-handle").css("top", "0");
						 getAllItemList();
							
						document.getElementById("enterQty").value=1;
						document.getElementById("closeAddcust").click();
						$('#itemTable tr').remove();
						
						var mainTrStr = '<tr>'
							+'<th style="text-align: center;" width="2%">Sr</th>'
							+'<th style="text-align: center;">Product</th>'
							+'<th style="text-align: center;" width="10%">QTY</th>' 
							+'<th style="text-align: center;" width="13%">Price</th>' 
							+'<th style="text-align: center;" width="13%">Total</th>'
							+'<th style="text-align: center;" width="2%">Del</th>'
							+'</tr>';
						var mainTr = $(mainTrStr);
						$('#itemTable tbody').append(
								mainTr);
						
						$
						.each(
								data,
								function(key, item) {
						
									 
							
							//alert(JSON.stringify(item))
							finalAmt += parseFloat(item.payableAmt);
							total += parseFloat(item.calPrice);
							tax += parseFloat(item.payableTax);
							payableAmt += parseFloat(item.payableAmt);
							
							var tr=$('<tr></tr>');
							tr
							.append($(
									'<td ></td>')
									.html(key+1));
								tr.append($('<td></td>').html('<div style="width: 100%; white-space: normal;">'+item.itemName+'</div>'));
								tr.append($('<td style="text-align: right;" class="initialism addcust1_open"  onclick="opnItemPopup('+item.itemId+',\'' + item.itemName + '\','+item.catId+','+item.aviableQty+',' + item.itemTax + ',' + item.itemTax + ',' + item.itemMrp + ',\'' + item.itemUom + '\','+0+')" > </td>').html(item.itemQty));
								tr.append($('<td style="text-align: right;"></td>').html(item.itemMrp.toFixed(2)));
								tr.append($('<td style="text-align: right;"></td>').html(item.calPrice.toFixed(2)));
								tr.append($('<td style="text-align: center;"></td>').html('<a href="#" class="trash_icon" onclick="deleteItem('+item.itemId+')" ><i class="fa fa-trash-o" aria-hidden="true"></i></a>'));
								
								
								$('#itemTable tbody').append(tr);
								
								
						});
						//alert(itemCnt);
						document.getElementById("totalCnt").innerHTML=itemCnt;
						//alert(total);
						document.getElementById("totalAmt").innerHTML=payableAmt.toFixed(2);
						//alert(tax);
						document.getElementById("totalTax").innerHTML=tax.toFixed(2);
						//alert(finalAmt);
						document.getElementById("finalAmount").innerHTML=total.toFixed(2);
						document.getElementById("tblQty").value="";
						
		       },
		       error: function(jqXHR, textStatus, errorThrown)
		       {
		           console.log('ERRORS: ' + textStatus);
		       }
		   });
		  
	 
 }
 
 
 function paymentClick(){
	
	 var pAmt=document.getElementById("finalAmount").innerHTML;
	 //alert(pAmt);
	 document.getElementById("pAmt").value=pAmt;
	 var detail =document.getElementById("custId").value;
	 
	 		
	 		$('#error_customer').hide()
	 		$.getJSON('${getItemList}',{ajax:true},function(data){
	 			if(data.length<1){
	 				//$('#empty_itemList').show()
	 				alertify.error("Please Select Atleast One Item To Genrate Bill!!!!!");
	 			}else{
	 				$('#empty_itemList').hide()
	 				document.getElementById("payment1").click();
	 			}
	 		});
	 		
	 	 
	 	
 }
 
 function billClick(){
	 var pAmt=document.getElementById("finalAmount").innerHTML;
	 document.getElementById("pAmt").value=pAmt;
	 var detail =document.getElementById("custId").value;
	 document.getElementById("paidAmt").value=pAmt;
	 
	 
	 
	 
	 		$('#error_customer').hide()
	 		$.getJSON('${getItemList}',{ajax:true},function(data){
	 			if(data.length<1){
	 				//$('#empty_itemList').show()
	 				alertify.error("Please Select Atleast One Item To Genrate Bill!!!!!");
	 				
	 			}else{
	 				$('#empty_itemList').hide()
	 				submitPayment();
	 			}
	 		});
	 			//document.getElementById("payment1").click();
 
	 
 }
 
 
 
 function itemDiscPerCalculation(val){
	 var pAmt=document.getElementById("finalAmount").innerHTML;
	 //alert(pAmt);
	 if(val==1){
		 document.getElementById("discAmt").value="";
	 var per = document.getElementById("discPer").value;
	 var perAmt= (pAmt/100)*per;
	
	 var newpAmt=pAmt-perAmt;  
	 document.getElementById("pAmt").value=newpAmt;
	// alert(per);
	 }else {
		 document.getElementById("discPer").value="";
		 var amount = document.getElementById("discAmt").value;
		 //alert(amount);
		 document.getElementById("pAmt").value=pAmt-amount;
	}
	 
 }
 
 
 
 

	function amtReturnCal() {
		
		var amt=document.getElementById("paidAmt").value;
		var pay=document.getElementById("pAmt").value;
		
		var ret=amt-pay;
		document.getElementById("rAmt").value=ret;
		
	}
 
 
 
 function submitPayment(){
	 //alert("payment");
	 var custName=document.getElementById("custId").value;
	var paidAmt=document.getElementById("paidAmt").value;
	 var payMode=document.getElementById("payMode").value;  
	 var discPer=document.getElementById("discPer").value;  
	 var payableAmt=document.getElementById("pAmt").value;
	 var isSMS=0; //new added by Sachin 18-08-2020 to send sms or not.
		if(document.getElementById('isSMS').checked){
			isSMS=1;
		}
	
	 
	
	  var isError=false;
	 
	
	 if(!payMode){
		 isError=true; 
		 $('#payMode_error').show()
	 }else {
		// isError=false;
		 $('#payMode_error').hide()
	} 
	 
	 
	  if(isError==false){
		  var key=document.getElementById("key").value;
		  document.getElementById("closePay").click();
			// will fade out the whole DIV that covers the website.
			 
	 		   var fd=new FormData();
			fd.append('custName',custName);
			fd.append('paidAmt',payableAmt);
			fd.append('payMode',payMode);
			fd.append('payableAmt',payableAmt);
			fd.append('discPer',discPer);
			fd.append('isSMS',isSMS);
			fd.append('key',key);
			// alert(key)
			$("#preloader").show();
			  $("#status").show();
			$
			.ajax({
				url : '${pageContext.request.contextPath}/genrateSellBill',
				type : 'post',
				data: fd,
				dataType : 'json', 
				contentType : false,
				processData : false, 
				success : function(response) {
  
						 $("#preloader").hide();
						  $("#status").hide();
						 cancelBill();
							//alert("Bill Genrated Successfully!!!");
							 
							if(response.error==false){
								   
									alertify.success("Bill genrated successfully !!!");
								}else{
									alertify.error(response.message);
								}
							if(key>0){
								window.location = "${pageContext.request.contextPath}/newPos/0";
							}
							 //document.getElementById("relod").click();
							 
						  
				},
			});
		   
		 
	  } 
 
 }
 
 
 function  checkAviableQty(flag){
	//alert("Ok");

	  var avQty = parseFloat(document.getElementById("aviableQty").value);
		if(flag>0){
			var qty= parseFloat(document.getElementById("enterQty").value);
		}else{
			var qty= parseFloat(document.getElementById("tblQty").value);
			}
		 
		if(!isNaN(qty) && qty>0){
			 
			addItem(flag);
		 
		}else{
			alertify.error("Enter Valid QTY ");
			document.getElementById("enterQty").value=1;
		}
 }
 
	
	function printAndSubmit(){
		//alert("Ok");
		 var custName=document.getElementById("custId").value;
		 var paidAmt=document.getElementById("paidAmt").value;
		 var payMode=document.getElementById("payMode").value;  
		 var discPer=document.getElementById("discPer").value;  
		 var payableAmt=document.getElementById("pAmt").value;
		 var isSMS=0; //new added by Sachin 18-08-2020 to send sms or not.
			if(document.getElementById('isSMS').checked){
				isSMS=1;
			}
		
		 var isError=false;
		 
	
		 if(!payMode){
			 isError=true; 
			 $('#payMode_error').show()
		 }else {
			 isError=false;
			 $('#payMode_error').hide()
		}
		 
		 
		 if(isError==false){
			 var key =  $("#key").val();
			 $("#preloader").show();
			  $("#status").show();
			  document.getElementById("closePay").click();
			 var fd=new FormData();
				fd.append('custName',custName);
				fd.append('paidAmt',payableAmt);
				fd.append('payMode',payMode);
				fd.append('payableAmt',payableAmt);
				fd.append('discPer',discPer);
				fd.append('isSMS',isSMS);
				fd.append('key',key);
			  $.ajax({
		       url: '${pageContext.request.contextPath}/genrateSellBill',
		       type: 'POST',
		       data: fd,
		       dataType: 'json',
		       processData: false,
		       contentType: false, 
		       success: function(data, textStatus, jqXHR)
		       {
		    	   
		    	   $("#preloader").hide();
					  $("#status").hide();
		    	  
					// alert("printing else"+JSON.stringify(data));
					  //var loginWindow = window.open('', 'UserLogin');
					 
					 cancelBill();
						//document.getElementById("li"+token).style.backgroundColor = "white";
					  
					  //  alert("opened");
					   if(data.error==false){
						   window.open('${pageContext.request.contextPath}/pdfSellBillNewPos?billNo='+ data.message+'&type=R');
							alertify.success("Bill genrated successfully !!!");
						}else{
							alertify.error(data.message);
						}
						
						if(key>0){
							window.location = "${pageContext.request.contextPath}/newPos/0";
						}
						 //	
	                
					 
					 },
		       error: function(jqXHR, textStatus, errorThrown)
		       {
		           console.log('ERRORS: ' + textStatus);
		       }
		   });
			 
		 }
		
	}
	
	
	
	function printBillClick(){
		//alert("PrintBill");
		 var pAmt=document.getElementById("finalAmount").innerHTML;
		 document.getElementById("pAmt").value=pAmt;
		 var detail =document.getElementById("custId").value;
		 document.getElementById("paidAmt").value=pAmt;
		 
		  
		 		$.getJSON('${getItemList}',{ajax:true},function(data){
		 			if(data.length<1){
		 				//$('#empty_itemList').show()
		 				alertify.error("Please Select Atleast One Item To Genrate Bill!!!!!");
		 			}else{
		 				$('#empty_itemList').hide()
		 				printAndSubmit();
		 			}
		 		});
		 		
		 		 
	}
	
	
	function cancelBill(val){
		//alert(val)
		$.getJSON('${cancelBill}',
		{
			ajax:true
		},function(data){
		//	alert(data.length);
			if(data.length==0){
				//alert("0");
				 
				$('#itemTable tr').remove();
				
				var mainTrStr = '<tr>'
				+'<th style="text-align: center;" width="2%">Sr</th>'
				+'<th style="text-align: center;">Product</th>'
				+'<th style="text-align: center;" width="10%">QTY</th>' 
				+'<th style="text-align: center;" width="13%">Price</th>' 
				+'<th style="text-align: center;" width="13%">Total</th>'
				+'<th style="text-align: center;" width="2%">Del</th>'
				+'</tr>';
			var mainTr = $(mainTrStr);
			$('#itemTable tbody').append(
					mainTr);
			
				if(val>0){
					document.getElementById("custId").value=0;
					$("#custId").trigger("chosen:updated");
				}
			 	
				document.getElementById("totalCnt").innerHTML="";
				document.getElementById("totalAmt").innerHTML="";
				document.getElementById("totalTax").innerHTML="";
				document.getElementById("finalAmount").innerHTML="";
			}
			
			//document.getElementById().value="";
		});
	}

	
	</script>

	<script>
	//makes sure the whole site is loaded
	  jQuery(window).load(function() {
		// will first fade out the loading animation
		$("#preloader").show();
		// will fade out the whole DIV that covers the website.
		jQuery("#preloader").delay(0).fadeOut("slow");

	})  
	  
 function billOnHold() {
		   
		var key =  $('#key').val() ;
		//var custId =  $('#cust').val() ;
		var custId =document.getElementById("custId").value;
		var rowcount = $('#itemTable tr').length;
		 
		//alert(rowcount)
	 if(rowcount>1){
		 
		  
		 if(custId!=""){
			 submitBillOnHold();
		 }else{
			 alertify.error("Select Customer");
		 }
		  
	 }else{
		 alertify.error("Add Minimum One Product");
	 }
		    
	}
	
	function revertHoldBillOnCurrent() {
		   
		var index =  $('#holdBillNo').val() ;
		  $
		.post(
				'${revertHoldBillOnCurrent}',
				{
					key : index,  
					ajax : 'true'
				},
				function(data) {
					  
					window.location = "${pageContext.request.contextPath}/newPos/1";
							 
				});   
	}
	
	function submitBillOnHold() {
		   
		var key =  $('#key').val() ;
		var custId =document.getElementById("custId").value;
			 
				if(custId!="" || key>0 ){
					  
					  $.post(
							'${billOnHold}',
							{
								key : key, 
								holdCustName : custId,
								ajax : 'true'
							},
							function(data) {
								
								window.location = "${pageContext.request.contextPath}/newPos/0";
										 
							});  
				}else{
					alertify.error("Select Customer");
					 
				}
			 
	}
	function cancelFromHoldBill(index) {
		   
		 
		  $
		.post(
				'${cancelFromHoldBill}',
				{
					key : index,  
					ajax : 'true'
				},
				function(data) {
					  
					window.location = "${pageContext.request.contextPath}/newPos/0";
							 
				});   
	}
</script>

</body>

</html>