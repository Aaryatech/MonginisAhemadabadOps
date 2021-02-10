package com.monginis.ops.model.newpos;

import java.util.ArrayList;
import java.util.List;

public class ErrorMsgWithItemList {

	private Boolean error;
	private String msg; 
	private List<BillItemList> itemList;
	public Boolean getError() {
		return error;
	}
	public void setError(Boolean error) {
		this.error = error;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public List<BillItemList> getItemList() {
		return itemList;
	}
	public void setItemList(List<BillItemList> itemList) {
		this.itemList = itemList;
	}
	@Override
	public String toString() {
		return "ErrorMsgWithItemList [error=" + error + ", msg=" + msg + ", itemList=" + itemList + "]";
	}
	
	

}
