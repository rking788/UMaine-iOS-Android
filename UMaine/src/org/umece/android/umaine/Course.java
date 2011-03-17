package org.umece.android.umaine;

import android.content.Context;
import android.text.Spannable;
import android.widget.EditText;

public class Course {
	private String dep;
	private String coursenum;
	private String title;
	private String sessionnum;
	private String description;
	private String meetingtime;
	private String building;
	private String roomnum;
	private Spannable spannable;
	
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
			String cmeetingtime, String cbuilding, String croomnum) {
		dep = cdep;
		coursenum = cnum;
		title = ctitle;
		sessionnum = csession;
		description = cdesc;
		meetingtime = cmeetingtime;
		building = cbuilding;
		roomnum = croomnum;
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
		building = strings[6];
		roomnum = strings[7].replaceAll("\"", "");
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
		return_val = (return_val + building + "\",\"");
		return_val = (return_val + roomnum + "\"");
		
		return return_val;
	}
	
	public Spannable getSpannable(Context context) {
		if (spannable != null) return spannable;
		if (context == null) return null;
		EditText newet = new EditText(context);
        newet.setText(getDep() + " " + getCoursenum()+ " - " + getTitle());
        Spannable str = newet.getText();
//        str.setSpan(new StyleSpan(android.graphics.Typeface.ITALIC), 0, str.length()-1, 
//        			Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        
        spannable = str;
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
	
	public String getBuilding() {
		return building;
	}
	
	public String getRoomnum() {
		return roomnum;
	}
}
