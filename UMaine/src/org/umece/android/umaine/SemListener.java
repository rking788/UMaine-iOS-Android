package org.umece.android.umaine;

import android.app.AlertDialog;
import android.content.DialogInterface;

public class SemListener implements
		android.content.DialogInterface.OnClickListener {
	public void onClick(DialogInterface dialog, int which) {
		int index = ((AlertDialog) dialog).getListView()
				.getCheckedItemPosition();
		UMCourses courses = UMCourses.getActivity();
		courses.setSemester(courses.getSemAdapter().getItem(index).toString());
		courses.saveSelectedSemester(courses.getSemAdapter().getItem(index).toString());
	}

}
