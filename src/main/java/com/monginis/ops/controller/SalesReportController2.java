package com.monginis.ops.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLConnection;
import java.text.DateFormat;
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
import org.springframework.util.FileCopyUtils;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;


import com.monginis.ops.model.CreditNoteReport;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.monginis.ops.common.DateConvertor;
import com.monginis.ops.constant.Constant;
import com.monginis.ops.model.ExportToExcel;
import com.monginis.ops.model.Franchisee;
import com.monginis.ops.model.SalesReportFranchisee;
import com.monginis.ops.model.SalesReportDateMonth;

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
	
	
	//Akhilesh 2021-01-04 
	@RequestMapping(value = "/FranchiseeSellDatewiseReport", method = RequestMethod.GET)
	public ModelAndView FranchiseeSellDatewiseReport(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView model = null;
		HttpSession session = request.getSession();

		model = new ModelAndView("report/billwisesalesgrpbydate");

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
	
	
	//Akhilesh 2021-01-05
		@RequestMapping(value = "/ProdewiseCreditNoteReport", method = RequestMethod.GET)
		public ModelAndView ProdewiseCreditNoteReport(HttpServletRequest request, HttpServletResponse response) {

			ModelAndView model = null;
			HttpSession session = request.getSession();

			model = new ModelAndView("report/prodWiseCreditNote");

			try {  
				ZoneId z = ZoneId.of("Asia/Calcutta");

				LocalDate date = LocalDate.now(z);
				DateTimeFormatter formatters = DateTimeFormatter.ofPattern("d-MM-uuuu");
				todaysDate = date.format(formatters);
				
				Franchisee frDetasessionils = (Franchisee) session.getAttribute("frDetails");
				model.addObject("frId", frDetasessionils.getFrId());
				model.addObject("todaysDate", todaysDate);
				
			} catch (Exception e) {

				System.out.println("Exc in show sales report bill wise  " + e.getMessage());
				e.printStackTrace();

			}
			return model;

		}
		
		//Akhilesh 2020-01-05
		@RequestMapping(value = "/creditNoteReportBetweenDatePdf", method = RequestMethod.GET)
		public void creditNoteReportBetweenDatePdf(HttpServletRequest request, HttpServletResponse response)
				throws FileNotFoundException {
			BufferedOutputStream outStream = null;
			System.out.println("Inside Pdf showPOReportPdf");
			Document document = new Document(PageSize.A4);
			document.setMargins(5, 5, 5, 5);
			DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
			Calendar cal = Calendar.getInstance();
			Date date1=new Date();
			Date date2 =new Date();
			

			String FILE_PATH = Constant.REPORT_SAVE;
			File file = new File(FILE_PATH);

			PdfWriter writer = null;

			FileOutputStream out = new FileOutputStream(FILE_PATH);
			try {
				writer = PdfWriter.getInstance(document, out);
			} catch (DocumentException e) {

				e.printStackTrace();
			}
			document.open();
			PdfPTable table = new PdfPTable(10);
			try {

				String fromDate = request.getParameter("fromDate");
				String toDate = request.getParameter("toDate");
				   System.err.println("From Date"+DateConvertor.convertToYMD(fromDate)+"\n"+DateConvertor.convertToYMD(toDate));
				RestTemplate restTemplate = new RestTemplate();
			      
			
				System.err.println("Dates -->"+"\n");

				System.out.println("time in Gen Bill PDF ==" + dateFormat.format(cal.getTime()));
				int frId = Integer.parseInt(request.getParameter("selectedFr"));

				MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
				map.add("frId", frId);
				map.add("fromDate", DateConvertor.convertToYMD(fromDate));   
				map.add("toDate",DateConvertor.convertToYMD(toDate));
				System.out.println(map);
				CreditNoteReport[] creditNoteReport = restTemplate
						.postForObject(Constant.URL + "creditNoteReportBetweenDate", map, CreditNoteReport[].class);

				List<CreditNoteReport> list = new ArrayList<>(Arrays.asList(creditNoteReport));

				System.out.println("Inside PDF Table try"+list.toString());
				table.setWidthPercentage(100);
				table.setWidths(new float[] { 1.0f, 3.0f, 2.0f, 7.5f, 1.0f, 1.2f, 1.5f, 1.5f, 1.5f, 2.2f });
				Font headFont = new Font(FontFamily.TIMES_ROMAN, 8, Font.NORMAL, BaseColor.BLACK);
				Font headFont1 = new Font(FontFamily.HELVETICA, 9, Font.BOLD, BaseColor.BLACK);
				headFont1.setColor(BaseColor.WHITE);

				Font totalFont = new Font(FontFamily.TIMES_ROMAN, 9, Font.BOLD, BaseColor.BLACK);

				Font f = new Font(FontFamily.TIMES_ROMAN, 9.0f, Font.UNDERLINE, BaseColor.BLUE);

				/*Paragraph name = new Paragraph("Siddarth Foods\n", f);
				name.setAlignment(Element.ALIGN_CENTER);
				document.add(name);*/

				Paragraph company = new Paragraph("Itemwise Grn/Gvn Report Date : " + fromDate + " To " + toDate , f);
				company.setAlignment(Element.ALIGN_CENTER); 
				document.add(company);
				
				/*Paragraph date = new Paragraph("Date : " + fromDate + " To " + toDate + "\n", f);
				date.setAlignment(Element.ALIGN_CENTER);
				document.add(date);*/
				
				 
				if (list.size() > 0) {

					String frnchiname = list.get(0).getFrName();

					Paragraph frName = new Paragraph(frnchiname + "\n", f);
					frName.setAlignment(Element.ALIGN_RIGHT);
					document.add(frName);
					document.add(new Paragraph(" "));

					PdfPCell hcell = new PdfPCell();

					hcell = new PdfPCell(new Phrase("-", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					//hcell.setPadding(5);
					hcell.setBorder(0);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Doc No", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					//hcell.setPadding(5);
					hcell.setBorder(0);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Date", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					//hcell.setPadding(5);
					hcell.setBorder(0);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Item Description", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					//hcell.setPadding(5);
					hcell.setBorder(0);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("UOM", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("QTY", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Rate", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Penalty AMT", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Credit AMT", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					hcell = new PdfPCell(new Phrase("Ref Inv No", headFont1));
					hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
					hcell.setBackgroundColor(BaseColor.PINK);
					hcell.setBorder(0);//hcell.setPadding(5);
					table.addCell(hcell);

					int index = 0;

					float totalPanalty = 0;
					float totalCredit = 0;
					float finaltotalPanalty = 0;
					float finaltotalCredit = 0;

					DecimalFormat df = new DecimalFormat("#.00");

					for (int i = 0; i < list.size(); i++) {

						CreditNoteReport row = list.get(i);

						index++;
						PdfPCell cell;

						cell = new PdfPCell(new Phrase(String.valueOf(index), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_CENTER); 
						cell.setPaddingRight(2);
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getCrnNo(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getCrnDate(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getItemName(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_LEFT);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase(" "+row.getItemUom(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setPaddingRight(2);
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getGrnGvnQty(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getBaseRate(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						cell = new PdfPCell(new Phrase("" + row.getPeneltyAmt(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);
						totalPanalty = totalPanalty + row.getPeneltyAmt();

						cell = new PdfPCell(new Phrase("" + row.getGrnGvnAmt(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);
						totalCredit = totalCredit + row.getGrnGvnAmt();

						cell = new PdfPCell(new Phrase("" + row.getRefInvoiceNo(), headFont));
						cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
						cell.setHorizontalAlignment(Element.ALIGN_CENTER);
						cell.setPaddingRight(2); 
						cell.setBorder(0);
						table.addCell(cell);

						int istotal = 0;
						try {

							if (list.get(i + 1).getCrnId() != row.getCrnId()) {
								istotal = 1;
							}

						} catch (Exception e) {
							istotal = 1;
						}

						if (istotal == 1) {

							cell = new PdfPCell(new Phrase("Total ", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_LEFT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							cell.setColspan(7);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(totalPanalty), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(totalCredit), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("-", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							finaltotalPanalty = finaltotalPanalty + totalPanalty;
							finaltotalCredit = finaltotalCredit + totalCredit;

							totalPanalty = 0;
							totalCredit = 0;

						}

						int isnextpage = 0;
						try {

							if (list.get(i + 1).getFrId() != row.getFrId()) {
								isnextpage = 1;
								frnchiname = list.get(i + 1).getFrName();
							}

						} catch (Exception e) {
							// isnextpage=1;

							cell = new PdfPCell(new Phrase("Final Total ", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_LEFT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							cell.setColspan(7);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(finaltotalPanalty), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(finaltotalCredit), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("-", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);
							document.add(table);
							finaltotalPanalty = 0;
							finaltotalCredit = 0;

						}

						if (isnextpage == 1) {

							cell = new PdfPCell(new Phrase("Final Total ", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_LEFT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							cell.setColspan(7);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(finaltotalPanalty), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("" + df.format(finaltotalCredit), totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);

							cell = new PdfPCell(new Phrase("-", totalFont));
							cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
							cell.setHorizontalAlignment(Element.ALIGN_CENTER);
							/*cell.setPaddingRight(2);
							cell.setPadding(3);*/
							cell.setBorder(0);
							table.addCell(cell);
							document.add(table);
							finaltotalPanalty = 0;
							finaltotalCredit = 0;

							// System.out.println("next paage");
							document.newPage();
							table = new PdfPTable(10);
							table.setWidthPercentage(100);
							table.setWidths(new float[] { 1.0f, 3.0f, 2.0f, 7.5f, 1.0f, 1.2f, 1.5f, 1.5f, 1.5f, 2.2f });
							index=0;
							hcell = new PdfPCell();

							hcell = new PdfPCell(new Phrase("-", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Doc No", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							hcell.setBorder(0);
							//hcell.setPadding(5);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Date", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Item Description", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("UOM", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("QTY", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							hcell.setBorder(0);//hcell.setPadding(5);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Rate", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Penalty AMT", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							hcell.setBorder(0);//hcell.setPadding(5);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Credit AMT", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							hcell = new PdfPCell(new Phrase("Ref Inv No", headFont1));
							hcell.setHorizontalAlignment(Element.ALIGN_CENTER);
							hcell.setBackgroundColor(BaseColor.PINK);
							//hcell.setPadding(5);
							hcell.setBorder(0);
							table.addCell(hcell);

							//document.add(name);
							document.add(company);
							//document.add(date);
							frName = new Paragraph(frnchiname + "\n", f);
							frName.setAlignment(Element.ALIGN_RIGHT);
							document.add(frName);
							document.add(new Paragraph(" "));

						}

					}

					/*
					 * Paragraph name = new Paragraph("Siddarth Foods\n", f);
					 * name.setAlignment(Element.ALIGN_CENTER); document.add(name); document.add(new
					 * Paragraph(" ")); Paragraph company = new
					 * Paragraph("Itemwise Grn/Gvn Report\n", f);
					 * company.setAlignment(Element.ALIGN_CENTER); document.add(company);
					 * document.add(new Paragraph(" "));
					 */

					DateFormat DF = new SimpleDateFormat("dd-MM-yyyy");
					String reportDate = DF.format(new Date());

				}
				int totalPages = writer.getPageNumber();

				System.out.println("Page no " + totalPages);

				document.close();

				if (file != null) {

					String mimeType = URLConnection.guessContentTypeFromName(file.getName());

					if (mimeType == null) {

						mimeType = "application/pdf";

					}

					response.setContentType(mimeType);

					response.addHeader("content-disposition", String.format("inline; filename=\"%s\"", file.getName()));

					response.setContentLength((int) file.length());

					BufferedInputStream inputStream = new BufferedInputStream(new FileInputStream(file));

					try {
						FileCopyUtils.copy(inputStream, response.getOutputStream());
					} catch (IOException e) {
						System.out.println("Excep in Opening a Pdf File");
						e.printStackTrace();
					}
				}

			} catch (DocumentException ex) {

				System.out.println("Pdf Generation Error: " + ex.getMessage());

				ex.printStackTrace();

			}

		}

	
	
	//Akhilesh 2021-01-04 
	@RequestMapping(value="/getDatewiseSales",method=RequestMethod.GET)
	public @ResponseBody List<SalesReportDateMonth> getDatewiseSales(HttpServletRequest request,HttpServletResponse response) {
		System.err.println("In getDatewiseSales");
		System.err.println(request.getParameter("frId"));
		List<SalesReportDateMonth> saleList = new ArrayList<>();
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		RestTemplate restTemplate = new RestTemplate();
		List<String> frIdList=new ArrayList<>();
		String fromDt="";
		String toDt="";
		try {
			
			 fromDt=request.getParameter("fromDate");
			 toDt=request.getParameter("toDate");
			frIdList.add(request.getParameter("frId"));
			map.add("frIdList", request.getParameter("frId"));
			map.add("fromDate", fromDt);
			map.add("toDate", toDt);
			
			System.out.println(map);
			
			ParameterizedTypeReference<List<SalesReportDateMonth>> typeRef = new ParameterizedTypeReference<List<SalesReportDateMonth>>() {
			};
			ResponseEntity<List<SalesReportDateMonth>> responseEntity =  restTemplate
					.exchange(Constant.URL + "getDatewiseReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);
			
			
			saleList = responseEntity.getBody();
			
			for (int i = 0; i < saleList.size(); i++) {

				float netGrandTotal = (saleList.get(i).getGrandTotal()
						- (saleList.get(i).getGrnGrandTotal() + saleList.get(i).getGvnGrandTotal()));
				float netTaxableAmt = (saleList.get(i).getTaxableAmt()
						- (saleList.get(i).getGrnTaxableAmt() + saleList.get(i).getGvnTaxableAmt()));

				float netTotalTax = (saleList.get(i).getTotalTax()
						- (saleList.get(i).getGrnTotalTax() + saleList.get(i).getGvnTotalTax()));
				saleList.get(i).setNetGrandTotal(netGrandTotal);
				saleList.get(i).setNetTaxableAmt(netTaxableAmt);
				saleList.get(i).setNetTotalTax(netTotalTax);
			}
			
			
			
			System.err.println("saleList Size-->"+saleList.size());
			System.err.println("saleList-->"+saleList.toString());
			System.err.println("saleList-->"+saleList.size());
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println("Exception Occuered In /getDatewiseSales");
			e.printStackTrace();
		}
		
		
		// exportToExcel

				List<ExportToExcel> exportToExcelList = new ArrayList<ExportToExcel>();

				ExportToExcel expoExcel = new ExportToExcel();
				List<String> rowData = new ArrayList<String>();

				rowData.add("SR NO");

				rowData.add("Bill Date");
				rowData.add("Taxable Amount");
				rowData.add("Tax Amount");
				rowData.add("Grand Total");

				rowData.add("GRN Taxable Amount");
				rowData.add("GRN Tax Amount");
				rowData.add("GRN Grand Total");

				rowData.add("GVN Taxable Amount");
				rowData.add("GVN Tax Amount");
				rowData.add("GVN Grand Total");

				rowData.add("Net Taxable Amount");
				rowData.add("Net Tax Amount");
				rowData.add("Net Grand Total");

				float totalGrandTotal = 0f;
				float totalTax = 0f;
				float totalTaxableAmt = 0f;

				float totalGrnGrandTotal = 0f;
				float totalGrnTaxableAmt = 0f;
				float totalGrnTax = 0f;

				float totalGvnGrandTotal = 0f;
				float totalGvnTax = 0f;
				float totalGvnTaxableAmt = 0f;

				float totalNetGrandTotal = 0f;
				float totalNetTax = 0f;
				float totalNetTaxableAmt = 0f;

				int srno = 1;
				expoExcel.setRowData(rowData);
				exportToExcelList.add(expoExcel);
				for (int i = 0; i < saleList.size(); i++) {

					totalGrnGrandTotal = totalGrnGrandTotal + saleList.get(i).getGrnGrandTotal();
					totalGrnTaxableAmt = totalGrnTaxableAmt + saleList.get(i).getGrnTaxableAmt();
					totalGrnTax = totalGrnTax + saleList.get(i).getGrnTotalTax();

					totalGrandTotal = totalGrandTotal + saleList.get(i).getGrandTotal();
					totalTax = totalTax + saleList.get(i).getTotalTax();
					totalTaxableAmt = totalTaxableAmt + saleList.get(i).getTaxableAmt();

					totalGvnGrandTotal = totalGvnGrandTotal + saleList.get(i).getGvnGrandTotal();
					totalGvnTax = totalGvnTax + saleList.get(i).getGvnTotalTax();
					totalGvnTaxableAmt = totalGvnTaxableAmt + saleList.get(i).getGvnTaxableAmt();

					totalNetGrandTotal = totalNetGrandTotal + saleList.get(i).getNetGrandTotal();
					totalNetTax = totalNetTax + saleList.get(i).getNetTotalTax();
					totalNetTaxableAmt = totalNetTaxableAmt + saleList.get(i).getNetTaxableAmt();

					expoExcel = new ExportToExcel();
					rowData = new ArrayList<String>();

					rowData.add("" + srno);

					rowData.add(saleList.get(i).getBillDate());
					rowData.add("" + saleList.get(i).getTaxableAmt());
					rowData.add("" + saleList.get(i).getTotalTax());
					rowData.add("" + saleList.get(i).getGrandTotal());

					rowData.add("" + saleList.get(i).getGrnTaxableAmt());
					rowData.add("" + saleList.get(i).getGrnTotalTax());
					rowData.add("" + saleList.get(i).getGrnGrandTotal());

					rowData.add("" + saleList.get(i).getGvnTaxableAmt());
					rowData.add("" + saleList.get(i).getGvnTotalTax());
					rowData.add("" + saleList.get(i).getGvnGrandTotal());

					rowData.add("" + saleList.get(i).getNetTaxableAmt());
					rowData.add("" + saleList.get(i).getNetTotalTax());
					rowData.add("" + saleList.get(i).getNetGrandTotal());

					srno = srno + 1;
					expoExcel.setRowData(rowData);
					exportToExcelList.add(expoExcel);

				}

				expoExcel = new ExportToExcel();
				rowData = new ArrayList<String>();

				rowData.add("Total");

				rowData.add("");

				rowData.add("" + roundUp(totalTax));
				rowData.add("" + roundUp(totalTaxableAmt));
				rowData.add("" + roundUp(totalGrandTotal));

				rowData.add("" + roundUp(totalGrnTaxableAmt));
				rowData.add("" + roundUp(totalGrnTax));
				rowData.add("" + roundUp(totalGrnGrandTotal));

				rowData.add("" + roundUp(totalGvnTaxableAmt));
				rowData.add("" + roundUp(totalGvnTax));
				rowData.add("" + roundUp(totalGvnGrandTotal));

				rowData.add("" + roundUp(totalNetTaxableAmt));
				rowData.add("" + roundUp(totalNetTax));
				rowData.add("" + roundUp(totalNetGrandTotal));

				expoExcel.setRowData(rowData);
				exportToExcelList.add(expoExcel);

				HttpSession session = request.getSession();
				session.setAttribute("exportExcelListNew", exportToExcelList);
				session.setAttribute("excelNameNew", "SaleBillWiseDate");
				session.setAttribute("reportNameNew", "View Billwise Sale Grp By Date");
				session.setAttribute("searchByNew", "From Date: " + fromDt + "  To Date: " + toDt + " ");
				session.setAttribute("mergeUpto1", "$A$1:$G$1");
				session.setAttribute("mergeUpto2", "$A$2:$G$2");
		
		
		
		return saleList;
	}
	
	
	//Akhilesh 2020-01-05
	@RequestMapping(value = "pdf/showSaleBillwiseGrpByDatePdf/{fromDate}/{toDate}/{selectedFr}/{routeId}", method = RequestMethod.GET)
	public ModelAndView showSaleBillwiseGrpByDate(@PathVariable String fromDate, @PathVariable String toDate,
			@PathVariable String selectedFr, @PathVariable String routeId, HttpServletRequest request,
			HttpServletResponse response) {

		ModelAndView model = new ModelAndView("report/sellReport/sellReportPdf/billwisesalesgrpbydatePdf");

		boolean isAllFrSelected = false;

		/*
		 * try { System.out.println("Inside get Sale Bill Wise");
		 * 
		 * frList = new ArrayList<>(); frList = Arrays.asList(selectedFr);
		 * 
		 * if (!routeId.equalsIgnoreCase("0")) {
		 * 
		 * MultiValueMap<String, Object> map = new LinkedMultiValueMap<String,
		 * Object>();
		 * 
		 * RestTemplate restTemplate = new RestTemplate();
		 * 
		 * map.add("routeId", routeId);
		 * 
		 * FrNameIdByRouteIdResponse frNameId = restTemplate.postForObject(Constants.url
		 * + "getFrNameIdByRouteId", map, FrNameIdByRouteIdResponse.class);
		 * 
		 * List<FrNameIdByRouteId> frNameIdByRouteIdList =
		 * frNameId.getFrNameIdByRouteIds();
		 * 
		 * System.out.println("route wise franchisee " +
		 * frNameIdByRouteIdList.toString());
		 * 
		 * StringBuilder sbForRouteFrId = new StringBuilder(); for (int i = 0; i <
		 * frNameIdByRouteIdList.size(); i++) {
		 * 
		 * sbForRouteFrId =
		 * sbForRouteFrId.append(frNameIdByRouteIdList.get(i).getFrId().toString() +
		 * ",");
		 * 
		 * }
		 * 
		 * String strFrIdRouteWise = sbForRouteFrId.toString(); selectedFr =
		 * strFrIdRouteWise.substring(0, strFrIdRouteWise.length() - 1);
		 * System.out.println("fr Id Route WISE = " + selectedFr);
		 * 
		 * } // end of if
		 * 
		 * if (selectedFr.equalsIgnoreCase("-1")) { isAllFrSelected = true; }
		 * 
		 * MultiValueMap<String, Object> map = new LinkedMultiValueMap<String,
		 * Object>(); RestTemplate restTemplate = new RestTemplate();
		 * 
		 * if (isAllFrSelected) {
		 * 
		 * System.out.println("Inside If all fr Selected ");
		 * 
		 * map.add("fromDate", fromDate); map.add("toDate", toDate);
		 * 
		 * ParameterizedTypeReference<List<SalesReportBillwise>> typeRef = new
		 * ParameterizedTypeReference<List<SalesReportBillwise>>() { };
		 * ResponseEntity<List<SalesReportBillwise>> responseEntity =
		 * restTemplate.exchange( Constants.url + "getSaleReportBillwiseByDateAllFr",
		 * HttpMethod.POST, new HttpEntity<>(map), typeRef);
		 * 
		 * saleList = responseEntity.getBody(); saleListForPdf = new ArrayList<>();
		 * 
		 * saleListForPdf = saleList;
		 * 
		 * System.out.println("sales List Bill Wise " + saleList.toString());
		 * 
		 * } else { System.out.println("Inside else Few fr Selected ");
		 * 
		 * map.add("frIdList", selectedFr); map.add("fromDate", fromDate);
		 * map.add("toDate", toDate);
		 * 
		 * ParameterizedTypeReference<List<SalesReportBillwise>> typeRef = new
		 * ParameterizedTypeReference<List<SalesReportBillwise>>() { };
		 * ResponseEntity<List<SalesReportBillwise>> responseEntity =
		 * restTemplate.exchange( Constants.url + "getSaleReportBillwiseByDate",
		 * HttpMethod.POST, new HttpEntity<>(map), typeRef);
		 * 
		 * saleList = responseEntity.getBody(); saleListForPdf = new ArrayList<>();
		 * 
		 * saleListForPdf = saleList;
		 * 
		 * System.out.println("sales List Bill Wise " + saleList.toString());
		 * 
		 * }
		 * 
		 * } catch (
		 * 
		 * Exception e) {
		 * 
		 * System.out.println("Exce in show Sale Bill wise by fr PDF " +
		 * e.getMessage()); e.printStackTrace();
		 * 
		 * }
		 */

		List<SalesReportDateMonth> saleList = new ArrayList<>();

		try {
			System.out.println("Inside get Sale Bill Wise");

			if (!routeId.equalsIgnoreCase("0")) {

				MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();

				RestTemplate restTemplate = new RestTemplate();

				map.add("routeId", routeId);

			/*	FrNameIdByRouteIdResponse frNameId = restTemplate.postForObject(Constants.url + "getFrNameIdByRouteId",
						map, FrNameIdByRouteIdResponse.class);

				List<FrNameIdByRouteId> frNameIdByRouteIdList = frNameId.getFrNameIdByRouteIds();*/

				//System.out.println("route wise franchisee " + frNameIdByRouteIdList.toString());

			/*	StringBuilder sbForRouteFrId = new StringBuilder();
				for (int i = 0; i < frNameIdByRouteIdList.size(); i++) {

					sbForRouteFrId = sbForRouteFrId.append(frNameIdByRouteIdList.get(i).getFrId().toString() + ",");

				}*/

				//String strFrIdRouteWise = sbForRouteFrId.toString();
				//selectedFr = strFrIdRouteWise.substring(0, strFrIdRouteWise.length() - 1);
				//System.out.println("fr Id Route WISE = " + selectedFr);

			} // end of if

			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			RestTemplate restTemplate = new RestTemplate();

			System.out.println("Inside else Few fr Selected ");

			map.add("frIdList", selectedFr);
			map.add("fromDate", fromDate);
			map.add("toDate", toDate);

			ParameterizedTypeReference<List<SalesReportDateMonth>> typeRef = new ParameterizedTypeReference<List<SalesReportDateMonth>>() {
			};
			ResponseEntity<List<SalesReportDateMonth>> responseEntity = restTemplate
					.exchange(Constant.URL + "getDatewiseReport", HttpMethod.POST, new HttpEntity<>(map), typeRef);

			saleList = responseEntity.getBody();

			for (int i = 0; i < saleList.size(); i++) {

				float netGrandTotal = (saleList.get(i).getGrandTotal()
						- (saleList.get(i).getGrnGrandTotal() + saleList.get(i).getGvnGrandTotal()));
				float netTaxableAmt = (saleList.get(i).getTaxableAmt()
						- (saleList.get(i).getGrnTaxableAmt() + saleList.get(i).getGvnTaxableAmt()));

				float netTotalTax = (saleList.get(i).getTotalTax()
						- (saleList.get(i).getGrnTotalTax() + saleList.get(i).getGvnTotalTax()));
				saleList.get(i).setNetGrandTotal(netGrandTotal);
				saleList.get(i).setNetTaxableAmt(netTaxableAmt);
				saleList.get(i).setNetTotalTax(netTotalTax);
			}

			System.out.println("sales List Bill Wise " + saleList.toString());

		} catch (

		Exception e) {
			System.out.println("get sale Report Bill Wise " + e.getMessage());
			e.printStackTrace();

		}

		model.addObject("fromDate", fromDate);

		model.addObject("toDate", toDate);
		model.addObject("FACTORYNAME", Constant.FACTORYNAME);
		model.addObject("FACTORYADDRESS", Constant.FACTORYADDRESS);
		model.addObject("report", saleList);
		
		
		
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
