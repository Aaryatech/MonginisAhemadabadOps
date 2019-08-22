package com.monginis.ops.model.salesreport3;

public class HsnDateWiseSellData {
	
	private int sell_bill_detail_no;
	private int no;
	
	private String invoiceNo;
	private String billDate;
	private String userName;
	private String userGstNo;
	private String hsnCode;
	
	private int qty;
	private float taxableAmt;
	private float cgstPer;
	private float cgstRs;
	private float sgstPer;
	private float sgstRs;
	private float total;
	private float billTotal;
	public int getSell_bill_detail_no() {
		return sell_bill_detail_no;
	}
	public void setSell_bill_detail_no(int sell_bill_detail_no) {
		this.sell_bill_detail_no = sell_bill_detail_no;
	}
	public int getNo() {
		return no;
	}
	public void setNo(int no) {
		this.no = no;
	}
	public String getInvoiceNo() {
		return invoiceNo;
	}
	public void setInvoiceNo(String invoiceNo) {
		this.invoiceNo = invoiceNo;
	}
	public String getBillDate() {
		return billDate;
	}
	public void setBillDate(String billDate) {
		this.billDate = billDate;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserGstNo() {
		return userGstNo;
	}
	public void setUserGstNo(String userGstNo) {
		this.userGstNo = userGstNo;
	}
	public String getHsnCode() {
		return hsnCode;
	}
	public void setHsnCode(String hsnCode) {
		this.hsnCode = hsnCode;
	}
	public int getQty() {
		return qty;
	}
	public void setQty(int qty) {
		this.qty = qty;
	}
	public float getTaxableAmt() {
		return taxableAmt;
	}
	public void setTaxableAmt(float taxableAmt) {
		this.taxableAmt = taxableAmt;
	}
	public float getCgstPer() {
		return cgstPer;
	}
	public void setCgstPer(float cgstPer) {
		this.cgstPer = cgstPer;
	}
	public float getCgstRs() {
		return cgstRs;
	}
	public void setCgstRs(float cgstRs) {
		this.cgstRs = cgstRs;
	}
	public float getSgstPer() {
		return sgstPer;
	}
	public void setSgstPer(float sgstPer) {
		this.sgstPer = sgstPer;
	}
	public float getSgstRs() {
		return sgstRs;
	}
	public void setSgstRs(float sgstRs) {
		this.sgstRs = sgstRs;
	}
	public float getTotal() {
		return total;
	}
	public void setTotal(float total) {
		this.total = total;
	}
	public float getBillTotal() {
		return billTotal;
	}
	public void setBillTotal(float billTotal) {
		this.billTotal = billTotal;
	}
	@Override
	public String toString() {
		return "HsnDateWiseSellReport [sell_bill_detail_no=" + sell_bill_detail_no + ", no=" + no + ", invoiceNo="
				+ invoiceNo + ", billDate=" + billDate + ", userName=" + userName + ", userGstNo=" + userGstNo
				+ ", hsnCode=" + hsnCode + ", qty=" + qty + ", taxableAmt=" + taxableAmt + ", cgstPer=" + cgstPer
				+ ", cgstRs=" + cgstRs + ", sgstPer=" + sgstPer + ", sgstRs=" + sgstRs + ", total=" + total
				+ ", billTotal=" + billTotal + "]";
	}

}
