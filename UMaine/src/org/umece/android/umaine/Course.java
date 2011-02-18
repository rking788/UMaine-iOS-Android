package org.umece.android.umaine;

public class Course {
	private String coursenum;
	private String title;
	private String sessionnum;
	private String description;
	private String days;
	private String times;
	private String building;
	private String roomnum;

	public void setCoursenum(String coursenum) {
		this.coursenum = coursenum;
	}
	
	public String getCoursenum() {
		return coursenum;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setSessionnum(String sessionnum) {
		this.sessionnum = sessionnum;
	}
	
	public String getSessionnum() {
		return sessionnum;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDays(String days) {
		this.days = days;
	}
	
	public String getDays() {
		return days;
	}
	
	public void setTimes(String times) {
		this.times = times;
	}
	
	public String getTimes() {
		return times;
	}
	
	public void setBuilding(String building) {
		this.building = building;
	}
	
	public String getBuilding() {
		return building;
	}
	
	public void setRoomnum(String roomnum) {
		this.roomnum = roomnum;
	}
	
	public String getRoomnum() {
		return roomnum;
	}
}
