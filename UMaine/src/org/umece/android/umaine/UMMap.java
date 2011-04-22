package org.umece.android.umaine;

/* import java.io.File; */
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import org.umece.android.umaine.UMItemizedOverlay;
import org.umece.android.umaine.R;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.drawable.Drawable;
import android.location.Location;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Toast;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

public class UMMap extends MapActivity {
	private Context mContext;
	
	/* File name for saved parking spots */
	private static final String FILE_NAME = "parkingspot.txt";
	private static final String SELECTED_PERMIT_FILE_NAME = "selectedpermit.txt";
	
	/* "Center of Campus" coordinates */
	private static final int mCenterLat = 44901006;
	private static final int mCenterLong = -68669536;
	
	/* Dialog Types */
	private static final int DIALOG_LOTS = 0;
	private static final int DIALOG_BUILDINGS = 1;
	private static final int SAVE_LOAD_SPOT = 2;
	private static final int NO_SAVED_SPACE = 3;
	private static final int FAILED_LOCATION_LOAD = 4;
	private static final int OVERWRITE_SPOT_WARNING = 5;
	
	/* Permit Types */
	private static final int PERMIT_STAFF = 0;
	private static final int PERMIT_RESIDENT = 1;
	private static final int PERMIT_COMMUTER = 2;
	private static final int PERMIT_VISITOR = 3;
	private static final int LOCATION_CURRENT = 4;
	private static final int LOCATION_POI = 5;
	
	private boolean[] selectedPermits = {false, true, false, false};
	private boolean[] prevSelectedPermits = {false, false, false, false};

	private UMItemizedOverlay staffitemizedoverlay;
	private UMItemizedOverlay resitemizedoverlay;
	private UMItemizedOverlay commitemizedoverlay;
	private UMItemizedOverlay visitemizedoverlay;
	private UMItemizedOverlay poioverlays;
	
	private MapView mv;
	
	private MyLocationOverlay mylocOverlay;
	private OverlayItem parkingOverlay;
	private OverlayItem classOverlay;
	private OverlayItem buildingOverlay;
	
