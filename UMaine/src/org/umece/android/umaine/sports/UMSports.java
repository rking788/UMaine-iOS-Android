package org.umece.android.umaine.sports;

import org.umece.android.umaine.R;
import org.umece.android.umaine.R.drawable;
import org.umece.android.umaine.R.id;
import org.umece.android.umaine.R.layout;

import android.app.ActivityGroup;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.TabHost.TabSpec;

public class UMSports extends ActivityGroup {

	public static final int TEXT_SIZE = 10;

	public static TabHost tab_host;
	public static final int update = Menu.FIRST;
	public static final int help = Menu.FIRST + 1;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.sprots_activity_sch_main);

		TabHost tab_host = (TabHost) findViewById(R.id.sports_tab_host);
		tab_host.setup(this.getLocalActivityManager());

		TabSpec ts1 = tab_host.newTabSpec("all_sch");
		ts1.setIndicator(("All Sch"),
			getResources().getDrawable(R.drawable.sports_all_sch));
		Intent in1 = new Intent(this, SportsDisplaySchAll.class);
		ts1.setContent(in1);
		tab_host.addTab(ts1);

		TabSpec ts2 = tab_host.newTabSpec("hockey_sch");
		ts2.setIndicator(("Hockey"),
				getResources().getDrawable(R.drawable.sports_hockey_sch));
		Intent in2 = new Intent(this, SportsDisplaySchHockey.class);
		ts2.setContent(in2);
		tab_host.addTab(ts2);

		TabSpec ts3 = tab_host.newTabSpec("basketball_sch");
		ts3.setIndicator(("Basketball"),
				getResources().getDrawable(R.drawable.sports_basketball_sch));
		Intent in3 = new Intent(this, SportsDisplaySchBasketball.class);
		ts3.setContent(in3);
		tab_host.addTab(ts3);

		TabSpec ts4 = tab_host.newTabSpec("others_sch");
		ts4.setIndicator(("Others"),
				getResources().getDrawable(R.drawable.sports_others_sch));
		Intent in4 = new Intent(this, SportsDisplaySchOthers.class);
		ts4.setContent(in4);
		tab_host.addTab(ts4);

		tab_host.setCurrentTab(0);

	}

	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0, update, 0, "Update");
		// menu.add(0,help,1,"Help");
		return super.onCreateOptionsMenu(menu);

	}

	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
		case update:
			// here is the function of update
			break;
		/*
		 * case help: // here is the funcion of help break;
		 */
		}
		return super.onOptionsItemSelected(item);
	}
}