package org.umece.android.umaine.sports;

import java.util.Date;
import java.util.List;
import org.umece.android.umaine.R;
import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.util.TypedValue;
import android.widget.TableRow.LayoutParams;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class SportsDisplaySchAll extends Activity {

	SportsGrabData sgd = null;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.sprots_activity_sch_all);

		sgd = new SportsGrabData();

		/* Find Tablelayout defined in myTableLayout.xml */
		TableLayout tl = (TableLayout) findViewById(R.id.myTableLayout);

		List<String> retval = sgd.postEventType("all");

		int current = 0;
		for (String s : retval) {
			current++;

			String[] row = s.split(";");

			sgd.setPostDate(row[0]);
			sgd.setPostEvent(row[1]);
			sgd.setPostLocation(row[2]);
			sgd.setPostTime(row[3]);
			
			TableRow tr = new TableRow(this);
			
			/* *
			 * check the sgd.getPostDate() 
			 * if the schedule is coming, set the row the textColor Color.BLACK 
			 * if the schedule has done, set the row textColor as R.color.maine_lightblue
			 * 
			 */
			
			Date date = new Date();
			TextView labelDate = new TextView(this);
			TextView labelEvent = new TextView(this);
			TextView labelLocation = new TextView(this);
			TextView labelTime = new TextView(this);
			
			/*String temp0 = sgd.getPostDate();
			int temp1 = (int)sgd.getPostDate().charAt(0);
			int temp2 = (int)sgd.getPostDate().charAt(1);
			*/
			
			String[] dateSplit = null ;
//			String str = null;
			if (!sgd.getPostDate().contains("-")){
				dateSplit = sgd.getPostDate().split("/");
			}
			else {
				String str2 = sgd.getPostDate().substring(sgd.getPostDate().indexOf("-"));
				dateSplit = str2.split("/");
			}
			
			int tempMonth = Integer.parseInt(dateSplit[0]);
			int tempDay = Integer.parseInt(dateSplit[1]);
			/*String[] dateSplit = sgd.getPostDate().split("/");
			int tempMonth = Integer.parseInt(dateSplit[0]);
			int tempDay = Integer.parseInt(dateSplit[1]);*/
			/*int tempMonth = sgd.getPostDate().charAt(0)+sgd.getPostDate().charAt(1);
			int tempDay = sgd.getPostDate().charAt(3)+sgd.getPostDate().charAt(4);*/
			
			if (((date.getMonth())>tempMonth) && (date.getDay()>tempDay)){
				labelDate.setTextColor(R.color.maine_lightblue);
				labelEvent.setTextColor(R.color.maine_lightblue);
				labelLocation.setTextColor(R.color.maine_lightblue);
				labelTime.setTextColor(R.color.maine_lightblue);
				
			}
			else{
				labelDate.setTextColor(Color.BLACK);
				labelEvent.setTextColor(Color.BLACK);
				labelLocation.setTextColor(Color.BLACK);
				labelTime.setTextColor(Color.BLACK);
			}
			
			
			

			// Create a TextView to house the name of the province
			
			labelDate.setId(100 + current);
			labelDate.setText(sgd.getPostDate());
			//labelDate.setTextColor(Color.BLACK);
//			labelDate.setTextColor(R.color.maine_lightblue);
			labelDate.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelDate.setGravity(android.view.Gravity.LEFT);
			labelDate.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			

			// Create a TextView to house the value of the after-tax income
			
			labelEvent.setId(200 + current);
			labelEvent.setText(sgd.getPostEvent());
//			labelEvent.setTextColor(Color.BLACK);
			labelEvent.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelEvent.setGravity(android.view.Gravity.LEFT);
			labelEvent.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			

			// Create a TextView to house the name of the province
			
			labelLocation.setId(300 + current);
			labelLocation.setText(sgd.getPostLocation());
//			labelLocation.setTextColor(Color.BLACK);
			labelLocation.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelLocation.setGravity(android.view.Gravity.LEFT);
			labelLocation.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			

			// Create a TextView to house the value of the after-tax income
			
			labelTime.setId(400 + current);
			labelTime.setText(sgd.getPostTime());
//			labelTime.setTextColor(Color.BLACK);
			labelTime.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelTime.setGravity(android.view.Gravity.LEFT);
			labelTime.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		

			// set the table
			tr.setId(current);
			tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
					LayoutParams.FILL_PARENT));
			tr.addView(labelDate);
			tr.addView(labelEvent);
			tr.addView(labelLocation);
			tr.addView(labelTime);
			
			// Add the TableRow to the TableLayout
			tl.addView(tr, new TableLayout.LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		}
	}

}
