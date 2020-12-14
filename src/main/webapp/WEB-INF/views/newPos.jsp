<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
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
	href="${pageContext.request.contextPath}/resources/newpos/images/favicon.png"
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

<!-- custom scrollbar stylesheet -->
<style >
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

</style>
</head>

<body >
<input type="hidden" id="sellBillNo">
<c:url value="addItemInBillLIst" var="addItemInBillLIst"></c:url>
<c:url value="getBillItemList" var="getBillItemList"></c:url>
<c:url value="getCustomerList" var="getCustomerList"></c:url>
<c:url value="addCustomer" var="addCustomer"></c:url>
<c:url value="deleteItem" var="deleteItem"></c:url>
<c:url value="genrateSellBill" var="genrateSellBill"></c:url>
<c:url  value="getItemList" var="getItemList"></c:url>
<c:url value="cancelBill" var="cancelBill" ></c:url>
<c:url value="billOnHold" var="billOnHold" ></c:url>
<c:url value="revertHoldBillOnCurrent" var="revertHoldBillOnCurrent" ></c:url>
<c:url value="cancelFromHoldBill" var="cancelFromHoldBill" ></c:url>

<div style="display: none;">
 	<a href="${pageContext.request.contextPath}/newPos/0" id="relod"></a>
</div>
	<form action="" method="get" >
	<input type="hidden" id="SubCatForSearch"  name="SubCatForSearch" value="0">

		<div id="iList" style="display: none;">
		${jsonItemList}
		</div>
		
		
		<!--wrapper-start-->
		<div class="wrapper">

			<header>
				<div class="logo">
					<img
						src="${pageContext.request.contextPath}/resources/images/minlogo.png"
						alt="madhvi_logo">
				</div>
				<div class="drop_menu">
					<div class="dropdown">
						<div class="select">
							<span>Hold Bill</span>
						</div>

						<ul class="dropdown-menu">
							<c:forEach items="${holdingList}" var="holdingList">
								<c:choose>
									<c:when test="${holdingList.key==key}">
										<li onclick="revertHoldBillOnCurrent(${holdingList.key})">${holdingList.value.tempCustomerName}</li>
									</c:when>
									<c:otherwise>
										<li onclick="revertHoldBillOnCurrent(${holdingList.key})">${holdingList.value.tempCustomerName}</li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</ul>
					</div>
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
											<ul>
												<li onclick="setItemList();subCatForSrch(0)"  ><a href="javascript:void(0)" class="scroll_menu">All</a></li>
												<c:forEach items="${subCatList}" var="subCat">

													<li onclick="selectBySubCatId(${subCat.subCatId});subCatForSrch(${subCat.subCatId})"><a href="javascript:void(0)" class="scroll_menu">${subCat.subCatName}</a></li>
												</c:forEach>


											</ul>
										</div>
									</div>
								</div>
							</div>





						</div>
						<div class="menu_search">
							<input name="" type="text" class="input_cat"  onkeyup="searchByItemName(this.value)"/>
						</div>
						<div class="clr"></div>
					</div>
								<div class="row">

										<span
											style="padding-top: 0px; float: left; margin-top: 13px; margin-left: 13px; font-size: 16px;"> SMS:<i class="fa fa-envelope-o" style="color: yellow">
											</i>
											<label class="switch">  
										 <input type="checkbox"
											name='isSMS' id='isSMS'  onchange="SliderAlert()"/> <span class="slider round" ></span>
										</label>
											
									</span>
										 
										
										
										<span
											style="padding-top: 0px; float: left; margin-top: 13px; margin-left: 13px; font-size: 16px;">Check Stock<i class="fa fa-envelope-o" style="color: yellow">
											
											<label class="switch">  <input type="checkbox"
											name='checkStock' id='checkStock' onchange="cancelBill(0)"/> <span class="slider round"></span>
										</label></i>
											</span>
										 
								</div>

					<!--listing box start here-->
					<div class="cat_list_bx">

						<div class="cat_list">
							<div class="carlist_scrollbars">


								<!--category pricing popup start-->
								<div id="quantity" class="category_popup">
									<h3 class="pop_head">Quantity</h3>

									<div class="add_frm">

										<div class="add_row">
											<div class="add_row_l">
												<span class="add_txt">Kg wise</span> <input name=""
													type="text" class="input_add" />
											</div>
											<div class="add_row_r">
												<span class="add_txt">Rate wise</span> <input name=""
													type="text" class="input_add" />
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
											<a href="javascript:void(0)">Save</a>
										</div>
										<div class="clr"></div>
									</div>

									<!--<button class="slide_close"><i class="fa fa-times" aria-hidden="true"></i></button>-->
								</div>
								<script type="text/javascript">
									$(document).ready(function() {
										$('#quantity').popup({
											focusdelay : 400,
											outline : true,
											vertical : 'top'
										});
									});
								</script>




								<div class="new_bx">
									<ul id="itemUl">
										<!--li start here-->
										<%-- <c:forEach items="${ItemList}" var="item">
										
											<li>
											<div id="itemDiv">
											
								
												<div class="new_cake_bx">

													<a href="javascript:void(0)" class="initialism addcust1_open">

														<div class="cake_picture">
															<p>${item.mrp}</p>
															<img
																src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg"
																alt=""> <span>${item.totalRegStock}</span>
														</div>
														<div class="cake_name">${item.itemName}</div>

													</a>

												
													
												</div>
										</div>
											</li>
										</c:forEach> --%>
										<!--pending amount popup-->
											 <div id="addcust1" class="add_customer calcy">
											 <input type="hidden" name="itemNameHidden" id="itemNameHidden">
											 <input type="hidden" name="itemUomHidden" id="itemUomHidden">
											 <input type="hidden" name="itemIdHidden" id="itemIdHidden">
											 <input type="hidden" name="itemTaxHidden" id="itemTaxHidden">
											 <input type="hidden" name="itemMrp" id="itemMrp">
											  <input type="hidden" name="itemCatId" id="itemCatId">
											   <input type="hidden" name="itemTax1Hidden" id="itemTax1Hidden">
											  <input type="hidden" name="itemTax2Hidden" id="itemTax2Hidden">
											  <input type="hidden" name="aviableQty" id="aviableQty">
											 
											 
											 
											
											 
											 
											 

														<div class="calcy_bx">
															<div class="calcy_1">
																<div class="calculator_bx">
																	<div class="cal_quan">
																		<div class="qty_l">QTY</div>
																		<div class="qty_m">
																		<!-- onkeyup="checkAviableQty(1)" -->
																			<input type="text" class="qty_one numberOnly" placeholder="QTY" value="1" name="enterQty" id="enterQty"  >
																		</div>
																		<div class="qty_r">
																			<button type="submit" class="go_btn"></button>
																		</div>
																		<div class="clr"></div>
																	</div>

																	<div class="calc_no">
																		<div class="calc_no_l">
																			<ul>
																				<li><a href="javascript:void(0)" onclick="calPad(1,7)">7</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,8)">8</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,9)">9</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,4)">4</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,5)">5</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,6)">6</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,1)">1</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,2)">2</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,3)">3</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,0)">0</a></li>
																				<li style="visibility: hidden;"><a href="javascript:void(0)">.</a></li>
																				<li><a href="javascript:void(0)" onclick="calPad(1,10)"><img
																						src="${pageContext.request.contextPath}/resources/newpos/images/next_arrow_one.png"
																						alt="next_arrow_one"> </a></li>
																			</ul>
																		</div>
																		<div class="calc_no_r">
																		<!-- <a href="javascript:void(0)" onclick="addItem(1)" > -->
																			<a href="javascript:void(0)" onclick="checkAviableQty(1)" ><img
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
																				<li><a href="javascript:void(0)">7</a></li>
																				<li><a href="javascript:void(0)">8</a></li>
																				<li><a href="javascript:void(0)">9</a></li>
																				<li><a href="javascript:void(0)">4</a></li>
																				<li><a href="javascript:void(0)">5</a></li>
																				<li><a href="javascript:void(0)">6</a></li>
																				<li><a href="javascript:void(0)">1</a></li>
																				<li><a href="javascript:void(0)">2</a></li>
																				<li><a href="javascript:void(0)">3</a></li>
																				<li><a href="javascript:void(0)">0</a></li>
																				<li><a href="javascript:void(0)">.</a></li>
																				<li><a href="javascript:void(0)"><img
																						src="${pageContext.request.contextPath}/resources/newpos/images/next_arrow_one.png"
																						alt="next_arrow_one"> </a></li>
																			</ul>
																		</div>
																		<div class="calc_no_r">
																			<a href="javascript:void(0)"><img
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
																<a href="javascript:void(0)" onclick="checkAviableQty(1)" >Submit</a>
															</div>
															<div class="clr"></div>
														</div>

													</div> 

									
									</ul>
								</div>





							</div>
						</div>
					</div>
				</div>
				

				<div class="cat_r">

					<!--top-buttons row-->
					<div class="pending_row">
						<a href="javascript:void(0)" class="pending_btn initialism slide_open">Pending
							Amt : <span>550.00000</span>
						</a>

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


						<input id=key name="key" value="${key}" type="hidden"> 
						<!--<a href="javascript:void(0)" class="pending_btn initialism addcust_open">Advance Amt : <span>550.00000</span></a>-->

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
										<input name="custName" id="custName" type="text" class="input_add"  />
									</div><span id="name_error" style="display: none;color:red" class="text-danger" >Please Enter Customer Name</span>
									<div class="clr"></div>
								</div>
								<div class="add_frm_one">
									<div class="add_customer_one">Mobile Number</div>
									<div class="add_input">
										<input name="custMob"  id="custMob" type="text" class="input_add" maxlength="10" minlength="1"  oninput="this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');" />
									</div><span id="mob_error" style="display: none;color:red"class="text-danger" >Please Enter Mob No</span>
									<span id="mob_error2" style="display: none;color:red"class="text-danger" >Enter10 Digits </span>
									<div class="clr"></div>
								</div>
								<div class="add_frm_one">
									<div class="add_customer_one">GST NO</div>
									<div class="add_input">
										<input name="custGst" id="custGst" type="text" class="input_add" maxlength="16"/>
									</div><span id="gst_error" style="display: none;color:red" class="text-danger">Please Enter Gst No.</span>
									<div class="clr"></div>
								</div>
								
							</div>

							<div class="pop_btns">
								<div class="close_l">
									<button class="addcust_close close_btn" id="clsAddCust">Close</button>
								</div>
								<div class="close_r"  id="saveBtn">
									<a href="javascript:void(0)" onclick="addCust()">Save</a>
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


						<a href="javascript:void(0)" class="pending_btn">Total Amt : <span>550.00000</span></a>
					</div>
					

					<!--customer drop down here-->
					<div class="add_customer_bx">
						<!--customer row 1-->
						<div class="customer_row">
							<div class="customer_one">Customer</div>
							<div class="customer_two small_size">
								<input name="selectCust"  list="templates" id="selectCust" type="text" class="input_add"
									placeholder="Add Customer" onchange="getCustInfo(this.value)" value="${holdBill.tempCustomerName}~${holdBill.tempMobNo}~${holdBill.tempGstNo}"/>
									<span id="error_customer"  style="display: none;color :red">Please Select Customer</span>
									
									<datalist id="templates"  >
									<%-- <c:forEach items="${customerList}" var="cust">
										<option value='${cust.userName} ~ ${cust.phoneNo} ~ ${cust.gstNo}' ></option>
									</c:forEach> --%>
								<!-- <option value='Remark 1'>Remark 1</option>
								<option value='Remark 2'>Remark 2</option> -->
							</datalist>
							</div>
							<div class="customer_three increase_size">
								<button class="plus_btn addcust_open" >
									<i class="fa fa-plus" aria-hidden="true"></i>
								</button>
							</div>
						<!-- 	<div class="customer_three">
								<button class="plus_btn">
									<i class="fa fa-pencil" aria-hidden="true"></i>
								</button>
							</div> -->
							<div class="clr"></div>
						</div>
						<!--customer row 2-->
						<div class="customer_row">
							<div class="customer_one">Item</div>
							<div class="customer_two">
							
								<div class="customer_divide">
                        
                         	  <div class="dropdown popup_drop">
                                <div class="select"> 
                                <span>Select Item</span></div>
                                <input type="hidden" name="gender">
                                <ul class="dropdown-menu">
                                	<c:forEach items="${ItemList}" var="items">
                               
                                	 <li id="${items.itemId}" onclick="opnItemPopup(${items.itemId},'${items.itemName}',${items.catId},${items.totalRegStock},${items.itemTax1},${items.itemTax2},${items.mrp},'${items.uom}','${1}')" >${items.itemName}</li>  
                                	</c:forEach>
                                 <!--   <li id="male">Akshay</li>
                                    <li id="female">Mahesh</li>
                                    <li id="female">Anmol</li> -->
                                </ul>
                            </div>
                        
                    </div>
                    <div class="customer_divide_1"><input name="tblQty" type="text" id="tblQty"  class="input_add" placeholder="Quantity"  onblur="checkAviableQty(0)" /></div> <!-- onblur="addItem(0)"  -->
																
							
							</div>
							<!-- <div class="customer_three">
								<button class="plus_btn" disabled="disabled">
									<i class="fa fa-plus" aria-hidden="true"></i>
								</button>
							</div> -->
							<div class="clr"></div>
						</div>
					</div>

					<!--product table-->
					<div class="total_table_one">
						<div class="scrollbars">
					

							<table id="itemTable">
							<thead>
								<tr>
									<th>Sr.</th>
									<th>Product</th>
									<th>Qty.</th>
									<th>Price</th>
									<th>Total</th>
									<th>Del</th>
								</tr>
							</thead>
							<tbody >
								<c:forEach items="${holdBill.itemList}" var="itemList"
										varStatus="count">
										<c:set var="totalItemCount" value="${totalItemCount+1}"></c:set>
										<tr>
											<td>${count.index+1}</td>
											<td style="">${itemList.itemName}</td>
											<td class="addcust1_open" onclick="opnItemPopup(${itemList.itemId},'${itemList.itemName}',${itemList.catId},${itemList.aviableQty},${itemList.itemTax},${itemList.itemTax},${itemList.itemMrp},'${itemList.itemUom}',${0})"
											>${itemList.itemQty}</td>
											<td style="">${itemList.itemMrp}</td>
											<td style="">${itemList.calPrice}</td>
											<td style="text-align: center;"><a href="javascript:void(0)"
												title="Delete"
												onclick="deleteItem(${itemList.itemId})"><i
													class="fa fa-trash"></i></a></td>
											</tr>
											<c:set var="totalTaxableAmt"
											value="${totalTaxableAmt+itemList.payableAmt}"></c:set>
										<c:set var="totalTaxAmt"
											value="${totalTaxAmt+itemList.payableTax}"></c:set>
									<c:set var="totalAmt" value="${totalAmt+itemList.calPrice}"></c:set>
											</c:forEach>
							
							</tbody>
						
						
								<!-- <tr>
									<td>02</td>
									<td>Chocolates</td>
									<td>1</td>
									<td>200</td>
									<td>200</td>
									<td><a href="javascript:void(0)" class="trash_icon"><i
											class="fa fa-trash-o" aria-hidden="true"></i></a></td>
								</tr> -->



							</table>
								<div>
								<span style="display :none ;color:red" id="empty_itemList">*Select Atleast One Item To Genrate Bill!!!!</span>
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
								<td>Total Items</td>
						<td id="totalCnt">${totalItemCount}</td>
								<td>Total :</td>
								<td align="right" id="totalAmt">${totalAmt}</td>
							</tr>
							<tr bgcolor="#ffe5e6" style="border-top: 1px solid #f4f4f4;">
								<td>Discount</td>
								<td>(0.00) 0.00</td>
								<td>Order Tax</td>
								<td align="right" id="totalTax"><fmt:formatNumber type = "number" 
         						maxIntegerDigits = "2" value = "${totalTaxAmt}" /></td>
							</tr>
							<tr bgcolor="#fefcd5" style="border-top: 1px solid #f4f4f4;">
								<td style="font-weight: 600;">Total Payable</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td style="font-weight: 600;" align="right" id="finalAmount">${totalAmt}</td>
							</tr>
						</table>
					</div>


					<!--five button here-->
					<div class="buttons_row">
						<div class="button_one">
							<a href="javascript:void(0)" class="hold hold_btn" onclick="submitBillOnHold()">Hold</a>
							 <a href="javascript:void(0)" class="hold can_btn" onclick="cancelFromHoldBill(${key})">Cancel</a>
						</div>
						<div class="button_one">
						<button  id="payment1" class="hold print_btn   initialism payment_open"  style="display: none;">Payment</button>
							<a href="javascript:void(0)"    class="hold print_btn  initialism  " onclick="paymentClick()">Payment</a>
						<!-- 	<a href="javascript:void(0)" class="hold print_btn"  >Print Order</a>  -->
						<!-- <button  id="payment1" class="hold bill_btn   "  style="display: none;">Print Bill</button> -->
							<a href="javascript:void(0)" class="hold bill_btn" onclick="printBillClick()">Print Bill</a>
						</div>
						<div class="button_two">
						<!-- 	<button  id="payment1" class="hold pay_btn  initialism payment_open"  style="display: none;">Payment</button>
							<a href="javascript:void(0)"   class="hold pay_btn  initialism " onclick="paymentClick()">Payment</a> -->
							<a href="javascript:void(0)"   class="hold pay_btn  initialism " onclick="billClick()">Bill</a>
						</div>

						<!--Payment popup start-->
						<div id="payment" class="add_customer">
							<input type="hidden" id="hiddenCustName" name="hiddenCustName">
							<input type="hidden" id="hiddenCustMob" name="hiddenCustMob">
						
						
							<!-- <button class="payment_close close_popup" ">
								<i class="fa fa-times" aria-hidden="true"></i>
							</button> -->
							<h3 class="pop_head">Payment</h3>

							<div class="add_frm">
									<div class="add_customer_one">Discount %</div>
								<div class="add_input" id="discountPopup">
									<input type="text" name="discPer" id="discPer" step="0.01"
										oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
										onchange="itemDiscPerCalculation(1)"
										onkeyup="itemDiscPerCalculation(1)" class="form-control"
										value="0" placeholder="Disc %"
										style="text-align: center; width: 90px; border-radius: 20px;" />
									<label for="discAmtLabel"
										style="font-weight: 700; padding-left: 5px;">&nbsp;Disc
										Amt&nbsp;</label>
										 <input type="text" name="discAmt" id="discAmt"
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
												<li id="1"  >Cash</li>
												<li id="2" >Card</li>
												<li id="3">E-pay</li>
											</ul>
										</div>

									</div>
										<span id="payMode_error" style="display: none;color:red">Please Select Payment Mode</span>
									<div class="clr"></div>
								</div>
								<div class="add_frm_one">
									<div class="add_customer_one">Amount</div>
									<div class="add_input">
										<input oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"  name="pAmt" id="pAmt" type="text" class="input_add" disabled="disabled" />
									</div>
									<div class="clr"></div>
								</div>

							<!-- 	<div class="add_frm_one">
									<div class="add_customer_one">Credit Bill</div>
									<div class="add_input">
										<div class="radio_row popup_radio">
											<ul>
												<li><input type="radio" id="yes" name="selector">
													<label for="yes">Yes</label>
													<div class="check"></div></li>
												<li><input type="radio" id="no" name="selector">
													<label for="no">No </label>
													<div class="check">
														<div class="inside"></div>
													</div></li>
											</ul>
										</div>
									</div>
									<div class="clr"></div>
								</div> -->
								
								
							

								<label style="font-weight: 700; padding-left: 5px;">Paid&nbsp;</label>
								<input type="text" name="paidAmt" id="paidAmt"
									oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
									onchange="amtReturnCal()" onkeyup="amtReturnCal()"
									class="form-control" value="" placeholder="Amount"
									style="text-align: center; width: 90px; border-radius: 20px;" />
									


								&nbsp;&nbsp; <label style="font-weight: 700; padding-left: 5px;">Return&nbsp;</label>
								<input type="text" name="rAmt" id="rAmt" readonly="readonly"
									class="form-control" value="" placeholder="Amount"
									style="text-align: center; width: 90px; border-radius: 20px;" />



								<span id="paidAmt_error" style="display: none;color:red">Please Enter Paid Amount</span>

							</div>



							<div class="pop_btns">
								<div class="close_l" >
									<button  class="payment_close close_btn" id="closePay">Close</button>
								</div>
								
								<div class="close_l">
									<a onclick="printAndSubmit()" href="javascript:void(0)">Print&Submit</a>
								</div>
								<div class="close_r">
									<a onclick="submitPayment()" href="javascript:void(0)">Submit</a>
								</div>
								<div class="clr"></div>
							</div>

							<!--<button class="slide_close"><i class="fa fa-times" aria-hidden="true"></i></button>-->
						</div>
						<script type="text/javascript">
							$(document).ready(function() {
								$('#payment').popup({
									focusdelay : 400,
									outline : true,
									vertical : 'top'
								});
							});
						</script>

					</div>


				</div>
				
				
			
				
				
				
				

				<script>
					$(document).ready(function() {
						$('.carlist_scrollbars').ClassyScroll();
					});
				</script>

			</section>

		</div>
		<!--wrapper-end-->
	</form>

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
		setItemList();
		getCustomerList();
			
	});
	
	
	
	function setItemList() {
		
		
		var iList=document.getElementById("iList").innerHTML;
		//alert(iList);
		sessionStorage.setItem("itemList",iList);
		var jsonStr= $.parseJSON(iList);
		
		var divStr =" ";
		var stockVal=0;
		//alert(jsonStr.length)
		for(var i=0 ; i <  jsonStr.length ; i++){
			
			if(jsonStr[i].totalRegStock<0){
				stockVal=0;
			}else{
				stockVal=jsonStr[i].totalRegStock;
			}	
	
		 divStr=divStr+'<li onclick="opnItemPopup('+jsonStr[i].itemId+',\'' + jsonStr[i].itemName + '\',' + jsonStr[i].catId + ',' + jsonStr[i].totalRegStock + ',' + jsonStr[i].itemTax1 + ',' + jsonStr[i].itemTax2 + ',' + jsonStr[i].mrp + ',\'' + jsonStr[i].uom + '\','+1+')"><div id="itemDiv">'+
						'<div class="new_cake_bx" >'+
							'<a href="javascript:void(0)" class="initialism  addcust1_open  " >'+
								'<div class="cake_picture">'+
									'<p>'+jsonStr[i].mrp+'</p>'+
									'<img src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg" alt="">'+
									'<span>'+stockVal+'</span>'+
								'</div>'+
							'<div class="cake_name">'+jsonStr[i].itemName+'</div>'+
						'</a> </div> </div> </li>';
								
								
				//	alert(iList[i].itemName);	
			}
		document.getElementById("itemUl").innerHTML=divStr;
		
	
		}

	
	
	
	function selectBySubCatId(id){
		//alert(id);
		var divStr="";
		var jsonStr = $.parseJSON(sessionStorage.getItem("itemList"));
		//alert(jsonStr);
		document.getElementById("itemUl").innerHTML="";
		for(var i=0 ; i <  jsonStr.length ; i++){
	
			if(parseInt(jsonStr[i].subCatId)==parseInt(id)){
				//alert(jsonStr[i].subCatId);
			 divStr=divStr+'<li> <div id="itemDiv">'+
							'<div class="new_cake_bx">'+
								'<a href="javascript:void(0)" class="initialism addcust1_open" onclick="opnItemPopup('+jsonStr[i].itemId+',\'' + jsonStr[i].itemName + '\','+jsonStr[i].catId+','+jsonStr[i].totalRegStock+',' + jsonStr[i].itemTax1 + ',' + jsonStr[i].itemTax2 + ',' + jsonStr[i].mrp + ',\'' + jsonStr[i].uom + '\','+1+')" >'+
									'<div class="cake_picture">'+
										'<p>'+jsonStr[i].mrp+'</p>'+
										'<img src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg" alt="">'+
										'<span>'+jsonStr[i].totalRegStock+'</span>'+
									'</div>'+
								'<div class="cake_name">'+jsonStr[i].itemName+'</div>'+
							'</a> </div> </div> </li>';
									
						}					
					//	alert(iList[i].itemName);	
				}
		document.getElementById("itemUl").innerHTML=divStr;
		
	}
	
	
	function searchByItemName(name) {
	var divStr="";
		//var name =document.getElementById("input_cat");
		//alert(name);
		 var jsonStr = $.parseJSON(sessionStorage.getItem("itemList"));
		//alert(name);
		document.getElementById("itemUl").innerHTML="";
		var flag=document.getElementById("SubCatForSearch").value;
		if(parseInt(flag)>0){
			//alert("If");
			for(var i=0 ; i <  jsonStr.length ; i++){
				if(jsonStr[i].itemName.includes(name) && parseInt(jsonStr[i].subCatId)==parseInt(flag)  ){
					//alert(jsonStr[i].itemName);
				 divStr=divStr+'<li> <div id="itemDiv">'+
								'<div class="new_cake_bx">'+
									'<a href="javascript:void(0)" class="initialism addcust1_open" onclick="opnItemPopup('+jsonStr[i].itemId+',\'' + jsonStr[i].itemName + '\',' + jsonStr[i].catId + ','+jsonStr[i].totalRegStock+',' + jsonStr[i].itemTax1 + ',' + jsonStr[i].itemTax2 + ',' + jsonStr[i].mrp + ',\'' + jsonStr[i].uom + '\','+1+')">'+
										'<div class="cake_picture">'+
											'<p>'+jsonStr[i].mrp+'</p>'+
											'<img src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg" alt="">'+
											'<span>'+jsonStr[i].totalRegStock+'</span>'+
										'</div>'+
									'<div class="cake_name">'+jsonStr[i].itemName+'</div>'+
								'</a> </div> </div> </li>';
										
							}					
						//	alert(iList[i].itemName);	
					}
		}else {
			//alert("Else");
			for(var i=0 ; i <  jsonStr.length ; i++){
				if(jsonStr[i].itemName.includes(name)){
					//alert(jsonStr[i].itemName);
				 divStr=divStr+'<li> <div id="itemDiv">'+
								'<div class="new_cake_bx">'+
									'<a href="javascript:void(0)" class="initialism addcust1_open"  onclick="opnItemPopup('+jsonStr[i].itemId+',\'' + jsonStr[i].itemName + '\',' + jsonStr[i].catId + ','+jsonStr[i].totalRegStock+',' + jsonStr[i].itemTax1 + ',' + jsonStr[i].itemTax2 + ',' + jsonStr[i].mrp + ',\'' + jsonStr[i].uom + '\','+1+')">'+
										'<div class="cake_picture">'+
											'<p>'+jsonStr[i].mrp+'</p>'+
											'<img src="${pageContext.request.contextPath}/resources/newpos/images/chocolate_cake.jpg" alt="">'+
											'<span>'+jsonStr[i].totalRegStock+'</span>'+
										'</div>'+
									'<div class="cake_name">'+jsonStr[i].itemName+'</div>'+
								'</a> </div> </div> </li>';
										
							}					
						//	alert(iList[i].itemName);	
					}
		}
		
	
		document.getElementById("itemUl").innerHTML=divStr; 
		
	}
	
	
	function subCatForSrch(val){
		//alert("FUNC"+val);
		document.getElementById("SubCatForSearch").value=val;
		//var s=document.getElementById("SubCatForSearch").value;
		//alert(s);
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
			// itemRateCalculation(1);
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
			// itemRateCalculation(2);
			 $("#enterRate").focus(); 
		 }
		 
		 if(value==11){
			 document.getElementById("enterQty").value = 1;
			 document.getElementById("enterRate").value = "";
		 }
		 
	}
	
	
