package org.umece.android.umaine;

import android.app.Activity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnKeyListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

public class UMDirectory extends Activity {
	
	ArrayAdapter<String> tempadapter;
	EditText et;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);
		
		et = (EditText) findViewById(R.id.dirsearch_et);
		
		tempadapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_list_item_1);;
		ListView lv = (ListView) findViewById(R.id.directory_lv);
		lv.setAdapter(tempadapter);
		tempadapter.add("This is new");
		tempadapter.add("This is new 2");
		
		et.setOnKeyListener(new OnKeyListener(){

			public boolean onKey(View v, int keyCode, KeyEvent event) {
				String s = et.getText().toString();
				tempadapter.getFilter().filter(s);
				return false;
			}
			
		});
	}
}