	private ArrayAdapter<String> buildingsAA;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.map);

        mContext = this;
        
        /* Get a reference to the MapView from the main layout 
         * also set built in zoom controls to true 
         */
        mv = (MapView) findViewById(R.id.mapview);
        mv.setBuiltInZoomControls(true);
        mv.setSatellite(false);
        
        /* Get the current MapController to set the center point to Barrows Hall */
        MapController mc = mv.getController();
        
        /* Set the center and zoom on the middle of the "Mall" */
        GeoPoint p1 = new GeoPoint(mCenterLat, mCenterLong);
        mc.setCenter(p1);
        mc.setZoom(16);
          
        /* Populate the itemizedoverlay objects */
        populateOverlays();
        
        /* Create the current location overlay list */
        /* Should change the parking space icon to like a car or something */
        poioverlays = new UMItemizedOverlay(getResources().getDrawable(R.drawable.poiflag), this);
        mylocOverlay = new MyLocationOverlay(this, mv);
        mylocOverlay.runOnFirstFix(new Runnable(){

			public void run() {
				mv.getController().animateTo(mylocOverlay.getMyLocation());
			}
			
		});
		
        /* Create and populate the ArrayAdapter for the buildings list */
        buildingsAA = new ArrayAdapter<String>(this,
        				android.R.layout.simple_dropdown_item_1line);
		for(String out : getResources().getStringArray(R.array.building_names)){
			String correctStr = "";
			for(String in : out.replaceAll("_", " ").split(" ")){
				String firstchar = String.valueOf(in.charAt(0)).toUpperCase();
				String rest = in.substring(1);
				correctStr = correctStr.concat(firstchar + rest).concat(" ");
			}
			buildingsAA.add(correctStr.trim());
		}
		
		/* Set the click handler for the save spot button */
		setSaveSpotHandler();
		
        /* If we didn't get here from the course details page 
         * then show the lot selection dialog */
        Bundle extras = getIntent().getExtras();
        if(extras != null){
        	int	lat = extras.getInt("lat");
			int longitude = extras.getInt("longitude");
			String buildingName = extras.getString("buildingname");
			GeoPoint building = new GeoPoint(lat, longitude);
			classOverlay = new OverlayItem(building, buildingName, "");
			Drawable d = getResources().getDrawable(R.drawable.poiflag);
			poioverlays.addOverlay(classOverlay,d);
			mc.setCenter(building);
			drawOverlays(LOCATION_POI);
        }
        else{
        	if(!loadSelectedPermits(selectedPermits)){
        		showDialog(DIALOG_LOTS);
        	}
        	else{
        		for(int i = 0; i < selectedPermits.length; i++){
            		if(selectedPermits[i]){
                		drawOverlays(i);
            		}
            		prevSelectedPermits[i] = selectedPermits[i];
        		}
        	}
        		
        }
    }

    /* Do we want to re-enable "my location" when resuming the activity? */
    /* Causes a problem where the location is turned on when the activity first starts */
    /*
    @Override
    public void onResume(){
    	super.onResume();
   		mylocOverlay.enableMyLocation();
   		mv.getOverlays().add(mylocOverlay);
    }*/
    
    @Override
    public void onPause(){
    	super.onPause();
    	if(mylocOverlay.isMyLocationEnabled()){
    		mylocOverlay.disableMyLocation();
    		clearOverlays(LOCATION_CURRENT);
    	}
    }
    
    private void setSaveSpotHandler(){
    	Button savespotBtn = (Button) findViewById(R.id.map_savespot_btn);
    	
    	savespotBtn.setOnClickListener(new View.OnClickListener(){

			public void onClick(View v) {
				showDialog(SAVE_LOAD_SPOT);
			}
    		
    	});
    }
    
    private void populateOverlays(){
    	Drawable drawable;
    	OverlayItem oi;
    	int i = 0;
    	String[] names;
        int[] lats;
        int[] longs;
    	
    	/* Staff Overlays */
        drawable = this.getResources().getDrawable(R.drawable.staffpin);
    	staffitemizedoverlay = new UMItemizedOverlay(drawable, this);
    	
    	names = getResources().getStringArray(R.array.staff_lots);
    	lats = getResources().getIntArray(R.array.staff_lat);
    	longs = getResources().getIntArray(R.array.staff_long);
    	
    	for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	staffitemizedoverlay.addOverlay(oi);
        }
    	
    	/* Resident Overlays */
    	drawable = this.getResources().getDrawable(R.drawable.residentpin);
        resitemizedoverlay = new UMItemizedOverlay(drawable, this); 
        
        names = getResources().getStringArray(R.array.resident_lots);
    	lats = getResources().getIntArray(R.array.resident_lat);
    	longs = getResources().getIntArray(R.array.resident_long);
    	
    	for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	resitemizedoverlay.addOverlay(oi);
        }

    	/* Commuter Overlays */
        drawable = this.getResources().getDrawable(R.drawable.commuterpin);
        commitemizedoverlay = new UMItemizedOverlay(drawable, this);
        
        names = getResources().getStringArray(R.array.commuter_lots);
    	lats = getResources().getIntArray(R.array.commuter_lat);
    	longs = getResources().getIntArray(R.array.commuter_long);
    	
    	for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	commitemizedoverlay.addOverlay(oi);
        }
    	
    	/* Visitor Overlays */
        drawable = this.getResources().getDrawable(R.drawable.visitorpin);
        visitemizedoverlay = new UMItemizedOverlay(drawable, this);
        names = getResources().getStringArray(R.array.visitor_lots);
        lats = getResources().getIntArray(R.array.visitor_lat);
        longs = getResources().getIntArray(R.array.visitor_long);
        
        for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	visitemizedoverlay.addOverlay(oi);
        }
    }
    
    private void drawOverlays(int permitType){
    	List<Overlay> mapOverlays = mv.getOverlays();
    	
    	switch(permitType){
    	case PERMIT_STAFF:
    		mapOverlays.add(staffitemizedoverlay);
    		break;
    	case PERMIT_RESIDENT:
    		mapOverlays.add(resitemizedoverlay);
    		break;
    	case PERMIT_COMMUTER:
    		mapOverlays.add(commitemizedoverlay);
    		break;
    	case PERMIT_VISITOR:
    		mapOverlays.add(visitemizedoverlay);
    		break;
    	case LOCATION_CURRENT:
    		mapOverlays.add(mylocOverlay);
    		break;
    	case LOCATION_POI:
    		mapOverlays.add(poioverlays);
    		break;
    	}
    	
    	mv.invalidate();
    }
    
    public void clearOverlays(int permitType){
    	List<Overlay> mapOverlays = mv.getOverlays();
    	
    	switch(permitType){
    	case PERMIT_STAFF:
    		mapOverlays.remove(staffitemizedoverlay);
    		break;
    	case PERMIT_RESIDENT:
    		mapOverlays.remove(resitemizedoverlay);
    		break;
    	case PERMIT_COMMUTER:
    		mapOverlays.remove(commitemizedoverlay);
    		break;
    	case PERMIT_VISITOR:
    		mapOverlays.remove(visitemizedoverlay);
    		break;
    	case LOCATION_CURRENT:
    		mapOverlays.remove(mylocOverlay);
        	break;
        case LOCATION_POI:
        	mapOverlays.remove(poioverlays);
        	break;
    	}
    	
    	mv.invalidate();
    }
    
    @Override
	public boolean onPrepareOptionsMenu(Menu menu){
		
    	/* Change the text of the "mylocation" button depending on 
    	 * if it is currently enabled or not
    	 */
    	if(mylocOverlay.isMyLocationEnabled()){
			menu.findItem(R.id.getlocation).setTitle("My Location Off");
		}
		else{
			menu.findItem(R.id.getlocation).setTitle("My Location On");
		}
    	
    	return true;
    }
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu){
    	MenuInflater inflater = getMenuInflater();
    	inflater.inflate(R.menu.map_menu, menu);
		
    	return true;
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item){
    	/* An item was selected from the options menu */
    	switch(item.getItemId()){
    	case R.id.lots:
    		showDialog(DIALOG_LOTS);
    		return true;
    	case R.id.getlocation:
    		toggleCurrentLocation();
    		return true;
    	case R.id.buildings:
    		showDialog(DIALOG_BUILDINGS);
    		return true;
    	case R.id.satview:
    		mv.setSatellite(true);
    		return true;
    	case R.id.mapview:
    		mv.setSatellite(false);
    		return true;
    	default:
    		return super.onOptionsItemSelected(item);
    	}
    }
    
    @Override
    protected Dialog onCreateDialog(int id){
    	final CharSequence[] permits = {"Staff/Faculty", "Resident", "Commuter", "Visitor"};

    	switch(id){
    	case DIALOG_LOTS:
    		return new AlertDialog.Builder(this)
    			.setTitle("Pick a permit type")
    			.setMultiChoiceItems(permits,
                        selectedPermits,
                        new DialogInterface.OnMultiChoiceClickListener() {
                            public void onClick(DialogInterface dialog, int whichButton,boolean isChecked) {
                            	selectedPermits[whichButton] = isChecked;
                            }
                        })
                .setPositiveButton("OK",
                        new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int whichButton) {
                    	for(int i = 0; i < selectedPermits.length; i++){
                    		if(selectedPermits[i] && (!prevSelectedPermits[i]))
                        		drawOverlays(i);
                        	else if((!selectedPermits[i]) && prevSelectedPermits[i])
                        		clearOverlays(i);
                        	
                    		prevSelectedPermits[i] = selectedPermits[i];
                    		
                    	}
                    	
                		saveSelectedPermits(selectedPermits);
                    }
                })
                .create();
    	case DIALOG_BUILDINGS:
    		return new AlertDialog.Builder(this)
    			.setTitle("Select a building")
    			.setSingleChoiceItems(buildingsAA, 0, new OnClickListener(){

					public void onClick(DialogInterface dialog, int which) {
						clearOverlays(LOCATION_POI);
						poioverlays.clearOverlays();
						int	lat = getResources()
									.getIntArray(R.array.building_latitude)[which];
						int longitude = getResources()
									.getIntArray(R.array.building_longitude)[which];
						String buildingName = buildingsAA.getItem(which);
						
						GeoPoint building = new GeoPoint(lat, longitude);
						buildingOverlay = new OverlayItem(building, buildingName, "");
						Drawable d = getResources().getDrawable(R.drawable.poiflag);
						poioverlays.addOverlay(buildingOverlay,d);
						mv.getController().setCenter(building);
						drawOverlays(LOCATION_POI);
						dialog.dismiss();
					}
    				
    			})
    			.create();
    	case SAVE_LOAD_SPOT:
    		return new AlertDialog.Builder(this)
    			.setTitle("Save or Load")
    			.setSingleChoiceItems(R.array.parkingspot_dialog_choices, 0, new DialogInterface.OnClickListener() {
					
					public void onClick(DialogInterface dialog, int which) {
						FileInputStream finStream = null;
						
						try {
							finStream = openFileInput(FILE_NAME);
						
							if(which == 0){
								/* Save space */
								dialog.dismiss();
								
								if(finStream != null){
									showDialog(OVERWRITE_SPOT_WARNING);
								}
								else{
									saveCurrentPos(((Dialog) dialog).getContext());
								}
							}
							else if(which == 1){
								/* Load space */
								dialog.dismiss();
								
								if(finStream == null){
									showDialog(NO_SAVED_SPACE);
								}
								else{
									getSavedPos(finStream);
								}
							}
							
							finStream.close();
						} catch (FileNotFoundException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				})
				.create();
    	case NO_SAVED_SPACE:
    		return new AlertDialog.Builder(this)
    			.setMessage("There are no saved parking space locations.")
    			.setPositiveButton("OK", new DialogInterface.OnClickListener(){
    				public void onClick(DialogInterface dialog, int id){
    					dialog.dismiss();
    				}
    			})
    			.create();
    	case OVERWRITE_SPOT_WARNING:
    		return new AlertDialog.Builder(this)
    			.setMessage("This will overwrite the last saved space. Do you want to continue?")
    			.setPositiveButton("Yes", new DialogInterface.OnClickListener(){
    				public void onClick(DialogInterface dialog, int id){
    					dialog.dismiss();
    					saveCurrentPos(((Dialog)dialog).getContext());
    				}
    			})
    			.setNegativeButton("No", new DialogInterface.OnClickListener(){
    				public void onClick(DialogInterface dialog, int id){
    					dialog.dismiss();
    				}
    			})
    			.create();
    	}
    	
    	return null;
    }
    
    private void toggleCurrentLocation(){
    	if(!(mylocOverlay.isMyLocationEnabled())){
    		if(mylocOverlay.enableMyLocation()){
    			drawOverlays(LOCATION_CURRENT);
    			Toast.makeText(this, "Successfully enabled location", Toast.LENGTH_SHORT).show();
    		}
    		else{
    			Toast.makeText(this, "Failed to enable location", Toast.LENGTH_SHORT).show();
    		}
    	}
    	else if(mylocOverlay.isMyLocationEnabled()){
    		mylocOverlay.disableMyLocation();
    		clearOverlays(LOCATION_CURRENT);
    	}
    }
    
    private void saveCurrentPos(Context cont){
    	Location loc = mylocOverlay.getLastFix();
    	String locationString = null;
    	
    	/* Is a location available? */
    	if(loc == null){
    		Toast.makeText(mContext, "Location Info Unavailable", Toast.LENGTH_LONG).show();
    	}
    	else{
    		Toast.makeText(mContext, "Location Found", Toast.LENGTH_LONG).show();
    		FileOutputStream outStream;
			
    		/*Write the location to file */
    		try {
				outStream = mContext.openFileOutput(FILE_NAME, Context.MODE_PRIVATE);
				
				Integer iLat = (int)((loc.getLatitude() * 1000000));
				Integer iLong = (int)((loc.getLongitude() * 1000000));
				
				locationString = iLat.toString() + ";" + iLong.toString();
				outStream.write(locationString.getBytes());
				outStream.close();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
    		
			String res = "Saved " + locationString + " to file";
			Toast.makeText(mContext, res, Toast.LENGTH_LONG).show();
    	}
    }
    
    private void getSavedPos(FileInputStream finStream){
    	try {
    		List<Overlay> mapOverlays = mv.getOverlays();
    		int num = -1;
    		byte[] in = new byte[22];
			FileInputStream finstream = openFileInput(FILE_NAME);
			if((num = finstream.read(in)) == -1){
				showDialog(FAILED_LOCATION_LOAD);
				return;
			}
			finstream.close();
			
			String[] coords = (new String(in, 0, num)).split(";");
			int iLat = (int)Integer.parseInt(coords[0]);
			int iLong = (int)Integer.parseInt(coords[1]);
			GeoPoint carLocation = new GeoPoint(iLat, iLong);
		
			Toast.makeText(mContext, "Loaded location: " + coords[0] + ";" + coords[1], Toast.LENGTH_LONG).show();
			
			/* Display the point found above as an overlay on the map */
			parkingOverlay = new OverlayItem(carLocation, "Current Parking Space", "");
			
			/* Move the map to the current parking space */
			mv.getController().animateTo(carLocation);
			
			if(poioverlays.size() != 0){
				mapOverlays.remove(poioverlays);
				poioverlays.clearOverlays();
			}
			
			poioverlays.addOverlay(parkingOverlay);
			mapOverlays.add(poioverlays);
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    private void saveSelectedPermits(boolean[] selected){
    	
    	try {
			FileOutputStream fout = openFileOutput(SELECTED_PERMIT_FILE_NAME, Context.MODE_PRIVATE);
			int index = 0;
			
			String vals = "";
			
			for(index = 0; index < selected.length; index++){
				if(selected[index] == true){
					vals = vals.concat("true");
				}
				else{
					vals = vals.concat("false");
				}
				
				//if(index!= (selected.length - 1)){
					vals = vals.concat(",");
			//	}
			}
			
			fout.write(vals.getBytes());
			fout.close();
			
    	} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	
    }
    
    private boolean loadSelectedPermits(boolean[] selected){
    	boolean ret = false;
    	
    	try {
			FileInputStream fin = openFileInput(SELECTED_PERMIT_FILE_NAME); 
			byte[] in = new byte[30];
			int numread = -1;
			int index = 0;
			
			// If the file does not exist then just return
			if(fin == null){
				return false;
			}
			
			numread = fin.read(in);
			if(numread == -1){
				// If read failed then just return
				return false;
			}
			
			ret = true;
			String[] vals = new String(in).split(",");
			
			// Loop over all values read in and set the selected permits array
			for(index = 0; index < selected.length; index++){
				if(vals[index].equals("true")){
					selected[index] = true;
				}
				else{
					selected[index] = false;
				}
				
			}
			
			fin.close();
			
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			ret = false;
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			ret = false;
			e.printStackTrace();
		}
		
		return ret;
    }
    
	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}

}
