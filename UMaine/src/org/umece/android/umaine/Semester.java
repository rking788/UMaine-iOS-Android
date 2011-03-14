package org.umece.android.umaine;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;

public class Semester {
	private String campus;
	private String year;
	private String season;
	private String department;
	
	private List<Course> courses;
	private Activity act;
	private String file;

	/**
	 * Creates an empty semester and the associated file
	 * for storing classes.
	 * 
	 * @param  file  The file to be created to hold semester data.
	 * @param  act  The activity that will be used to open the semester file.
	 * 
	 * @author jmonk
	 */
	public Semester(String file, Activity act, String campus, String year, String season, String department) throws IOException {
		FileOutputStream fos = act.openFileOutput(file, Context.MODE_PRIVATE);
		
		String write_string;
		write_string = campus + "," + year + "," + season + "," + department;
		
		fos.write(write_string.getBytes());
		
		fos.close();
		
		this.file = file;
		this.act = act;
		this.campus = campus;
		this.department = department;
		this.season = season;
		this.year = year;
		courses = new ArrayList<Course>();
	}

	/**
	 * Creates a semester loading data from an existing file.
	 * The file must exist already
	 * 
	 * @param  file  The full path to file that will be opened.
	 * @param  act  The activity that will be used to open the file, reused upon adding of classes.
	 * 
	 * @author jmonk
	 */
	public Semester(String file, Activity act) throws IOException {
		this.setCourses(new ArrayList<Course>());
		this.file = file;
		this.act = act;
		
		FileInputStream fis = act.openFileInput(file);
		byte[] bytes = new byte[200];
		String read = new String();
		int len;
		while ((len = fis.read(bytes)) != -1) {
			read = (read + new String(bytes, 0, len));
		}
		
		String pieces[] = read.split(";");
		String line[] = pieces[0].split(",");
		campus = line[0];
		year = line[1];
		season = line[2];
		department = line[3];
		
		int i;
		for (i = 1; i < pieces.length; i++) {
			courses.add(new Course(pieces[i].split("\",\"")));
		}
		
		fis.close();
	}

	public String getFile() {
		return file;
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
	
	public int size() {
		return courses.size();
	}

	public Course getCourse(int i) {
		return courses.get(i);
	}
	
	/**
	 * This adds a course to semester's file then to its local list of courses.
	 * If an exception is thrown then the course is not added to the semester.
	 * 
	 * @param new_course Course to be added to the semester, cannot be modified once added.
	 * 
	 * @throws IOException IOExceptions are thrown if the file cannot be opened or cannot be appended to.
	 * 
	 * @author jmonk
	 */
	public void addCourse(Course new_course) throws IOException {
		FileOutputStream fos = act.openFileOutput(file, Context.MODE_APPEND);
		
		fos.write((";" + new_course.toString()).getBytes());
		
		fos.close();
		
		courses.add(new_course);
	}
}
