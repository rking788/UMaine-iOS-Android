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

public class SportsDisplaySchBasketball extends Activity {
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.sprots_activity_sch_basketball);
/*
		 Find Tablelayout defined in main.xml 
		TableLayout tl = (TableLayout) findViewById(R.id.myTableLayoutBasketball);
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
				LayoutParams.WRAP_CONTENT));*/
		

		TextView textView = (TextView) findViewById(R.id.text_view);
		
		textView.setText("test1");
		

	}
}
