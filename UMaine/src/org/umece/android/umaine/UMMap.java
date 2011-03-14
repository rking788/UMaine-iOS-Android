package org.umece.android.umaine;

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
import com.google.android.maps.Overlay;
import com.google.android.maps.OverlayItem;

public class UMMap extends MapActivity {
	
	/* Dialog Types */
	private static final int DIALOG_LOTS = 0;
	
	/* Permit Types */
	private static final int PERMIT_STAFF = 0;
	private static final int PERMIT_RESIDENT = 1;
	private static final int PERMIT_COMMUTER = 2;
	private static final int PERMIT_VISITOR = 3;
	
	private boolean[] selectedPermits = {false, true, false, false};
	private boolean[] prevSelectedPermits = {false, true, false, false};

	private UMItemizedOverlay staffitemizedoverlay;
	private UMItemizedOverlay resitemizedoverlay;
	private UMItemizedOverlay commitemizedoverlay;
	private UMItemizedOverlay visitemizedoverlay;
	
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.map);

        /* Get a reference to the MapView from the main layout 
         * also set built in zoom controls to true 
         */
        MapView mapView = (MapView) findViewById(R.id.mapview);
        mapView.setBuiltInZoomControls(true);
        mapView.setSatellite(true);
        
        /* Get the current MapController to set the center point to Barrows Hall */
        MapController mc = mapView.getController();
        
        /* Set the center and zoom on Barrows Hall */
        GeoPoint p1 = new GeoPoint(44902222, -68667222);
        mc.setCenter(p1);
        mc.setZoom(18);
          
        populateOverlays();
        
        /* TODO: Maybe prompt the user to see which lot they want to be displayed first */
        drawOverlays(PERMIT_RESIDENT);
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
    	MapView mapView = (MapView) findViewById(R.id.mapview);
    	List<Overlay> mapOverlays = mapView.getOverlays();
    	
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
    	
    	mapView.invalidate();
    }
    
    public void clearOverlays(int permitType){
    	MapView mapView = (MapView) findViewById(R.id.mapview);
    	List<Overlay> mapOverlays = mapView.getOverlays();
    	
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
    	
    	mapView.invalidate();;
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
    	}
    	
    	return null;
    }
    
	@Override
	protected boolean isRouteDisplayed() {
		// TODO Auto-generated method stub
		return false;
	}

}
