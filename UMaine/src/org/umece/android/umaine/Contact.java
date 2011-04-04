package org.umece.android.umaine;

public class Contact {
	private String name;
	private String office;
	private String department;
	private String email;
	private String title;
	private String number;
	
	public Contact() {
		name = "John Smith";
		office = "101 Barrows Hall";
		department = "Electrical and Computer Engineering";
		number = "(207) 581-2247";
		email = "jason.monk@maine.edu";
		title = "Nothing";
	}
	
	public Contact(String name, String values[]) {
		this.name = name;
		department = values[0];
		title = values[1];
		number = values[2];
		email = values[3];
		office = values[4];
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
