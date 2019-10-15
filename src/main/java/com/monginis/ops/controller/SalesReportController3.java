package com.monginis.ops.controller;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Scope;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.monginis.ops.common.DateConvertor;
import com.monginis.ops.constant.Constant;
import com.monginis.ops.model.CategoryListResponse;
import com.monginis.ops.model.ExportToExcel;
import com.monginis.ops.model.Franchisee;
import com.monginis.ops.model.GetSellBillHeader;
import com.monginis.ops.model.MCategoryList;
import com.monginis.ops.model.SubCategory;
import com.monginis.ops.model.salesreport3.HsnDateWiseSellData;
import com.monginis.ops.model.salesreport3.SubCatDateWiseSellData;
import com.monginis.ops.model.salesreport3.TempFrWiseSubCat;
import com.monginis.ops.model.salesreport3.TempItemList;
import com.monginis.ops.model.salesreport3.TempSubCatList;
import com.monginis.ops.model.salesreport3.TempSubCatWiseBillData;
import com.monginis.ops.model.salesreport3.YearlyItemReport;
import com.monginis.ops.model.salesreport3.YearlySaleData;

@Controller
@Scope("session")
public class SalesReportController3 {

	String todaysDate;
	ArrayList<SubCategory> subCatAList;

	List<MCategoryList> mCategoryList;

	// -----------------YEARLY
	// REPORT--------------------------------------------------

	@RequestMapping(value = "/showYearlyFrSubCatSaleReport", method = RequestMethod.GET)
	public ModelAndView showYearlyFrSubCatSaleReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/yearlyFrSubCatSale");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			RestTemplate restTemplate = new RestTemplate();

			model.addObject("todaysDate", todaysDate);

			CategoryListResponse categoryListResponse;

			categoryListResponse = restTemplate.getForObject(Constant.URL + "showAllCategory",
					CategoryListResponse.class);

			mCategoryList = categoryListResponse.getmCategoryList();

			model.addObject("mCategoryList", mCategoryList);

			SubCategory[] subCatList = restTemplate.getForObject(Constant.URL + "getAllSubCatList",
					SubCategory[].class);

