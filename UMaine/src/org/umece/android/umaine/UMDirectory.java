package org.umece.android.umaine;

import java.util.ArrayList;
import java.util.List;

import org.umece.android.umaine.R;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
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
		et.setInputType(InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);
		
		mInflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		
		tempadapter = new ArrayAdapter<String>(this,
				R.layout.list_item_small) {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				View row;
				
				if (convertView == null) {
					row = mInflater.inflate(R.layout.list_item_small, parent, false);
					((TextView)row.findViewById(R.id.listitemtext)).setText(getItem(position));
					if ((position % 2) == 0) {
						((TextView)row.findViewById(R.id.listitemtext)).setBackgroundColor(Color.getColor("WHITE_BLUE").getColor());
						((TextView)row.findViewById(R.id.listitemtext)).setTextColor(Color.getColor("BLACK").getColor());
					} else {
						((TextView)row.findViewById(R.id.listitemtext)).setBackgroundColor(Color.getColor("LIGHT_BLUE").getColor());
						((TextView)row.findViewById(R.id.listitemtext)).setTextColor(Color.getColor("BLACK").getColor());
					}
				} else {
					row = convertView;
					((TextView)row.findViewById(R.id.listitemtext)).setText(getItem(position));
					if ((position % 2) == 0) {
						((TextView)row.findViewById(R.id.listitemtext)).setBackgroundColor(Color.getColor("WHITE_BLUE").getColor());
						((TextView)row.findViewById(R.id.listitemtext)).setTextColor(Color.getColor("BLACK").getColor());
					} else {
						((TextView)row.findViewById(R.id.listitemtext)).setBackgroundColor(Color.getColor("LIGHT_BLUE").getColor());
						((TextView)row.findViewById(R.id.listitemtext)).setTextColor(Color.getColor("BLACK").getColor());
					}
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
				if (event.getKeyCode() == KeyEvent.KEYCODE_ENTER) {
					return true;
				}
				return false;
			}
			
		});
		
		//et.addTextChangedListener(new TextWatcher() {

			/*@Override
			public void afterTextChanged(Editable s) {
				// TODO Auto-generated method stub
				
			}*/

			/*@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
				// TODO Auto-generated method stub
				
			}*/

			/*@Override
			public void onTextChanged(CharSequence s, int start, int before,
					int count) {
				updateList(s.toString().toLowerCase());
			}*/
		//});
		
//		et.setOnTouchListener(new OnTouchListener(){
//			@Override
//			public boolean onTouch(View v, MotionEvent event) {
//				if (et.getText().toString().contains("\n")) {
//					et.setText(et.getText().toString().replace("\n", ""));
//				}
//				String s = et.getText().toString().toLowerCase();
//				updateList(s);
//				return false;
//			}
//		});
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
