package com.monginis.ops.model.newpos;

public class NewPosBillItem {

	
	private int id;
	private String itemId;
	private String itemName;
	private int catId;
	private double mrp;
	private double rate;
	private int qty;
	private double itemTax1;
	private double itemTax2;
	private double itemTax3;
	private String uom;
	
	

	

	private int totalRegStock;

	private int subCatId;

	private String itemImg;
	
	
	public String getUom() {
		return uom;
	}

	public void setUom(String uom) {
		this.uom = uom;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getItemId() {
		return itemId;
	}

	public void setItemId(String itemId) {
		this.itemId = itemId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getCatId() {
		return catId;
	}

	public void setCatId(int catId) {
		this.catId = catId;
	}

	public double getMrp() {
		return mrp;
	}

	public void setMrp(double mrp) {
		this.mrp = mrp;
	}

	public double getRate() {
		return rate;
	}

	public void setRate(double rate) {
		this.rate = rate;
	}

	public int getQty() {
		return qty;
	}

	public void setQty(int qty) {
		this.qty = qty;
	}

	public double getItemTax1() {
		return itemTax1;
	}

	public void setItemTax1(double itemTax1) {
		this.itemTax1 = itemTax1;
	}

	public double getItemTax2() {
		return itemTax2;
	}

	public void setItemTax2(double itemTax2) {
		this.itemTax2 = itemTax2;
	}

	public double getItemTax3() {
		return itemTax3;
	}

	public void setItemTax3(double itemTax3) {
		this.itemTax3 = itemTax3;
	}

	public int getTotalRegStock() {
		return totalRegStock;
	}

	public void setTotalRegStock(int totalRegStock) {
		this.totalRegStock = totalRegStock;
	}

	public int getSubCatId() {
		return subCatId;
	}

	public void setSubCatId(int subCatId) {
		this.subCatId = subCatId;
	}

	public String getItemImg() {
		return itemImg;
	}

	public void setItemImg(String itemImg) {
		this.itemImg = itemImg;
	}

	@Override
	public String toString() {
		return "NewPosBillItem [id=" + id + ", itemId=" + itemId + ", itemName=" + itemName + ", catId=" + catId
				+ ", mrp=" + mrp + ", rate=" + rate + ", qty=" + qty + ", itemTax1=" + itemTax1 + ", itemTax2="
				+ itemTax2 + ", itemTax3=" + itemTax3 + ", uom=" + uom + ", totalRegStock=" + totalRegStock
				+ ", subCatId=" + subCatId + ", itemImg=" + itemImg + "]";
	}


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
