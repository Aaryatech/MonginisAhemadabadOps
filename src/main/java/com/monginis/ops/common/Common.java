package com.monginis.ops.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

public class Common {

	// public static ArrayList<Menu>menuList;

	public static java.sql.Date stringToSqlDate(String date) {
		java.sql.Date sqlDate = null;
		try {
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date utilDate;

			utilDate = sdf1.parse(date);
			sqlDate = new java.sql.Date(utilDate.getTime());

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sqlDate;

	}

	public static void sendTextMessage(int i, String cName, String frName, String string, String string2,
			float grandTotal, String string3, String cPhone) {
		// TODO Auto-generated method stub
		
	}

}