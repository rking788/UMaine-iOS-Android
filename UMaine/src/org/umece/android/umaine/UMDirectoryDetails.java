package org.umece.android.umaine;

import java.util.Arrays;
import java.util.List;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

public class UMDirectoryDetails extends Activity {
	
	/* Dialog Types */
	private static final int DIALOG_LOCATION_NOT_AVAILABLE = 0;
	
	private int selIndex;
	static ArrayAdapter<String> tempadapter;

	public LayoutInflater mInflater;
	private Contact contact;
	private int courseBuildingLat;
	private int courseBuildingLong;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.directorydetails);
		
		mInflater = (LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		
		Bundle extras = getIntent().getExtras();
		selIndex = extras.getInt("selectedindex");
		
		TextView tv = (TextView)findViewById(R.id.title);
		
		contact = UMDirectory.getContact(selIndex);
		
		findCourseCoords(contact);
		
		tv.setText(contact.getName());
		tv.setTextSize(20);
		
		tv = (TextView)findViewById(R.id.room);
		 
		tv.setText(contact.getTitle() + "\n" + contact.getDepartment());

		tempadapter = new ArrayAdapter<String>(this, R.layout.list_item_small_icon) {
			@Override
			public View getView(int position, View convertView, ViewGroup parent) {
				View row;
				
				if (convertView == null) {
					row = mInflater.inflate(R.layout.list_item_small_icon, parent, false);
					((TextView)row.findViewById(R.id.listtextview)).setText(getItem(position));
					((TextView)row.findViewById(R.id.listtextview)).setTextColor(Color.getColor("BLACK").getColor());
					if (position == 0) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.number);
					} 
					if (position == 1) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.email);
					}
					if (position == 2) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.location);
					}
//					((ImageView)row.findViewById(R.id.image)).setScaleType(ScaleType.CENTER);
				} else {
					row = convertView;
					if (position == 0) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.number);
					} 
					if (position == 1) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.email);
					}
					if (position == 2) {
						((ImageView)row.findViewById(R.id.image)).setImageResource(R.drawable.location);
					}
					((TextView)row.findViewById(R.id.listtextview)).setText(getItem(position));
					((TextView)row.findViewById(R.id.listtextview)).setTextColor(Color.getColor("BLACK").getColor());
				}
				
				return row;
			}
		};
		 
		tempadapter.add(contact.getNumber());
		tempadapter.add(contact.getEmail());
		tempadapter.add(contact.getOffice());
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
				} else if (arg2 == 2) {
					if (courseBuildingLat != -1) {
						Intent myIntent = new Intent(arg1.getContext(), UMMap.class);
						myIntent.putExtra("lat", courseBuildingLat);
						myIntent.putExtra("longitude", courseBuildingLong);
						myIntent.putExtra("buildingname", contact.getOffice());
						startActivity(myIntent);
					} else {
						showDialog(DIALOG_LOCATION_NOT_AVAILABLE);
					}
				}
			}
		});
	}

	@Override
	protected Dialog onCreateDialog(int id) {
		switch(id){
		case DIALOG_LOCATION_NOT_AVAILABLE:
			return new AlertDialog.Builder(this)
			.setMessage("There are no GPS coordinates available for this building")
			.setTitle("Coordinates Unavailable")
			.setPositiveButton("Ok", new DialogInterface.OnClickListener(){
				public void onClick(DialogInterface dialog, int id){
					dialog.dismiss();
				}
			})
			.create();
		}

		return null;
	}
	
	private void findCourseCoords(Contact c){
		/* Find the coordinates for the course meeting location, to be used if they 
		 * press the "map it" button 
		 */
		String[] campusBuildings = getResources().getStringArray(R.array.building_names);
		List<String> buildingList = Arrays.asList(campusBuildings);
		String buildingName = c.getOffice();
		
		/* Replace spaces with underscores */
		//buildingName = buildingName.replaceAll(" \\d+", "");
		String split[] = buildingName.split(" \\d+");
		if (split != null) {
			buildingName = split[0];
		}
		if (split.length > 1) {
			if (split[1].length() > split[0].length()) {
				buildingName = split[1];
			}
		}
		if (buildingName != null) {
			buildingName = buildingName.replace(' ', '_');
			if (buildingName != null) {
				buildingName = buildingName.toLowerCase();
				
				if (contains(buildingList, buildingName)) {
					int index = indexOf(buildingList, buildingName);
					courseBuildingLat = getResources().getIntArray(R.array.building_latitude)[index];
					courseBuildingLong = getResources().getIntArray(R.array.building_longitude)[index];
				}
				else{
					courseBuildingLat = -1;
					courseBuildingLong = -1;
				}
			}
		}
	}
	
	private int indexOf(List<String> buildingList, String buildingName) {
		int i;
		for (i = 0; i < buildingList.size(); i++) {
			if (buildingList.get(i).contains(buildingName)) {
				return i;
			}
			if (buildingName.contains(buildingList.get(i))) {
				return i;
			}
		}
		
		return -1;
	}

	private boolean contains(List<String> buildingList, String buildingName) {
		for (String building : buildingList) {
			if (building.contains(buildingName)) {
				return true;
			}
			if (buildingName.contains(building)) {
				return true;
			}
		}
		
		return false;
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
