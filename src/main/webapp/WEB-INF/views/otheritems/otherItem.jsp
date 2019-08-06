
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

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
								
								<div class="col1title" align="right"> 
						<a href="${pageContext.request.contextPath}/showOtherBill"><input type="button" value="Other Purchase Bill" class="btn btn-info">
							</a>
					</div>
						</div>
						
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Item Code*: </div>
						</div>
						<div class="col-md-3">
							<input id="itemCode" class="form-control"
								placeholder="Item Code" name="itemCode" type="text" value="${item.itemId}" required>
								<input id="itemId" class="form-control"	  name="itemId" value="${item.id}" type="hidden" >
						</div>
						<div class="col-md-1">
							 
						</div>
						<div class="col-md-2">
							<div class="col1title" align="left">Item Name*: </div>
						</div>
						<div class="col-md-3">
							<input id="itemName" class="form-control"
								placeholder="Item Name" name="itemName" type="text" value="${item.itemName}" required>
						</div>
					 
					</div>
					
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">UOM*: </div>
						</div>
						<div class="col-md-3">
						    <input type="text" name="selectedUom" id="selectedUom">
						
							<select name="itemUom" id="itemUom" class="form-control"placeholder="Item UOM" onchange="javascript:getSelectedLabel(this);"
												 data-rule-required="true" >
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
							<input type="text" name="hsnCode" id="hsnCode"
											placeholder="HSN Code" class="form-control"
											data-rule-required="true" value="${itemSup.itemHsncd}"/>

						</div>
				 
					</div>
					
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Purchase Rate*: </div>
						</div>
						<div class="col-md-3">
							<input id="purchaseRate" class="form-control"
								placeholder="Purchase Rate" name="purchaseRate" type="text" value="${item.itemRate1}" required>

						</div>
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">Sale Rate*: </div>
						</div>
						<div class="col-md-3">
							<input id="saleRate" class="form-control"
								placeholder="Sale Rate" name="saleRate" type="text" value="${item.itemMrp1}"  required>

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
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">Cgst Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="cgstPer" class="form-control"
								placeholder="Cgst Per" name="cgstPer" type="text" value="${item.itemTax2}"  required>

						</div>
				 
					</div>
					
					<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Sgst Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="sgstPer" class="form-control"
								placeholder="Sgst Per" name="sgstPer" type="text" value="${item.itemTax3}" required>

						</div>
						<div class="col-md-1">
							 
						</div>

						<div class="col-md-2">
							<div class="col1title" align="left">Igst Per*: </div>
						</div>
						<div class="col-md-3">
							<input id="igstPer" class="form-control"
								placeholder="Igst Per" name="igstPer" type="text"  value="${otherItem.igstPer}"  required>

						</div>
				 
					</div> 
				
						<div class="colOuter">
						<div class="col-md-2">
							<div class="col1title" align="left">Cess Per*: </div>
						</div>
						<div class="col-md-3">
						<input id="cessPer" class="form-control"
								placeholder="Cess Per" name="cessPer" type="text"  value="${otherItem.cessPer}"  required>
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
							<input name="submit" class="buttonsaveorder" value="Submit"
								type="submit" align="center">
						</div>
				 
					</div>
					<div id="table-scroll" class="table-scroll">
					<div id="faux-table" class="faux-table" aria="hidden"></div>
					<div class="table-wrap">
						 <table id="table_grid" class="main-table">

							<thead>
								<tr class="bgpink">
									<th class="col-sm-1">Sr No</th>
									<th class="col-md-1">Item Code</th> 
									<th class="col-md-1">Name</th>
									<th class="col-md-1">UOM</th> 
									<th class="col-md-1">HSN Code</th>
									<th class="col-md-1">Purchase Rate</th>
									<th class="col-md-1">Sale Rate</th>
									<th class="col-md-1">Total Tax %</th>
									<th class="col-md-1">Is Active</th>
									<th class="col-md-1">Action</th>
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
										 <td class="col-sm-1"><c:out value="${count.index+1}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.itemCode}" /></td>
										<td class="col-md-2"><c:out
												value="${itemList.itemName}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.uom}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.hsnCode}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.purchaseRate}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.sellRate}" /></td>
										<td class="col-md-1"><c:out
												value="${itemList.totalPer}" /></td>
										<td class="col-md-1">
										<c:choose>
													<c:when test="${itemList.isActive==1}">
 														Yes						
 												    </c:when>
												    <c:otherwise>
												         No
												    </c:otherwise>
										</c:choose>
												</td>
										<td class="col-md-1"><div >
					<a href="${pageContext.request.contextPath}/updateOtherItem/${itemList.itemId}"   >
						<abbr title='Edit'><i  class='fa fa-edit'></i></abbr></a>
												&nbsp;&nbsp;
						<a href="${pageContext.request.contextPath}/deleteOtherItem/${itemList.itemId}" onClick="return confirm('Are you sure want to delete this record');"   >
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
</body>
</html>
