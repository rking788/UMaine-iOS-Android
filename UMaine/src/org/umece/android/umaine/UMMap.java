package org.umece.android.umaine;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;

import org.umece.android.umaine.UMItemizedOverlay;
import org.umece.android.umaine.R;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

import com.google.android.maps.GeoPoint;
import com.google.android.maps.MapActivity;
import com.google.android.maps.MapController;
import com.google.android.maps.MapView;
import com.google.android.maps.MyLocationOverlay;
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

public class UMMap extends MapActivity {
	
	/* File name for saved parking spots */
	private String FILE_NAME = "parkingspot.txt";
	
	/* Dialog Types */
	private static final int DIALOG_LOTS = 0;
	private static final int SAVE_LOAD_SPOT = 1;
	private static final int NO_SAVED_SPACE = 2;
	private static final int FAILED_LOCATION_LOAD = 3;
	private static final int OVERWRITE_SPOT_WARNING = 4;
	private static final int WAIT_FOR_POSITION = 5;
	
	/* Permit Types */
	private static final int PERMIT_STAFF = 0;
	private static final int PERMIT_RESIDENT = 1;
	private static final int PERMIT_COMMUTER = 2;
	private static final int PERMIT_VISITOR = 3;
	private static final int LOCATION_CURRENT = 4;
	private static final int LOCATION_PARKING_SPOT = 5;
	private static final int LOCATION_CLASS = 6;
	
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
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.map);

        /* Get a reference to the MapView from the main layout 
         * also set built in zoom controls to true 
         */
        mv = (MapView) findViewById(R.id.mapview);
        mv.setBuiltInZoomControls(true);
        mv.setSatellite(true);
        
        /* Get the current MapController to set the center point to Barrows Hall */
        MapController mc = mv.getController();
        
        /* Set the center and zoom on Barrows Hall */
        GeoPoint p1 = new GeoPoint(44902222, -68667222);
        mc.setCenter(p1);
        mc.setZoom(17);
          
        populateOverlays();
        
        /* Create the current location overlay list */
        poioverlays = new UMItemizedOverlay(getResources().getDrawable(R.drawable.aicar), this);
        mylocOverlay = new MyLocationOverlay(this, mv);
        mylocOverlay.runOnFirstFix(new Runnable(){

			public void run() {
				mv.getController().animateTo(mylocOverlay.getMyLocation());
			}
			
		});
		
        /* If we didn't get here from the course details page 
         * then show the lot selection dialog */
        Bundle extras = getIntent().getExtras();
        if(extras != null){
        	int	lat = extras.getInt("lat");
			int longitude = extras.getInt("longitude");
			String buildingName = extras.getString("buildingname");
			GeoPoint building = new GeoPoint(lat, longitude);
			classOverlay = new OverlayItem(building, buildingName, "");
			Drawable d = getResources().getDrawable(R.drawable.icon);
			poioverlays.addOverlay(classOverlay,d);
			mc.setCenter(building);
			drawOverlays(LOCATION_CLASS);
        }
        else{
        	showDialog(DIALOG_LOTS);
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
    
    private void populateOverlays(){
    	Drawable drawable;
    	OverlayItem oi;
    	int i = 0;
    	String[] names;
        int[] lats;
        int[] longs;
    	
    	/* Staff Overlays */
        drawable = this.getResources().getDrawable(R.drawable.staffmarker);
    	staffitemizedoverlay = new UMItemizedOverlay(drawable, this);
    	
    	names = getResources().getStringArray(R.array.staff_lots);
    	lats = getResources().getIntArray(R.array.staff_lat);
    	longs = getResources().getIntArray(R.array.staff_long);
    	
    	for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	staffitemizedoverlay.addOverlay(oi);
        }
    	
    	/* Resident Overlays */
    	drawable = this.getResources().getDrawable(R.drawable.residentmarker);
        resitemizedoverlay = new UMItemizedOverlay(drawable, this); 
        
        names = getResources().getStringArray(R.array.resident_lots);
    	lats = getResources().getIntArray(R.array.resident_lat);
    	longs = getResources().getIntArray(R.array.resident_long);
    	
    	for(i = 0; i < names.length; i++){
        	oi = new OverlayItem(new GeoPoint(lats[i], longs[i]), names[i], "");
        	resitemizedoverlay.addOverlay(oi);
        }

    	/* Commuter Overlays */
        drawable = this.getResources().getDrawable(R.drawable.commutermarker);
        commitemizedoverlay = new UMItemizedOverlay(drawable, this);
        
        oi = new OverlayItem(new GeoPoint(44905600, -68673180), "Satellite Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44904604, -68672796), "Alfond Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44904043, -68671536), "Football Field Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900204, -68673878), "Steam Plant Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44896433, -68671891), "Chadbourne Hall Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44894484, -68667980), "Sawyer Environmental Research Center", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44895433, -68666380), "near Libby Hall", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44897032, -68665872), "near Nutting Hall", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44898900, -68664591), "Sebago Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900165, -68663975), "CCA Lot", "");
        commitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44905288, -68662770), "Rec Center Lot", "");
        commitemizedoverlay.addOverlay(oi);
    	
    	/* Visitor Overlays */
        drawable = this.getResources().getDrawable(R.drawable.commutermarker);
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
    	case LOCATION_PARKING_SPOT:
    		break;
    	case LOCATION_CLASS:
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
        case LOCATION_PARKING_SPOT:
        	break;
        case LOCATION_CLASS:
        	break;
    	}
    	
    	mv.invalidate();
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
    	case R.id.myparkingspace:
    		showDialog(SAVE_LOAD_SPOT);
    		return true;
    	case R.id.buildings:
    		// TODO: do something here
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
                    }
                })
                .create();
    	case SAVE_LOAD_SPOT:
    		return new AlertDialog.Builder(this)
    			.setTitle("Save or Load")
    			.setSingleChoiceItems(R.array.parkingspot_dialog_choices, 0, new DialogInterface.OnClickListener() {
					
					public void onClick(DialogInterface dialog, int which) {
						File fin = new File(FILE_NAME);
						
						if(which == 0){
							/* Save space */
							dialog.dismiss();
							
							if(fin.exists()){
								showDialog(OVERWRITE_SPOT_WARNING);
							}
							else{
								//saveCurrentPos();
							}
						}
						else if(which == 1){
							/* Load space */
							dialog.dismiss();
							
							if(!fin.exists()){
								showDialog(NO_SAVED_SPACE);
							}
							else{
								getSavedPos(fin);
							}
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
    					//saveCurrentPos();
    				}
    			})
    			.setNegativeButton("No", new DialogInterface.OnClickListener(){
    				public void onClick(DialogInterface dialog, int id){
    					dialog.dismiss();
    				}
    			})
    			.create();
    	case WAIT_FOR_POSITION:
    		return new AlertDialog.Builder(this)
    			.setTitle("Please Wait")
    			.setMessage("Please wait while your current position is found so that it can be saved.")
    			.setCancelable(false)
    			.create();
    	}
    	
    	return null;
    }
    
    private void toggleCurrentLocation(){
    	if(!(mylocOverlay.isMyLocationEnabled())){
    		mylocOverlay.enableMyLocation();
    		drawOverlays(LOCATION_CURRENT);
    	}
    	else if(mylocOverlay.isMyLocationEnabled()){
    		mylocOverlay.disableMyLocation();
    		clearOverlays(LOCATION_CURRENT);
    	}
    }
    
    private void getSavedPos(File fin){
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
			
			String[] coords = (new String(in, 0, num)).split(",");
			GeoPoint carLocation = new GeoPoint((int)Integer.parseInt(coords[0]), (int)Integer.parseInt(coords[1]));
		
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
    
	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}

}
