package org.umece.android.umaine;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnKeyListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.AdapterView.OnItemClickListener;

public class UMDirectory extends Activity {
	
	static ArrayAdapter<String> tempadapter;
	static List<String> names;
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
		registerForContextMenu(lv);
		lv.setOnItemClickListener(new OnItemClickListener(){
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				Intent myIntent = new Intent(arg1.getContext(), UMDirectoryDetails.class);
				myIntent.putExtra("selectedindex", arg2);
				startActivity(myIntent);
			}
		});
		
		List<NameValuePair> postParams = new ArrayList<NameValuePair>();

		postParams.add(new BasicNameValuePair("field", "names"));
		try {
			names = UMCourses.httpRequest(postParams);
		} catch (Exception e) {
			names = new ArrayList<String>();
			names.add("This is new");
			names.add("This is new 2");
		}
		
		updateList("".toLowerCase());
		
		et.setOnKeyListener(new OnKeyListener(){

			public boolean onKey(View v, int keyCode, KeyEvent event) {
				String s = et.getText().toString().toLowerCase();
				updateList(s);
				return false;
			}
			
		});
	}
	
	public static Contact getContact(int i) {
		return new Contact();
	}

	private void updateList(String string) {
		tempadapter.clear();
		
		for (String s : names) {
			if (s.toLowerCase().contains(string)) {
				tempadapter.add(s);
			}
		}
	}
}
