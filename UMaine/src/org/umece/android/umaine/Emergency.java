package org.umece.android.umaine;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

public class Emergency extends Activity {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.emergency);
		
		Button btn911 = (Button) findViewById(R.id.btn911);
		Button btnDispatcher = (Button) findViewById(R.id.btnDispatcher);
		Button btnParking = (Button) findViewById(R.id.btnParking);
		Button btnPrevention = (Button) findViewById(R.id.btnPrevention);
		Button btnInvestigator = (Button) findViewById(R.id.btnInvestigator);
		Button btnHelpline = (Button) findViewById(R.id.btnHelpline);
	
		btn911.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:911"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android 911", "Call failed", e);
                }
            }
        });

		btnDispatcher.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:2075814040"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android btnDispatcher", "Call failed", e);
                }
            }
        });
		
		btnParking.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:2075814047"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android btnParking", "Call failed", e);
                }
            }
        });
		
		btnPrevention.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:207-581-4036"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android btnPrevention", "Call failed", e);
                }
            }
        });
		
		btnInvestigator.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:2075814048"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android btnInvestigator", "Call failed", e);
                }
            }
        });
		
		btnHelpline.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // Perform action on click
                try {
                    Intent callIntent = new Intent(Intent.ACTION_CALL, Uri.parse("tel:2075814020"));
                    startActivity(callIntent);
                } catch (ActivityNotFoundException e) {
                    Log.e("Android btnHelpline", "Call failed", e);
                }
            }
        });
	}
}
