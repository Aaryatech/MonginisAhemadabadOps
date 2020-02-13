
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<style>
.form-control {
    text-align: left !important;
}

table, th, td {
	border: 1px solid #9da88d;
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/include/header.jsp"></jsp:include>
<c:url var="editFrSupplier" value="/editFrSupplier"></c:url>

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

	<jsp:include page="/WEB-INF/views/include/logo.jsp"></jsp:include>

	<!--rightContainer-->
	<div class="fullGrid center">
		<!--fullGrid-->
		<div class="wrapperIn2">

			<!--leftNav-->

			<jsp:include page="/WEB-INF/views/include/left.jsp">
				<jsp:param name="myMenu" value="${menuList}" />
			</jsp:include>
            	<div class="sidebarright">
				 
	<form name="frm_search" id="frm_search" method="post"	action="${pageContext.request.contextPath}/addOtherItemProcess">
					
						<div class="col-md -3">
						<c:choose>
						<c:when test="${isEdit==1}">
						<div class="col1title" align="left"><h3>Edit Other Item</h3></div>
						</c:when>
						<c:otherwise>
						<div class="col1title" align="left"><h3>Add Other Item</h3></div>
						</c:otherwise>
						</c:choose>
							<input id="itemId" class="form-control"	  name="itemId" value="${itemSup.id}" type="hidden" >
							<input id="id" class="form-control"	  name="id"  value="${item.id}" type="hidden" >	
								<div class="col1title" align="right"> 
						<a href="${pageContext.request.contextPath}/showOtherBill"><input type="button" value="Other Purchase Bill" class="btn additem_btn">
							</a>
					</div>
						</div>
						
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Item Code*: </div>
						</div>
						<div class="col-md-3">
						<c:choose>
						<c:when test="${isEdit==1}">
							<input id="itemCode" class="form-control" readonly="readonly"
								placeholder="Item Code" name="itemCode" autocomplete="off"  type="text" value="${itemSup.itemCode}" required>
							</c:when>
							<c:otherwise>
							<input id="itemCode" class="form-control"
								placeholder="Item Code" name="itemCode" autocomplete="off"  type="text" value="${code}" required>
							</c:otherwise>
							</c:choose>
						</div>
						<div class="col-md-1">
							 
						</div>
						<div class="col-md-2">
							<div class="col1title" align="left">Item Name*: </div>
						</div>
						<div class="col-md-3">
							<input id="itemName" class="form-control"
								placeholder="Item Name" name="itemName" autocomplete="off"  type="text" value="${item.itemName}" required>
						</div>
					 
					</div>
					
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">UOM*: </div>
						</div>
						<div class="col-md-3">
						    <input type="hidden" name="selectedUom" id="selectedUom">
						
							<select name="itemUom" required id="itemUom" class="form-control"placeholder="Item UOM" onchange="javascript:getSelectedLabel(this);"
												 >
											<option value="">Select Item UOM</option>
											<c:forEach items="${rmUomList}" var="rmUomList"
													varStatus="count">
													<c:choose>
													<c:when test="${rmUomList.uom eq itemSup.itemUom}">
														<option value="${rmUomList.uomId}" selected><c:out value="${rmUomList.uom}"/></option>
													</c:when>
													<c:otherwise>
														<option value="${rmUomList.uomId}"><c:out value="${rmUomList.uom}"/></option>
													</c:otherwise>
													</c:choose>
												</c:forEach>
										</select>
						</div>
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">HSN Code*: </div>
						</div>
						<div class="col-md-3">
							<input type="text" name="hsnCode" autocomplete="off"  id="hsnCode" 
							maxlength="6" placeholder="HSN Code" class="form-control"
											required value="${itemSup.itemHsncd}"/>

						</div>
				 
					</div>
					
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Purchase Rate*: </div>
						</div>
						<div class="col-md-3">
							<input id="purchaseRate" class="form-control"
								placeholder="Purchase Rate" autocomplete="off"  name="purchaseRate" type="text" value="${item.itemRate1}" required>

						</div>
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">Sale Rate(Inclusive Tax)*: </div>
						</div>
						<div class="col-md-3">
							<input id="saleRate" class="form-control"
								placeholder="Sale Rate" autocomplete="off"  name="saleRate" type="text" value="${item.itemMrp1}"  required>

						</div>
				 
					</div>
					
					<div class="colOuter">
					<%-- 	<div class="col-md-2">
							<div class="col1title" align="left">Tax Description*: </div>
						</div>
						<div class="col-md-3">
							<input id="taxDesc" class="form-control"
								placeholder="Tax Description" name="taxDesc" type="text" value="${otherItem.taxDesc}" required>

						</div> --%>
							<div class="col-md-2">
							<div class="col1title" align="left">SGST Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="sgstPer" class="form-control"
								placeholder="SGST Per" autocomplete="off"  name="sgstPer" type="text" value="${item.itemTax1}" onkeyup="changeTax()" required>

						</div>
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">CGST Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="cgstPer" class="form-control"
								placeholder="CGST Per" autocomplete="off"  name="cgstPer" type="text" value="${item.itemTax2}" onkeyup="changeTax()" required>

						</div>
				 
					</div>
					
					<div class="colOuter">
					
						<div class="col-md-2">
							<div class="col1title" align="left">IGST Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="igstPer" class="form-control"
								placeholder="IGST Per" autocomplete="off"  name="igstPer" type="text"  value="${item.itemTax3}"  required>

						</div>
				 
						<div class="col-md-1">
							 
						</div>
				 

						<div class="col-md-2">
							<div class="col1title" align="left">Is Active?* </div>
						</div>
						<div class="col-md-3">
						<select name="isActive" id="isActive" class="form-control" placeholder="Is Active"
												 data-rule-required="true" >
							<c:choose>	
							<c:when test="${otherItem.isActive==0}">
							<option value="0" selected>No</option>
							<option value="1">Yes</option>
							</c:when>	
							<c:when test="${otherItem.isActive==1}">
							<option value="0">No</option>
							<option value="1" selected>Yes</option>
							</c:when>
							<c:otherwise>
							<option value="0">No</option>
							<option value="1" selected>Yes</option>
							</c:otherwise>	
							</c:choose>				 
						</select>
						</div>
						</div>
							<div class="colOuter">
						<div align="center">
						<!-- <button type="submit" name="submit" class="buttonsaveorder" id="submtbtn" disabled="disabled">Submit</button> -->
							 <input name="submit" class="buttonsaveorder" value="Submit"
								type="submit" align="center" id="submtbtn"> 
						</div>
				 
					</div>
					<div id="table-scroll">  <!-- class="table-scroll"> --> 
					<div id="faux-table" class="faux-table" aria="hidden" style="display: none;"></div>
					<div > <!-- class="table-wrap" -->
						 <table id="table_grid" class="responsive-table">

							<thead>
								<tr class="bgpink">
									<th class="col-sm-1" style="text-align: center;">Sr No</th>
									<th class="col-md-1" style="text-align: center;">Item Code</th> 
									<th class="col-md-1" style="text-align: center;">Name</th>
									<th class="col-md-1" style="text-align: center;">Purchase Rate</th>
									<th class="col-md-1" style="text-align: center;">Sale Rate</th>
									<th class="col-md-1" style="text-align: center;">SGST Per</th>
									<th class="col-md-1" style="text-align: center;">CGST Per</th>
									<th class="col-md-1" style="text-align: center;">IGST Per</th>
									<th class="col-md-1" style="text-align: center;">Is Active</th>
									<th class="col-md-1" style="text-align: center;">Action</th>
								</tr>
							</thead>
							<tbody>

								<c:forEach items="${itemList}" var="itemList"
									varStatus="count">
									<c:set var="color" value=""></c:set>
									<c:if test="${isEdit==1}">
									<c:choose>
									<c:when test="${itemList.itemId==otherItem.itemId}">
									<c:set var="color" value="color: red;"></c:set>
									</c:when>
									
									</c:choose>
									</c:if>
									<tr style="${color}">
										 <td class="col-sm-1" style="text-align: right;"><c:out value="${count.index+1}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.itemId}" /></td>
										<td class="col-md-2" style="text-align: center;"><c:out
												value="${itemList.itemName}" /></td>
									
										<td class="col-md-1"><c:out
												value="${itemList.itemRate1}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.itemMrp1}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.itemTax1}" /></td>
											<td class="col-md-1"><c:out
												value="${itemList.itemTax2}" /></td>
												<td class="col-md-1"><c:out
												value="${itemList.itemTax3}" /></td>
										<td class="col-md-1" style="text-align: center;">
										<c:choose>
													<c:when test="${itemList.itemIsUsed==1}">
 														Yes						
 												    </c:when>
												    <c:otherwise>
												         No
												    </c:otherwise>
										</c:choose>
												</td>
										<td class="col-md-1" style="text-align: center;"><div >
					<a href="${pageContext.request.contextPath}/updateOtherItem/${itemList.id}"   >
						<abbr title='Edit'><i  class='fa fa-edit'></i></abbr></a>
												&nbsp;&nbsp;
						<a href="${pageContext.request.contextPath}/deleteOtherItem/${itemList.id}" onClick="return confirm('Are you sure want to delete this record');"   >
						<abbr title='Delete'><i  class='fa fa-trash'></i></abbr></a>
												 
											</div></td>
									</tr>
								</c:forEach>
						</table> 

					</div>
				</div>

				</form>

				 
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
$('#hsnCode').on('input', function() {
	 this.value = this.value.replace(/[^0-9]/g, '').replace(/(\..*)\./g, '$1');
	});

$('#purchaseRate').on('input', function() {
	 this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
	});

$('#sgstPer').on('input', function() {
	 this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
	});
	
$('#saleRate').on('input', function() {
	 this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
	});
	
$('#cgstPer').on('input', function() {
	 this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
	});
	
$('#igstPer').on('input', function() {
	 this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
	});
		$(document)
			.ready(
				function($) {
		
								$("#frm_search")
										.submit(
													function(e) {
																	var isError = false;
																	var errMsg = "";
																	
		
																	if (!$("#itemCode").val()) {
																		
																		isError = true;
																	}
																	
																	if (!$("#itemUom").val()) {
																		
																		isError = true;
																	}
																	if (!$("#purchaseRate").val()) {
																		
																		isError = true;
																	}
																	
																	if (!$("#sgstPer").val()) {
																		
																		isError = true;
																	}
																	
																	if (!$("#igstPer").val()) {
																		
																		isError = true;
																	}
																	
																	if (!$("#itemName").val()) {
																		
																		isError = true;
																	}
																	if (!$("#hsnCode").val()) {
																		
																		isError = true;
																	}
																	if (!$("#itemCode").val()) {
																		
																		isError = true;
																	}
																	if (!$("#saleRate").val()) {
																		
																		isError = true;
																	}
																	if (!$("#cgstPer").val()) {
																		
																		isError = true;
																	}
																	else{
																		
																		isError = false;
																	}
																	if (!isError) {
																	
																	var x = true;
																	if (x == true) {
																	
																	document.getElementById("submtbtn").disabled = true;
																	
																	return true;
																	}
																	//end ajax send this to php page
																}
																	return false;
										});
		});
//
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


	</script>
<script>
function getSelectedLabel(sel) {
    document.getElementById("selectedUom").value = sel.options[sel.selectedIndex].text;
}
</script>
<script type="text/javascript">
function changeTax()
{
	  var cgstPer=document.getElementById("cgstPer").value;
	  if( cgstPer.length !="")
		  {
		  cgstPer=parseInt(cgstPer);
		  }else
			  {
			  cgstPer=0;
			  }
	  var sgstPer=document.getElementById("sgstPer").value;
	  if( sgstPer.length !="")
		  {
		  sgstPer=parseInt(sgstPer);
		  }else
			  {
			  sgstPer=0;
			  }
	  document.getElementById("igstPer").value=(cgstPer+sgstPer).toFixed(2);
}
</script>
</body>
</html>
