package org.umece.android.umaine;

import android.content.Context;
import android.text.Spannable;
import android.text.style.ForegroundColorSpan;
import android.widget.EditText;

public class Course {
	private String dep;
	private String coursenum;
	private String title;
	private String sessionnum;
	private String description;
	private String meetingtime;
	private String location;
	private String inst;
	private String phone;
	private String email;
	private String office;
	private String departURL;
	private String staffURL;
	private String book;
	private Spannable spannable;
	private Color color;
	
	/**
	 * Creates a course to be added to a semester.
	 * 
	 * @param cnum Course Number
	 * @param ctitle Title
	 * @param csession Session Number
	 * @param cdesc Description
	 * @param cdays Course Meeting Days
	 * @param ctimes Course Times
	 * @param cbuilding Course Location
	 * @param croomnum Course Room
	 * 
	 * @author jmonk
	 */
	public Course(String cdep, String cnum, String ctitle, String csession, String cdesc, 
			String cmeetingtime, String clocation, String cinst, String cphone, String cemail, 
			String coffice, String cdeparturl, String cstaffurl, String cbook) {
		dep = cdep;
		coursenum = cnum;
		title = ctitle;
		sessionnum = csession;
		description = cdesc;
		meetingtime = cmeetingtime;
		location = clocation;
		inst = cinst;
		phone = cphone;
		email = cemail;
		office = coffice;
		departURL = cdeparturl;
		staffURL = cstaffurl;
		book = cbook;
	}
	

	/**
	 * Creates a course from the comma separated list found in each
	 * semester's file. Throws exception if strings is not at least length
	 * 8.
	 * 
	 * @param strings Course info in the following order: course_num, title,
	 *					session_num, description, days, times, building, 
	 *					room_num.
	 *
	 * @author jmonk
	 */
	public Course(String[] strings) {		
		dep = strings[0].replaceAll("\"", "");
		coursenum = strings[1];
		title = strings[2];
		sessionnum = strings[3];
		description = strings[4];
		meetingtime = strings[5];
		location = strings[6];
		inst = strings[7];
		phone = strings[8];
		email = strings[9];
		office = strings[10];
		departURL = strings[11];
		staffURL = strings[12];
		book = strings[11].replaceAll("\"", "");
	}
	
	/**
	 * Returns all of the fields of the course separated by |.
	 * They are listed in the following order: course_num, title,
	 *					session_num, description, days, times, building, 
	 *					room_num.
	 *
	 * @author jmonk
	 */
	@Override
	public String toString() {
		String return_val;
		
		return_val = "\"" + dep + "\",\"";
		return_val = (return_val + coursenum + "\",\"");
		return_val = (return_val + title + "\",\"");
		return_val = (return_val + sessionnum + "\",\"");
		return_val = (return_val + description + "\",\"");
		return_val = (return_val + meetingtime + "\",\"");
		return_val = (return_val + location + "\",\"");
		return_val = (return_val + inst + "\",\"");
		return_val = (return_val + phone + "\",\"");
		return_val = (return_val + email + "\",\"");
		return_val = (return_val + office + "\",\"");
		return_val = (return_val + departURL + "\",\"");
		return_val = (return_val + staffURL + "\",\"");
		return_val = (return_val + book + "\"");
		
		return return_val;
	}
	
	public void setColor(Color color) {
		this.color = color;
		this.spannable = null;
	}
	
	public String getString() {
		return getDep() + " " + getCoursenum()+ " - " + getTitle();
	}
	
	public void createSpannable(Context context) {
		if (context == null) return;
		EditText newet = new EditText(context);
        newet.setText(getDep() + " " + getCoursenum()+ " - " + getTitle());
        Spannable str = newet.getText();
        
        if (color != null) {
        	str.setSpan(new ForegroundColorSpan(color.getColor()), 0, 
        			str.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        }

        spannable = str;
	}
	
	public void addNotification() {
		
	}
	
	public Spannable getSpannable(Context context) {
		if (spannable != null) return spannable;
		
		createSpannable(context);
        return spannable;
	}
	
	public String getDep(){
		return dep;
	}

	public String getCoursenum() {
		return coursenum;
	}
	
	public String getTitle() {
		return title;
	}
	
	public String getSessionnum() {
		return sessionnum;
	}
	
	public String getDescription() {
		return description;
	}
	
	public String getMeetingTime() {
		return meetingtime;
	}
	
	public String getLocation() {
		return location;
	}
	
	public String getInstructor(){
		return inst;
	}
	
	public String getPhone(){
		return phone;
	}
	
	public String getEmail(){
		return email;
	}
	
	public String getOffice(){
		return office;
	}
	
	public String getDepartURL(){
		return departURL;
	}
	
	public String getStaffURL(){
		return staffURL;
	}
	
	public String getBook(){
		return book;
	}

	public int getColor() {
		if (color != null) {
			return color.getColor();
		} else {
			return Color.getColor("BLACK").getColor();
		}
	}
}