			subCatAList = new ArrayList<SubCategory>(Arrays.asList(subCatList));

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			model.addObject("frId", frDetails.getFrId());

		} catch (Exception e) {

			System.out.println("Exc in showYearlyFrSubCatSaleReport--  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	// ----AJAX----GET SUB CATEGORY LIST BY CAT ID-------------------

	@RequestMapping(value = "/getSubCatListByCatId", method = RequestMethod.GET)
	public @ResponseBody List<SubCategory> getSubCatByCatIdForReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<SubCategory> subCatList = new ArrayList<SubCategory>();
		try {
			RestTemplate restTemplate = new RestTemplate();
			String selectedCat = request.getParameter("catId");
			boolean isAllCatSelected = false;

			System.out.println(
					"System.out.println(selectedCat);System.out.println(selectedCat);System.out.println(selectedCat);"
							+ selectedCat);

			if (selectedCat.contains("-1")) {
				isAllCatSelected = true;
			} else {
				selectedCat = selectedCat.substring(1, selectedCat.length() - 1);
				selectedCat = selectedCat.replaceAll("\"", "");
			}

			System.out.println(selectedCat);
			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			map.add("catId", selectedCat);
			map.add("isAllCatSelected", isAllCatSelected);

			subCatList = restTemplate.postForObject(Constant.URL + "getSubCatListByCatIdInForDisp", map, List.class);
			System.out.println(subCatList.toString());

		} catch (Exception e) {

		}

		return subCatList;
	}

	@RequestMapping(value = "/displayYearlyReport", method = RequestMethod.GET)
	public ModelAndView displayYearlyReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/displayFrSubCatYearlyReport");

		List<YearlySaleData> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		String selectedType = "";

		try {

			System.err.println("FR ID ---------**************************************---/////////-- "
					+ request.getParameter("fr_id"));

			int frId = Integer.parseInt(request.getParameter("frId"));
			String selectedSubCatIdArray[] = request.getParameterValues("item_grp2");
			String selectedCatIdArray[] = request.getParameterValues("item_grp1");
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");
			selectedType = request.getParameter("typeId");

			StringBuilder sb = new StringBuilder();

			System.err.println("FR ID ---------**************************************----- " + frId);

			String selectedSubCatIdList = "";
			StringBuilder sb1 = new StringBuilder();

			List<String> scIds = new ArrayList<>();
			scIds = Arrays.asList(selectedSubCatIdArray);

			List<String> catIds = new ArrayList<>();
			catIds = Arrays.asList(selectedCatIdArray);

			if (scIds.contains("-1")) {
				// subCatIdList.clear();
				List<String> tempScIdList = new ArrayList();

				if (subCatAList != null) {

					for (int i = 0; i < subCatAList.size(); i++) {
						tempScIdList.add(String.valueOf(subCatAList.get(i).getSubCatId()));
					}
				}
				System.err.println("SUB CAT ID ARRAY --------- " + tempScIdList);
				selectedSubCatIdList = tempScIdList.toString().substring(1, tempScIdList.toString().length() - 1);
				selectedSubCatIdList = selectedSubCatIdList.replaceAll("\"", "");

			} else {

				if (selectedSubCatIdArray.length > 0) {
					for (int i = 0; i < selectedSubCatIdArray.length; i++) {
						System.out.println("sc Ids List " + selectedSubCatIdArray[i]);

						sb1 = sb1.append(selectedSubCatIdArray[i] + ",");
					}

					selectedSubCatIdList = sb1.toString();
					selectedSubCatIdList = selectedSubCatIdList.substring(0, selectedSubCatIdList.length() - 1);
				}
			}

			System.out.println("selectedFrAfter------------------" + selectedSubCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			System.out.println("Inside If all fr Selected ");

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frIdList", "" + frId);
			map.add("subCatIdList", selectedSubCatIdList);

			ParameterizedTypeReference<List<YearlySaleData>> typeRef = new ParameterizedTypeReference<List<YearlySaleData>>() {
			};
			ResponseEntity<List<YearlySaleData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getYearlyFrSubCatSaleReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = new ArrayList<>();
			reportList = responseEntity.getBody();

			DecimalFormat df = new DecimalFormat("0.00");

			System.err.println("REPORT ------------------- " + reportList);

			if (reportList != null) {

				for (int i = 0; i < reportList.size(); i++) {

					float monthTotalSoldQty = 0;
					float monthTotalSoldAmt = 0;
					float monthTotalVarQty = 0;
					float monthTotalVarAmt = 0;
					float monthTotalRetQty = 0;
					float monthTotalRetAmt = 0;
					float monthTotalNetQty = 0;
					float monthTotalNetAmt = 0;
					float monthTotalRetAmtPer = 0;

					float monthTotalSoldTaxableAmt = 0;
					float monthTotalVarTaxableAmt = 0;
					float monthTotalRetTaxableAmt = 0;
					float monthTotalNetTaxableAmt = 0;
					float monthTotalRetTaxableAmtPer = 0;

					for (int j = 0; j < reportList.get(i).getDataList().size(); j++) {

						float frTotalSoldQty = 0;
						float frTotalSoldAmt = 0;
						float frTotalVarQty = 0;
						float frTotalVarAmt = 0;
						float frTotalRetQty = 0;
						float frTotalRetAmt = 0;
						float frTotalNetQty = 0;
						float frTotalNetAmt = 0;
						float frTotalRetAmtPer = 0;
						float frTotalSoldTaxableAmt = 0;
						float frTotalVarTaxableAmt = 0;
						float frTotalRetTaxableAmt = 0;
						float frTotalNetTaxableAmt = 0;
						float frTotalRetTaxableAmtPer = 0;

						TempFrWiseSubCat frData = reportList.get(i).getDataList().get(j);

						for (int k = 0; k < frData.getSubCatList().size(); k++) {

							TempSubCatWiseBillData data = frData.getSubCatList().get(k);

							frTotalSoldQty = frTotalSoldQty + data.getSoldQty();
							frTotalSoldAmt = frTotalSoldAmt + data.getSoldAmt();
							frTotalVarQty = frTotalVarQty + data.getVarQty();
							frTotalVarAmt = frTotalVarAmt + data.getVarAmt();
							frTotalRetQty = frTotalRetQty + data.getRetQty();
							frTotalRetAmt = frTotalRetAmt + data.getRetAmt();
							frTotalNetQty = frTotalNetQty + (data.getSoldQty() - (data.getVarQty() + data.getRetQty()));
							frTotalNetAmt = frTotalNetAmt + (data.getSoldAmt() - (data.getVarAmt() + data.getRetAmt()));

							if (data.getSoldAmt() == 0) {
								frTotalRetAmtPer = frTotalRetAmtPer + 0;

							} else {
								frTotalRetAmtPer = frTotalRetAmtPer
										+ (((data.getVarAmt() + data.getRetAmt()) * 100) / data.getSoldAmt());
							}

							frTotalSoldTaxableAmt = frTotalSoldTaxableAmt + data.getTaxableAmt();
							frTotalVarTaxableAmt = frTotalVarTaxableAmt + data.getVarTaxableAmt();
							frTotalRetTaxableAmt = frTotalRetTaxableAmt + data.getRetTaxableAmt();
							frTotalNetTaxableAmt = frTotalNetTaxableAmt
									+ (data.getTaxableAmt() - (data.getVarTaxableAmt() + data.getRetTaxableAmt()));

							if (data.getTaxableAmt() == 0) {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer + 0;
							} else {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer
										+ (((data.getVarTaxableAmt() + data.getRetTaxableAmt()) * 100)
												/ data.getTaxableAmt());
							}

						}

						frData.setFrTotalSoldQty(frTotalSoldQty);
						frData.setFrTotalSoldAmt(frTotalSoldAmt);

						frData.setFrTotalVarQty(frTotalVarQty);
						frData.setFrTotalVarAmt(frTotalVarAmt);

						frData.setFrTotalRetQty(frTotalRetQty);
						frData.setFrTotalRetAmt(frTotalRetAmt);

						frData.setFrTotalNetQty(frTotalNetQty);
						frData.setFrTotalNetAmt(frTotalNetAmt);

						frData.setFrTotalRetAmtPer(frTotalRetAmtPer);

						frData.setFrTotalSoldTaxableAmt(frTotalSoldTaxableAmt);

						frData.setFrTotalVarTaxableAmt(frTotalVarTaxableAmt);

						frData.setFrTotalRetTaxableAmt(frTotalRetTaxableAmt);

						frData.setFrTotalNetTaxableAmt(frTotalNetTaxableAmt);

						frData.setFrTotalRetTaxableAmtPer(frTotalRetTaxableAmtPer);

						// -----------MONTHLY SUM--------------------------
						monthTotalSoldQty = monthTotalSoldQty + frTotalSoldQty;
						monthTotalSoldAmt = monthTotalSoldAmt + frTotalSoldAmt;
						monthTotalVarQty = monthTotalVarQty + frTotalVarQty;
						monthTotalVarAmt = monthTotalVarAmt + frTotalVarAmt;
						monthTotalRetQty = monthTotalRetQty + frTotalRetQty;
						monthTotalRetAmt = monthTotalRetAmt + frTotalRetAmt;
						monthTotalNetQty = monthTotalNetQty + frTotalNetQty;
						monthTotalNetAmt = monthTotalNetAmt + frTotalNetAmt;
						monthTotalRetAmtPer = monthTotalRetAmtPer + frTotalRetAmtPer;

						monthTotalSoldTaxableAmt = monthTotalSoldTaxableAmt + frTotalSoldTaxableAmt;
						monthTotalVarTaxableAmt = monthTotalVarTaxableAmt + frTotalVarTaxableAmt;
						monthTotalRetTaxableAmt = monthTotalRetTaxableAmt + frTotalRetTaxableAmt;
						monthTotalNetTaxableAmt = monthTotalNetTaxableAmt + frTotalNetTaxableAmt;
						monthTotalRetTaxableAmtPer = monthTotalRetTaxableAmtPer + frTotalRetTaxableAmtPer;

					}

					reportList.get(i).setMonthTotalSoldQty(monthTotalSoldQty);
					reportList.get(i).setMonthTotalSoldAmt(monthTotalSoldAmt);

					reportList.get(i).setMonthTotalVarQty(monthTotalVarQty);
					reportList.get(i).setMonthTotalVarAmt(monthTotalVarAmt);

					reportList.get(i).setMonthTotalRetQty(monthTotalRetQty);
					reportList.get(i).setMonthTotalRetAmt(monthTotalRetAmt);

					reportList.get(i).setMonthTotalNetQty(monthTotalNetQty);
					reportList.get(i).setMonthTotalNetAmt(monthTotalNetAmt);

					reportList.get(i).setMonthTotalRetAmtPer(monthTotalRetAmtPer);

					reportList.get(i).setMonthTotalSoldTaxableAmt(monthTotalSoldTaxableAmt);

					reportList.get(i).setMonthTotalVarTaxableAmt(monthTotalVarTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmt(monthTotalRetTaxableAmt);

					reportList.get(i).setMonthTotalNetTaxableAmt(monthTotalNetTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmtPer(monthTotalRetTaxableAmtPer);

				}
			}

			System.err.println("-------------- REPORT---------------- " + reportList);

			model.addObject("reportList", reportList);
			model.addObject("reportType", selectedType);

		} catch (Exception e) {

			System.out.println("Exc in display yearly report--  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add(" ");
			for (int i = 0; i < reportList.size(); i++) {
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(reportList.get(i).getDateStr());
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add(" ");

			for (int i = 0; i < reportList.size(); i++) {

				rowData.add("Sold Qty");
				rowData.add("Sold Amt");
				rowData.add("Var Qty");
				rowData.add("Var Amt");
				rowData.add("Ret Qty");
				rowData.add("Ret Amt");
				rowData.add("Net Qty");
				rowData.add("Net Amt");
				rowData.add("Ret Amt %");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {

				YearlySaleData monthData = reportList.get(0);

				for (int f = 0; f < monthData.getDataList().size(); f++) {

					TempFrWiseSubCat frData = monthData.getDataList().get(f);

					/*
					 * expoExcel = new ExportToExcel(); rowData = new ArrayList<String>();
					 * 
					 * rowData.add("" + frData.getFrName());
					 * 
					 * expoExcel.setRowData(rowData); exportToExcelList.add(expoExcel);
					 */
					for (int s = 0; s < frData.getSubCatList().size(); s++) {

						TempSubCatWiseBillData scData = frData.getSubCatList().get(s);

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("" + scData.getSubCatName());

						for (int m = 0; m < reportList.size(); m++) {

							for (int f1 = 0; f1 < reportList.get(m).getDataList().size(); f1++) {

								if (reportList.get(m).getDataList().get(f1).getFrId() == frData.getFrId()) {
									for (int sc1 = 0; sc1 < reportList.get(m).getDataList().get(f1).getSubCatList()
											.size(); sc1++) {
										if (reportList.get(m).getDataList().get(f1).getSubCatList().get(sc1)
												.getSubCatId() == scData.getSubCatId()) {

											TempSubCatWiseBillData scData1 = reportList.get(m).getDataList().get(f1)
													.getSubCatList().get(sc1);

											// rowData.add("" + scData1.getSubCatName());

											if (selectedType.equalsIgnoreCase("1")) {

												rowData.add("" + scData1.getSoldQty());
												rowData.add("" + scData1.getSoldAmt());

												rowData.add("" + scData1.getVarQty());
												rowData.add("" + scData1.getVarAmt());

												rowData.add("" + scData1.getRetQty());
												rowData.add("" + scData1.getRetAmt());

												rowData.add("" + (scData1.getSoldQty()
														- (scData1.getVarQty() + scData1.getRetQty())));
												rowData.add("" + (scData1.getSoldAmt()
														- (scData1.getVarAmt() + scData1.getRetAmt())));

												if (scData1.getSoldAmt() == 0) {
													rowData.add("0.00%");
												} else {
													rowData.add(
															"" + (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																	/ scData1.getSoldAmt()) + "%");
												}

											} else if (selectedType.equalsIgnoreCase("2")) {

												rowData.add("" + scData1.getSoldQty());
												rowData.add("");

												rowData.add("" + scData1.getVarQty());
												rowData.add("");

												rowData.add("" + scData1.getRetQty());
												rowData.add("");

												rowData.add("" + (scData1.getSoldQty()
														- (scData1.getVarQty() + scData1.getRetQty())));
												rowData.add("");

												rowData.add("");

											} else if (selectedType.equalsIgnoreCase("3")) {

												rowData.add("");
												rowData.add("" + scData1.getSoldAmt());

												rowData.add("");
												rowData.add("" + scData1.getVarAmt());

												rowData.add("");
												rowData.add("" + scData1.getRetAmt());

												rowData.add("");
												rowData.add("" + (scData1.getSoldAmt()
														- (scData1.getVarAmt() + scData1.getRetAmt())));

												if (scData1.getSoldAmt() == 0) {
													rowData.add("0.00%");
												} else {
													rowData.add(
															"" + (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																	/ scData1.getSoldAmt()) + "%");
												}

											} else if (selectedType.equalsIgnoreCase("4")) {

												rowData.add("" + (int) scData1.getSoldQty());
												rowData.add("" + scData1.getTaxableAmt());

												rowData.add("" + (int) scData1.getVarQty());
												rowData.add("" + scData1.getVarTaxableAmt());

												rowData.add("" + (int) scData1.getRetQty());
												rowData.add("" + scData1.getRetTaxableAmt());

												rowData.add("" + (int) (scData1.getSoldQty()
														- (scData1.getVarQty() + scData1.getRetQty())));
												rowData.add("" + (scData1.getTaxableAmt()
														- (scData1.getVarTaxableAmt() + scData1.getRetTaxableAmt())));

												if (scData1.getTaxableAmt() == 0) {
													rowData.add("0.00%");
												} else {
													rowData.add("" + (((scData1.getVarTaxableAmt()
															+ scData1.getRetTaxableAmt()) * 100)
															/ scData1.getTaxableAmt()) + "%");
												}

											}

											break;
										}
									}

									break;
								}
							}
						}
						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

					}

					/*
					 * expoExcel = new ExportToExcel(); rowData = new ArrayList<String>();
					 * 
					 * rowData.add("Total");
					 * 
					 * for (int k = 0; k < reportList.size(); k++) { for (int n = 0; n <
					 * reportList.get(k).getDataList().size(); n++) {
					 * 
					 * TempFrWiseSubCat fr = reportList.get(k).getDataList().get(n);
					 * 
					 * if (frData.getFrId() == fr.getFrId()) {
					 * 
					 * if (selectedType.equalsIgnoreCase("1")) {
					 * 
					 * rowData.add("" + (int)fr.getFrTotalSoldQty()); rowData.add("" +
					 * fr.getFrTotalSoldAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalVarQty()); rowData.add("" +
					 * fr.getFrTotalVarAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalRetQty()); rowData.add("" +
					 * fr.getFrTotalRetAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalNetQty()); rowData.add("" +
					 * fr.getFrTotalNetAmt());
					 * 
					 * rowData.add("" + fr.getFrTotalRetAmtPer() + "%");
					 * 
					 * } else if (selectedType.equalsIgnoreCase("2")) {
					 * 
					 * rowData.add("" + (int)fr.getFrTotalSoldQty()); rowData.add("");
					 * 
					 * rowData.add("" + (int)fr.getFrTotalVarQty()); rowData.add("");
					 * 
					 * rowData.add("" + (int)fr.getFrTotalRetQty()); rowData.add("");
					 * 
					 * rowData.add("" + (int)fr.getFrTotalNetQty()); rowData.add("");
					 * 
					 * rowData.add("");
					 * 
					 * } else if (selectedType.equalsIgnoreCase("3")) {
					 * 
					 * rowData.add(""); rowData.add("" + fr.getFrTotalSoldAmt());
					 * 
					 * rowData.add(""); rowData.add("" + fr.getFrTotalVarAmt());
					 * 
					 * rowData.add(""); rowData.add("" + fr.getFrTotalRetAmt());
					 * 
					 * rowData.add(""); rowData.add("" + fr.getFrTotalNetAmt());
					 * 
					 * rowData.add("" + fr.getFrTotalRetAmtPer() + "%");
					 * 
					 * } else if (selectedType.equalsIgnoreCase("4")) {
					 * 
					 * rowData.add("" + (int)fr.getFrTotalSoldQty()); rowData.add("" +
					 * fr.getFrTotalSoldTaxableAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalVarQty()); rowData.add("" +
					 * fr.getFrTotalVarTaxableAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalRetQty()); rowData.add("" +
					 * fr.getFrTotalRetTaxableAmt());
					 * 
					 * rowData.add("" + (int)fr.getFrTotalNetQty()); rowData.add("" +
					 * fr.getFrTotalNetTaxableAmt());
					 * 
					 * rowData.add("" + fr.getFrTotalRetTaxableAmtPer() + "%");
					 * 
					 * }
					 * 
					 * }
					 * 
					 * } }
					 * 
					 * expoExcel.setRowData(rowData); exportToExcelList.add(expoExcel);
					 */

				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			for (int i = 0; i < reportList.size(); i++) {

				YearlySaleData data = reportList.get(i);

				if (selectedType.equalsIgnoreCase("1")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("2")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("");

					rowData.add("");

				} else if (selectedType.equalsIgnoreCase("3")) {

					rowData.add("");
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("4")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetTaxableAmt());

					rowData.add("" + data.getMonthTotalRetTaxableAmtPer() + "%");

				}

			}

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "Sub_Category_Wise_Yearly_Report");
			session.setAttribute("reportNameNew", "Sub Category Wise Yearly Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$J$1");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return model;

	}

	// ----AJAX-------------SEARCH YEARLY REPORT-------------

	@RequestMapping(value = "/getYearlyFrSubCatSaleReport", method = RequestMethod.GET)
	public @ResponseBody List<YearlySaleData> getYearlyFrSubCatSaleReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<YearlySaleData> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		String selectedType = "";
		try {
			System.out.println("Inside get Sale Bill Wise");
			frId = Integer.parseInt(request.getParameter("frId"));
			String selectedSubCatIdList = request.getParameter("subCat_id_list");
			String selectedCatIdList = request.getParameter("cat_id_list");

			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");
			selectedType = request.getParameter("selectedType");

			// System.err.println("SC ************************************************** " +
			// selectedSubCatIdList);

			selectedSubCatIdList = selectedSubCatIdList.substring(1, selectedSubCatIdList.length() - 1);
			selectedSubCatIdList = selectedSubCatIdList.replaceAll("\"", "");

			List<Integer> scIds = Stream.of(selectedSubCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			// System.err.println("SC LIST**************************************************
			// " + scIds);

			selectedCatIdList = selectedCatIdList.substring(1, selectedCatIdList.length() - 1);
			selectedCatIdList = selectedCatIdList.replaceAll("\"", "");

			List<Integer> cIds = Stream.of(selectedCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			if (scIds.contains(-1)) {
				// subCatIdList.clear();
				List<String> tempScIdList = new ArrayList();

				if (subCatAList != null) {

					for (int j = 0; j < cIds.size(); j++) {

						for (int i = 0; i < subCatAList.size(); i++) {

							if (cIds.get(j) == subCatAList.get(i).getCatId()) {
								tempScIdList.add(String.valueOf(subCatAList.get(i).getSubCatId()));
							}

						}
					}

				}
				System.err.println("SUB CAT ID ARRAY --------- " + tempScIdList);
				selectedSubCatIdList = tempScIdList.toString().substring(1, tempScIdList.toString().length() - 1);
				selectedSubCatIdList = selectedSubCatIdList.replaceAll("\"", "");

			}

			// System.out.println("selectedFrAfter------------------" +
			// selectedSubCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			System.out.println("Inside If all fr Selected ");

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frIdList", "" + frId);
			map.add("subCatIdList", selectedSubCatIdList);

			System.out.println(map);

			ParameterizedTypeReference<List<YearlySaleData>> typeRef = new ParameterizedTypeReference<List<YearlySaleData>>() {
			};
			ResponseEntity<List<YearlySaleData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getYearlyFrSubCatSaleReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get Yearly sale Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			DecimalFormat df = new DecimalFormat("0.00");

			System.err.println("REPORT ------------------- " + reportList);

			if (reportList != null) {

				for (int i = 0; i < reportList.size(); i++) {

					float monthTotalSoldQty = 0;
					float monthTotalSoldAmt = 0;
					float monthTotalVarQty = 0;
					float monthTotalVarAmt = 0;
					float monthTotalRetQty = 0;
					float monthTotalRetAmt = 0;
					float monthTotalNetQty = 0;
					float monthTotalNetAmt = 0;
					float monthTotalRetAmtPer = 0;

					float monthTotalSoldTaxableAmt = 0;
					float monthTotalVarTaxableAmt = 0;
					float monthTotalRetTaxableAmt = 0;
					float monthTotalNetTaxableAmt = 0;
					float monthTotalRetTaxableAmtPer = 0;

					for (int j = 0; j < reportList.get(i).getDataList().size(); j++) {

						float frTotalSoldQty = 0;
						float frTotalSoldAmt = 0;
						float frTotalVarQty = 0;
						float frTotalVarAmt = 0;
						float frTotalRetQty = 0;
						float frTotalRetAmt = 0;
						float frTotalNetQty = 0;
						float frTotalNetAmt = 0;
						float frTotalRetAmtPer = 0;
						float frTotalSoldTaxableAmt = 0;
						float frTotalVarTaxableAmt = 0;
						float frTotalRetTaxableAmt = 0;
						float frTotalNetTaxableAmt = 0;
						float frTotalRetTaxableAmtPer = 0;

						TempFrWiseSubCat frData = reportList.get(i).getDataList().get(j);

						for (int k = 0; k < frData.getSubCatList().size(); k++) {

							TempSubCatWiseBillData data = frData.getSubCatList().get(k);

							frTotalSoldQty = frTotalSoldQty + data.getSoldQty();
							frTotalSoldAmt = frTotalSoldAmt + data.getSoldAmt();
							frTotalVarQty = frTotalVarQty + data.getVarQty();
							frTotalVarAmt = frTotalVarAmt + data.getVarAmt();
							frTotalRetQty = frTotalRetQty + data.getRetQty();
							frTotalRetAmt = frTotalRetAmt + data.getRetAmt();
							frTotalNetQty = frTotalNetQty + (data.getSoldQty() - (data.getVarQty() + data.getRetQty()));
							frTotalNetAmt = frTotalNetAmt + (data.getSoldAmt() - (data.getVarAmt() + data.getRetAmt()));

							if (data.getSoldAmt() == 0) {
								frTotalRetAmtPer = frTotalRetAmtPer + 0;

							} else {
								frTotalRetAmtPer = frTotalRetAmtPer
										+ (((data.getVarAmt() + data.getRetAmt()) * 100) / data.getSoldAmt());
							}

							frTotalSoldTaxableAmt = frTotalSoldTaxableAmt + data.getTaxableAmt();
							frTotalVarTaxableAmt = frTotalVarTaxableAmt + data.getVarTaxableAmt();
							frTotalRetTaxableAmt = frTotalRetTaxableAmt + data.getRetTaxableAmt();
							frTotalNetTaxableAmt = frTotalNetTaxableAmt
									+ (data.getTaxableAmt() - (data.getVarTaxableAmt() + data.getRetTaxableAmt()));

							if (data.getTaxableAmt() == 0) {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer + 0;
							} else {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer
										+ (((data.getVarTaxableAmt() + data.getRetTaxableAmt()) * 100)
												/ data.getTaxableAmt());
							}

						}

						frData.setFrTotalSoldQty(frTotalSoldQty);
						frData.setFrTotalSoldAmt(frTotalSoldAmt);

						frData.setFrTotalVarQty(frTotalVarQty);
						frData.setFrTotalVarAmt(frTotalVarAmt);

						frData.setFrTotalRetQty(frTotalRetQty);
						frData.setFrTotalRetAmt(frTotalRetAmt);

						frData.setFrTotalNetQty(frTotalNetQty);
						frData.setFrTotalNetAmt(frTotalNetAmt);

						frData.setFrTotalRetAmtPer(frTotalRetAmtPer);

						frData.setFrTotalSoldTaxableAmt(frTotalSoldTaxableAmt);

						frData.setFrTotalVarTaxableAmt(frTotalVarTaxableAmt);

						frData.setFrTotalRetTaxableAmt(frTotalRetTaxableAmt);

						frData.setFrTotalNetTaxableAmt(frTotalNetTaxableAmt);

						frData.setFrTotalRetTaxableAmtPer(frTotalRetTaxableAmtPer);

						// -----------MONTHLY SUM--------------------------
						monthTotalSoldQty = monthTotalSoldQty + frTotalSoldQty;
						monthTotalSoldAmt = monthTotalSoldAmt + frTotalSoldAmt;
						monthTotalVarQty = monthTotalVarQty + frTotalVarQty;
						monthTotalVarAmt = monthTotalVarAmt + frTotalVarAmt;
						monthTotalRetQty = monthTotalRetQty + frTotalRetQty;
						monthTotalRetAmt = monthTotalRetAmt + frTotalRetAmt;
						monthTotalNetQty = monthTotalNetQty + frTotalNetQty;
						monthTotalNetAmt = monthTotalNetAmt + frTotalNetAmt;
						monthTotalRetAmtPer = monthTotalRetAmtPer + frTotalRetAmtPer;

						monthTotalSoldTaxableAmt = monthTotalSoldTaxableAmt + frTotalSoldTaxableAmt;
						monthTotalVarTaxableAmt = monthTotalVarTaxableAmt + frTotalVarTaxableAmt;
						monthTotalRetTaxableAmt = monthTotalRetTaxableAmt + frTotalRetTaxableAmt;
						monthTotalNetTaxableAmt = monthTotalNetTaxableAmt + frTotalNetTaxableAmt;
						monthTotalRetTaxableAmtPer = monthTotalRetTaxableAmtPer + frTotalRetTaxableAmtPer;

					}

					reportList.get(i).setMonthTotalSoldQty(monthTotalSoldQty);
					reportList.get(i).setMonthTotalSoldAmt(monthTotalSoldAmt);

					reportList.get(i).setMonthTotalVarQty(monthTotalVarQty);
					reportList.get(i).setMonthTotalVarAmt(monthTotalVarAmt);

					reportList.get(i).setMonthTotalRetQty(monthTotalRetQty);
					reportList.get(i).setMonthTotalRetAmt(monthTotalRetAmt);

					reportList.get(i).setMonthTotalNetQty(monthTotalNetQty);
					reportList.get(i).setMonthTotalNetAmt(monthTotalNetAmt);

					reportList.get(i).setMonthTotalRetAmtPer(monthTotalRetAmtPer);

					reportList.get(i).setMonthTotalSoldTaxableAmt(monthTotalSoldTaxableAmt);

					reportList.get(i).setMonthTotalVarTaxableAmt(monthTotalVarTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmt(monthTotalRetTaxableAmt);

					reportList.get(i).setMonthTotalNetTaxableAmt(monthTotalNetTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmtPer(monthTotalRetTaxableAmtPer);

				}
			}

			System.err.println("-------------- REPORT---------------- " + reportList);

		} catch (Exception e) {

			System.out.println("Exc in display yearly report--  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add(" ");
			for (int i = 0; i < reportList.size(); i++) {
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(reportList.get(i).getDateStr());
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add(" ");

			for (int i = 0; i < reportList.size(); i++) {

				rowData.add("Sold Qty");
				rowData.add("Sold Amt");
				rowData.add("Var Qty");
				rowData.add("Var Amt");
				rowData.add("Ret Qty");
				rowData.add("Ret Amt");
				rowData.add("Net Qty");
				rowData.add("Net Amt");
				rowData.add("Ret Amt %");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					YearlySaleData monthData = reportList.get(0);

					for (int f = 0; f < monthData.getDataList().size(); f++) {

						TempFrWiseSubCat frData = monthData.getDataList().get(f);

						for (int s = 0; s < frData.getSubCatList().size(); s++) {

							TempSubCatWiseBillData scData = frData.getSubCatList().get(s);

							expoExcel = new ExportToExcel();
							rowData = new ArrayList<String>();

							rowData.add("" + scData.getSubCatName());

							for (int m = 0; m < reportList.size(); m++) {

								for (int f1 = 0; f1 < reportList.get(m).getDataList().size(); f1++) {

									if (reportList.get(m).getDataList().get(f1).getFrId() == frData.getFrId()) {
										for (int sc1 = 0; sc1 < reportList.get(m).getDataList().get(f1).getSubCatList()
												.size(); sc1++) {
											if (reportList.get(m).getDataList().get(f1).getSubCatList().get(sc1)
													.getSubCatId() == scData.getSubCatId()) {

												TempSubCatWiseBillData scData1 = reportList.get(m).getDataList().get(f1)
														.getSubCatList().get(sc1);

												// rowData.add("" + scData1.getSubCatName());

												if (selectedType.equalsIgnoreCase("1")) {

													rowData.add("" + scData1.getSoldQty());
													rowData.add("" + scData1.getSoldAmt());

													rowData.add("" + scData1.getVarQty());
													rowData.add("" + scData1.getVarAmt());

													rowData.add("" + scData1.getRetQty());
													rowData.add("" + scData1.getRetAmt());

													rowData.add("" + (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add("" + (scData1.getSoldAmt()
															- (scData1.getVarAmt() + scData1.getRetAmt())));

													if (scData1.getSoldAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add(""
																+ (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																		/ scData1.getSoldAmt())
																+ "%");
													}

												} else if (selectedType.equalsIgnoreCase("2")) {

													rowData.add("" + scData1.getSoldQty());
													rowData.add("");

													rowData.add("" + scData1.getVarQty());
													rowData.add("");

													rowData.add("" + scData1.getRetQty());
													rowData.add("");

													rowData.add("" + (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add("");

													rowData.add("");

												} else if (selectedType.equalsIgnoreCase("3")) {

													rowData.add("");
													rowData.add("" + scData1.getSoldAmt());

													rowData.add("");
													rowData.add("" + scData1.getVarAmt());

													rowData.add("");
													rowData.add("" + scData1.getRetAmt());

													rowData.add("");
													rowData.add("" + (scData1.getSoldAmt()
															- (scData1.getVarAmt() + scData1.getRetAmt())));

													if (scData1.getSoldAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add(""
																+ (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																		/ scData1.getSoldAmt())
																+ "%");
													}

												} else if (selectedType.equalsIgnoreCase("4")) {

													rowData.add("" + (int) scData1.getSoldQty());
													rowData.add("" + scData1.getTaxableAmt());

													rowData.add("" + (int) scData1.getVarQty());
													rowData.add("" + scData1.getVarTaxableAmt());

													rowData.add("" + (int) scData1.getRetQty());
													rowData.add("" + scData1.getRetTaxableAmt());

													rowData.add("" + (int) (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add(
															"" + (scData1.getTaxableAmt() - (scData1.getVarTaxableAmt()
																	+ scData1.getRetTaxableAmt())));

													if (scData1.getTaxableAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add("" + (((scData1.getVarTaxableAmt()
																+ scData1.getRetTaxableAmt()) * 100)
																/ scData1.getTaxableAmt()) + "%");
													}

												}

												break;
											}
										}

										break;
									}
								}
							}
							expoExcel.setRowData(rowData);
							exportToExcelList.add(expoExcel);

						}

					}
				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			for (int i = 0; i < reportList.size(); i++) {

				YearlySaleData data = reportList.get(i);

				if (selectedType.equalsIgnoreCase("1")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("2")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("");

					rowData.add("");

				} else if (selectedType.equalsIgnoreCase("3")) {

					rowData.add("");
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("4")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetTaxableAmt());

					rowData.add("" + data.getMonthTotalRetTaxableAmtPer() + "%");

				}

			}

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "Sub_Category_Month_Wise_Purchase_Report");
			session.setAttribute("reportNameNew", "Sub Category Month Wise Purchase Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$J$1");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// -------------------SELL REPORT MAPPING----------------------

	@RequestMapping(value = "/showYearlySellReport", method = RequestMethod.GET)
	public ModelAndView showYearlySellReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/yearlySellReport");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			RestTemplate restTemplate = new RestTemplate();

			model.addObject("todaysDate", todaysDate);

			CategoryListResponse categoryListResponse;

			categoryListResponse = restTemplate.getForObject(Constant.URL + "showAllCategory",
					CategoryListResponse.class);

			mCategoryList = categoryListResponse.getmCategoryList();

			model.addObject("mCategoryList", mCategoryList);

			SubCategory[] subCatList = restTemplate.getForObject(Constant.URL + "getAllSubCatList",
					SubCategory[].class);

			subCatAList = new ArrayList<SubCategory>(Arrays.asList(subCatList));

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			model.addObject("frId", frDetails.getFrId());

			SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");
			Date date1 = new Date(); // your date
			// Choose time zone in which you want to interpret your Date
			Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Calcutta"));
			cal.setTime(date1);
			int year = cal.get(Calendar.YEAR);
			int month = (cal.get(Calendar.MONTH)) + 1;
			int day = cal.get(Calendar.DAY_OF_MONTH);

			String toDays = day + "-" + month + "-" + year;
			String year1stdate = "01" + "-" + "04" + "-" + year;

			Date today = sf.parse(toDays);
			Date yeardate = sf.parse(year1stdate);
			
			if(today.compareTo(yeardate)<0) {
				cal.add(Calendar.YEAR, -1);
				year = cal.get(Calendar.YEAR);
				year1stdate = "01" + "-" + "04" + "-" + year; 
				yeardate = sf.parse(year1stdate);
				
				model.addObject("fromDate", sf.format(yeardate));
				model.addObject("toDate", sf.format(today));
				
				System.out.println(today + "  year date big  " + yeardate);
			}else {
				
				model.addObject("fromDate", sf.format(yeardate));
				model.addObject("toDate", sf.format(today));
				System.out.println(today + "  To day big  " + yeardate);
			}

			
		} catch (Exception e) {

			System.out.println("Exc in showYearlySellReport--  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	// ---AJAX--------SUB CAT SELL REPORT------------------

	@RequestMapping(value = "/getFrSubCatYearlySellReport", method = RequestMethod.GET)
	public @ResponseBody List<YearlySaleData> getFrSubCatYearlySellReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<YearlySaleData> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		try {
			System.out.println("Inside get Sale Bill Wise");
			frId = Integer.parseInt(request.getParameter("frId"));
			String selectedSubCatIdList = request.getParameter("subCat_id_list");
			String selectedCatIdList = request.getParameter("cat_id_list");
			
			selectedCatIdList = selectedCatIdList.substring(1, selectedCatIdList.length() - 1);
			selectedCatIdList = selectedCatIdList.replaceAll("\"", "");

			List<Integer> cIds = Stream.of(selectedCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());
			
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");

			System.err.println("SC ************************************************** " + selectedSubCatIdList);

			selectedSubCatIdList = selectedSubCatIdList.substring(1, selectedSubCatIdList.length() - 1);
			selectedSubCatIdList = selectedSubCatIdList.replaceAll("\"", "");

			List<Integer> scIds = Stream.of(selectedSubCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			System.err.println("SC LIST************************************************** " + scIds);

			if (scIds.contains(-1)) {
				// subCatIdList.clear();
				List<String> tempScIdList = new ArrayList();

				if (subCatAList != null) {

					for (int j = 0; j < cIds.size(); j++) {

						for (int i = 0; i < subCatAList.size(); i++) {

							if (cIds.get(j) == subCatAList.get(i).getCatId()) {
								tempScIdList.add(String.valueOf(subCatAList.get(i).getSubCatId()));
							}

						}
					}

				}
				System.err.println("SUB CAT ID ARRAY --------- " + tempScIdList);
				selectedSubCatIdList = tempScIdList.toString().substring(1, tempScIdList.toString().length() - 1);
				selectedSubCatIdList = selectedSubCatIdList.replaceAll("\"", "");

			}

			System.out.println("selectedFrAfter------------------" + selectedSubCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			System.out.println("Inside If all fr Selected ");

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frIdList", "" + frId);
			map.add("subCatIdList", selectedSubCatIdList);

			ParameterizedTypeReference<List<YearlySaleData>> typeRef = new ParameterizedTypeReference<List<YearlySaleData>>() {
			};
			ResponseEntity<List<YearlySaleData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getFrSubCatSellYearlyReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get Yearly sale Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			DecimalFormat df = new DecimalFormat("0.00");

			System.err.println("REPORT ------------------- " + reportList);

			if (reportList != null) {

				for (int i = 0; i < reportList.size(); i++) {

					float monthTotalSoldQty = 0;
					float monthTotalSoldAmt = 0;
					float monthTotalVarQty = 0;
					float monthTotalVarAmt = 0;
					float monthTotalRetQty = 0;
					float monthTotalRetAmt = 0;
					float monthTotalNetQty = 0;
					float monthTotalNetAmt = 0;
					float monthTotalRetAmtPer = 0;

					float monthTotalSoldTaxableAmt = 0;
					float monthTotalVarTaxableAmt = 0;
					float monthTotalRetTaxableAmt = 0;
					float monthTotalNetTaxableAmt = 0;
					float monthTotalRetTaxableAmtPer = 0;

					for (int j = 0; j < reportList.get(i).getDataList().size(); j++) {

						float frTotalSoldQty = 0;
						float frTotalSoldAmt = 0;
						float frTotalVarQty = 0;
						float frTotalVarAmt = 0;
						float frTotalRetQty = 0;
						float frTotalRetAmt = 0;
						float frTotalNetQty = 0;
						float frTotalNetAmt = 0;
						float frTotalRetAmtPer = 0;
						float frTotalSoldTaxableAmt = 0;
						float frTotalVarTaxableAmt = 0;
						float frTotalRetTaxableAmt = 0;
						float frTotalNetTaxableAmt = 0;
						float frTotalRetTaxableAmtPer = 0;

						TempFrWiseSubCat frData = reportList.get(i).getDataList().get(j);

						for (int k = 0; k < frData.getSubCatList().size(); k++) {

							TempSubCatWiseBillData data = frData.getSubCatList().get(k);

							frTotalSoldQty = frTotalSoldQty + data.getSoldQty();
							frTotalSoldAmt = frTotalSoldAmt + data.getSoldAmt();
							frTotalVarQty = frTotalVarQty + data.getVarQty();
							frTotalVarAmt = frTotalVarAmt + data.getVarAmt();
							frTotalRetQty = frTotalRetQty + data.getRetQty();
							frTotalRetAmt = frTotalRetAmt + data.getRetAmt();
							frTotalNetQty = frTotalNetQty + (data.getSoldQty() - (data.getVarQty() + data.getRetQty()));
							frTotalNetAmt = frTotalNetAmt + (data.getSoldAmt() - (data.getVarAmt() + data.getRetAmt()));

							if (data.getSoldAmt() == 0) {
								frTotalRetAmtPer = frTotalRetAmtPer + 0;

							} else {
								frTotalRetAmtPer = frTotalRetAmtPer
										+ (((data.getVarAmt() + data.getRetAmt()) * 100) / data.getSoldAmt());
							}

							frTotalSoldTaxableAmt = frTotalSoldTaxableAmt + data.getTaxableAmt();
							frTotalVarTaxableAmt = frTotalVarTaxableAmt + data.getVarTaxableAmt();
							frTotalRetTaxableAmt = frTotalRetTaxableAmt + data.getRetTaxableAmt();
							frTotalNetTaxableAmt = frTotalNetTaxableAmt
									+ (data.getTaxableAmt() - (data.getVarTaxableAmt() + data.getRetTaxableAmt()));

							if (data.getTaxableAmt() == 0) {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer + 0;
							} else {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer
										+ (((data.getVarTaxableAmt() + data.getRetTaxableAmt()) * 100)
												/ data.getTaxableAmt());
							}

						}

						frData.setFrTotalSoldQty(frTotalSoldQty);
						frData.setFrTotalSoldAmt(frTotalSoldAmt);

						frData.setFrTotalVarQty(frTotalVarQty);
						frData.setFrTotalVarAmt(frTotalVarAmt);

						frData.setFrTotalRetQty(frTotalRetQty);
						frData.setFrTotalRetAmt(frTotalRetAmt);

						frData.setFrTotalNetQty(frTotalNetQty);
						frData.setFrTotalNetAmt(frTotalNetAmt);

						frData.setFrTotalRetAmtPer(frTotalRetAmtPer);

						frData.setFrTotalSoldTaxableAmt(frTotalSoldTaxableAmt);

						frData.setFrTotalVarTaxableAmt(frTotalVarTaxableAmt);

						frData.setFrTotalRetTaxableAmt(frTotalRetTaxableAmt);

						frData.setFrTotalNetTaxableAmt(frTotalNetTaxableAmt);

						frData.setFrTotalRetTaxableAmtPer(frTotalRetTaxableAmtPer);

						// -----------MONTHLY SUM--------------------------
						monthTotalSoldQty = monthTotalSoldQty + frTotalSoldQty;
						monthTotalSoldAmt = monthTotalSoldAmt + frTotalSoldAmt;
						monthTotalVarQty = monthTotalVarQty + frTotalVarQty;
						monthTotalVarAmt = monthTotalVarAmt + frTotalVarAmt;
						monthTotalRetQty = monthTotalRetQty + frTotalRetQty;
						monthTotalRetAmt = monthTotalRetAmt + frTotalRetAmt;
						monthTotalNetQty = monthTotalNetQty + frTotalNetQty;
						monthTotalNetAmt = monthTotalNetAmt + frTotalNetAmt;
						monthTotalRetAmtPer = monthTotalRetAmtPer + frTotalRetAmtPer;

						monthTotalSoldTaxableAmt = monthTotalSoldTaxableAmt + frTotalSoldTaxableAmt;
						monthTotalVarTaxableAmt = monthTotalVarTaxableAmt + frTotalVarTaxableAmt;
						monthTotalRetTaxableAmt = monthTotalRetTaxableAmt + frTotalRetTaxableAmt;
						monthTotalNetTaxableAmt = monthTotalNetTaxableAmt + frTotalNetTaxableAmt;
						monthTotalRetTaxableAmtPer = monthTotalRetTaxableAmtPer + frTotalRetTaxableAmtPer;

					}

					reportList.get(i).setMonthTotalSoldQty(monthTotalSoldQty);
					reportList.get(i).setMonthTotalSoldAmt(monthTotalSoldAmt);

					reportList.get(i).setMonthTotalVarQty(monthTotalVarQty);
					reportList.get(i).setMonthTotalVarAmt(monthTotalVarAmt);

					reportList.get(i).setMonthTotalRetQty(monthTotalRetQty);
					reportList.get(i).setMonthTotalRetAmt(monthTotalRetAmt);

					reportList.get(i).setMonthTotalNetQty(monthTotalNetQty);
					reportList.get(i).setMonthTotalNetAmt(monthTotalNetAmt);

					reportList.get(i).setMonthTotalRetAmtPer(monthTotalRetAmtPer);

					reportList.get(i).setMonthTotalSoldTaxableAmt(monthTotalSoldTaxableAmt);

					reportList.get(i).setMonthTotalVarTaxableAmt(monthTotalVarTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmt(monthTotalRetTaxableAmt);

					reportList.get(i).setMonthTotalNetTaxableAmt(monthTotalNetTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmtPer(monthTotalRetTaxableAmtPer);

				}
			}

			System.err.println("-------------- REPORT---------------- " + reportList);

		} catch (Exception e) {

			System.out.println("Exc in display yearly report--  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add(" ");
			for (int i = 0; i < reportList.size(); i++) {

				String dispStr = reportList.get(i).getDateStr();

				rowData.add("" + dispStr.substring(0, dispStr.indexOf('-')));
				rowData.add("" + reportList.get(i).getYearId());
			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add(" ");

			for (int i = 0; i < reportList.size(); i++) {

				rowData.add("Sold Qty");
				rowData.add("Sold Amt");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					YearlySaleData monthData = reportList.get(0);

					for (int f = 0; f < monthData.getDataList().size(); f++) {

						TempFrWiseSubCat frData = monthData.getDataList().get(f);

						for (int s = 0; s < frData.getSubCatList().size(); s++) {

							TempSubCatWiseBillData scData = frData.getSubCatList().get(s);

							expoExcel = new ExportToExcel();
							rowData = new ArrayList<String>();

							rowData.add("" + scData.getSubCatName());

							for (int m = 0; m < reportList.size(); m++) {

								for (int f1 = 0; f1 < reportList.get(m).getDataList().size(); f1++) {

									if (reportList.get(m).getDataList().get(f1).getFrId() == frData.getFrId()) {
										for (int sc1 = 0; sc1 < reportList.get(m).getDataList().get(f1).getSubCatList()
												.size(); sc1++) {
											if (reportList.get(m).getDataList().get(f1).getSubCatList().get(sc1)
													.getSubCatId() == scData.getSubCatId()) {

												TempSubCatWiseBillData scData1 = reportList.get(m).getDataList().get(f1)
														.getSubCatList().get(sc1);

												// rowData.add("" + scData1.getSubCatName());

												rowData.add("" + scData1.getSoldQty());
												rowData.add("" + scData1.getSoldAmt());

												break;
											}
										}

										break;
									}
								}
							}
							expoExcel.setRowData(rowData);
							exportToExcelList.add(expoExcel);

						}

					}
				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			for (int i = 0; i < reportList.size(); i++) {

				YearlySaleData data = reportList.get(i);

				rowData.add("" + (int) data.getMonthTotalSoldQty());
				rowData.add("" + data.getMonthTotalSoldAmt());

			}

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "Sub_Category_Month_Wise_Sell_Report");
			session.setAttribute("reportNameNew", "Sub Category Month Wise Sell Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$J$1");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// -------------------Itemwise Report---------------------------------

	@RequestMapping(value = "/yearlyItemWisePurchaseReport", method = RequestMethod.GET)
	public ModelAndView yearlyItemWisePurchaseReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/yearlyItemWisePurchaseReport");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			RestTemplate restTemplate = new RestTemplate();

			model.addObject("todaysDate", todaysDate);

			CategoryListResponse categoryListResponse;

			categoryListResponse = restTemplate.getForObject(Constant.URL + "showAllCategory",
					CategoryListResponse.class);

			mCategoryList = categoryListResponse.getmCategoryList();

			model.addObject("mCategoryList", mCategoryList);

			SubCategory[] subCatList = restTemplate.getForObject(Constant.URL + "getAllSubCatList",
					SubCategory[].class);

			subCatAList = new ArrayList<SubCategory>(Arrays.asList(subCatList));

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			model.addObject("frId", frDetails.getFrId());

		} catch (Exception e) {

			System.out.println("Exc in showYearlyFrSubCatSaleReport--  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	// ----AJAX-------------SEARCH ITEM YEARLY REPORT-------------

	@RequestMapping(value = "/getItemYearlyPurchaseReport", method = RequestMethod.GET)
	public @ResponseBody List<YearlyItemReport> getItemYearlyPurchaseReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<YearlyItemReport> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		String selectedType = "";
		try {
			System.out.println("Inside ITEM WISE REPORT");
			frId = Integer.parseInt(request.getParameter("frId"));
			String selectedCatIdList = request.getParameter("cat_id_list");
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");
			selectedType = request.getParameter("selectedType");

			System.err.println("SC ************************************************** " + selectedCatIdList);

			selectedCatIdList = selectedCatIdList.substring(1, selectedCatIdList.length() - 1);
			selectedCatIdList = selectedCatIdList.replaceAll("\"", "");

			List<Integer> cIds = Stream.of(selectedCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			System.err.println("SC LIST************************************************** " + cIds);

			if (cIds.contains(-1)) {
				// subCatIdList.clear();
				List<String> tempcIdList = new ArrayList();

				if (mCategoryList != null) {

					for (int i = 0; i < mCategoryList.size(); i++) {
						tempcIdList.add(String.valueOf(mCategoryList.get(i).getCatId()));
					}
				}
				System.err.println("CAT ID ARRAY --------- " + tempcIdList);
				selectedCatIdList = tempcIdList.toString().substring(1, tempcIdList.toString().length() - 1);
				selectedCatIdList = selectedCatIdList.replaceAll(" ", "");

			}

			System.out.println("selectedCATAfter 565656------------------" + selectedCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frId", frId);
			map.add("catIdList", selectedCatIdList);

			ParameterizedTypeReference<List<YearlyItemReport>> typeRef = new ParameterizedTypeReference<List<YearlyItemReport>>() {
			};
			ResponseEntity<List<YearlyItemReport>> responseEntity = restTemplate.exchange(
					Constant.URL + "getOpsItemwiseYearlyPurchaseReport", HttpMethod.POST, new HttpEntity<>(map),
					typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get Yearly sale Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			DecimalFormat df = new DecimalFormat("0.00");

			System.err.println("REPORT ------------------- " + reportList);

			if (reportList != null) {

				for (int i = 0; i < reportList.size(); i++) {

					float monthTotalSoldQty = 0;
					float monthTotalSoldAmt = 0;
					float monthTotalVarQty = 0;
					float monthTotalVarAmt = 0;
					float monthTotalRetQty = 0;
					float monthTotalRetAmt = 0;
					float monthTotalNetQty = 0;
					float monthTotalNetAmt = 0;
					float monthTotalRetAmtPer = 0;

					float monthTotalSoldTaxableAmt = 0;
					float monthTotalVarTaxableAmt = 0;
					float monthTotalRetTaxableAmt = 0;
					float monthTotalNetTaxableAmt = 0;
					float monthTotalRetTaxableAmtPer = 0;

					for (int j = 0; j < reportList.get(i).getDataList().size(); j++) {

						float frTotalSoldQty = 0;
						float frTotalSoldAmt = 0;
						float frTotalVarQty = 0;
						float frTotalVarAmt = 0;
						float frTotalRetQty = 0;
						float frTotalRetAmt = 0;
						float frTotalNetQty = 0;
						float frTotalNetAmt = 0;
						float frTotalRetAmtPer = 0;
						float frTotalSoldTaxableAmt = 0;
						float frTotalVarTaxableAmt = 0;
						float frTotalRetTaxableAmt = 0;
						float frTotalNetTaxableAmt = 0;
						float frTotalRetTaxableAmtPer = 0;

						TempSubCatList frData = reportList.get(i).getDataList().get(j);

						for (int k = 0; k < frData.getItemList().size(); k++) {

							TempItemList data = frData.getItemList().get(k);

							frTotalSoldQty = frTotalSoldQty + data.getSoldQty();
							frTotalSoldAmt = frTotalSoldAmt + data.getSoldAmt();
							frTotalVarQty = frTotalVarQty + data.getVarQty();
							frTotalVarAmt = frTotalVarAmt + data.getVarAmt();
							frTotalRetQty = frTotalRetQty + data.getRetQty();
							frTotalRetAmt = frTotalRetAmt + data.getRetAmt();
							frTotalNetQty = frTotalNetQty + (data.getSoldQty() - (data.getVarQty() + data.getRetQty()));
							frTotalNetAmt = frTotalNetAmt + (data.getSoldAmt() - (data.getVarAmt() + data.getRetAmt()));

							if (data.getSoldAmt() == 0) {
								frTotalRetAmtPer = frTotalRetAmtPer + 0;

							} else {
								frTotalRetAmtPer = frTotalRetAmtPer
										+ (((data.getVarAmt() + data.getRetAmt()) * 100) / data.getSoldAmt());
							}

							frTotalSoldTaxableAmt = frTotalSoldTaxableAmt + data.getTaxableAmt();
							frTotalVarTaxableAmt = frTotalVarTaxableAmt + data.getVarTaxableAmt();
							frTotalRetTaxableAmt = frTotalRetTaxableAmt + data.getRetTaxableAmt();
							frTotalNetTaxableAmt = frTotalNetTaxableAmt
									+ (data.getTaxableAmt() - (data.getVarTaxableAmt() + data.getRetTaxableAmt()));

							if (data.getTaxableAmt() == 0) {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer + 0;
							} else {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer
										+ (((data.getVarTaxableAmt() + data.getRetTaxableAmt()) * 100)
												/ data.getTaxableAmt());
							}

						}

						frData.setFrTotalSoldQty(frTotalSoldQty);
						frData.setFrTotalSoldAmt(frTotalSoldAmt);

						frData.setFrTotalVarQty(frTotalVarQty);
						frData.setFrTotalVarAmt(frTotalVarAmt);

						frData.setFrTotalRetQty(frTotalRetQty);
						frData.setFrTotalRetAmt(frTotalRetAmt);

						frData.setFrTotalNetQty(frTotalNetQty);
						frData.setFrTotalNetAmt(frTotalNetAmt);

						frData.setFrTotalRetAmtPer(frTotalRetAmtPer);

						frData.setFrTotalSoldTaxableAmt(frTotalSoldTaxableAmt);

						frData.setFrTotalVarTaxableAmt(frTotalVarTaxableAmt);

						frData.setFrTotalRetTaxableAmt(frTotalRetTaxableAmt);

						frData.setFrTotalNetTaxableAmt(frTotalNetTaxableAmt);

						frData.setFrTotalRetTaxableAmtPer(frTotalRetTaxableAmtPer);

						// -----------MONTHLY SUM--------------------------
						monthTotalSoldQty = monthTotalSoldQty + frTotalSoldQty;
						monthTotalSoldAmt = monthTotalSoldAmt + frTotalSoldAmt;
						monthTotalVarQty = monthTotalVarQty + frTotalVarQty;
						monthTotalVarAmt = monthTotalVarAmt + frTotalVarAmt;
						monthTotalRetQty = monthTotalRetQty + frTotalRetQty;
						monthTotalRetAmt = monthTotalRetAmt + frTotalRetAmt;
						monthTotalNetQty = monthTotalNetQty + frTotalNetQty;
						monthTotalNetAmt = monthTotalNetAmt + frTotalNetAmt;
						monthTotalRetAmtPer = monthTotalRetAmtPer + frTotalRetAmtPer;

						monthTotalSoldTaxableAmt = monthTotalSoldTaxableAmt + frTotalSoldTaxableAmt;
						monthTotalVarTaxableAmt = monthTotalVarTaxableAmt + frTotalVarTaxableAmt;
						monthTotalRetTaxableAmt = monthTotalRetTaxableAmt + frTotalRetTaxableAmt;
						monthTotalNetTaxableAmt = monthTotalNetTaxableAmt + frTotalNetTaxableAmt;
						monthTotalRetTaxableAmtPer = monthTotalRetTaxableAmtPer + frTotalRetTaxableAmtPer;

					}

					reportList.get(i).setMonthTotalSoldQty(monthTotalSoldQty);
					reportList.get(i).setMonthTotalSoldAmt(monthTotalSoldAmt);

					reportList.get(i).setMonthTotalVarQty(monthTotalVarQty);
					reportList.get(i).setMonthTotalVarAmt(monthTotalVarAmt);

					reportList.get(i).setMonthTotalRetQty(monthTotalRetQty);
					reportList.get(i).setMonthTotalRetAmt(monthTotalRetAmt);

					reportList.get(i).setMonthTotalNetQty(monthTotalNetQty);
					reportList.get(i).setMonthTotalNetAmt(monthTotalNetAmt);

					reportList.get(i).setMonthTotalRetAmtPer(monthTotalRetAmtPer);

					reportList.get(i).setMonthTotalSoldTaxableAmt(monthTotalSoldTaxableAmt);

					reportList.get(i).setMonthTotalVarTaxableAmt(monthTotalVarTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmt(monthTotalRetTaxableAmt);

					reportList.get(i).setMonthTotalNetTaxableAmt(monthTotalNetTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmtPer(monthTotalRetTaxableAmtPer);

				}
			}

			System.err.println("-------------- REPORT---------------- " + reportList);

		} catch (Exception e) {

			System.out.println("Exc in display yearly report--  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add(" ");
			for (int i = 0; i < reportList.size(); i++) {
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(reportList.get(i).getDateStr());
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");
				rowData.add(" ");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add(" ");

			for (int i = 0; i < reportList.size(); i++) {

				rowData.add("Sold Qty");
				rowData.add("Sold Amt");
				rowData.add("Var Qty");
				rowData.add("Var Amt");
				rowData.add("Ret Qty");
				rowData.add("Ret Amt");
				rowData.add("Net Qty");
				rowData.add("Net Amt");
				rowData.add("Ret Amt %");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					YearlyItemReport monthData = reportList.get(0);

					for (int f = 0; f < monthData.getDataList().size(); f++) {

						TempSubCatList frData = monthData.getDataList().get(f);

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("" + frData.getSubCatName());

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

						for (int s = 0; s < frData.getItemList().size(); s++) {

							TempItemList scData = frData.getItemList().get(s);

							expoExcel = new ExportToExcel();
							rowData = new ArrayList<String>();

							rowData.add("" + scData.getItemName());

							for (int m = 0; m < reportList.size(); m++) {

								for (int f1 = 0; f1 < reportList.get(m).getDataList().size(); f1++) {

									if (reportList.get(m).getDataList().get(f1).getSubCatId() == frData.getSubCatId()) {
										for (int sc1 = 0; sc1 < reportList.get(m).getDataList().get(f1).getItemList()
												.size(); sc1++) {
											if (reportList.get(m).getDataList().get(f1).getItemList().get(sc1)
													.getItemId() == scData.getItemId()) {

												TempItemList scData1 = reportList.get(m).getDataList().get(f1)
														.getItemList().get(sc1);

												// rowData.add("" + scData1.getSubCatName());

												if (selectedType.equalsIgnoreCase("1")) {

													rowData.add("" + scData1.getSoldQty());
													rowData.add("" + scData1.getSoldAmt());

													rowData.add("" + scData1.getVarQty());
													rowData.add("" + scData1.getVarAmt());

													rowData.add("" + scData1.getRetQty());
													rowData.add("" + scData1.getRetAmt());

													rowData.add("" + (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add("" + (scData1.getSoldAmt()
															- (scData1.getVarAmt() + scData1.getRetAmt())));

													if (scData1.getSoldAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add(""
																+ (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																		/ scData1.getSoldAmt())
																+ "%");
													}

												} else if (selectedType.equalsIgnoreCase("2")) {

													rowData.add("" + scData1.getSoldQty());
													rowData.add("");

													rowData.add("" + scData1.getVarQty());
													rowData.add("");

													rowData.add("" + scData1.getRetQty());
													rowData.add("");

													rowData.add("" + (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add("");

													rowData.add("");

												} else if (selectedType.equalsIgnoreCase("3")) {

													rowData.add("");
													rowData.add("" + scData1.getSoldAmt());

													rowData.add("");
													rowData.add("" + scData1.getVarAmt());

													rowData.add("");
													rowData.add("" + scData1.getRetAmt());

													rowData.add("");
													rowData.add("" + (scData1.getSoldAmt()
															- (scData1.getVarAmt() + scData1.getRetAmt())));

													if (scData1.getSoldAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add(""
																+ (((scData1.getVarAmt() + scData1.getRetAmt()) * 100)
																		/ scData1.getSoldAmt())
																+ "%");
													}

												} else if (selectedType.equalsIgnoreCase("4")) {

													rowData.add("" + (int) scData1.getSoldQty());
													rowData.add("" + scData1.getTaxableAmt());

													rowData.add("" + (int) scData1.getVarQty());
													rowData.add("" + scData1.getVarTaxableAmt());

													rowData.add("" + (int) scData1.getRetQty());
													rowData.add("" + scData1.getRetTaxableAmt());

													rowData.add("" + (int) (scData1.getSoldQty()
															- (scData1.getVarQty() + scData1.getRetQty())));
													rowData.add(
															"" + (scData1.getTaxableAmt() - (scData1.getVarTaxableAmt()
																	+ scData1.getRetTaxableAmt())));

													if (scData1.getTaxableAmt() == 0) {
														rowData.add("0.00%");
													} else {
														rowData.add("" + (((scData1.getVarTaxableAmt()
																+ scData1.getRetTaxableAmt()) * 100)
																/ scData1.getTaxableAmt()) + "%");
													}

												}

												break;
											}
										}

										break;
									}
								}
							}
							expoExcel.setRowData(rowData);
							exportToExcelList.add(expoExcel);

						}

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("Total");

						for (int k = 0; k < reportList.size(); k++) {
							for (int n = 0; n < reportList.get(k).getDataList().size(); n++) {

								TempSubCatList fr = reportList.get(k).getDataList().get(n);

								if (frData.getSubCatId() == fr.getSubCatId()) {

									if (selectedType.equalsIgnoreCase("1")) {

										rowData.add("" + (int) fr.getFrTotalSoldQty());
										rowData.add("" + fr.getFrTotalSoldAmt());

										rowData.add("" + (int) fr.getFrTotalVarQty());
										rowData.add("" + fr.getFrTotalVarAmt());

										rowData.add("" + (int) fr.getFrTotalRetQty());
										rowData.add("" + fr.getFrTotalRetAmt());

										rowData.add("" + (int) fr.getFrTotalNetQty());
										rowData.add("" + fr.getFrTotalNetAmt());

										rowData.add("" + fr.getFrTotalRetAmtPer() + "%");

									} else if (selectedType.equalsIgnoreCase("2")) {

										rowData.add("" + (int) fr.getFrTotalSoldQty());
										rowData.add("");

										rowData.add("" + (int) fr.getFrTotalVarQty());
										rowData.add("");

										rowData.add("" + (int) fr.getFrTotalRetQty());
										rowData.add("");

										rowData.add("" + (int) fr.getFrTotalNetQty());
										rowData.add("");

										rowData.add("");

									} else if (selectedType.equalsIgnoreCase("3")) {

										rowData.add("");
										rowData.add("" + fr.getFrTotalSoldAmt());

										rowData.add("");
										rowData.add("" + fr.getFrTotalVarAmt());

										rowData.add("");
										rowData.add("" + fr.getFrTotalRetAmt());

										rowData.add("");
										rowData.add("" + fr.getFrTotalNetAmt());

										rowData.add("" + fr.getFrTotalRetAmtPer() + "%");

									} else if (selectedType.equalsIgnoreCase("4")) {

										rowData.add("" + (int) fr.getFrTotalSoldQty());
										rowData.add("" + fr.getFrTotalSoldTaxableAmt());

										rowData.add("" + (int) fr.getFrTotalVarQty());
										rowData.add("" + fr.getFrTotalVarTaxableAmt());

										rowData.add("" + (int) fr.getFrTotalRetQty());
										rowData.add("" + fr.getFrTotalRetTaxableAmt());

										rowData.add("" + (int) fr.getFrTotalNetQty());
										rowData.add("" + fr.getFrTotalNetTaxableAmt());

										rowData.add("" + fr.getFrTotalRetTaxableAmtPer() + "%");

									}

								}

							}
						}

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

					}
				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			for (int i = 0; i < reportList.size(); i++) {

				YearlyItemReport data = reportList.get(i);

				if (selectedType.equalsIgnoreCase("1")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("2")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("");

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("");

					rowData.add("");

				} else if (selectedType.equalsIgnoreCase("3")) {

					rowData.add("");
					rowData.add("" + data.getMonthTotalSoldAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalVarAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalRetAmt());

					rowData.add("");
					rowData.add("" + data.getMonthTotalNetAmt());

					rowData.add("" + data.getMonthTotalRetAmtPer() + "%");

				} else if (selectedType.equalsIgnoreCase("4")) {

					rowData.add("" + (int) data.getMonthTotalSoldQty());
					rowData.add("" + data.getMonthTotalSoldTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalVarQty());
					rowData.add("" + data.getMonthTotalVarTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalRetQty());
					rowData.add("" + data.getMonthTotalRetTaxableAmt());

					rowData.add("" + (int) data.getMonthTotalNetQty());
					rowData.add("" + data.getMonthTotalNetTaxableAmt());

					rowData.add("" + data.getMonthTotalRetTaxableAmtPer() + "%");

				}

			}

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "Item_Wise_Month_Wise_Purchase_Report");
			session.setAttribute("reportNameNew", "Item Month Wise Purchase Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$J$1");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// --AJAX-------ITEM--SELL REPORT-------------------------------

	@RequestMapping(value = "/getItemYearlySellReport", method = RequestMethod.GET)
	public @ResponseBody List<YearlyItemReport> getItemYearlySellReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<YearlyItemReport> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		String selectedType = "";
		try {
			System.out.println("Inside ITEM WISE SELL REPORT");
			frId = Integer.parseInt(request.getParameter("frId"));
			String selectedCatIdList = request.getParameter("cat_id_list");
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");

			System.err.println("SC ************************************************** " + selectedCatIdList);

			selectedCatIdList = selectedCatIdList.substring(1, selectedCatIdList.length() - 1);
			selectedCatIdList = selectedCatIdList.replaceAll("\"", "");

			List<Integer> cIds = Stream.of(selectedCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			System.err.println("SC LIST************************************************** " + cIds);

			if (cIds.contains(-1)) {
				// subCatIdList.clear();
				List<String> tempcIdList = new ArrayList();

				if (mCategoryList != null) {

					for (int i = 0; i < mCategoryList.size(); i++) {
						tempcIdList.add(String.valueOf(mCategoryList.get(i).getCatId()));
					}
				}
				System.err.println("CAT ID ARRAY --------- " + tempcIdList);
				selectedCatIdList = tempcIdList.toString().substring(1, tempcIdList.toString().length() - 1);
				selectedCatIdList = selectedCatIdList.replaceAll(" ", "");

			}

			System.out.println("selectedCATAfter 565656------------------" + selectedCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frId", frId);
			map.add("catIdList", selectedCatIdList);

			ParameterizedTypeReference<List<YearlyItemReport>> typeRef = new ParameterizedTypeReference<List<YearlyItemReport>>() {
			};
			ResponseEntity<List<YearlyItemReport>> responseEntity = restTemplate.exchange(
					Constant.URL + "getOpsItemwiseYearlySellReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get Yearly SEll Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			DecimalFormat df = new DecimalFormat("0.00");

			System.err.println("REPORT ------------------- " + reportList);

			if (reportList != null) {

				for (int i = 0; i < reportList.size(); i++) {

					float monthTotalSoldQty = 0;
					float monthTotalSoldAmt = 0;
					float monthTotalVarQty = 0;
					float monthTotalVarAmt = 0;
					float monthTotalRetQty = 0;
					float monthTotalRetAmt = 0;
					float monthTotalNetQty = 0;
					float monthTotalNetAmt = 0;
					float monthTotalRetAmtPer = 0;

					float monthTotalSoldTaxableAmt = 0;
					float monthTotalVarTaxableAmt = 0;
					float monthTotalRetTaxableAmt = 0;
					float monthTotalNetTaxableAmt = 0;
					float monthTotalRetTaxableAmtPer = 0;

					for (int j = 0; j < reportList.get(i).getDataList().size(); j++) {

						float frTotalSoldQty = 0;
						float frTotalSoldAmt = 0;
						float frTotalVarQty = 0;
						float frTotalVarAmt = 0;
						float frTotalRetQty = 0;
						float frTotalRetAmt = 0;
						float frTotalNetQty = 0;
						float frTotalNetAmt = 0;
						float frTotalRetAmtPer = 0;
						float frTotalSoldTaxableAmt = 0;
						float frTotalVarTaxableAmt = 0;
						float frTotalRetTaxableAmt = 0;
						float frTotalNetTaxableAmt = 0;
						float frTotalRetTaxableAmtPer = 0;

						TempSubCatList frData = reportList.get(i).getDataList().get(j);

						for (int k = 0; k < frData.getItemList().size(); k++) {

							TempItemList data = frData.getItemList().get(k);

							frTotalSoldQty = frTotalSoldQty + data.getSoldQty();
							frTotalSoldAmt = frTotalSoldAmt + data.getSoldAmt();
							frTotalVarQty = frTotalVarQty + data.getVarQty();
							frTotalVarAmt = frTotalVarAmt + data.getVarAmt();
							frTotalRetQty = frTotalRetQty + data.getRetQty();
							frTotalRetAmt = frTotalRetAmt + data.getRetAmt();
							frTotalNetQty = frTotalNetQty + (data.getSoldQty() - (data.getVarQty() + data.getRetQty()));
							frTotalNetAmt = frTotalNetAmt + (data.getSoldAmt() - (data.getVarAmt() + data.getRetAmt()));

							if (data.getSoldAmt() == 0) {
								frTotalRetAmtPer = frTotalRetAmtPer + 0;

							} else {
								frTotalRetAmtPer = frTotalRetAmtPer
										+ (((data.getVarAmt() + data.getRetAmt()) * 100) / data.getSoldAmt());
							}

							frTotalSoldTaxableAmt = frTotalSoldTaxableAmt + data.getTaxableAmt();
							frTotalVarTaxableAmt = frTotalVarTaxableAmt + data.getVarTaxableAmt();
							frTotalRetTaxableAmt = frTotalRetTaxableAmt + data.getRetTaxableAmt();
							frTotalNetTaxableAmt = frTotalNetTaxableAmt
									+ (data.getTaxableAmt() - (data.getVarTaxableAmt() + data.getRetTaxableAmt()));

							if (data.getTaxableAmt() == 0) {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer + 0;
							} else {
								frTotalRetTaxableAmtPer = frTotalRetTaxableAmtPer
										+ (((data.getVarTaxableAmt() + data.getRetTaxableAmt()) * 100)
												/ data.getTaxableAmt());
							}

						}

						frData.setFrTotalSoldQty(frTotalSoldQty);
						frData.setFrTotalSoldAmt(frTotalSoldAmt);

						frData.setFrTotalVarQty(frTotalVarQty);
						frData.setFrTotalVarAmt(frTotalVarAmt);

						frData.setFrTotalRetQty(frTotalRetQty);
						frData.setFrTotalRetAmt(frTotalRetAmt);

						frData.setFrTotalNetQty(frTotalNetQty);
						frData.setFrTotalNetAmt(frTotalNetAmt);

						frData.setFrTotalRetAmtPer(frTotalRetAmtPer);

						frData.setFrTotalSoldTaxableAmt(frTotalSoldTaxableAmt);

						frData.setFrTotalVarTaxableAmt(frTotalVarTaxableAmt);

						frData.setFrTotalRetTaxableAmt(frTotalRetTaxableAmt);

						frData.setFrTotalNetTaxableAmt(frTotalNetTaxableAmt);

						frData.setFrTotalRetTaxableAmtPer(frTotalRetTaxableAmtPer);

						// -----------MONTHLY SUM--------------------------
						monthTotalSoldQty = monthTotalSoldQty + frTotalSoldQty;
						monthTotalSoldAmt = monthTotalSoldAmt + frTotalSoldAmt;
						monthTotalVarQty = monthTotalVarQty + frTotalVarQty;
						monthTotalVarAmt = monthTotalVarAmt + frTotalVarAmt;
						monthTotalRetQty = monthTotalRetQty + frTotalRetQty;
						monthTotalRetAmt = monthTotalRetAmt + frTotalRetAmt;
						monthTotalNetQty = monthTotalNetQty + frTotalNetQty;
						monthTotalNetAmt = monthTotalNetAmt + frTotalNetAmt;
						monthTotalRetAmtPer = monthTotalRetAmtPer + frTotalRetAmtPer;

						monthTotalSoldTaxableAmt = monthTotalSoldTaxableAmt + frTotalSoldTaxableAmt;
						monthTotalVarTaxableAmt = monthTotalVarTaxableAmt + frTotalVarTaxableAmt;
						monthTotalRetTaxableAmt = monthTotalRetTaxableAmt + frTotalRetTaxableAmt;
						monthTotalNetTaxableAmt = monthTotalNetTaxableAmt + frTotalNetTaxableAmt;
						monthTotalRetTaxableAmtPer = monthTotalRetTaxableAmtPer + frTotalRetTaxableAmtPer;

					}

					reportList.get(i).setMonthTotalSoldQty(monthTotalSoldQty);
					reportList.get(i).setMonthTotalSoldAmt(monthTotalSoldAmt);

					reportList.get(i).setMonthTotalVarQty(monthTotalVarQty);
					reportList.get(i).setMonthTotalVarAmt(monthTotalVarAmt);

					reportList.get(i).setMonthTotalRetQty(monthTotalRetQty);
					reportList.get(i).setMonthTotalRetAmt(monthTotalRetAmt);

					reportList.get(i).setMonthTotalNetQty(monthTotalNetQty);
					reportList.get(i).setMonthTotalNetAmt(monthTotalNetAmt);

					reportList.get(i).setMonthTotalRetAmtPer(monthTotalRetAmtPer);

					reportList.get(i).setMonthTotalSoldTaxableAmt(monthTotalSoldTaxableAmt);

					reportList.get(i).setMonthTotalVarTaxableAmt(monthTotalVarTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmt(monthTotalRetTaxableAmt);

					reportList.get(i).setMonthTotalNetTaxableAmt(monthTotalNetTaxableAmt);

					reportList.get(i).setMonthTotalRetTaxableAmtPer(monthTotalRetTaxableAmtPer);

				}
			}

			System.err.println("-------------- REPORT---------------- " + reportList);

		} catch (Exception e) {

			System.out.println("Exc in display yearly report--  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add(" ");
			for (int i = 0; i < reportList.size(); i++) {
				String dispStr = reportList.get(i).getDateStr();
				rowData.add(dispStr.substring(0, dispStr.indexOf('-')));
				rowData.add("" + reportList.get(i).getYearId());

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add(" ");

			for (int i = 0; i < reportList.size(); i++) {

				rowData.add("Sold Qty");
				rowData.add("Sold Amt");

			}
			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					YearlyItemReport monthData = reportList.get(0);

					for (int f = 0; f < monthData.getDataList().size(); f++) {

						TempSubCatList frData = monthData.getDataList().get(f);

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("" + frData.getSubCatName());

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

						for (int s = 0; s < frData.getItemList().size(); s++) {

							TempItemList scData = frData.getItemList().get(s);

							expoExcel = new ExportToExcel();
							rowData = new ArrayList<String>();

							rowData.add("" + scData.getItemName());

							for (int m = 0; m < reportList.size(); m++) {

								for (int f1 = 0; f1 < reportList.get(m).getDataList().size(); f1++) {

									if (reportList.get(m).getDataList().get(f1).getSubCatId() == frData.getSubCatId()) {
										for (int sc1 = 0; sc1 < reportList.get(m).getDataList().get(f1).getItemList()
												.size(); sc1++) {
											if (reportList.get(m).getDataList().get(f1).getItemList().get(sc1)
													.getItemId() == scData.getItemId()) {

												TempItemList scData1 = reportList.get(m).getDataList().get(f1)
														.getItemList().get(sc1);

												// rowData.add("" + scData1.getSubCatName());

												rowData.add("" + scData1.getSoldQty());
												rowData.add("" + scData1.getSoldAmt());

												break;
											}
										}

										break;
									}
								}
							}
							expoExcel.setRowData(rowData);
							exportToExcelList.add(expoExcel);

						}

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("Total");

						for (int k = 0; k < reportList.size(); k++) {
							for (int n = 0; n < reportList.get(k).getDataList().size(); n++) {

								TempSubCatList fr = reportList.get(k).getDataList().get(n);

								if (frData.getSubCatId() == fr.getSubCatId()) {

									rowData.add("" + (int) fr.getFrTotalSoldQty());
									rowData.add("" + fr.getFrTotalSoldAmt());

								}

							}
						}

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

					}
				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			for (int i = 0; i < reportList.size(); i++) {

				YearlyItemReport data = reportList.get(i);

				rowData.add("" + (int) data.getMonthTotalSoldQty());
				rowData.add("" + data.getMonthTotalSoldAmt());

			}

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "Item_Wise_Month_Wise_Sell_Report");
			session.setAttribute("reportNameNew", "Item Month Wise Sell Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$J$1");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");
			session.setAttribute("mergeUpto2", "$A$2:$J$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// -------SUB CAT DATE WISE SELL REPORT-----------------

	@RequestMapping(value = "/showSubCatDateWiseSellReport", method = RequestMethod.GET)
	public ModelAndView showSubCatDateWiseSellReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/subCatDateWiseSell");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			RestTemplate restTemplate = new RestTemplate();

			model.addObject("todaysDate", todaysDate);

			CategoryListResponse categoryListResponse;

			categoryListResponse = restTemplate.getForObject(Constant.URL + "showAllCategory",
					CategoryListResponse.class);

			mCategoryList = categoryListResponse.getmCategoryList();

			model.addObject("mCategoryList", mCategoryList);

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			model.addObject("frId", frDetails.getFrId());

		} catch (Exception e) {

			System.out.println("Exc in showSubCatDateWiseSellReport--  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	// ------AJAX------

	@RequestMapping(value = "/getSubCatDateWiseDataAjax", method = RequestMethod.GET)
	public @ResponseBody List<SubCatDateWiseSellData> getSubCatDateWiseDataAjax(HttpServletRequest request,
			HttpServletResponse response) {

		List<SubCatDateWiseSellData> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		try {
			System.out.println("Inside ITEM WISE SELL REPORT");
			frId = Integer.parseInt(request.getParameter("frId"));
			String selectedCatIdList = request.getParameter("cat_id_list");
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");

			System.err.println("SC ************************************************** " + selectedCatIdList);

			selectedCatIdList = selectedCatIdList.substring(1, selectedCatIdList.length() - 1);
			selectedCatIdList = selectedCatIdList.replaceAll("\"", "");

			List<Integer> cIds = Stream.of(selectedCatIdList.split(",")).map(Integer::parseInt)
					.collect(Collectors.toList());

			System.err.println("SC LIST************************************************** " + cIds);

			if (cIds.contains(-1)) {
				// subCatIdList.clear();
				List<String> tempcIdList = new ArrayList();

				if (mCategoryList != null) {

					for (int i = 0; i < mCategoryList.size(); i++) {
						tempcIdList.add(String.valueOf(mCategoryList.get(i).getCatId()));
					}
				}
				System.err.println("CAT ID ARRAY --------- " + tempcIdList);
				selectedCatIdList = tempcIdList.toString().substring(1, tempcIdList.toString().length() - 1);
				selectedCatIdList = selectedCatIdList.replaceAll(" ", "");

			}

			System.out.println("selectedCATAfter 565656------------------" + selectedCatIdList);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frId", frId);
			map.add("catIdList", selectedCatIdList);

			ParameterizedTypeReference<List<SubCatDateWiseSellData>> typeRef = new ParameterizedTypeReference<List<SubCatDateWiseSellData>>() {
			};
			ResponseEntity<List<SubCatDateWiseSellData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSubCatDateWiseSellReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get SEll Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add("Sub Category");
			rowData.add("Qty");
			rowData.add("Taxable Amount");
			rowData.add("Tax Amount");
			rowData.add("Total Amount");

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					for (int i = 0; i < reportList.size(); i++) {

						SubCatDateWiseSellData data = reportList.get(i);

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("" + data.getSubCatName());
						rowData.add("" + data.getSoldQty());
						rowData.add("" + data.getTaxableAmt());
						rowData.add("" + data.getTotalTax());
						rowData.add("" + data.getSoldAmt());

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

					}

				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");

			float sumQty = 0, sumAmt = 0, sumTaxableAmt = 0, sumTaxAmt = 0;
			for (int i = 0; i < reportList.size(); i++) {

				SubCatDateWiseSellData data = reportList.get(i);

				sumQty = sumQty + data.getSoldQty();
				sumAmt = sumAmt + data.getSoldAmt();
				sumTaxableAmt = sumTaxableAmt + data.getTaxableAmt();
				sumTaxAmt = sumTaxAmt + data.getTotalTax();

			}

			rowData.add("" + sumQty);
			rowData.add("" + sumTaxableAmt);
			rowData.add("" + sumTaxAmt);
			rowData.add("" + sumAmt);

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "SubCat_Date_Wise_Sell_Report");
			session.setAttribute("reportNameNew", "Sub Category Date Wise Sell Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$C$1");
			session.setAttribute("mergeUpto2", "$A$2:$C$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// --------PDF-------------------

	@RequestMapping(value = "pdf/showSubCatDateWiseSellReportPdf/{fromDate}/{toDate}/{frId}/{selectedCat}", method = RequestMethod.GET)
	public ModelAndView showSubCatDateWiseSellReportPdf(@PathVariable String fromDate, @PathVariable String toDate,
			@PathVariable int frId, @PathVariable String selectedCat, HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("BILL LIST pdf");

		ModelAndView model = new ModelAndView("reports/sales/subCatDateWiseSellPdf");

		List<SubCatDateWiseSellData> getSellBillHeaderList = new ArrayList<SubCatDateWiseSellData>();
		try {
			System.out.println("BILL LIST try");

			System.err.println("CAT ID ARRAY -----1---- " + selectedCat);

			RestTemplate restTemplate = new RestTemplate();

			/*
			 * selectedCat = selectedCat.substring(1, selectedCat.length() - 1); selectedCat
			 * = selectedCat.replaceAll("\"", "");
			 * 
			 * System.err.println("CAT ID ARRAY ----2----- " + selectedCat);
			 */

			if (selectedCat.equalsIgnoreCase("-1")) {

				CategoryListResponse categoryListResponse;

				categoryListResponse = restTemplate.getForObject(Constant.URL + "showAllCategory",
						CategoryListResponse.class);

				mCategoryList = categoryListResponse.getmCategoryList();

				// subCatIdList.clear();
				List<String> tempcIdList = new ArrayList();

				if (mCategoryList != null) {

					for (int i = 0; i < mCategoryList.size(); i++) {
						tempcIdList.add(String.valueOf(mCategoryList.get(i).getCatId()));
					}
				}
				System.err.println("CAT ID ARRAY --------- " + tempcIdList);
				selectedCat = tempcIdList.toString().substring(1, tempcIdList.toString().length() - 1);
				selectedCat = selectedCat.replaceAll(" ", "");

			}

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			System.err.println("FROM DATE - " + frDt);
			System.err.println("TO DATE - " + toDt);
			System.err.println("FRID - " + frId);
			System.err.println("CAT - " + selectedCat);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			map.add("frId", frId);
			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("catIdList", selectedCat);

			ParameterizedTypeReference<List<SubCatDateWiseSellData>> typeRef = new ParameterizedTypeReference<List<SubCatDateWiseSellData>>() {
			};
			ResponseEntity<List<SubCatDateWiseSellData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSubCatDateWiseSellReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			getSellBillHeaderList = responseEntity.getBody();
			System.out.println("BILL LIST" + getSellBillHeaderList.toString());

			map = new LinkedMultiValueMap<String, Object>();

			map.add("frId", frId);
			Franchisee franchisee = restTemplate.getForObject(Constant.URL + "getFranchisee?frId={frId}",
					Franchisee.class, frId);
			model.addObject("frName", franchisee.getFrName());

			model.addObject("fromDate", fromDate);
			model.addObject("toDate", toDate);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}

		model.addObject("reportList", getSellBillHeaderList);
		return model;
	}

	// ------------HSN REPORT--------------------

	@RequestMapping(value = "/showHsnDateWiseSellReport", method = RequestMethod.GET)
	public ModelAndView showHsnDateWiseSellReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;

		model = new ModelAndView("reports/sales/hsnDateWiseSellReport");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			RestTemplate restTemplate = new RestTemplate();

			model.addObject("todaysDate", todaysDate);

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			model.addObject("frId", frDetails.getFrId());

		} catch (Exception e) {

			System.out.println("Exc in showHsnDateWiseSellReport--  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	// ------AJAX------

	@RequestMapping(value = "/getHsnDateWiseDataAjax", method = RequestMethod.GET)
	public @ResponseBody List<HsnDateWiseSellData> getHsnDateWiseDataAjax(HttpServletRequest request,
			HttpServletResponse response) {

		List<HsnDateWiseSellData> reportList = new ArrayList<>();

		String fromDate = "";
		String toDate = "";
		int frId;
		try {
			System.out.println("Inside ITEM WISE SELL REPORT");
			frId = Integer.parseInt(request.getParameter("frId"));
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			map.add("fromDate", frDt);
			map.add("toDate", toDt);
			map.add("frId", frId);

			ParameterizedTypeReference<List<HsnDateWiseSellData>> typeRef = new ParameterizedTypeReference<List<HsnDateWiseSellData>>() {
			};
			ResponseEntity<List<HsnDateWiseSellData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getHsnDateWiseSellReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			reportList = responseEntity.getBody();

			System.err.println("REPORT ------------------- " + reportList);

		} catch (Exception e) {
			System.out.println("get SEll Report  " + e.getMessage());
			e.printStackTrace();

		}

		try {

			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add("Invoice No");
			rowData.add("Invoice Date");
			rowData.add("Party Name");
			rowData.add("Gst No");
			rowData.add("HSN Code");
			rowData.add("Billed Qty");
			rowData.add("Taxable Amt");
			rowData.add("Cgst % ");
			rowData.add("Cgst Amt");
			rowData.add("Sgst %");
			rowData.add("Sgst Amt");
			rowData.add("Total");
			rowData.add("Bill Amt");

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			if (reportList != null) {
				if (reportList.size() > 0) {

					for (int i = 0; i < reportList.size(); i++) {

						HsnDateWiseSellData data = reportList.get(i);

						expoExcel = new ExportToExcel();
						rowData = new ArrayList<String>();

						rowData.add("" + data.getInvoiceNo());
						rowData.add("" + data.getBillDate());
						rowData.add("" + data.getUserName());
						rowData.add("" + data.getUserGstNo());
						rowData.add("" + data.getHsnCode());
						rowData.add("" + data.getQty());
						rowData.add("" + data.getTaxableAmt());
						rowData.add("" + data.getCgstPer());
						rowData.add("" + data.getCgstRs());
						rowData.add("" + data.getSgstPer());
						rowData.add("" + data.getSgstRs());
						rowData.add("" + data.getTotal());
						rowData.add("" + data.getBillTotal());

						expoExcel.setRowData(rowData);
						exportToExcelList.add(expoExcel);

					}

				}

			} // if

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("TOTAL");
			rowData.add(" ");
			rowData.add(" ");
			rowData.add(" ");
			rowData.add(" ");

			float sumQty = 0, sumTotal = 0, sumTaxableAmt = 0, sumBillAmt = 0, sumCgstRs = 0, sumSgstRs = 0,
					sumCgstPer = 0, sumSgstPer = 0;
			for (int i = 0; i < reportList.size(); i++) {

				HsnDateWiseSellData data = reportList.get(i);

				sumQty = sumQty + data.getQty();
				sumTotal = sumTotal + data.getTotal();
				sumTaxableAmt = sumTaxableAmt + data.getTaxableAmt();
				sumBillAmt = sumBillAmt + data.getBillTotal();
				sumCgstRs = sumCgstRs + data.getCgstRs();
				sumSgstRs = sumSgstRs + data.getSgstRs();

				sumCgstPer = sumCgstPer + data.getSgstPer();
				sumSgstPer = sumSgstPer + data.getSgstPer();

			}

			rowData.add("" + sumQty);
			rowData.add("" + sumTaxableAmt);
			rowData.add("" + sumCgstPer);
			rowData.add("" + sumCgstRs);

			rowData.add("" + sumSgstPer);
			rowData.add("" + sumSgstRs);

			rowData.add("" + sumTotal);
			rowData.add("" + sumBillAmt);

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			// rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "HSN_Date_Wise_Sell_Report");
			session.setAttribute("reportNameNew", "HSN Date Wise Sell Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$M$1");
			session.setAttribute("mergeUpto2", "$A$2:$M$2");

		} catch (Exception e) {
			System.err.println("--------------EXC - ");
			e.printStackTrace();
		}

		return reportList;
	}

	// --------PDF-------------------

	@RequestMapping(value = "pdf/showHsnDateWiseSellReportPdf/{fromDate}/{toDate}/{frId}", method = RequestMethod.GET)
	public ModelAndView showHsnDateWiseSellReportPdf(@PathVariable String fromDate, @PathVariable String toDate,
			@PathVariable int frId, HttpServletRequest request, HttpServletResponse response) {
		System.out.println("BILL LIST pdf");

		ModelAndView model = new ModelAndView("reports/sales/hsnDateWiseSellReportPdf");

		List<HsnDateWiseSellData> getSellBillHeaderList = new ArrayList<HsnDateWiseSellData>();
		try {
			System.out.println("BILL LIST try");

			RestTemplate restTemplate = new RestTemplate();

			String frDt = "", toDt = "";
			try {
				frDt = DateConvertor.convertToYMD(fromDate);
				toDt = DateConvertor.convertToYMD(toDate);
			} catch (Exception e) {
			}

			System.err.println("FROM DATE - " + frDt);
			System.err.println("TO DATE - " + toDt);
			System.err.println("FRID - " + frId);

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			map.add("frId", frId);
			map.add("fromDate", frDt);
			map.add("toDate", toDt);

			ParameterizedTypeReference<List<HsnDateWiseSellData>> typeRef = new ParameterizedTypeReference<List<HsnDateWiseSellData>>() {
			};
			ResponseEntity<List<HsnDateWiseSellData>> responseEntity = restTemplate.exchange(
					Constant.URL + "getHsnDateWiseSellReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			getSellBillHeaderList = responseEntity.getBody();
			System.out.println("BILL LIST" + getSellBillHeaderList.toString());

			map = new LinkedMultiValueMap<String, Object>();

			map.add("frId", frId);
			Franchisee franchisee = restTemplate.getForObject(Constant.URL + "getFranchisee?frId={frId}",
					Franchisee.class, frId);
			model.addObject("frName", franchisee.getFrName());

			model.addObject("fromDate", fromDate);
			model.addObject("toDate", toDate);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}

		model.addObject("reportList", getSellBillHeaderList);
		return model;
	}

}
