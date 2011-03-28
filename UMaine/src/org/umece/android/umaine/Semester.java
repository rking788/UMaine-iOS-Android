package org.umece.android.umaine;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;

public class Semester{

	public static Semester getSemester(String loc, String year, String season, Activity activity) throws IOException {
//		boolean mExternalStorageAvailable = false;
//		boolean mExternalStorageWriteable = false;
//		String state = Environment.getExternalStorageState();
//		File dir = null;

//		if (Environment.MEDIA_MOUNTED.equals(state)) {
//		    // We can read and write the media
//		    mExternalStorageAvailable = mExternalStorageWriteable = true;
//		} else if (Environment.MEDIA_MOUNTED_READ_ONLY.equals(state)) {
//		    // We can only read the media
//		    mExternalStorageAvailable = true;
//		    mExternalStorageWriteable = false;
//		} else {
//		    // Something else is wrong. It may be one of many other states, but all we need
//		    //  to know is we can neither read nor write
//		    mExternalStorageAvailable = mExternalStorageWriteable = false;
//		}
		
//		if (mExternalStorageWriteable) {
//			dir = activity.getExternalFilesDir(null);
//		} else {
//			dir = activity.getFilesDir();
//		}
		
		try {
			return new Semester(loc + year + season + ".sem", activity);
		} catch (Exception e) {
			return new Semester(loc + year + season + ".sem", activity, loc, year, season);
		}
//		if ((dir != null) && (dir.listFiles().length > 0)) {
//			for (File file : dir.listFiles()) {
//				if (file.getName().equalsIgnoreCase(file_name)) {
//					return new Semester(dir.listFiles()[0].getName(), activity);
//				}
//			}
//			return new Semester(file_name, activity, "Orono", "2011", "Fall", "ECE");
//		} else {
//			return new Semester(file_name, activity, "Orono", "2011", "Fall", "ECE");
//		}
	}
	private String campus;
	private String year;
	private String season;
	
	private List<Course> courses;
	private Activity act;

	private String file;
	private ScheduleDrawable sd;

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
		
		int i;
		for (i = 1; i < pieces.length; i++) {
			courses.add(new Course(pieces[i].split("\",\"")));
		}
		
		fis.close();
		sd = null;
	}
	
	/**
	 * Creates an empty semester and the associated file
	 * for storing classes.
	 * 
	 * @param  file  The file to be created to hold semester data.
	 * @param  act  The activity that will be used to open the semester file.
	 * 
	 * @author jmonk
	 */
	public Semester(String file, Activity act, String campus, String year, String season) throws IOException {
		FileOutputStream fos = act.openFileOutput(file, Context.MODE_PRIVATE);
		
		String write_string;
		write_string = campus + "," + year + "," + season;
		
		fos.write(write_string.getBytes());
		
		fos.close();
		
		this.file = file;
		this.act = act;
		this.campus = campus;
		this.season = season;
		this.year = year;
		courses = new ArrayList<Course>();
		sd = null;
	}
	
	public void setScheduleDraw(ScheduleDrawable sd) {
		this.sd = sd;
		sd.setSemester(this);
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
		if (sd != null) {
			sd.onChange();
		}
	}

	public String getCampus() {
		return campus;
	}

	public int getCourseCount(){
		return courses.size();
	}
	
	public Course getCourse(int i) {
		return courses.get(i);
	}

	public Course[] getCourses() {
		Course[] ret = new Course[courses.size()];
		int i = 0;
		
		for (Course course : courses) {
			ret[i++] = course;
		}
		
		return ret;
	}

	public String getFile() {
		return file;
	}

	public String getSeason() {
		return season;
	}

	public String getYear() {
		return year;
	}

	public void remCourse(Course course) throws IOException {
		File f = act.getFileStreamPath(file);
		f.delete();
		f = null;
		
		FileOutputStream fos = act.openFileOutput(file, Context.MODE_PRIVATE);
		
		String write_string;
		write_string = campus + "," + year + "," + season;
		
		fos.write(write_string.getBytes());
		
		fos.close();
		
		List<Course> old_courses = courses;
		courses = new ArrayList<Course>();
		old_courses.remove(course);
		
		for (Course c : old_courses) {
			addCourse(c);
		}
		if (sd != null) {
			sd.onChange();
		}
	}

	public void setCampus(String campus) {
		this.campus = campus;
	}
	
	public void setCourses(List<Course> courses) {
		this.courses = courses;
	}
	
	public void setSeason(String season) {
		this.season = season;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public int size() {
		return courses.size();
	}

	public Course getCourse(String item) {
		for (Course course : courses) {
			if (course.getString().equals(item)) {
				return course;
			}
		}
	
		return null;
	}

	public void delete() {
		act.deleteFile(file);
	}
}
