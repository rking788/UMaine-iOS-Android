package org.umece.android.umaine;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class UMDirectoryDetails extends Activity {
	private int selIndex;
	static ArrayAdapter<String> tempadapter;

	public LayoutInflater mInflater;
	private Contact contact;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directorydetails);
		
		mInflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		
		Bundle extras = getIntent().getExtras();
		selIndex = extras.getInt("selectedindex");
		
		TextView tv = (TextView)findViewById(R.id.title);
		
		contact = UMDirectory.getContact(selIndex);
		
		tv.setText(contact.getName());
		tv.setTextSize(20);
		
		tv = (TextView)findViewById(R.id.room);
		
		tv.setText(contact.getTitle() + "\n\n" + contact.getDepartment() + "\n\n" + contact.getOffice() + "\n");

		tempadapter = new ArrayAdapter<String>(this, R.layout.list_item_small) {
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
		
		tempadapter.add(contact.getNumber());
		tempadapter.add(contact.getEmail());
		ListView lv = (ListView) findViewById(R.id.dd_lv);
		lv.setAdapter(tempadapter);
		registerForContextMenu(lv);
		
		lv.setOnItemClickListener(new OnItemClickListener(){
			public void onItemClick(AdapterView<?> arg0, View arg1,
					int arg2, long arg3) {
				if (arg2 == 0) {
					callNumber();
				} else if (arg2 == 1) {
					sendEmail();
				}
			}
		});
	}
	
	public void callNumber() {
		try {
			startActivity(new Intent(Intent.ACTION_DIAL, Uri.parse("tel:"
					+ contact.getNumber())));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void sendEmail() {
		Intent intent = new Intent(Intent.ACTION_SEND);
		intent.setType("text/rfc822");
		intent.putExtra(Intent.EXTRA_EMAIL, new String[] {contact.getEmail()});
		Intent mailer = Intent.createChooser(intent, null);
		startActivity(mailer);
	}
}
