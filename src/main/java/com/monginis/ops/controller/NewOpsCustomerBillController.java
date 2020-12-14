package com.monginis.ops.controller;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Year;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.ItemList;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.monginis.ops.billing.SellBillDetail;
import com.monginis.ops.billing.SellBillHeader;
import com.monginis.ops.common.Common;
import com.monginis.ops.constant.Constant;
import com.monginis.ops.model.CustomerBillItem;
import com.monginis.ops.model.FrMenu;
import com.monginis.ops.model.Franchisee;
import com.monginis.ops.model.GetCustBillTax;
import com.monginis.ops.model.GetCustmoreBillResponse;
import com.monginis.ops.model.GetFrMenus;
import com.monginis.ops.model.Info;
import com.monginis.ops.model.PostFrItemStockHeader;
import com.monginis.ops.model.SubCategory;
import com.monginis.ops.model.frsetting.FrSetting;
import com.monginis.ops.model.newpos.BillItemList;
import com.monginis.ops.model.newpos.Customer;
import com.monginis.ops.model.newpos.CustomerBillOnHold;
import com.monginis.ops.model.newpos.NewPosBillItem;

@Controller
public class NewOpsCustomerBillController {
	
	
	public int frGstType = 0;
	
	
	List<NewPosBillItem> billItemList = new ArrayList<NewPosBillItem>();
	
	List<BillItemList> itemList=new ArrayList<BillItemList>();
	
	List<Customer> custometList=new ArrayList<Customer>();
	

	LinkedHashMap<Integer, CustomerBillOnHold> hashMap = new LinkedHashMap<Integer, CustomerBillOnHold>();
	int key = 0;
	int tempBillNo = 0;
	
