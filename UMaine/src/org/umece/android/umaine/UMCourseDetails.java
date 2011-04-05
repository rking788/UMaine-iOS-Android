package org.umece.android.umaine;

import java.util.Arrays;
import java.util.List;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.text.Spanned;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

public class UMCourseDetails extends Activity {
	
	/* Dialog Types */
	private static final int DIALOG_CONFIRM_DELETE = 0;
	
	private int selIndex;
	private Semester sem;
	private int courseBuildingLat;
	private int courseBuildingLong;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.coursedetails);
		
		/* Retrieve the data from the previous activity */
		sem = UMCourses.getActivity().getSemester();
		Bundle extras = getIntent().getExtras();
		selIndex = extras.getInt("selectedindex");
	
		populateCourseDetails(sem.getCourse(selIndex));
		
		findCourseCoords(sem.getCourse(selIndex));
		
		setButtonHandlers();
	}
	
	private void populateCourseDetails(Course c){
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
		else if(bookInfo.equals(" ()")){
			bookInfo = "No Textbook";
		}
		
		textbookinfo_tv.setText(bookInfo);
		
		/* Set instructor information */
		Spanned instinfo = Html.fromHtml(c.getInstructor() + "<br/>" + c.getOffice() + "<br/>" + c.getPhone() + "<br/>" + c.getEmail());
		instinfo_tv.setText(instinfo);
	}
	
	private void findCourseCoords(Course c){
		/* Find the coordinates for the course meeting location, to be used if they 
		 * press the "map it" button 
		 */
		String[] campusBuildings = getResources().getStringArray(R.array.building_names);
		List<String> buildingList = Arrays.asList(campusBuildings);
		String buildingName = c.getLocation();
		
		/* Replace spaces with underscores */
		buildingName = buildingName.replaceAll(" \\d+", "");
		buildingName = buildingName.replace(' ', '_');
		buildingName = buildingName.toLowerCase();
		
		if(buildingList.contains(buildingName)){
			int index = buildingList.indexOf(buildingName);
			courseBuildingLat = getResources().getIntArray(R.array.building_latitude)[index];
			courseBuildingLong = getResources().getIntArray(R.array.building_longitude)[index];
		}
		else{
			courseBuildingLat = -1;
			courseBuildingLong = -1;
			((Button) findViewById(R.id.cdetails_map_btn)).setEnabled(false);
		}
	}
	
	private void setButtonHandlers(){
		Button delbtn = (Button) findViewById(R.id.cdetails_delete_btn);
		Button mapbtn = (Button) findViewById(R.id.cdetails_map_btn);
		
		delbtn.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				showDialog(DIALOG_CONFIRM_DELETE);
			}
		});
		
		mapbtn.setOnClickListener(new OnClickListener(){

			public void onClick(View v) {
				Intent myIntent = new Intent(v.getContext(), UMMap.class);
				myIntent.putExtra("lat", courseBuildingLat);
				myIntent.putExtra("longitude", courseBuildingLong);
				myIntent.putExtra("buildingname", "Bennett Hall");
				startActivity(myIntent);
				finish();
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
