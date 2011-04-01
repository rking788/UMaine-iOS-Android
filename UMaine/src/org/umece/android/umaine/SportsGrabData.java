package org.umece.android.umaine;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.ContextMenu.ContextMenuInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;

public class SportsGrabData {

	/* PHP script */
	private static final String SERVER_SCRIPT = "http://with.eece.maine.edu/sample.php";

	private static final String POST_EVENTTYPE = "event_type";
	private static final String POST_YEAR = "year";
	private static final String POST_SPORTS = "sports";

	public ArrayAdapter<CharSequence> eventTypeAdapter;

	private Spinner coursenumspin;

	public void postEventType(String eventType) {
		List<NameValuePair> postParams = new ArrayList<NameValuePair>();
		postParams.add(new BasicNameValuePair(POST_YEAR, "2011"));
		postParams.add(new BasicNameValuePair("field", POST_SPORTS));
		postParams.add(new BasicNameValuePair(POST_EVENTTYPE, eventType));

		try {
			for (String s : httpRequest(postParams)) {
				String[] row = s.split(";");
				row = row;
			}
		} catch (Exception e) {
			throw new RuntimeException();
		}
		coursenumspin.setSelection(0);
		// coursenumac.getSelectedItem().toString();
	}

	public List<String> httpRequest(List<? extends NameValuePair> postParams)
			throws Exception {
		HttpClient client = new DefaultHttpClient();
		HttpPost request = new HttpPost(SERVER_SCRIPT);
		List<String> ret = new ArrayList<String>();

		UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParams);

		request.setEntity(formEntity);
		HttpResponse response = client.execute(request);
		BufferedReader in = new BufferedReader(new InputStreamReader(response
				.getEntity().getContent()));

		String line = "";
		while ((line = in.readLine()) != null) {
			ret.add(line);
		}

		in.close();

		return ret;
	}

}