	@RequestMapping(value = "/newPos/{type}", method = RequestMethod.GET)
	public String displayNewPOs(HttpServletRequest request, HttpServletResponse response, @PathVariable int type,
			Model model) {
		
		System.out.println("type---->"+type);
		
		
		RestTemplate restTemplate = new RestTemplate();
		
		List<SubCategory> subCatResp = new ArrayList<SubCategory>();
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		HttpSession session = request.getSession();
		Franchisee frDetails = (Franchisee) session.getAttribute("frDetails");

		ArrayList<FrMenu> menuList = (ArrayList<FrMenu>) session.getAttribute("allMenuList");

		int runningMonth = 0;
		try {
			
			
			Customer[] custResp=restTemplate.getForObject(Constant.URL+"getAllCustomer",Customer[].class);
			custometList=new ArrayList<Customer>(Arrays.asList(custResp));
			System.err.println("customer List Length="+custometList.size());
			model.addAttribute("customerList", custometList);
			model.addAttribute("holdingList", hashMap);
			
			
			if (type == 1) {
				System.err.println("holdBill------>"+hashMap.get(key));
				model.addAttribute("holdBill", hashMap.get(key));
				itemList = hashMap.get(key).getItemList();
				model.addAttribute("key", key);
			} else {
			//itemList.clear();
				itemList=new ArrayList<BillItemList>();
				model.addAttribute("key", 0);
			}
			map.add("frId", frDetails.getFrId());

			ParameterizedTypeReference<List<PostFrItemStockHeader>> typeRef1 = new ParameterizedTypeReference<List<PostFrItemStockHeader>>() {
			};
			ResponseEntity<List<PostFrItemStockHeader>> responseEntity1 = restTemplate.exchange(
					Constant.URL + "getCurrentMonthOfCatId", HttpMethod.POST, new HttpEntity<>(map), typeRef1);
			List<PostFrItemStockHeader> list = responseEntity1.getBody();

			for (int i = 0; i < list.size(); i++) {

				runningMonth = list.get(i).getMonth();

			}

			String items;
			StringBuilder builder = new StringBuilder();

			MultiValueMap<String, Object> menuMap = new LinkedMultiValueMap<String, Object>();
			menuMap.add("frId", frDetails.getFrId());

			GetFrMenus getFrMenus = restTemplate.postForObject(Constant.URL + "/getFrConfigMenus", menuMap,
					GetFrMenus.class);

			System.out.println("Get Fr Menus Response " + getFrMenus.toString());

			List<FrMenu> frMenuList = getFrMenus.getFrMenus();

			if (frMenuList != null) {
				for (FrMenu frMenu : menuList) {
					builder.append("," + frMenu.getItemShow());
				}
			}

			items = builder.toString();
			items = items.substring(1, items.length());

			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			DateFormat yearFormat = new SimpleDateFormat("yyyy");

			Date todaysDate = new Date();
			System.out.println(dateFormat.format(todaysDate));

			Calendar cal = Calendar.getInstance();
			cal.setTime(todaysDate);

			cal.set(Calendar.DAY_OF_MONTH, 1);

			Date firstDay = cal.getTime();

			System.out.println("First Day of month " + firstDay);

			String strFirstDay = dateFormat.format(firstDay);

			System.out.println("Year " + yearFormat.format(todaysDate));
			boolean isMonthCloseApplicable = false;

			map = new LinkedMultiValueMap<String, Object>();

			DateFormat dateFormat1 = new SimpleDateFormat("dd/MM/yyyy");
			Date date = new Date();
			System.out.println(dateFormat1.format(date));

			Calendar cal1 = Calendar.getInstance();
			cal1.setTime(date);

			int dayOfMonth = cal1.get(Calendar.DATE);

			int calCurrentMonth = cal1.get(Calendar.MONTH) + 1;
			System.err.println(
					"Current Cal Month " + calCurrentMonth + "menuList" + menuList.toString() + "itemShow" + items);

			System.out.println("Day Of Month is: " + dayOfMonth);

			if (runningMonth < calCurrentMonth) {

				isMonthCloseApplicable = true;
				System.out.println("Day Of Month End ......");

			} else if (runningMonth == 12 && calCurrentMonth == 1) {
				isMonthCloseApplicable = true;
			}

			if (isMonthCloseApplicable) {
				System.err.println("### Inside iMonthclose app");
				String strDate;
				int year;
				if (runningMonth == 12) {
					System.err.println("running month =12");
					year = (Calendar.getInstance().getWeekYear() - 1);
					System.err.println("year value " + year);
				} else {
					System.err.println("running month not eq 12");
					year = Calendar.getInstance().getWeekYear();
					System.err.println("year value " + year);
				}

				// strDate="01/"+runningMonth+"/"+year;

				strDate = year + "/" + runningMonth + "/01";
				System.out.println("strDate-------"+strDate);
				map.add("fromDt", strDate);
			} else {
				System.out.println("dateFormat.format(firstDay)-------"+dateFormat.format(firstDay));
				map.add("fromDt", dateFormat.format(firstDay));

			}

			map.add("frId", frDetails.getFrId());
			map.add("frStockType", frDetails.getStockType());
			map.add("toDt", dateFormat.format(todaysDate));
			map.add("month", String.valueOf(runningMonth));
			map.add("year", yearFormat.format(todaysDate));

			map.add("itemList", items);
			
			System.out.println(items);
			System.out.println(frDetails.getFrId()+" * "+frDetails.getStockType()+" * "+dateFormat.format(todaysDate)+" * "+String.valueOf(runningMonth)+" * "+yearFormat.format(todaysDate));
			
			NewPosBillItem[] biiItleListArr=restTemplate.postForObject(Constant.URL+"getItemListWithCS", map, NewPosBillItem[].class);
			List<NewPosBillItem> BillItemsRespList=new ArrayList<NewPosBillItem>(Arrays.asList(biiItleListArr));
			billItemList = BillItemsRespList;
			
			String jsonStr="";
			ObjectMapper Obj = new ObjectMapper();

			try {
			 jsonStr = Obj.writeValueAsString(BillItemsRespList);
			
			} catch (Exception e) {
				e.printStackTrace();
			}
			System.err.println("BillItemsRespList"+BillItemsRespList);
			System.err.println(jsonStr+"JSO");
			model.addAttribute("jsonItemList", jsonStr);
			model.addAttribute("ItemList", BillItemsRespList);
			
			

			SubCategory[] subCatArr = restTemplate.getForObject(Constant.URL + "getAllSubCatList", SubCategory[].class);
			subCatResp = new ArrayList<SubCategory>(Arrays.asList(subCatArr));
			System.err.println("Subcat List=" + "\t" + subCatResp);

			model.addAttribute("subCatList", subCatResp);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return "newPos";

	}
	
	@RequestMapping(value = "/billOnHold", method = RequestMethod.POST)
	@ResponseBody
	public Info billOnHold(HttpServletRequest request, HttpServletResponse responsel) {

		Info info = new Info();
		System.out.println(" in billOnHold");
		try {

			int key = Integer.parseInt(request.getParameter("key"));
		
			String holdCustName = request.getParameter("holdCustName");
			String tempGstNo = request.getParameter("custGst");
			String tempMobNo = request.getParameter("custMob");
			
			System.out.println(holdCustName+" "+tempGstNo+" "+tempMobNo);
			
			if (hashMap.containsKey(key)) {
				hashMap.get(key).setTempCustomerName(holdCustName);
				hashMap.get(key).setTempGstNo(tempGstNo);
				hashMap.get(key).setTempMobNo(tempMobNo);						
				hashMap.get(key).setItemList(itemList);
				System.out.println("in If");
			} else {
				CustomerBillOnHold addNew = new CustomerBillOnHold();
				tempBillNo = tempBillNo + 1;
				
				addNew.setItemList(itemList);				
				addNew.setTempCustomerName(holdCustName);
				addNew.setTempGstNo(tempGstNo);
				addNew.setTempMobNo(tempMobNo);
				
				hashMap.put(tempBillNo, addNew);
			System.out.println("in else");
			}
			System.out.println("hashMap---------->"+hashMap);
			info.setError(false);
			info.setMessage("Successfully");
		} catch (Exception e) {
			e.printStackTrace();
			info.setError(true);
			info.setMessage("failed");
		}
		return info;
	}

	
	@RequestMapping(value="/addItemInBillLIst",method=RequestMethod.GET)
	@ResponseBody
	public List<BillItemList> addItemInBillLIst(HttpServletRequest request,HttpServletResponse response,Model model){
		System.err.println("In addItemInBillLIst ");
		try {	
			
			
			String itemName=request.getParameter("itemName");
			int itemId =Integer.parseInt(request.getParameter("itemId"));
			float itemMrp=Float.parseFloat(request.getParameter("itemMrp"));
			float itemTax=Float.parseFloat(request.getParameter("itemTax"));
			String itemUom=request.getParameter("itemUom");
			int itemQty =Integer.parseInt(request.getParameter("qty"));
			float price=Float.parseFloat(request.getParameter("price"));
			float paybeleTax=Float.parseFloat(request.getParameter("paybeleTax"));
			float paybeleAmt=Float.parseFloat(request.getParameter("paybeleAmt"));
			float tax1=Float.parseFloat(request.getParameter("tax1"));
			float tax2=Float.parseFloat(request.getParameter("tax2"));
			int catId=Integer.parseInt(request.getParameter("catId"));
			int avQty=Integer.parseInt(request.getParameter("aviableQty"));
			//System.err.println("catidtax1,2="+catId+tax1+tax2);
			
			int flag=0;
			
			
			for(int i=0 ;i<itemList.size();i++) {
				if(itemList.get(i).getItemId()==itemId) {
					itemList.get(i).setItemQty(itemQty);
					//float taxAmt=(price/100)*100;
					itemList.get(i).setItemName(itemName);
					itemList.get(i).setItemMrp(itemMrp);
					itemList.get(i).setCalPrice(price);
					itemList.get(i).setPayableTax(paybeleTax);
					itemList.get(i).setPayableAmt(paybeleAmt);
					itemList.get(i).setTax1(tax1);
					itemList.get(i).setTax2(tax2);
					itemList.get(i).setCatId(catId);
					itemList.get(i).setAviableQty(avQty);
					//System.out.println(itemList.get(i));
					
					flag=1;
					System.out.println();
				}
			}

			
			if(flag==0) {
				
				BillItemList it=new BillItemList();
				
				it.setItemId(itemId);
				it.setItemName(itemName);
				it.setItemQty(itemQty);
				it.setItemMrp(itemMrp);
				it.setCalPrice(price);
				it.setItemUom(itemUom);
				it.setItemTax(itemTax);
				it.setPayableTax(paybeleTax);
				it.setPayableAmt(paybeleAmt);
				it.setTax1(tax1);
				it.setTax2(tax2);
				it.setCatId(catId);
				it.setAviableQty(avQty);
			//	System.out.println(it);
				itemList.add(it);
				
			}
		
		System.err.println("itemList=="+itemList.size());
		
			} catch (Exception e) {
			// TODO: handle exception
			System.err.println("Exception Occured In Catch Block Of /addItemInBillLIst Mapping");
			e.printStackTrace();
		}
		
		
		return itemList;
	}
	
	
	
	@RequestMapping(value="/getCustomerList",method=RequestMethod.GET)
	@ResponseBody
	public List<Customer>  getCustomerList(HttpServletRequest request,HttpServletResponse response){
		System.err.println("in Get Customer List----->"+custometList);
		return custometList;
		
	}
	
	@RequestMapping(value="/getItemList",method=RequestMethod.GET)
	@ResponseBody
	public List<BillItemList>  getItemList(HttpServletRequest request,HttpServletResponse response){
		System.err.println("in Get Item List");
		return itemList;
		
	}
	
	
	
	@RequestMapping(value="/addCustomer",method=RequestMethod.POST)
	@ResponseBody
	public int addCustomer(HttpServletRequest request,HttpServletResponse response) {
		System.err.println("in Add Customer");
		int flag=0;
		/*
		 * String name=request.getParameter("name");
		 *  System.err.println(name+"Name Is");
		 */
		String uuid = UUID.randomUUID().toString();

		try {
			String name=request.getParameter("name");
			String mob=request.getParameter("mob");
			String gst=request.getParameter("gst");
			Customer cust=new Customer();
				
				cust.setId(uuid);
				cust.setUserName(name);
				cust.setPhoneNo(mob);
				cust.setGstNo(gst);
				System.err.println("Before=="+custometList.size());
			custometList.add(cust);
			System.err.println("AFter=="+custometList.size());
			flag=1;
			
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println("Exception Occuered In Catach Block Of /addCustomer");
			flag =0;
			e.printStackTrace();
		}
		
		return  flag;
		
	}
 	
	
	
	@RequestMapping(value="/deleteItem",method=RequestMethod.POST)
	@ResponseBody
	public List<BillItemList> deleteItem(HttpServletRequest request,HttpServletResponse response){
		System.err.println("In Dlete Item From ItemList");
		try {
		
			int id=Integer.parseInt(request.getParameter("id"));
			
			  System.err.println("id ="+id); for ( int i=0 ;i<itemList.size();i++ ) {
			  if(itemList.get(i).getItemId()==id) { itemList.remove(i);
			  
			  } }
			 
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println("Exception Occuered In Catch Block Of /deleteItem");
			e.printStackTrace();
		}
		
		return itemList;
	}
	
	@RequestMapping(value = "/revertHoldBillOnCurrent", method = RequestMethod.POST)
	@ResponseBody
	public Info revertHoldBillOnCurrent(HttpServletRequest request, HttpServletResponse responsel) {

		Info info = new Info();

		try {

			int index = Integer.parseInt(request.getParameter("key"));
			key = index;

			info.setError(false);
			info.setMessage("Successfully");
		} catch (Exception e) {
			e.printStackTrace();
			info.setError(true);
			info.setMessage("failed");
		}
		return info;
	}
	
	@RequestMapping(value="/genrateSellBill",method=RequestMethod.POST)
	public @ResponseBody SellBillHeader genrateSellBill(HttpServletRequest request,HttpServletResponse response) {
		System.err.println("In genrateSellBill ");
		String cName="",cPhone="",cGst ="";
		HttpSession session = request.getSession();
		Franchisee frDetails = (Franchisee) session.getAttribute("frDetails");
		java.sql.Date cDate = new java.sql.Date(Calendar.getInstance().getTime().getTime());
		SellBillHeader sellBillHeaderRes = new SellBillHeader();
		
		
		
		try {
			
		int index = Integer.parseInt(request.getParameter("key"));
		String custDetails=request.getParameter("custName");
		//float paidAmt= Float.parseFloat(request.getParameter("paidAmt"));
		int  payMode =Integer.parseInt(request.getParameter("payMode")); 
		//System.err.println(custDetails+"cust");
		float discountPer= Float.parseFloat(request.getParameter("discPer"));
		float payableAmount= Float.parseFloat(request.getParameter("payableAmt"));
		String[] customeDetailArr=custDetails.split("~");
		for(int i=0;i<customeDetailArr.length;i++) {
			if(i==0) {
				 cName=customeDetailArr[i];
			}if(i==1){
				 cPhone =customeDetailArr[i];
			}if(i==2) {
				 cGst= customeDetailArr[2];
			}
		}
		
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate localDate = LocalDate.now();
		
		
		
		
		System.out.println("Cust=========="+cName+cPhone+cGst);
		
		SellBillHeader sellBillHeader = new SellBillHeader();
		
		sellBillHeader.setFrId(frDetails.getFrId());
		sellBillHeader.setFrCode(frDetails.getFrCode());
		sellBillHeader.setDelStatus(0);
		sellBillHeader.setUserName(cName);
		sellBillHeader.setBillDate(dtf.format(localDate));
		sellBillHeader.setInvoiceNo(getInvoiceNo(request,response));
		sellBillHeader.setPaidAmt(Math.round(payableAmount));
		sellBillHeader.setPaymentMode(payMode);
		sellBillHeader.setBillType('R');
		sellBillHeader.setSellBillNo(0);

		sellBillHeader.setUserGstNo(cGst);

		sellBillHeader.setUserPhone(cPhone);
		
		
		List<SellBillDetail> sellBillDetailList = new ArrayList<SellBillDetail>();
		List<CustomerBillItem> customerBillItemList = new ArrayList<CustomerBillItem>();
		
		float sumTaxableAmt = 0, sumTotalTax = 0, sumGrandTotal = 0, sumMrp = 0;
		float sumDiscAmt=0.f;
		for (int i = 0; i < itemList.size(); i++) {
		SellBillDetail sellBillDetail = new SellBillDetail();
		
		
		
		
		Float rate = (float) itemList.get(i).getItemMrp();

		Float tax1 = (float) itemList.get(i).getTax1();
		Float tax2 = (float) itemList.get(i).getTax2();
		Float tax3 = (float) itemList.get(i).getItemTax();

		int qty = itemList.get(i).getItemQty();

		Float mrpBaseRate = (rate * 100) / (100 + (tax1 + tax2));
		mrpBaseRate = roundUp(mrpBaseRate);

		System.out.println("Mrp: " + rate);
		System.out.println("Tax1 : " + tax1);
		System.out.println("tax2 : " + tax2);

		Float taxableAmt = (float) (mrpBaseRate * qty);
		taxableAmt = roundUp(taxableAmt);

		// -----------------------------------------

		float discAmt = ((taxableAmt * discountPer) / 100);
		sumDiscAmt=sumDiscAmt+discAmt;
		taxableAmt = taxableAmt - discAmt;

		float sgstRs = (taxableAmt * tax1) / 100;
		float cgstRs = (taxableAmt * tax2) / 100;
		float igstRs = (taxableAmt * tax3) / 100;

		sgstRs = roundUp(sgstRs);
		cgstRs = roundUp(cgstRs);
		igstRs = roundUp(igstRs);

		Float totalTax = sgstRs + cgstRs;
		totalTax = roundUp(totalTax);

		Float grandTotal = totalTax + taxableAmt;
		grandTotal = roundUp(grandTotal);
		
		sellBillDetail.setCatId(itemList.get(i).getCatId());
		sellBillDetail.setSgstPer(tax1);
		sellBillDetail.setSgstRs(sgstRs);
		sellBillDetail.setCgstPer(tax2);
		sellBillDetail.setCgstRs(cgstRs);
		sellBillDetail.setDelStatus(0);
		sellBillDetail.setGrandTotal(grandTotal);
		sellBillDetail.setIgstPer(tax3);
		sellBillDetail.setIgstRs(igstRs);
		sellBillDetail.setItemId(itemList.get(i).getItemId());
		sellBillDetail.setMrp(rate);
		sellBillDetail.setMrpBaseRate(mrpBaseRate);
		sellBillDetail.setQty(itemList.get(i).getItemQty());
		sellBillDetail.setRemark("");
		sellBillDetail.setSellBillDetailNo(0);
		sellBillDetail.setSellBillNo(0);
		sellBillDetail.setBillStockType(1);
		
		//sumMrp = sumMrp + (rate * qty);
		sumTaxableAmt = sumTaxableAmt + taxableAmt;
		sumTotalTax = sumTotalTax + totalTax;
		sumGrandTotal = sumGrandTotal + totalTax + taxableAmt;

		sellBillDetail.setTaxableAmt(taxableAmt);
		sellBillDetail.setTotalTax(totalTax);

		sellBillDetailList.add(sellBillDetail);
		
		
		}
		
		sellBillHeader.setTaxableAmt(sumTaxableAmt);
		sellBillHeader.setDiscountPer(discountPer);
		
		float payableAmt = sumGrandTotal;

		payableAmt = roundUp(payableAmt);
		
		sellBillHeader.setDiscountAmt(Math.round(payableAmount));
		sellBillHeader.setPayableAmt(Math.round(payableAmount));
		System.out.println("Payable amt  : " + payableAmt);
		sellBillHeader.setTotalTax(sumTotalTax);
		sellBillHeader.setGrandTotal(Math.round(sumGrandTotal));
		
		
		float calRemainingTotal = 0;
	

		if (calRemainingTotal < 0) {
			sellBillHeader.setRemainingAmt(0);

		} else {

			sellBillHeader.setRemainingAmt(calRemainingTotal);
		}
		if (calRemainingTotal <= 0) {

			sellBillHeader.setStatus(1);
		} else if (calRemainingTotal == payableAmt) {
			sellBillHeader.setStatus(2);

		} else if (payableAmt > calRemainingTotal) {
			sellBillHeader.setStatus(3);
		}

		sellBillHeader.setSellBillDetailsList(sellBillDetailList);
		
		System.out.println("Sell Bill Detail: " + sellBillHeader.toString());
		
		RestTemplate restTemplate = new RestTemplate();

		sellBillHeaderRes = restTemplate.postForObject(Constant.URL + "insertSellBillData", sellBillHeader,
				SellBillHeader.class);
		
		System.out.println("info :" + sellBillHeaderRes.toString());
		
		//System.out.println("Sell Bill Header: " + sellBillHeader.toString());
		
		
		if (sellBillHeaderRes != null) {
			hashMap.remove(index);
			itemList=new ArrayList<BillItemList>();
			MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
			map = new LinkedMultiValueMap<String, Object>();
			
			

			map.add("frId", frDetails.getFrId());
			FrSetting frSetting = restTemplate.postForObject(Constant.URL + "getFrSettingValue", map,
					FrSetting.class);

			int sellBillNo = frSetting.getSellBillNo();
			
			sellBillNo = sellBillNo + 1;

			map = new LinkedMultiValueMap<String, Object>();

			map.add("frId", frDetails.getFrId());
			map.add("sellBillNo", sellBillNo);
			
			Info info = restTemplate.postForObject(Constant.URL + "updateFrSettingBillNo", map, Info.class);
			
			try {
			String isSMS=request.getParameter("isSMS");
			if(isSMS.equals("1"))
			Common.sendTextMessage(2, cName, frDetails.getFrName(), 
					"", "", sellBillHeaderRes.getGrandTotal(), 
					"", cPhone);
			}catch (Exception e) {
				e.printStackTrace();
			}
			
			
		}
		
		
		
		
		}catch(Exception e) {
			System.out.println("Exception:" + e.getMessage());
			e.printStackTrace();
		}
		
		System.out.println("Order Response:" + sellBillHeaderRes.toString());

		return sellBillHeaderRes;
	}
	
	
	
	
	
	
	
	public String getInvoiceNo(HttpServletRequest request, HttpServletResponse response) {

		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		RestTemplate restTemplate = new RestTemplate();


		HttpSession session = request.getSession();

		Franchisee frDetails = (Franchisee) session.getAttribute("frDetails");

		int frId = frDetails.getFrId();

		// String frCode = frDetails.getFrCode();

		map.add("frId", frId);
		FrSetting frSetting = restTemplate.postForObject(Constant.URL + "getFrSettingValue", map, FrSetting.class);

		int billNo = frSetting.getSellBillNo();

		int settingValue =billNo;

		System.out.println("Setting Value Received " + settingValue);
		int year = Year.now().getValue();
		String curStrYear = String.valueOf(year);
		curStrYear = curStrYear.substring(2);

		int preMarchYear = Year.now().getValue() - 1;
		String preMarchStrYear = String.valueOf(preMarchYear);
		preMarchStrYear = preMarchStrYear.substring(2);

		System.out.println("Pre MArch year ===" + preMarchStrYear);

		int nextYear = Year.now().getValue() + 1;
		String nextStrYear = String.valueOf(nextYear);
		nextStrYear = nextStrYear.substring(2);

		System.out.println("Next  year ===" + nextStrYear);

		int postAprilYear = nextYear + 1;
		String postAprilStrYear = String.valueOf(postAprilYear);
		postAprilStrYear = postAprilStrYear.substring(2);

		System.out.println("Post April   year ===" + postAprilStrYear);

		java.util.Date date = new Date();
		Calendar cale = Calendar.getInstance();
		cale.setTime(date);
		int month = cale.get(Calendar.MONTH);
		
		month=month+1;

		if (month <= 3) {

			curStrYear = preMarchStrYear + curStrYear;
			System.out.println("Month <= 3::Cur Str Year " + curStrYear);
		} else if (month >= 4) {

			curStrYear = curStrYear + nextStrYear;
			System.out.println("Month >=4::Cur Str Year " + curStrYear);
		}

		////

		int length = String.valueOf(settingValue).length();

		String invoiceNo = null;

		if (length == 1)
		{
			invoiceNo = curStrYear + "-" + "0000" + settingValue;
		}else
		if (length == 2)
		{
			invoiceNo = curStrYear + "-" + "000" + settingValue;
		}else
		if (length == 3)
		{
			invoiceNo = curStrYear + "-" + "00" + settingValue;
		}else
		if (length == 4)
		{
			invoiceNo = curStrYear + "-" + "0" + settingValue;
		}else
		{
			invoiceNo = curStrYear + "-" + settingValue;
		}
		invoiceNo=frDetails.getFrCode()+invoiceNo;
		System.out.println("*** settingValue= " + settingValue);
		return invoiceNo;

	}
	
	
	
	public static float roundUp(float d) {
		return BigDecimal.valueOf(d).setScale(2, BigDecimal.ROUND_HALF_UP).floatValue();
	}
	
	
	
	
	
	@RequestMapping(value = "/pdfSellBillNewPos", method = RequestMethod.GET)
	public ModelAndView demoBill(HttpServletRequest request, HttpServletResponse response) {
		System.err.println("in pdfSellBillNewPos Mapping");
		String sellBillNo = request.getParameter("billNo");
		System.out.println("bill No "+sellBillNo);
		String billType=request.getParameter("type");
		int billNo = Integer.parseInt(sellBillNo);
		// int billNo=Integer.parseInt(fr_Id);
		HttpSession ses = request.getSession();
		Franchisee frDetails = (Franchisee) ses.getAttribute("frDetails");
		frGstType = frDetails.getFrGstType();
		ModelAndView model = new ModelAndView("report/franchCompInvoice");

		RestTemplate rest = new RestTemplate();
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		try {
		map.add("billNo", billNo);
		if (frGstType == 10000000) {
			model = new ModelAndView("report/franchTaxInvoice");
			List<GetCustBillTax> getCustBilTaxList = rest.postForObject(Constant.URL + "getCustomerBillTax", map,
					List.class);

			model.addObject("custBilltax", getCustBilTaxList);
		} 

		ParameterizedTypeReference<List<GetCustmoreBillResponse>> typeRef = new ParameterizedTypeReference<List<GetCustmoreBillResponse>>() {
		};
		ResponseEntity<List<GetCustmoreBillResponse>> responseEntity = rest.exchange(Constant.URL + "getCustomerBill",
				HttpMethod.POST, new HttpEntity<>(map), typeRef);
	
		List<GetCustmoreBillResponse> getCustmoreBillResponseList = responseEntity.getBody();

		GetCustmoreBillResponse billResponse = getCustmoreBillResponseList.get(0);
			//System.err.println("custBill Resp"+getCustmoreBillResponseList.get(0));
		
		float billAmt = billResponse.getMrp()*billResponse.getQty();
		float discPer = billResponse.getDiscountPer();
		//System.err.println("Bill Amount======="+billAmt);
		float intDiscAmt = roundUp((billAmt * discPer) / 100);
		

		getCustmoreBillResponseList.get(0).setIntDiscAmt(intDiscAmt);
		
		//For Get Proper Values In Print
		getCustmoreBillResponseList.get(0).setDiscountAmt(billResponse.getMrp()*billResponse.getQty());
		//
		System.out.println("bill no:" + billNo + "Custmore Bill : " + getCustmoreBillResponseList.toString());

		model.addObject("billList", getCustmoreBillResponseList);
		model.addObject("frGstType", frGstType);
		model.addObject("billType", billType);
		
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return model;
	}

	@RequestMapping(value = "/cancelFromHoldBill", method = RequestMethod.POST)
	@ResponseBody
	public Info cancelFromHoldBill(HttpServletRequest request, HttpServletResponse responsel) {

		Info info = new Info();

		try {

			int index = Integer.parseInt(request.getParameter("key"));
			hashMap.remove(index);

		} catch (Exception e) {
			e.printStackTrace();
			info.setError(true);
			info.setMessage("failed");
		}
		return info;
	}

//	@RequestMapping(value="/cancelBill",method=RequestMethod.GET)
//	public @ResponseBody List<BillItemList> cancelBill(HttpServletRequest request,HttpServletResponse response) {
//		System.err.println("In cancelBill"+itemList.size());
//		itemList.clear();
//		hashMap.clear();
//		System.err.println(itemList.size());
//	
//		
//		 return itemList;
//		 
//	}
//	
	
	
	
}
