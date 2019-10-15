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

import com.monginis.ops.common.DateConvertor;
import com.monginis.ops.constant.Constant;
import com.monginis.ops.model.ExportToExcel;
import com.monginis.ops.model.Franchisee;
import com.monginis.ops.model.SalesReportFranchisee;

@Controller
@Scope("session")
public class SalesReportController2 {

	String todaysDate;  
	
	@RequestMapping(value = "/showFranchiseeWiseBillReport", method = RequestMethod.GET)
	public ModelAndView showFranchiseeWiseBillReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;
		HttpSession session = request.getSession();

		model = new ModelAndView("reports/frwiseSummeryReport");

		try {
			ZoneId z = ZoneId.of("Asia/Calcutta");

			LocalDate date = LocalDate.now(z);
			DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
			todaysDate = date.format(formatters);
			
			Franchisee frDetasessionils = (Franchisee) session.getAttribute("frDetails");
			model.addObject("frId", frDetasessionils.getFrId());
			
		} catch (Exception e) {

			System.out.println("Exc in show sales report bill wise  " + e.getMessage());
			e.printStackTrace();

		}
		return model;

	}

	List<String> frList = new ArrayList<>();

	@RequestMapping(value = "/getSaleFrwiseReport", method = RequestMethod.GET)
	public @ResponseBody List<SalesReportFranchisee> getSaleFrwiseReport(HttpServletRequest request,
			HttpServletResponse response) {

		List<SalesReportFranchisee> saleList = new ArrayList<>();
		String fromDate = "";
		String toDate = "";
		try {

			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");

			System.out.println("************************" + frDetails.getFrId());

			fromDate = request.getParameter("fromDate");
			toDate = request.getParameter("toDate");

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			System.out.println("Inside If all fr Selected "); 
			
			map.add("fromDate", fromDate);
			map.add("toDate", toDate);
			map.add("frIdList", frDetails.getFrId());

			ParameterizedTypeReference<List<SalesReportFranchisee>> typeRef = new ParameterizedTypeReference<List<SalesReportFranchisee>>() {
			};
			ResponseEntity<List<SalesReportFranchisee>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSaleReportFrwiseSummery", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			saleList = responseEntity.getBody();

			System.out.println("saleList*********************************************" + saleList.toString());

		} catch (

		Exception e) {
			System.out.println("get sale Report Bill Wise " + e.getMessage());
			e.printStackTrace();

		}

		// exportToExcel
		List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

		ExportToExcel expoExcel = new ExportToExcel();
		List<String> rowData = new ArrayList<String>();

		rowData.add("Sr");
		rowData.add("Date");
		rowData.add("Type");
		rowData.add("Document");
		rowData.add("Order Ref");
		rowData.add("Dr Amt");
		rowData.add("Cr Amt");
		rowData.add("Balance");

		expoExcel.setRowData(rowData);
		int srno = 1;
		exportToExcelList.add(expoExcel);
		float drTotalAmt = 0.0f;
		float crTotalAmt = 0.0f;
		float bal = 0.0f;
		
		for (int i = 0; i < saleList.size(); i++) {

			expoExcel = new ExportToExcel();
			rowData = new ArrayList<String>();

			rowData.add("" + srno);
			rowData.add(saleList.get(i).getBillDate());
			rowData.add(saleList.get(i).getType());
			rowData.add(saleList.get(i).getInvoiceNo());
			rowData.add(saleList.get(i).getOrderRef());

			if (saleList.get(i).getType().equals("INV")) {

				bal = bal + saleList.get(i).getGrandTotal();
				
				drTotalAmt = drTotalAmt + saleList.get(i).getGrandTotal();
				rowData.add("" +saleList.get(i).getGrandTotal());
				rowData.add("0");
				
			}else if (saleList.get(i).getType().equals("RET")) {
				
				bal = bal - saleList.get(i).getGrandTotal();
				crTotalAmt = crTotalAmt + saleList.get(i).getGrandTotal();
				rowData.add("0");
				rowData.add("" +saleList.get(i).getGrandTotal());
				
			}else if (saleList.get(i).getType().equals("VER")) {
				
				bal = bal - saleList.get(i).getGrandTotal();
				crTotalAmt = crTotalAmt + saleList.get(i).getGrandTotal();
				rowData.add("0");
				rowData.add("" +saleList.get(i).getGrandTotal());
				
			} else {
				rowData.add("0");
				rowData.add("0");
			}

			rowData.add("" +bal);
			srno = srno + 1;

			expoExcel.setRowData(rowData);
			exportToExcelList.add(expoExcel);

		}
		expoExcel = new ExportToExcel();
		rowData = new ArrayList<String>();

		rowData.add("");
		rowData.add("");
		rowData.add("");
		rowData.add("");
		rowData.add("Total");

		rowData.add("" + roundUp(drTotalAmt));
		rowData.add("" + roundUp(crTotalAmt));
		rowData.add("" + roundUp(drTotalAmt - crTotalAmt));

		expoExcel.setRowData(rowData);
		exportToExcelList.add(expoExcel);

		HttpSession session = request.getSession();
		session.setAttribute("exportExcelListNew", exportToExcelList);
		session.setAttribute("excelNameNew", "SaleBillWiseDate");
		session.setAttribute("reportNameNew", "Bill-wise Report");
		session.setAttribute("searchByNew", "From Date: " + fromDate + "  To Date: " + toDate + " ");
		session.setAttribute("mergeUpto1", "$A$1:$G$1");
		session.setAttribute("mergeUpto2", "$A$2:$G$2");

		return saleList;
	}

	public static float roundUp(float d) {
		return BigDecimal.valueOf(d).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue();
	}

	@RequestMapping(value = "pdf/showSummeryFrByFrPdf/{fromDate}/{toDate}/{frId}", method = RequestMethod.GET)
	public ModelAndView showSummeryFrByFrPdf(@PathVariable String fromDate, @PathVariable String toDate,
			@PathVariable int frId, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView model = new ModelAndView("reports/frwiseSummeryPdf");

		List<SalesReportFranchisee> saleList = new ArrayList<>();

		try {
			HttpSession ses = request.getSession();
			Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();
			map.add("fromDate", fromDate );
			map.add("toDate", toDate);
			map.add("frIdList", frId);

			System.out.println(map);
			
			ParameterizedTypeReference<List<SalesReportFranchisee>> typeRef = new ParameterizedTypeReference<List<SalesReportFranchisee>>() {
			};
			ResponseEntity<List<SalesReportFranchisee>> responseEntity = restTemplate.exchange(
					Constant.URL + "getSaleReportFrwiseSummery", HttpMethod.POST, new HttpEntity<>(map), typeRef);
			saleList = responseEntity.getBody();
			model.addObject("salesRepFrList", saleList);
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
