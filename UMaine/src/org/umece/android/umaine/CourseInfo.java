package org.umece.android.umaine;

import java.util.ArrayList;
import java.util.List;

public class CourseInfo {
	private String campus;
	private String year;
	private String season;
	private String department;
	
	private List<Course> courses;
	
	public CourseInfo(){
		this.setCourses(new ArrayList<Course>());
	}

	public void setCampus(String campus) {
		this.campus = campus;
	}

	public String getCampus() {
		return campus;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getYear() {
		return year;
	}

	public void setSeason(String season) {
		this.season = season;
	}

	public String getSeason() {
		return season;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getDepartment() {
		return department;
	}

	public void setCourses(List<Course> courses) {
		this.courses = courses;
	}

	public List<Course> getCourses() {
		return courses;
	}
}
