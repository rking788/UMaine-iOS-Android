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

public class SportsDisplaySchHockey extends Activity {
	// public static String results = "bbbbbbbbbbbbb";

	// TextView textView;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.sprots_activity_sch_hockey);

		TextView textView = (TextView) findViewById(R.id.text_view_hockey);

		textView.setText("test1 hockey");

//		setContentView(textView);
	}
}
