package org.umece.android.umaine;

import android.app.Activity;
import android.os.Bundle;
import android.text.SpannableStringBuilder;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class UMCourseDetails extends Activity {
	
	private int selIndex;
	private Semester sem;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.coursedetails);
		
		/* Retrieve the data from the previous activity */
		sem = UMCourses.getActivity().getSemester();
		Bundle extras = getIntent().getExtras();
		selIndex = extras.getInt("selectedindex");
	
		populateCourseDetails(sem.getCourse(selIndex));
		
		setButtonHandlers();
	}
	
	private void populateCourseDetails(Course c){
		/* TODO: Add textbook information */
		/* TODO: Add instructor once it is added to the course class */
		TextView title_tv = (TextView) findViewById(R.id.cdetail_title_tv);
		TextView details_tv = (TextView) findViewById(R.id.cdetails_tv);
		
		String titleline = c.getDep() +  " " + c.getCoursenum() + " - " + c.getTitle();
		title_tv.setText(titleline);
		
		String details = "\t" + c.getMeetingTime() + "\n\t" + c.getLocation() + "\n\t" + c.getInstructor();
		SpannableStringBuilder ssb = new SpannableStringBuilder(details);
		details_tv.setText(ssb);
	}
	
	private void setButtonHandlers(){
		Button delbtn = (Button) findViewById(R.id.cdetails_delete_btn);
		
		delbtn.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				UMCourses.getActivity().removeCourse(selIndex);
				finish();
			}
		});
	}
}