function opnItemPopup(itemId,itemName,catId,aviableQty,itemTax1,itemTax2,itemMrp,uom,flag){
	//'+jsonStr[i].itemId+','+jsonStr[i].itemName+','+jsonStr[i].itemTax1+','+jsonStr[i].itemTax2+','+jsonStr[i].mrp+','+jsonStr[i].uom+'
	//itemId,itemName,itemTax1,itemTax2,itemMrp,uom
	//alert(itemTax1+itemTax2);
	//alert("kjhjkhjk  "+itemName)
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
		
		
		
		
		//alert("Hiii");
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
		var price= qty*itemMrp;
		var paybeleTax=(price/100)*itemTax;
		var paybeleAmt=price+paybeleTax;
		//alert(price);
		//alert(itemTax);
		//alert(paybeleTax);
		//alert(paybeleAmt);
		//alert("Here1")
		
		$.getJSON('${pageContext.request.contextPath}/addItemInBillLIst',
			{ 
			itemName : itemName,
			itemId 	 : itemId,
			itemMrp  : itemMrp,
			itemTax  : itemTax,
			tax1	 : tax1,
			tax2	 : tax2,
			catId 	 : catId,
			aviableQty : aviableQty,
			itemUom  : itemUom,
			qty		 : qty,
			price    : price,
			paybeleTax : paybeleTax,
			paybeleAmt : paybeleAmt,
			ajax : 'true'
			
			},function(data){
				var itemCnt = data.length;
				var total = 0;
				var tax = 0;
				var finalAmt =0;
				//alert(data.length);
					document.getElementById("enterQty").value=1;
					document.getElementById("closeAddcust").click();
					$('#itemTable td').remove();
					$
					.each(
							data,
							function(key, item) {
					
								 
						
						//alert(JSON.stringify(item))
						finalAmt += parseFloat(item.payableAmt);
						total += parseFloat(item.calPrice);
						tax += parseFloat(item.payableTax);
						var tr=$('<tr></tr>');
						tr
						.append($(
								'<td ></td>')
								.html(key+1));
							tr.append($('<td></td>').html(item.itemName));
							tr.append($('<td class="initialism addcust1_open"  onclick="opnItemPopup('+item.itemId+',\'' + item.itemName + '\','+item.catId+','+item.aviableQty+',' + item.itemTax + ',' + item.itemTax + ',' + item.itemMrp + ',\'' + item.itemUom + '\','+0+')" > </td>').html(item.itemQty));
							tr.append($('<td></td>').html(item.itemMrp));
							tr.append($('<td></td>').html(item.calPrice));
							tr.append($('<td></td>').html('<a href="javascript:void(0)" class="trash_icon" onclick="deleteItem('+item.itemId+')" ><i class="fa fa-trash-o" aria-hidden="true"></i></a>'));
							
							
							$('#itemTable tbody').append(tr);
							
							
					});
					//alert(itemCnt);
					document.getElementById("totalCnt").innerHTML=itemCnt;
					//alert(total);
					document.getElementById("totalAmt").innerHTML=total;
					//alert(tax);
					document.getElementById("totalTax").innerHTML=tax;
					//alert(finalAmt);
					document.getElementById("finalAmount").innerHTML=total;
					document.getElementById("tblQty").value="";
			});
	}
	
	function getCustomerList() {
		//alert(type);

		$.getJSON('${pageContext.request.contextPath}/getCustomerList', {
			
			ajax : 'true'
		}, function(data) {

			//alert(data);

			$('#templates').find('option').remove().end()

			for (var i = 0; i < data.length; i++) {

				var flag = 0;
				var dataValue=data[i].userName+"~"+data[i].phoneNo+"~"+data[i].gstNo;
				
				$("#templates").append($("<option></option>").attr("value",dataValue).text(data[i].phoneNo+data[i].userName));
			}
			$("#templates").trigger("chosen:updated");

		});

	}

 function getCustInfo(val){
	//
	
	//alert(val);
	//var temp= document.getElementById("custMob").value;
	var phoneno = /^\d{10}$/;
	if(val.match(phoneno)){
		document.getElementById("custMob").value=val;
	}else{
		 var str=val.split("~");
		
		document.getElementById("custName").value=str[0];
		document.getElementById("custMob").value=str[1];
		document.getElementById("custGst").value=str[2]; 
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
		isError=false;
		$('#name_error').hide();
	}
	if(!mob){
		isError=true;
		$('#mob_error').show()
		
	}else{
		isError=false;
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
	/* if(!gst){
		isError=true;
		$('#gst_error').show()
		
	}else{
		isError=false;
		$('#gst_error').hide();
	} */
	
	if(isError){
		//alert("In If");
	}else {
		
		$.post('${pageContext.request.contextPath}/addCustomer',
				{
				name :name,
				mob:mob,
				gst: gst,
				ajax : 'true'
				},function(data){
				//	alert(data);
				if(data==1){
					getCustomerList();
						alert("Customer Addeed!");
						document.getElementById("clsAddCust").click();
						document.getElementById("selectCust").value=name+"~"+mob+"~"+gst;
						document.getElementById("custName").value="";
						document.getElementById("custMob").value="";
						document.getElementById("custGst").value="";
					}else{
						alert("Unable To Add Customer");
					} 
				});
		
		
		
	}
		
}
 
 
 

 
 function deleteItem(id){
	 
	 $.post('${pageContext.request.contextPath}/deleteItem',
			 {
		 		id :id,
		 		ajax : 'true'
			 },
			 function(data){
					//alert(JSON.stringify(data));
					var itemCnt = data.length;
					var total = 0;
					var tax = 0;
					var finalAmt =0;
					//alert(data.length);
						document.getElementById("enterQty").value=1;
						document.getElementById("closeAddcust").click();
						$('#itemTable td').remove();
						$
						.each(
								data,
								function(key, item) {
						
									 
							
							//alert(JSON.stringify(item))
							finalAmt += parseFloat(item.payableAmt);
							total += parseFloat(item.calPrice);
							tax += parseFloat(item.payableTax);
							var tr=$('<tr></tr>');
							tr
							.append($(
									'<td ></td>')
									.html(key+1));
								tr.append($('<td></td>').html(item.itemName));
								tr.append($('<td class="initialism addcust1_open"  onclick="opnItemPopup('+item.itemId+',\'' + item.itemName + '\','+item.catId+','+item.aviableQty+',' + item.itemTax + ',' + item.itemTax + ',' + item.itemMrp + ',\'' + item.itemUom + '\','+0+')" > </td>').html(item.itemQty));
								tr.append($('<td></td>').html(item.itemMrp));
								tr.append($('<td></td>').html(item.calPrice));
								tr.append($('<td></td>').html('<a href="javascript:void(0)" class="trash_icon" onclick="deleteItem('+item.itemId+')" ><i class="fa fa-trash-o" aria-hidden="true"></i></a>'));
								
								
								$('#itemTable tbody').append(tr);
								
								
						});
						//alert(itemCnt);
						document.getElementById("totalCnt").innerHTML=itemCnt;
						//alert(total);
						document.getElementById("totalAmt").innerHTML=Math.round(total);
						//alert(tax);
						document.getElementById("totalTax").innerHTML=Math.round(tax);
						//alert(finalAmt);
						document.getElementById("finalAmount").innerHTML=Math.round(finalAmt);
						document.getElementById("tblQty").value="";
				});
	 
 }
 
 
 function paymentClick(){
	
	 var pAmt=document.getElementById("finalAmount").innerHTML;
	 //alert(pAmt);
	 document.getElementById("pAmt").value=pAmt;
	 var detail =document.getElementById("selectCust").value;
	if(!detail){
	 		//$('#error_customer').show()
		alert("Please Select Customer!!!!!");
	 	}else{
	 		
	 		$('#error_customer').hide()
	 		$.getJSON('${pageContext.request.contextPath}}/getItemList',{ajax:true},function(data){
	 			if(data.length<1){
	 				//$('#empty_itemList').show()
	 				alert("Please Select Atleast One Item To Genrate Bill!!!!!");
	 			}else{
	 				$('#empty_itemList').hide()
	 				document.getElementById("payment1").click();
	 			}
	 		});
	 		
	 	}
	 	
 }
 
 function billClick(){
	 var r = confirm("Are you sure you want to submit?");
		if (r == true) {
	 var pAmt=document.getElementById("finalAmount").innerHTML;
	 document.getElementById("pAmt").value=pAmt;
	 var detail =document.getElementById("selectCust").value;
	 document.getElementById("paidAmt").value=pAmt;
	 
	 
	 
	 if(!detail){
	 		//$('#error_customer').show()
	 		alert("Please Select Customer!!!!!");
	 	}else{
	 		$('#error_customer').hide()
	 		$.getJSON('${pageContext.request.contextPath}/getItemList',
	 		{ajax:true},function(data){
	 			if(data.length<1){
	 				//$('#empty_itemList').show()
	 				alert("Please Select Atleast One Item To Genrate Bill!!!!!");
	 				
	 			}else{
	 				$('#empty_itemList').hide()
	 				submitPayment();
	 			}
	 		});
	 			//document.getElementById("payment1").click();

	 		
	 		
	 	}
		}
	 
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
	 
	 var key=$("#key").val();
	 var custName=document.getElementById("selectCust").value;
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
		 $.post('${pageContext.request.contextPath}/genrateSellBill',
				 {
			 		custName : custName,
			 		paidAmt	 : payableAmt,
			 		payMode  : payMode,
			 		payableAmt : payableAmt,
			 		discPer  : discPer,
			 		isSMS	:	isSMS,
			 		key : key,
			 		ajax : true
				 },
				 function(data){
					 if(data){
						alert("Bill Genrated Successfully!!!");
						
						 document.getElementById("closePay").click();
						 document.getElementById("relod").click();
						 
					 }
				 });   
	  } 
 
 }
 
 
 function  checkAviableQty(flag){
	//alert("Ok");

	  var avQty =document.getElementById("aviableQty").value;
		if(flag>0){
			var qty= document.getElementById("enterQty").value;
		}else{
			var qty= document.getElementById("tblQty").value;
			}
		
		
		
		
		if(!document.getElementById("checkStock").checked){
			
			addItem(flag);
			}else{
				  if(parseInt(qty)<= parseInt(avQty)){
					  addItem(flag);
				  }else{
					  alert("Please Enter Quatity In Aviable Range");
				 		}
			}
		
		
		
		
		
	
	  
 }
 
	
	function printAndSubmit(){
		//alert("Ok");
		 var custName=document.getElementById("selectCust").value;
		 var paidAmt=document.getElementById("paidAmt").value;
		 var payMode=document.getElementById("payMode").value;  
		 var discPer=document.getElementById("discPer").value;  
		 var payableAmt=document.getElementById("pAmt").value;
		 var key=$("#key").val();
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
			 $.post('${pageContext.request.contextPath}/genrateSellBill',
					 {
				 		custName : custName,
				 		paidAmt	 : paidAmt,
				 		payMode  : payMode,
				 		payableAmt : payableAmt,
				 		discPer  : discPer,
				 		isSMS	: isSMS,
				 		key : key,
				 		ajax : true
					 },
					 function(data){
						 if (data == "") {
								alert("Order Not Placed !!");
						 }else 
						 {
							// alert("printing else"+JSON.stringify(data));
							  //var loginWindow = window.open('', 'UserLogin');
							 
							 
								//document.getElementById("li"+token).style.backgroundColor = "white";
							   window.open('${pageContext.request.contextPath}/pdfSellBillNewPos?billNo='+ data.sellBillNo+'&type=R');
							  //  alert("opened");
								
								document.getElementById("closePay").click();
								 document.getElementById("relod").click();	
			                
							}
						
					 });   
		 }
		
	}
	
	
	
	function printBillClick(){
		
		//alert("PrintBill");
		var r = confirm("Are you sure you want to submit?");
		if (r == true) {		  
		 
		 var pAmt=document.getElementById("finalAmount").innerHTML;
		 document.getElementById("pAmt").value=pAmt;
		 var detail =document.getElementById("selectCust").value;
		 document.getElementById("paidAmt").value=pAmt;
		 
		 
		 
		 if(!detail){
		 		//$('#error_customer').show()
			 alert("Please Select Customer!!!!!");
		 	}else{
		 		$.getJSON('${pageContext.request.contextPath}/getItemList',{ajax:true},function(data){
		 			if(data.length<1){
		 				//$('#empty_itemList').show()
		 				alert("Please Select Atleast One Item To Genrate Bill!!!!!");
		 			}else{
		 				$('#empty_itemList').hide()
		 				printAndSubmit();
		 			}
		 		});
		 		
		 		
		 		//document.getElementById("payment1").click();
		 	//	$('#error_customer').hide()
		 	
		 	}
		}
	}
	
	function billOnHold() {
		var key =  $('#key').val() ;
		var custId =  $('#cust').val() ;
		
		var rowcount = $('#itemTable tr').length;
		 
	 if(rowcount>1){		
		 if(key>0){
			//submitBillOnHold();
		 }else{
			 var modal = document.getElementById("custModel");
			 modal.style.display = "block"; 
			 document.getElementById("holdCustName").focus();
		 }
		  
	 }else{
		 alert("Add Minimum One Product");
	 }
		    
	}
	
	function submitBillOnHold() {
		var holdCustName = null;
		var custMob = null;
		var custGst = null;
		
		var key = $('#key').val();		
		
		var selectCust=$('#selectCust').val();
		holdCustName = $('#custName').val() ;
		custMob = $('#custMob').val();
		custGst = $('#custGst').val();
		
		if(holdCustName=="" || holdCustName==null){			
			var selCust = selectCust.split("~");
			holdCustName=selCust[0];
			custMob = selCust[1];
			custGst = selCust[2];
		}
		
		var rowcount = $('#itemTable tr').length;
		
		if(rowcount>1){
			
			if(holdCustName!="" || key>0){
				 
				  $.post(
						'${pageContext.request.contextPath}/billOnHold',
						{
							key : key, 
							holdCustName : holdCustName,
							custMob : custMob,							
							ajax : 'true'
						},
						function(data) {
							
							window.location = "${pageContext.request.contextPath}/newPos/0";
									 
						});  
			}else{
				alert("Enter Customer Name");
				document.getElementById("holdCustName").focus();
			}
		}else{
			alert("Add Minimum One Product");
		}		    
	}
	
	function revertHoldBillOnCurrent(index) {
		   
		$
		.post(
				'${pageContext.request.contextPath}/revertHoldBillOnCurrent',
				{
					key : index,  
					ajax : 'true'
				},
				function(data) {
					  
					window.location = "${pageContext.request.contextPath}/newPos/1";
							 
				}); 
	}
	function cancelFromHoldBill(index) {
		   
		 
		  $
		.post(
				'${pageContext.request.contextPath}/cancelFromHoldBill',
				{
					key : index,  
					ajax : 'true'
				},
				function(data) {
					  
					window.location = "${pageContext.request.contextPath}/newPos/0";
							 
				});   
	}	
	
	/* function cancelBill(val){		
		$.get('${pageContext.request.contextPath}/cancelBill',
		{
			ajax:true
		},function(data){
			//alert(data.length);
			if(data.length==0){
				//alert("0");
				$("#itemTable tbody tr").detach(); 
				if(val>0){
					document.getElementById("selectCust").value="";
				}
			 	
				document.getElementById("totalCnt").innerHTML="";
				document.getElementById("totalAmt").innerHTML="";
				document.getElementById("totalTax").innerHTML="";
				document.getElementById("finalAmount").innerHTML="";
			}
			
			//document.getElementById().value="";
		});
	} */
	</script>
	

	


</body>

</html>