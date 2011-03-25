package org.umece.android.umaine;

import android.app.ActivityGroup;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;

public class UMSports extends ActivityGroup {

	public static TabHost tab_host;
	public static final int update = Menu.FIRST;
	public static final int help = Menu.FIRST+1;
	
	public String all_results = "bbbbbbbb";
	
	public SportsDisplay sd = new SportsDisplay();
	
	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
/*		TabHost tabHost = getTabHost();
		LayoutInflater.from(this).inflate(R.layout.sports,
				tabHost.getTabContentView(), true);
		tabHost.addTab(tabHost.newTabSpec("tab1").setIndicator("All")
				.setContent(R.id.tab_view1));
		tabHost.addTab(tabHost.newTabSpec("tab2").setIndicator("Hockey")
				.setContent(R.id.tab_view2));
		tabHost.addTab(tabHost.newTabSpec("tab3").setIndicator("Basketball")
				.setContent(R.id.tab_view3));
		tabHost.addTab(tabHost.newTabSpec("tab4").setIndicator("Other")
				.setContent(R.id.tab_view4));*/
		
		setContentView(R.layout.sprotsbottomtab);

		//TextView textView = (TextView) findViewById(R.id.text_view);
		//textView.setText(showResults());
		
        tab_host = (TabHost) findViewById(R.id.edit_item_tab_host);
        tab_host.setup(this.getLocalActivityManager());

        sd.input("allSch");
        TabSpec ts1 = tab_host.newTabSpec("tab_all_sch"); 
        ts1.setIndicator("All Sch");
        ts1.setContent(new Intent(this, SportsDisplay.class)); 
//        sd.input("allSch");
        tab_host.addTab(ts1);

        sd.input("hockeySch");
        TabSpec ts2 = tab_host.newTabSpec("tab_hockey_sch");       
        ts2.setIndicator("Hockey"); 
        ts2.setContent(new Intent(this, SportsDisplay.class)); 
//        sd.input("hockeySch"); 
        tab_host.addTab(ts2);

        sd.input("basketballSch");
        TabSpec ts3 = tab_host.newTabSpec("tab_basketball_sch");        
        ts3.setIndicator("Basketball"); 
        ts3.setContent(new Intent(this, SportsDisplay.class)); 
//        sd.input("basketballSch");
        tab_host.addTab(ts3);
        
        sd.input("othersSch");
        TabSpec ts4 = tab_host.newTabSpec("tab_others_sch"); 
        ts4.setIndicator("Others");   
        ts4.setContent(new Intent(this, SportsDisplay.class)); 
//      sd.input("othersSch");
        tab_host.addTab(ts4);

        tab_host.setCurrentTab(0);
	}
	
	public boolean onCreateOptionsMenu(Menu menu) {
		menu.add(0,update,0,"Update");
//		menu.add(0,help,1,"Help");
		return super.onCreateOptionsMenu(menu);  
		
	}
	public boolean onOptionsItemSelected(MenuItem item) {  
        //TextView tv = (TextView)findViewById(R.id.tv01);  
        switch(item.getItemId()){  
            case update:
            	// here is the function of update
            	break;  
/*            case help:
            	// here is the funcion of help
            	break; */ 
        }  
        return super.onOptionsItemSelected(item);  
    }  
}