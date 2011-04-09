package org.umece.android.umaine.sports;

import java.io.BufferedReader;
/* import java.io.IOException; */
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


import android.widget.ArrayAdapter;


public class SportsGrabData {

	/* PHP script */
	private static final String SERVER_SCRIPT = "http://with.eece.maine.edu/sample.php";

	private static final String POST_EVENTTYPE = "event_type";
	private static final String POST_YEAR = "year";
	private static final String POST_SPORTS = "sports";

	public ArrayAdapter<CharSequence> eventTypeAdapter;

	private String postDate;
	private String postEvent;
	private String postLocation;
	private String postTime;

	private String[] row;

	public List<String> postEventType(String eventType) {
		List<String> retList = null;
		List<NameValuePair> postParams = new ArrayList<NameValuePair>();
		postParams.add(new BasicNameValuePair(POST_YEAR, "2011"));
		postParams.add(new BasicNameValuePair("field", POST_SPORTS));
		postParams.add(new BasicNameValuePair(POST_EVENTTYPE, eventType));

		try {
			retList = httpRequest(postParams);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return retList;
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

	public void setPostDate(String postDate) {
		this.postDate = postDate;
	}

	public String getPostDate() {
		return postDate;
	}

	public void setPostEvent(String postEvent) {
		this.postEvent = postEvent;
	}

	public String getPostEvent() {
		return postEvent;
	}

	public void setPostLocation(String postLocation) {
		this.postLocation = postLocation;
	}

	public String getPostLocation() {
		return postLocation;
	}

	public void setPostTime(String postTime) {
		this.postTime = postTime;
	}

	public String getPostTime() {
		return postTime;
	}

	public void setRow(String[] row) {
		this.row = row;
	}

	public String[] getRow() {
		return row;
	}

}
