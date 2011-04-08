package org.umece.android.umaine;

import java.util.List;

public class Contact {
	private String name;
	private String office;
	private String department;
	private String email;
	private String title;
	private String number;
	private String website;
	private String dept_website;
	
	public Contact() {
		name = "John Smith";
		office = "101 Barrows Hall";
		department = "Electrical and Computer Engineering";
		number = "(207) 581-2247";
		email = "jason.monk@maine.edu";
		title = "Nothing";
		dept_website = "www.google.ca";
		website = "www.google.com";
	}
	
	public Contact(String name, List<String> list) {
		this.name = name;
		department = list.get(0);
		title = list.get(1);
		number = list.get(2);
		email = list.get(3);
		office = list.get(4);
		dept_website = list.get(5);
		website = list.get(6);
	}
	
	public String getDeptWebsite() {
		return dept_website;
	}
	
	public String getWebsite() {
		return website;
	}
	
	public String getName() {
		return name;
	}
	
	public String getOffice() {
		return office;
	}
	
	public String getDepartment() {
		return department;
	}
	
	public String getNumber() {
		return number;
	}
	
	public String getEmail() {
		return email;
	}
	
	public String getTitle() {
		return title;
	}

}
