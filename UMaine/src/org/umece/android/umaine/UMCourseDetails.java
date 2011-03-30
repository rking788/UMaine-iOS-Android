package org.umece.android.umaine;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.StyleSpan;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class UMCourseDetails extends Activity {
	/* TODO: Fix ISBN "autolink" problem */
	/* TODO: ECE 210 textbook information not showing up */
	
	/* Dialog Types */
	private static final int DIALOG_CONFIRM_DELETE = 0;
	
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
		/* TODO: isbn is being recognized as a phone number which is wrong */
		TextView title_tv = (TextView) findViewById(R.id.cdetail_title_tv);
		TextView courseinfo_tv = (TextView) findViewById(R.id.cdetails_courseinfo_tv);
		TextView textbookinfo_tv = (TextView) findViewById(R.id.cdetails_tbi_tv);
		TextView instinfo_tv = (TextView) findViewById(R.id.cdetails_ii_tv);
		
		/* Set the course title line */
		String titleline = c.getDep() +  " " + c.getCoursenum() + " - " + c.getTitle();
		title_tv.setText(titleline);
		
		/* Set the course information text */
		Spanned courseinfo = Html.fromHtml(c.getMeetingTime() + "<br/>" + c.getLocation());
		courseinfo_tv.setText(courseinfo);
		
		/* Set the textbook information */
		String bookInfo = c.getBook();
		if((bookInfo == null)||(bookInfo.equals("null"))){
			bookInfo = "Information Unavailable";
		}
		else if(bookInfo.equals("()")){
			bookInfo = "No Textbook";
		}
		
		textbookinfo_tv.setText(bookInfo);
		
		/* Set instructor information */
		Spanned instinfo = Html.fromHtml(c.getInstructor() + "<br/>" + c.getOffice() + "<br/>" + c.getPhone() + "<br/>" + c.getEmail());
		instinfo_tv.setText(instinfo);
	}
	
	private void setButtonHandlers(){
		Button delbtn = (Button) findViewById(R.id.cdetails_delete_btn);
		
		delbtn.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				showDialog(DIALOG_CONFIRM_DELETE);
			}
		});
	}

	@Override
	protected Dialog onCreateDialog(int id) {
		switch(id){
		case DIALOG_CONFIRM_DELETE:
			return new AlertDialog.Builder(this)
			.setMessage("Deleting this course cannot be undone. Do you wish to continue?")
			.setTitle("Confirm Delete")
			.setPositiveButton("Yes", new DialogInterface.OnClickListener(){
				public void onClick(DialogInterface dialog, int id){
					UMCourses.getActivity().removeCourse(selIndex);
					finish();
				}
			})
			.setNegativeButton("No", new DialogInterface.OnClickListener() {
				
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
				}
			})
			.create();
		}

	return null;
	}
}
