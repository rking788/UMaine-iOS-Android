package org.umece.android.umaine;


import org.umece.android.umaine.sports.UMSports;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;

public class UMaine extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        /* Set up the listener for the course schedule button */
        Button coursesbtn = (Button) findViewById(R.id.coursesbtn);
        coursesbtn.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				Intent myIntent = new Intent(v.getContext(), UMCourses.class);
				startActivityForResult(myIntent, 0);
			}
		});
        
        /* Set up the listener for the parking button */
        /*ImageButton parkingbtn = (ImageButton) findViewById(R.id.parkingbtn);*/
        Button parkingbtn = (Button) findViewById(R.id.parkingbtn);
        parkingbtn.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				Intent myIntent = new Intent(v.getContext(), UMMap.class);
				startActivityForResult(myIntent, 0);
			}
    	});
        
        /* Set up the listener for the sports button */
        Button sportsbtn = (Button) findViewById(R.id.sportsbtn);
        sportsbtn.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				Intent myIntent = new Intent(v.getContext(), UMSports.class);
				startActivityForResult(myIntent, 0);
			}
		});
        
        /* Set up the listener for the directory button */
        Button dirbtn = (Button) findViewById(R.id.directorybtn);
        dirbtn.setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View v) {
				Intent myIntent = new Intent(v.getContext(), UMDirectory.class);
				startActivityForResult(myIntent, 0);
			}
		});
    }
}