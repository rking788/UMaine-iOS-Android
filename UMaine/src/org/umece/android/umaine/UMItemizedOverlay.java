package org.umece.android.umaine;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.widget.Toast;

import com.google.android.maps.ItemizedOverlay;
import com.google.android.maps.OverlayItem;

@SuppressWarnings("rawtypes")
public class UMItemizedOverlay extends ItemizedOverlay {

	private ArrayList<OverlayItem> mOverlays = new ArrayList<OverlayItem>();
	Context mContext;
	
	public UMItemizedOverlay(Drawable defaultMarker, Context context) {
		super(boundCenter(defaultMarker));
		mContext = context;
	}
	
	public void addOverlay(OverlayItem overlay) {
	    mOverlays.add(overlay);
	    populate();
	}
	
	public void clearOverlays(){
		mOverlays.clear();
		populate();
	}

	@Override
	protected OverlayItem createItem(int i) {
		return mOverlays.get(i);
	}

	@Override
	public int size() {
		return mOverlays.size();
	}
	
	@Override
	protected boolean onTap(int index) {
	  OverlayItem item = mOverlays.get(index);
	  Toast.makeText(mContext, item.getTitle(), Toast.LENGTH_SHORT).show();
	  //AlertDialog.Builder dialog = new AlertDialog.Builder(mContext);
	  //dialog.setTitle(item.getTitle());
	  //dialog.setMessage(item.getSnippet());
	  //dialog.show();
	  return true;
	}
}
