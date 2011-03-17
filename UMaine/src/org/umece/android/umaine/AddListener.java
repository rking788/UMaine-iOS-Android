package org.umece.android.umaine;

import android.content.DialogInterface;

public class AddListener implements android.content.DialogInterface.OnClickListener {
	public void onClick(DialogInterface dialog, int which) {
		UMCourses courses = UMCourses.getActivity();
		
		String department = courses.getDepartSpin();
		String coursenum = courses.getCoursesSpin();
		String section = courses.getSectionSpin();
		
		courses.addCourse(department, coursenum, section);
	}

}
