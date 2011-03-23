package org.umece.android.umaine;

import android.app.Activity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.StyleSpan;
import android.text.util.Linkify;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class UMCourseDetails extends Activity {
	
	/* TODO ROB: Textbook information Professor contact info. */
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
		/* TODO: Set a custom filter or something to add links to the email address in the contact info */
		TextView title_tv = (TextView) findViewById(R.id.cdetail_title_tv);
		TextView details_tv = (TextView) findViewById(R.id.cdetails_tv);
		
		String titleline = c.getDep() +  " " + c.getCoursenum() + " - " + c.getTitle();
		title_tv.setText(titleline);
		
		String details = "\t" + c.getMeetingTime() + "\n\t" + c.getLocation() + "\n\t" + "Textbook:" + "\n\t\t" + c.getBook() +
							"\n\t" + "Instructor:" + "\n\t\t" + c.getInstructor() + "\n\t\t" + c.getOffice() + "\n\t\t" + 
							c.getPhone() + "\n\t\t" + c.getEmail();
		int beginBoldINST = details.indexOf("Instructor");
		int beginBoldTB = details.indexOf("Textbook:");
		SpannableStringBuilder ssb = new SpannableStringBuilder(details);
		ssb.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), beginBoldINST, (beginBoldINST + 11), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		ssb.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), beginBoldTB, (beginBoldTB + 9), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		Linkify.addLinks(ssb, Linkify.PHONE_NUMBERS|Linkify.EMAIL_ADDRESSES);
		details_tv.setText(ssb);
	}
	
	private void setButtonHandlers(){
		Button delbtn = (Button) findViewById(R.id.cdetails_delete_btn);
		
		delbtn.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				/* TODO ROB: Prompt the user with a dialog to make sure they really want to remove the course */
				UMCourses.getActivity().removeCourse(selIndex);
				finish();
			}
		});
	}
}
