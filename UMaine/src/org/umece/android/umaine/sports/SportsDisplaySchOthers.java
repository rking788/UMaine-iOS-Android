package org.umece.android.umaine.sports;

import org.umece.android.umaine.R;
import org.umece.android.umaine.R.id;
import org.umece.android.umaine.R.layout;

import android.app.Activity;
import android.os.Bundle;
import android.view.ViewGroup.LayoutParams;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

public class SportsDisplaySchOthers extends Activity {
	// public static String results = "bbbbbbbbbbbbb";

	// TextView textView;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.sprots_activity_sch_others);

		/*
		 * Find Tablelayout defined in main.xml TableLayout tl = (TableLayout)
		 * findViewById(R.id.myTableLayoutOthers); Create a new row to be added.
		 * TableRow tr = new TableRow(this); tr.setLayoutParams(new
		 * LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		 * Create a Button to be the row-content. TextView textView = new
		 * TextView(this); textView.setText("Dynamic text");
		 * textView.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
		 * LayoutParams.WRAP_CONTENT)); Add Button to row. tr.addView(textView);
		 * Add row to TableLayout. tl.addView(tr, new
		 * TableLayout.LayoutParams(LayoutParams.FILL_PARENT,
		 * LayoutParams.WRAP_CONTENT));
		 */

		TextView textView = (TextView) findViewById(R.id.text_view_others);

		textView.setText("test1 others");

//		setContentView(textView);
		
		
		////
	       
	       
		/*
		 * setContentView(R.layout.sprots_activity_sch_all);
		 * 
		 * textView = (TextView) findViewById(R.id.text_view);
		 * 
		 * //textView.setText(showResults()); textView.setText("test1");
		 * 
		 * TableLayout tl=new TableLayout(this);
		 * 
		 * TableRow tr=new TableRow(this);
		 * 
		 * //for (int i = 0; i < R; i++){}
		 * 
		 * TextView textView1 = new TextView(this);
		 * textView1.setText("Hello all");
		 * 
		 * tr.addView(textView1,0); tr.addView(textView1,1);
		 * tr.addView(textView1,2); tr.addView(textView1,3);
		 * tr.addView(textView1,4);
		 * 
		 * tl.addView(tr,0); tl.addView(tr,1); tl.addView(tr,2);
		 * 
		 * setContentView(tl);
		 */
/*
		this.setContentView(R.layout.sprots_activity_sch_all);

		 Find Tablelayout defined in main.xml 
		TableLayout tl = (TableLayout) findViewById(R.id.myTableLayoutAll);
		 Create a new row to be added. 
		TableRow tr = new TableRow(this);
		tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT));
		 Create a Button to be the row-content. 
		TextView textView = new TextView(this);
		textView.setText("Dynamic text");
		textView.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT));
		 Add Button to row. 
		tr.addView(textView);
		 Add row to TableLayout. 
		tl.addView(tr, new TableLayout.LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.WRAP_CONTENT));
		
		TextView textView = (TextView) findViewById(R.id.text_view_all);
		
		textView.setText("test1 all");
		
//		setContentView(textView);
*/
		

		/*
		 * Create a new row to be added. TableRow tr = new TableRow(this);
		 * tr.setLayoutParams(new LayoutParams(LayoutParams.FILL_PARENT,
		 * LayoutParams.WRAP_CONTENT));
		 * 
		 * 
		 * Create a TextView to be the row-content. TextView[] textView = new
		 * TextView[5]; for (int i =0; i < 5; i++){
		 * textView[i].setText("Dynamic Button"+i);
		 * textView[i].setLayoutParams(new
		 * LayoutParams(LayoutParams.FILL_PARENT, LayoutParams.WRAP_CONTENT));
		 * Add Button to row. tr.addView(textView[i]); }
		 * 
		 * 
		 * Add row to TableLayout. tl.addView(tr, new
		 * TableLayout.LayoutParams(LayoutParams.FILL_PARENT,
		 * LayoutParams.WRAP_CONTENT));
		 */

	}
}
