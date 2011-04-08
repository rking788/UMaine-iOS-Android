package org.umece.android.umaine.sports;

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

public class SportsDisplaySchHockey extends Activity {

	SportsGrabData sgdho = null;
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.sprots_activity_sch_hockey);
		sgdho = new SportsGrabData();
		
		/* Find Tablelayout defined in myTableLayout.xml */
		TableLayout tl = (TableLayout) findViewById(R.id.hoTableLayout);

		List<String>retvalho = sgdho.postEventType("hockey");
		
		int current = 0;
		for (String s : retvalho) {
			current++;
			
			String [] row = s.split(";");

			sgdho.setPostDate(row[0]);
			sgdho.setPostEvent(row[1]);
			sgdho.setPostLocation(row[2]);
			sgdho.setPostTime(row[3]);

			TableRow tr = new TableRow(this);
			tr.setId(current);
			tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
					LayoutParams.FILL_PARENT));

			// Create a TextView to house the name of the province
			TextView labelDate = new TextView(this);
			labelDate.setId(100 + current);
			labelDate.setText(sgdho.getPostDate());
			labelDate.setTextColor(Color.WHITE);
			labelDate.setTextSize(TypedValue.COMPLEX_UNIT_SP,UMSports.TEXT_SIZE);
			labelDate.setGravity(android.view.Gravity.LEFT);
			labelDate.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelDate);

			// Create a TextView to house the value of the after-tax income
			TextView labelEvent = new TextView(this);
			labelEvent.setId(200+current);
			labelEvent.setText(sgdho.getPostEvent());
			labelEvent.setTextColor(Color.WHITE);
			labelEvent.setTextSize(TypedValue.COMPLEX_UNIT_SP,UMSports.TEXT_SIZE);
			labelEvent.setGravity(android.view.Gravity.LEFT);
			labelEvent.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelEvent);

			// Create a TextView to house the name of the province
			TextView labelLocation = new TextView(this);
			labelLocation.setId(300 + current);
			labelLocation.setText(sgdho.getPostLocation());
			labelLocation.setTextColor(Color.WHITE);
			labelLocation.setTextSize(TypedValue.COMPLEX_UNIT_SP,UMSports.TEXT_SIZE);
			labelLocation.setGravity(android.view.Gravity.LEFT);
			labelLocation.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelLocation);

			// Create a TextView to house the value of the after-tax income
			TextView labelTime = new TextView(this);
			labelTime.setId(400+current);
			labelTime.setText(sgdho.getPostTime());
			labelTime.setTextColor(Color.WHITE);
			labelTime.setTextSize(TypedValue.COMPLEX_UNIT_SP,UMSports.TEXT_SIZE);
			labelTime.setGravity(android.view.Gravity.LEFT);
			labelTime.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelTime);

			// Add the TableRow to the TableLayout
			tl.addView(tr, new TableLayout.LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		}
	}
}
