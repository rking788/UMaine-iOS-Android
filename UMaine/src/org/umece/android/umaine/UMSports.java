package org.umece.android.umaine;


import android.app.TabActivity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.widget.TabHost;

public class UMSports extends TabActivity {

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		TabHost tabHost = getTabHost();
		LayoutInflater.from(this).inflate(R.layout.tab_sports,
				tabHost.getTabContentView(), true);
		tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator("All")
				.setContent(R.id.tab_view1));
		tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator("Hockey")
				.setContent(R.id.tab_view2));
		tabHost.addTab(tabHost.newTabSpec("tab3").setIndicator("Basketball")
				.setContent(R.id.tab_view3));
		tabHost.addTab(tabHost.newTabSpec("tab4").setIndicator("Other")
				.setContent(R.id.tab_view4));
	}

}
