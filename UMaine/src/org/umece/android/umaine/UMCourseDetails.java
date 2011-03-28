package org.umece.android.umaine;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
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
		TextView details_tv = (TextView) findViewById(R.id.cdetails_tv);
		
		String titleline = c.getDep() +  " " + c.getCoursenum() + " - " + c.getTitle();
		title_tv.setText(titleline);
		String bookInfo = c.getBook();
		if((bookInfo == null)||(bookInfo.equals("null"))){
			bookInfo = "Information Unavailable";
		}
		else if(bookInfo.equals("()")){
			bookInfo = "No Textbook";
		}
		
		String details = "\t" + c.getMeetingTime() + "\n\t" + c.getLocation() + "\n\t" + "Textbook:" + "\n\t\t" + bookInfo +
							"\n\t" + "Instructor:" + "\n\t\t" + c.getInstructor() + "\n\t\t" + c.getOffice() + "\n\t\t" + 
							c.getPhone() + "\n\t\t" + c.getEmail();
		int beginBoldINST = details.indexOf("Instructor");
		int beginBoldTB = details.indexOf("Textbook:");
		SpannableStringBuilder ssb = new SpannableStringBuilder(details);
		ssb.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), beginBoldINST, (beginBoldINST + 11), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		ssb.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), beginBoldTB, (beginBoldTB + 9), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
		details_tv.setText(ssb);
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
