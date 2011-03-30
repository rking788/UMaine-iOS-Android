package org.umece.android.umaine;

import java.io.File;
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
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.Toast;

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
	
	private boolean[] selectedPermits = {false, true, false, false};
	private boolean[] prevSelectedPermits = {false, false, false, false};

	private UMItemizedOverlay staffitemizedoverlay;
	private UMItemizedOverlay resitemizedoverlay;
	private UMItemizedOverlay commitemizedoverlay;
	private UMItemizedOverlay visitemizedoverlay;
	private UMItemizedOverlay curlocoverlay;
	
	private MapView mv;
	
	private MyLocationOverlay mylocOverlay;
	
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
        curlocoverlay = new UMItemizedOverlay(getResources().getDrawable(R.drawable.aicar), this);
        mylocOverlay = new MyLocationOverlay(this, mv);
		
        /* TODO: Maybe prompt the user to see which lot they want to be displayed first */
        showDialog(DIALOG_LOTS);
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
    		mv.getOverlays().remove(mylocOverlay);
    	}
    }
    
    private void populateOverlays(){
    	Drawable drawable;
    	OverlayItem oi;
    	
    	/* Staff Overlays */
        drawable = this.getResources().getDrawable(R.drawable.staffmarker);
    	staffitemizedoverlay = new UMItemizedOverlay(drawable, this);
    	
    	oi = new OverlayItem(new GeoPoint(44903443, -68673012), "Crossland Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44903536, -68671554), "Corbett Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44904255, -68670142), "Field House Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44903273, -68668198), "Bennett Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44903759, -68667202), "Cutler Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44903895, -68665125), "near Adroscoggin", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44904771, -68662141), "Hilltop Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44900157, -68673217), "Steam Plant Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44902672, -68665413), "Jenness Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44902069, -68664483), "AEWC Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44901724, -68665773), "AEWC Advanced Structures Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44899988, -68665473), "CCA Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44900735, -68661642), "Keyo Public Affairs Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44899346, -68660609), "The Depot Lots", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44898546, -68666972), "Norman Smith Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44897745, -68666676), "Small Animal Research Building", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44897304, -68667152), "next to Hitchner", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44896973, -68666454), "Nutting Hall", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44897923, -68668991), "Merrill Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44896218, -68668577), "Deering Hall Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44897691, -68671267), "Carnegie Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(4489535, -68666904), "Libby Hall Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44894653, -68666703), "Edward Bryand Glocal Sciences Center Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44893286, -68669357), "near Lengyl Field Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44895054, -68672197), "Lengyl Gym Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44896447, -68672903), "Chadbourne / Stodder Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44894417, -68674041), "Phi Kappa Sigma Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	oi = new OverlayItem(new GeoPoint(44899193, -68670205), "Libby / Fogler Lot", "");
    	staffitemizedoverlay.addOverlay(oi);
    	
    	/* Resident Overlays */
    	drawable = this.getResources().getDrawable(R.drawable.residentmarker);
        resitemizedoverlay = new UMItemizedOverlay(drawable, this); 
        
        oi = new OverlayItem(new GeoPoint(44902571, -68673820), "College Ave Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44902546, -68672612), "Beta Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44903020, -68672652), "Next to Beta Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900358, -68673411), "Steam Plant", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44897846, -68672905), "Stodder Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44897353, -68670496), "Next to Carnegie", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44897159, -68669323), "Next to Merrill", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44896114, -68670192), "Behind Estabrooke", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44895790, -68668831), "Near Estabrooke", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44894546, -68668553), "Aroostook Lots", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44893645, -68669430), "Lengyl Field Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44901600, -68664345), "AEWC Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44903706, -68666187), "Gannett Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44903364, -68665532), "Cumberland Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44903698, -68665104), "Androscogin Lot", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44903600, -68664112), "Knox Hall", "");
        resitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44904564, -68660993), "Hilltop Lot", "");
        resitemizedoverlay.addOverlay(oi);
    	
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
        
        oi = new OverlayItem(new GeoPoint(44903164, -68672766), "Crossland Hall Lot", "");
        visitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900533, -68671210), "West of Lord Hall", "");
        visitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900485, -68670366), "South of Lord Hall", "");
        visitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44897564, -68666540), "near Small Animal Research", "");
        visitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44898544, -68666879), "near Maine Bound", "");
        visitemizedoverlay.addOverlay(oi);
        oi = new OverlayItem(new GeoPoint(44900492, -68667990), "near Union", "");
        visitemizedoverlay.addOverlay(oi);
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
    	}
    	
    	mv.invalidate();;
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
    		mylocOverlay.runOnFirstFix(new Runnable(){

				public void run() {
					mv.getController().animateTo(mylocOverlay.getMyLocation());
				}
    			
    		});
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
								saveCurrentPos();
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
    					saveCurrentPos();
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
    		mv.getOverlays().add(mylocOverlay);
    	}
    	else if(mylocOverlay.isMyLocationEnabled()){
    		mylocOverlay.disableMyLocation();
    		mv.getOverlays().remove(mylocOverlay);
    	}
    }
    
    private void saveCurrentPos(){
    	
    	showDialog(WAIT_FOR_POSITION);
    	
    	/* If the position is not available then set the onfirstfix listener
    	 * if there is a position then just save that.
    	 */
    	if(mylocOverlay.getMyLocation() == null){
    		mylocOverlay.runOnFirstFix(new Runnable(){

				public void run() {
					savePos(mylocOverlay.getMyLocation());
				}
    			
    		});
    		
    		if((!mylocOverlay.isMyLocationEnabled())){
        		toggleCurrentLocation();
        	}	
    	}
    	else{
    		savePos(mylocOverlay.getMyLocation());
    	}
    	
    	dismissDialog(WAIT_FOR_POSITION);
    	
    }
    
    private void savePos(GeoPoint p){
    	try {
			FileOutputStream foutstream = openFileOutput(FILE_NAME, Context.MODE_PRIVATE);
			foutstream.write(p.toString().getBytes());
			foutstream.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
    	Toast.makeText(this, "Spot Saved " + p.toString(), Toast.LENGTH_LONG).show();
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
			OverlayItem oi = new OverlayItem(carLocation, "Current Parking Space", "");
			
			/* Move the map to the current parking space */
			mv.getController().animateTo(carLocation);
			
			if(curlocoverlay.size() != 0){
				mapOverlays.remove(curlocoverlay);
				curlocoverlay.clearOverlays();
			}
			
			curlocoverlay.addOverlay(oi);
			mapOverlays.add(curlocoverlay);
			
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
