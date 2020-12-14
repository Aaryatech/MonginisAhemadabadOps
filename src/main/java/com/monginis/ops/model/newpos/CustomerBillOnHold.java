package com.monginis.ops.model.newpos;

import java.util.List;

public class CustomerBillOnHold {
	
	private int custId;
	private String tempCustomerName;
	private String tempMobNo;
	private String tempGstNo;
	private List<BillItemList> itemList;
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public List<BillItemList> getItemList() {
		return itemList;
	}
	public void setItemList(List<BillItemList> itemList) {
		this.itemList = itemList;
	}
	
	public String getTempCustomerName() {
		return tempCustomerName;
	}
	public void setTempCustomerName(String tempCustomerName) {
		this.tempCustomerName = tempCustomerName;
	}
	public String getTempMobNo() {
		return tempMobNo;
	}
	public void setTempMobNo(String tempMobNo) {
		this.tempMobNo = tempMobNo;
	}
	public String getTempGstNo() {
		return tempGstNo;
	}
	public void setTempGstNo(String tempGstNo) {
		this.tempGstNo = tempGstNo;
	}
	@Override
	public String toString() {
		return "CustomerBillOnHold [custId=" + custId + ", tempCustomerName=" + tempCustomerName + ", tempMobNo="
				+ tempMobNo + ", tempGstNo=" + tempGstNo + ", itemList=" + itemList + "]";
	}
	

}
