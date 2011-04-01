package org.umece.android.umaine;

import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TabHost;
import android.widget.TextView;
import android.widget.TabHost.TabSpec;

public class UMSports extends ActivityGroup {

	public static TabHost tab_host;
	public static final int update = Menu.FIRST;
	public static final int help = Menu.FIRST + 1;

	public SportsGrabData sgd;
	// public String all_results = "bbbbbbbb";

	// public SportsDisplay sd = new SportsDisplay();

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		/*
		 * TabHost tabHost = getTabHost();
		 * LayoutInflater.from(this).inflate(R.layout.sports,
		 * tabHost.getTabContentView(), true);
		 * tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator("All")
		 * .setContent(R.id.tab_view1));
		 * tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator("Hockey")
		 * .setContent(R.id.tab_view2));
		 * tabHost.addTab(tabHost.newTabSpec("tab3").setIndicator("Basketball")
		 * .setContent(R.id.tab_view3));
		 * tabHost.addTab(tabHost.newTabSpec("tab4").setIndicator("Other")
		 * .setContent(R.id.tab_view4));
		 */
		sgd = new SportsGrabData();
		sgd.postEventType("hockey");

		setContentView(R.layout.sprotsbottomtab);

		TabHost tab_host = (TabHost) findViewById(R.id.sports_tab_host);
		tab_host.setup();

		TabSpec ts1 = tab_host.newTabSpec("all_sch");
		ts1.setIndicator(("All Sch"),
				getResources().getDrawable(R.drawable.sports_all_sch));
		ts1.setContent(R.id.sports_all_sch_text);
		tab_host.addTab(ts1);

		TabSpec ts2 = tab_host.newTabSpec("hockey_sch");
		ts2.setIndicator(("Hockey"),
				getResources().getDrawable(R.drawable.sports_hockey_sch));
		ts2.setContent(R.id.sports_hockey_sch_text);
		tab_host.addTab(ts2);

		TabSpec ts3 = tab_host.newTabSpec("basketball_sch");
		ts3.setIndicator(("Basketball"),
				getResources().getDrawable(R.drawable.sports_basketball_sch));
		ts3.setContent(R.id.sports_basketball_sch_text);
		tab_host.addTab(ts3);

		TabSpec ts4 = tab_host.newTabSpec("others_sch");
		ts4.setIndicator(("Others"),
				getResources().getDrawable(R.drawable.sports_others_sch));
		ts4.setContent(R.id.sports_other_sch_text);
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