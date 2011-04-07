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

public class SportsDisplaySchOthers extends Activity {

	SportsGrabData sgdot = null;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.sprots_activity_sch_others);
		
		sgdot = new SportsGrabData();

		/* Find Tablelayout defined in myTableLayout.xml */
		TableLayout tlot = (TableLayout) findViewById(R.id.otTableLayout);

		// String[] testData = { "hello1", "hello2", "hello3", "hello4",
		// "hello5","asdf","sadfa","dasfalsfje","143243","adfsa0832","dafadsfadsfoiehfoihfage","dafewfj;eljfa","000","10"
		// };

		List<String> retvalot = sgdot.postEventType("other");

		int current = 0;
		for (String s : retvalot) {
			current++;

			String[] row = s.split(";");

			sgdot.setPostDate(row[0]);
			sgdot.setPostEvent(row[1]);
			sgdot.setPostLocation(row[2]);
			sgdot.setPostTime(row[3]);
			/*
			 * }
			 * 
			 * // for (int current = 0; current < sgd.getRow().length;
			 * current++) {
			 */
			// Create a TableRow and give it an ID
			TableRow tr = new TableRow(this);
			tr.setId(current);
			tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
					LayoutParams.FILL_PARENT));

			// Create a TextView to house the name of the province
			TextView labelDate = new TextView(this);
			labelDate.setId(100 + current);
			labelDate.setText(sgdot.getPostDate());
			labelDate.setTextColor(Color.WHITE);
			labelDate.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelDate.setGravity(android.view.Gravity.LEFT);
			labelDate.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelDate);

			// Create a TextView to house the value of the after-tax income
			TextView labelEvent = new TextView(this);
			labelEvent.setId(200 + current);
			labelEvent.setText(sgdot.getPostEvent());
			labelEvent.setTextColor(Color.WHITE);
			labelEvent.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelEvent.setGravity(android.view.Gravity.LEFT);
			labelEvent.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelEvent);

			// Create a TextView to house the name of the province
			TextView labelLocation = new TextView(this);
			labelLocation.setId(300 + current);
			labelLocation.setText(sgdot.getPostLocation());
			labelLocation.setTextColor(Color.WHITE);
			labelLocation.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelLocation.setGravity(android.view.Gravity.LEFT);
			labelLocation.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelLocation);

			// Create a TextView to house the value of the after-tax income
			TextView labelTime = new TextView(this);
			labelTime.setId(400 + current);
			labelTime.setText(sgdot.getPostTime());
			labelTime.setTextColor(Color.WHITE);
			labelTime.setTextSize(TypedValue.COMPLEX_UNIT_SP,
					UMSports.TEXT_SIZE);
			labelTime.setGravity(android.view.Gravity.LEFT);
			labelTime.setLayoutParams(new LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
			tr.addView(labelTime);

			// Add the TableRow to the TableLayout
			tlot.addView(tr, new TableLayout.LayoutParams(
					LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		}
	}
}
