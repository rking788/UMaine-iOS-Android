package org.umece.android.umaine;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnKeyListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class UMDirectory extends Activity {
	
	static ArrayAdapter<String> tempadapter;
	static List<String> names;
	EditText et;
	public LayoutInflater mInflater;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directory);
		
		et = (EditText) findViewById(R.id.dirsearch_et);
		
		mInflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		
		tempadapter = new ArrayAdapter<String>(this,
				R.layout.list_item_small) {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				View row;
				
				if (convertView == null) {
					row = mInflater.inflate(R.layout.list_item, parent, false);
					((TextView)row.findViewById(R.id.listtextview)).setText(getItem(position));
				} else {
					row = convertView;
					((TextView)row.findViewById(R.id.listtextview)).setText(getItem(position));
				}
				
				return row;
			}
		};
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
		String name = tempadapter.getItem(i);
		Contact contact;
		
		List<NameValuePair> postParams = new ArrayList<NameValuePair>();

		postParams.add(new BasicNameValuePair("field", "staff_details"));
		postParams.add(new BasicNameValuePair("names", name));
		
		try {
			contact = new Contact(name, UMCourses.httpRequest(postParams));
		} catch (Exception e) {
			contact = null;
		}
		
		return contact;
	}

	private void updateList(String string) {
		String filters[] = string.toLowerCase().split(" ");
		
		tempadapter.clear();
		
		boolean flag;
		String lower;
		for (String s : names) {
			flag = true;
			lower = s.toLowerCase();
			for (String f : filters) {
				if (!lower.contains(f)) {
					flag = false;
				}
			}
			if (flag) {
				tempadapter.add(s);
			}
		}
	}
}
