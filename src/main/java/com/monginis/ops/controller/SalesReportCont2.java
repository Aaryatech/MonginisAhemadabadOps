package com.monginis.ops.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.TreeSet;

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

import com.monginis.ops.constant.Constant;
import com.monginis.ops.model.ExportToExcel;
import com.monginis.ops.model.Franchisee;
import com.monginis.ops.model.SalesReportFranchisee;
import com.monginis.ops.model.reportv2.SubCatReport;

@Controller
@Scope("session")
public class SalesReportCont2 {

	String todaysDate;

	public static float roundUp(float d) {
		return BigDecimal.valueOf(d).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue();
	}

	@RequestMapping(value = "/showSaleReportBySubCategory", method = RequestMethod.GET)
	public ModelAndView showSaleReportBySubCategory(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;
		HttpSession session = request.getSession();

		model = new ModelAndView("reports/saleRepBySubCatOnly");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");
			Franchisee frDetails = (Franchisee) session.getAttribute("frDetails");
			
			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);

			model.addObject("todaysDate", todaysDate);
			model.addObject("frId", frDetails.getFrId());

		} catch (Exception e) {

			System.out.println("Exc in show sales report bill wise  " + e.getMessage());
			e.printStackTrace();
		}

		return model;

	}

	@RequestMapping(value = "/getSubCatReport", method = RequestMethod.GET)
	public @ResponseBody List<SubCatReport> getSubCatReport(HttpServletRequest request, HttpServletResponse response) {

		List<SubCatReport> saleList = new ArrayList<>();
		String fromDate = "";
		String toDate = "";
		try {

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");
			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();

			RestTemplate restTemplate = new RestTemplate();

			map.add("fromDate", fromDate);
			map.add("toDate", toDate);
			map.add("frId", frDetails.getFrId());

			ParameterizedTypeReference<List<SubCatReport>> typeRef = new ParameterizedTypeReference<List<SubCatReport>>() {
			};
			ResponseEntity<List<SubCatReport>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSubCatReportApiByFrId", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			saleList = responseEntity.getBody();

			for (int i = 0; i < saleList.size(); i++) {

				float netQty = saleList.get(i).getSoldQty()
						- (saleList.get(i).getVarQty() + saleList.get(i).getRetQty());
				float netAmt = saleList.get(i).getSoldAmt()
						- (saleList.get(i).getVarAmt() + saleList.get(i).getRetAmt());
				float retAmtPer = (((saleList.get(i).getVarAmt() + saleList.get(i).getRetAmt()) * 100)
						/ saleList.get(i).getSoldAmt());

				saleList.get(i).setNetQty(netQty);
				saleList.get(i).setNetAmt(netAmt);
				saleList.get(i).setRetAmtPer(retAmtPer);
			}

			System.out.println(saleList.toString());

			// exportToExcel
			List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

			ExportToExcel expoExcel = new ExportToExcel();
			List<String> rowData = new ArrayList<String>();

			rowData.add("Sr");
			rowData.add("Sub Category Name");
			rowData.add("Sold Qty");
			rowData.add("Sold Amt");

			rowData.add("Var Qty");
			rowData.add("Var Amt");

			rowData.add("Ret Qty");
			rowData.add("Ret Amt");

			rowData.add("Net Qty");
			rowData.add("Net Amt");

			rowData.add("Ret Per Amt");

			expoExcel.setRowData(rowData);
			int srno = 1;
			exportToExcelList.add(expoExcel);

			float totalSoldQty = 0;
			float totalSoldAmt = 0;
			float totalVarQty = 0;
			float totalVarAmt = 0;
			float totalRetQty = 0;
			float totalRetAmt = 0;
			float totalNetQty = 0;
			float totalNetAmt = 0;
			float retAmtPer = 0;

			for (int i = 0; i < saleList.size(); i++) {

				totalSoldQty = totalSoldQty + saleList.get(i).getSoldQty();
				totalSoldAmt = totalSoldAmt + saleList.get(i).getSoldAmt();
				totalVarQty = totalVarQty + saleList.get(i).getVarQty();
				totalVarAmt = totalVarAmt + saleList.get(i).getVarAmt();
				totalRetQty = totalRetQty + saleList.get(i).getRetQty();
				totalRetAmt = totalRetAmt + saleList.get(i).getRetAmt();
				totalNetQty = totalNetQty + saleList.get(i).getNetQty();
				totalNetAmt = totalNetAmt + saleList.get(i).getNetAmt();
				retAmtPer = retAmtPer + saleList.get(i).getRetAmtPer();

				expoExcel = new ExportToExcel();
				rowData = new ArrayList<String>();

				rowData.add("" + srno);
				rowData.add(saleList.get(i).getSubCatName());

				rowData.add("" + roundUp(saleList.get(i).getSoldQty()));
				rowData.add("" + roundUp(saleList.get(i).getSoldAmt()));
				rowData.add("" + roundUp(saleList.get(i).getVarQty()));
				rowData.add("" + roundUp(saleList.get(i).getVarAmt()));
				rowData.add("" + roundUp(saleList.get(i).getRetQty()));

				rowData.add("" + roundUp(saleList.get(i).getRetAmt()));
				rowData.add("" + roundUp(saleList.get(i).getNetQty()));
				rowData.add("" + roundUp(saleList.get(i).getNetAmt()));
				rowData.add("" + roundUp(saleList.get(i).getRetAmtPer()));

				srno = srno + 1;

				expoExcel.setRowData(rowData);
				exportToExcelList.add(expoExcel);

			}
			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();
			rowData.add(" ");
			rowData.add("Total");

			rowData.add("" + roundUp(totalSoldQty));
			rowData.add("" + roundUp(totalSoldAmt));
			rowData.add("" + roundUp(totalVarQty));
			rowData.add("" + roundUp(totalVarAmt));
			rowData.add("" + roundUp(totalRetQty));
			rowData.add("" + roundUp(totalRetAmt));

			rowData.add("" + roundUp(totalNetQty));
			rowData.add("" + roundUp(totalNetAmt));
			rowData.add("" + roundUp(retAmtPer));

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

			HttpSession session = request.getSession();
			session.setAttribute("exportExcelListNew", exportToExcelList);
			session.setAttribute("excelNameNew", "SaleBillWiseDate");
			session.setAttribute("reportNameNew", "Bill-wise Report");
			session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
			session.setAttribute("mergeUpto1", "$A$1:$K$1");
			session.setAttribute("mergeUpto2", "$A$2:$K$2");
		} catch (Exception e) {
			// TODO: handle exception
		}

		return saleList;
	}

	@RequestMapping(value = "pdf/showSaleReportBySubCatPdf/{fromDate}/{toDate}/{frId}", method = RequestMethod.GET)
	public ModelAndView showSaleReportBySubCatPdf(@PathVariable String fromDate, @PathVariable String toDate,@PathVariable int frId,
			HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView("reports/saleRepBySubCatOnlyPdf");

		List<SubCatReport> subCatReportList = new ArrayList<>();

		try {

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			map.add("fromDate", fromDate);
			map.add("toDate", toDate);
			map.add("frId", frId);

			ParameterizedTypeReference<List<SubCatReport>> typeRef = new ParameterizedTypeReference<List<SubCatReport>>() {
			};
			ResponseEntity<List<SubCatReport>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSubCatReportApiByFrId", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			subCatReportList = responseEntity.getBody();

			for (int i = 0; i < subCatReportList.size(); i++) {

				float netQty = subCatReportList.get(i).getSoldQty()
						- (subCatReportList.get(i).getVarQty() + subCatReportList.get(i).getRetQty());
				float netAmt = subCatReportList.get(i).getSoldAmt()
						- (subCatReportList.get(i).getVarAmt() + subCatReportList.get(i).getRetAmt());
				float retAmtPer = (((subCatReportList.get(i).getVarAmt() + subCatReportList.get(i).getRetAmt()) * 100)
						/ subCatReportList.get(i).getSoldAmt());

				subCatReportList.get(i).setNetQty(netQty);
				subCatReportList.get(i).setNetAmt(netAmt);
				subCatReportList.get(i).setRetAmtPer(retAmtPer);
			}

			model.addObject("subCatReportList", subCatReportList);
			model.addObject("FACTORYNAME", Constant.FACTORYNAME);
			model.addObject("FACTORYADDRESS", Constant.FACTORYADDRESS);
			model.addObject("fromDate", fromDate);
			model.addObject("toDate", toDate);

		} catch (

		Exception e) {
			System.out.println("get sale Report Bill Wise " + e.getMessage());
			e.printStackTrace();

		}

		return model;
	}

}
