package com.monginis.ops.model.newpos;

public class BillItemList {
	
	
	private int itemId;
	
	private String itemName;
	
	private float itemMrp;
	
	
	private int catId;
	
	private float tax1;
	
	private float tax2;
	


	private int aviableQty;



	private float itemTax;
	
	private String itemUom;
	
	private int itemQty;
	
	private float calPrice;
	
	private float payableTax;
	
	
	private float payableAmt;


	public int getItemId() {
		return itemId;
	}


	public void setItemId(int itemId) {
		this.itemId = itemId;
	}


	public String getItemName() {
		return itemName;
	}


	public void setItemName(String itemName) {
		this.itemName = itemName;
	}


	public float getItemMrp() {
		return itemMrp;
	}


	public void setItemMrp(float itemMrp) {
		this.itemMrp = itemMrp;
	}


	public float getItemTax() {
		return itemTax;
	}


	public void setItemTax(float itemTax) {
		this.itemTax = itemTax;
	}


	public String getItemUom() {
		return itemUom;
	}


	public void setItemUom(String itemUom) {
		this.itemUom = itemUom;
	}


	public int getItemQty() {
		return itemQty;
	}


	public void setItemQty(int itemQty) {
		this.itemQty = itemQty;
	}


	public float getCalPrice() {
		return calPrice;
	}


	public void setCalPrice(float calPrice) {
		this.calPrice = calPrice;
	}


	public float getPayableTax() {
		return payableTax;
	}


	public void setPayableTax(float payableTax) {
		this.payableTax = payableTax;
	}


	public float getPayableAmt() {
		return payableAmt;
	}


	public void setPayableAmt(float payableAmt) {
		this.payableAmt = payableAmt;
	}


	public int getCatId() {
		return catId;
	}


	public void setCatId(int catId) {
		this.catId = catId;
	}


	public float getTax1() {
		return tax1;
	}


	public void setTax1(float tax1) {
		this.tax1 = tax1;
	}


	public float getTax2() {
		return tax2;
	}


	public void setTax2(float tax2) {
		this.tax2 = tax2;
	}


	public int getAviableQty() {
		return aviableQty;
	}


	public void setAviableQty(int aviableQty) {
		this.aviableQty = aviableQty;
	}


	@Override
	public String toString() {
		return "BillItemList [itemId=" + itemId + ", itemName=" + itemName + ", itemMrp=" + itemMrp + ", catId=" + catId
				+ ", tax1=" + tax1 + ", tax2=" + tax2 + ", aviableQty=" + aviableQty + ", itemTax=" + itemTax
				+ ", itemUom=" + itemUom + ", itemQty=" + itemQty + ", calPrice=" + calPrice + ", payableTax="
				+ payableTax + ", payableAmt=" + payableAmt + "]";
	}







	
	
	
	
	
	
	

}
