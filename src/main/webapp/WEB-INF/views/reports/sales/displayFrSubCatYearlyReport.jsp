<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

<body>

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
							<h2 class="pageTitle">SubCategory-wise Yearly Report</h2>
						</div>
					</div>

					<div class="row">
						<div class="col-md-3" align="left">
							<input type="button" id="expExcel" name="expExcel"
								onclick="exportToExcel();" value="Export to Excel">
						</div>
					</div>


					



					<div class="row" id="table">
						<div class="col-md-12">
							<!--table-->
							<div class="clearfix"></div>


							<div id="table-scroll" class="table-scroll">
								<div id="faux-table" class="faux-table" aria="hidden">
									<div class="table-wrap">
										<table id="table_grid" class="main-table">
											<thead>
												<tr>
													<th></th>
													<c:forEach var="report" items="${reportList}"
														varStatus="cnt">
														<th colspan="9">${report.dateStr}</th>

													</c:forEach>
												</tr>


												<tr class="bgpink">
													<th></th>
													<c:forEach var="report" items="${reportList}"
														varStatus="cnt">

														<th>Pur Qty</th>
														<th>Pur Amt</th>
														<th>Var Qty</th>
														<th>Var Amt</th>
														<th>Ret Qty</th>
														<th>Ret Amt</th>
														<th>Net Qty</th>
														<th>Net Amt</th>
														<th>Ret Amt %</th>

													</c:forEach>

												</tr>
											</thead>
											<tbody>
											</tbody>
										</table>

									</div>
								</div>
								<div class="table-wrap">
									<table id="table_grid" class="main-table">
										<thead>
											<tr>
												<th></th>
												<c:forEach var="report" items="${reportList}"
													varStatus="cnt">
													<th colspan="9">${report.dateStr}</th>

												</c:forEach>
											</tr>


											<tr class="bgpink">
												<th></th>
												<c:forEach var="report" items="${reportList}"
													varStatus="cnt">

													<th>Pur Qty</th>
													<th>Pur Amt</th>
													<th>Var Qty</th>
													<th>Var Amt</th>
													<th>Ret Qty</th>
													<th>Ret Amt</th>
													<th>Net Qty</th>
													<th>Net Amt</th>
													<th>Ret Amt %</th>

												</c:forEach>

											</tr>
										</thead>
										<tbody>


											<c:forEach items="${reportList}" var="month"
												varStatus="count" end="0">


												<c:forEach items="${month.dataList}" var="fr"
													varStatus="count">


													<%-- <tr>
														<td>${fr.frName}</td>
													</tr> --%>

													<c:forEach items="${fr.subCatList}" var="sc"
														varStatus="count">
														<tr>

															<td>${sc.subCatName}</td>



															<c:forEach items="${reportList}" var="month1"
																varStatus="count">

																<c:forEach items="${month1.dataList}" var="fr1"
																	varStatus="count">

																	<c:if test="${fr1.frId==fr.frId}">

																		<c:forEach items="${fr1.subCatList}" var="sc1"
																			varStatus="count">

																			<c:if test="${sc1.subCatId==sc.subCatId}">


																				<c:if test="${reportType==1}">

																					<td align="right">${sc1.soldQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.soldAmt}" /></td>
																					<td align="right">${sc1.varQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.varAmt}" /></td>
																					<td align="right">${sc1.retQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.retAmt}" /></td>
																					<td align="right">${(sc1.soldQty-(sc1.varQty+sc1.retQty))}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2"
																							value="${(sc1.soldAmt-(sc1.varAmt+sc1.retAmt))}" /></td>
																					<%-- <td align="right"><fmt:formatNumber type="number"
																				minFractionDigits="2" maxFractionDigits="2"
																				value="${(((sc1.varAmt+sc1.retAmt)*100)/sc1.soldAmt)}" />%</td> --%>

																					<c:choose>
																						<c:when test="${sc1.soldAmt==0}">
																							<td align="right">0.00%</td>
																						</c:when>
																						<c:otherwise>
																							<td align="right"><fmt:formatNumber
																									type="number" minFractionDigits="2"
																									maxFractionDigits="2"
																									value="${(((sc1.varAmt+sc1.retAmt)*100)/sc1.soldAmt)}" />%</td>

																						</c:otherwise>
																					</c:choose>



																				</c:if>

																				<c:if test="${reportType==2}">

																					<td align="right">${sc1.soldQty}</td>
																					<td align="right"></td>
																					<td align="right">${sc1.varQty}</td>
																					<td align="right"></td>
																					<td align="right">${sc1.retQty}</td>
																					<td align="right"></td>
																					<td align="right">${(sc1.soldQty-(sc1.varQty+sc1.retQty))}</td>
																					<td align="right"></td>
																					<td align="right"></td>

																				</c:if>

																				<c:if test="${reportType==3}">

																					<td align="right"></td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.soldAmt}" /></td>
																					<td align="right"></td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.varAmt}" /></td>
																					<td align="right"></td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.retAmt}" /></td>
																					<td align="right"></td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2"
																							value="${(sc1.soldAmt-(sc1.varAmt+sc1.retAmt))}" /></td>
																					<%-- 																		<td align="right"><fmt:formatNumber type="number"
																				minFractionDigits="2" maxFractionDigits="2"
																				value="${(((sc1.varAmt+sc1.retAmt)*100)/sc1.soldAmt)}" />%</td> --%>

																					<c:choose>
																						<c:when test="${sc1.soldAmt==0}">
																							<td align="right">0.00%</td>
																						</c:when>
																						<c:otherwise>
																							<td align="right"><fmt:formatNumber
																									type="number" minFractionDigits="2"
																									maxFractionDigits="2"
																									value="${(((sc1.varAmt+sc1.retAmt)*100)/sc1.soldAmt)}" />%</td>

																						</c:otherwise>
																					</c:choose>



																				</c:if>

																				<c:if test="${reportType==4}">

																					<td align="right">${sc1.soldQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2" value="${sc1.taxableAmt}" /></td>
																					<td align="right">${sc1.varQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2"
																							value="${sc1.varTaxableAmt}" /></td>
																					<td align="right">${sc1.retQty}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2"
																							value="${sc1.retTaxableAmt}" /></td>
																					<td align="right">${(sc1.soldQty-(sc1.varQty+sc1.retQty))}</td>
																					<td align="right"><fmt:formatNumber
																							type="number" minFractionDigits="2"
																							maxFractionDigits="2"
																							value="${(sc1.taxableAmt-(sc1.varTaxableAmt+sc1.retTaxableAmt))}" /></td>
																					<%-- 																		<td align="right"><fmt:formatNumber type="number"
																				minFractionDigits="2" maxFractionDigits="2"
																				value="${(((sc1.varTaxableAmt+sc1.retTaxableAmt)*100)/sc1.taxableAmt)}" />%</td> --%>

																					<c:choose>
																						<c:when test="${sc1.taxableAmt==0}">
																							<td align="right">0.00%</td>
																						</c:when>
																						<c:otherwise>
																							<td align="right"><fmt:formatNumber
																									type="number" minFractionDigits="2"
																									maxFractionDigits="2"
																									value="${(((sc1.varTaxableAmt+sc1.retTaxableAmt)*100)/sc1.taxableAmt)}" />%</td>

																						</c:otherwise>
																					</c:choose>


																				</c:if>



																			</c:if>
																		</c:forEach>

																	</c:if>
																</c:forEach>
															</c:forEach>
														</tr>

													</c:forEach>
													<%-- <tr>
														<td style='font-weight: bold'>Total</td>

														<c:forEach items="${reportList}" var="month2"
															varStatus="count">

															<c:forEach items="${month2.dataList}" var="fr2"
																varStatus="count">

																<c:if test="${fr2.frId==fr.frId}">

																	<c:if test="${reportType==1}">

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalSoldQty}" /></td>
																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalSoldAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalVarQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalVarAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalRetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalRetAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalNetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalNetAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalRetAmtPer}" />%</td>


																	</c:if>


																	<c:if test="${reportType==2}">

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalSoldQty}" /></td>
																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalVarQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalRetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalNetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="" /></td>

																	</c:if>

																	<c:if test="${reportType==3}">

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="" /></td>
																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalSoldAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalVarAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalRetAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2" value="${fr2.frTotalNetAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalRetAmtPer}" />%</td>

																	</c:if>

																	<c:if test="${reportType==4}">

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalSoldQty}" /></td>
																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalSoldTaxableAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalVarQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalVarTaxableAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalRetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalRetTaxableAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="0"
																				maxFractionDigits="0" value="${fr2.frTotalNetQty}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalNetTaxableAmt}" /></td>

																		<td align="right" style='font-weight: bold'><fmt:formatNumber
																				type="number" minFractionDigits="2"
																				maxFractionDigits="2"
																				value="${fr2.frTotalRetTaxableAmtPer}" />%</td>

																	</c:if>



																</c:if>
															</c:forEach>
														</c:forEach>

													</tr> --%>


												</c:forEach>

												<tr>
													<td style='font-weight: bold'>TOTAL </td>


													<c:forEach items="${reportList}" var="month3"
														varStatus="count">




														<c:if test="${reportType==1}">

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="0"
																	maxFractionDigits="0"
																	value="${month3.monthTotalSoldQty}" /></td>
															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2"
																	value="${month3.monthTotalSoldAmt}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="0"
																	maxFractionDigits="0"
																	value="${month3.monthTotalVarQty}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2"
																	value="${month3.monthTotalVarAmt}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="0"
																	maxFractionDigits="0"
																	value="${month3.monthTotalRetQty}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2"
																	value="${month3.monthTotalRetAmt}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="0"
																	maxFractionDigits="0"
																	value="${month3.monthTotalNetQty}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2"
																	value="${month3.monthTotalNetAmt}" /></td>

															<td align="right" style='font-weight: bold'><fmt:formatNumber
																	type="number" minFractionDigits="2"
																	maxFractionDigits="2"
																	value="${month3.monthTotalRetAmtPer}" />%</td>


														</c:if>
													</c:forEach>


												</tr>

											</c:forEach>




										</tbody>
									</table>

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
	<script type="text/javascript"
		src="https://www.gstatic.com/charts/loader.js"></script>
	<!--easyTabs-->



	<script>
		function exportToExcel() {

			window.open("${pageContext.request.contextPath}/exportToExcelNew");
			document.getElementById("expExcel").disabled = true;
		}
	</script>





</body>
</html>
