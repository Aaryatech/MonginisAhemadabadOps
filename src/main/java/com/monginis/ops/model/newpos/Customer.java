package com.monginis.ops.model.newpos;

public class Customer {
	
	
	private String id;
	
	private String userName;
	
	private String gstNo;
	
	private String phoneNo;
	


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getGstNo() {
		return gstNo;
	}

	public void setGstNo(String gstNo) {
		this.gstNo = gstNo;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	@Override
	public String toString() {
		return "Customer [id=" + id + ", userName=" + userName + ", gstNo=" + gstNo + ", phoneNo=" + phoneNo + "]";
	}


	
	
	
	

}
