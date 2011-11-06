package org.umece.android.umaine;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.widget.TextView;

public class ShowNewsItem extends Activity {

	SingleNewsItem newsItem;
	WebView webview;
	TextView title;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.news);
		
		Bundle extras = getIntent().getExtras();

		newsItem = new SingleNewsItem(extras.getString("puDate"),
				extras.getString("title"),
				extras.getString("description"),
				extras.getString("content"),
				extras.getString("link"));
		
		title = (TextView) findViewById(R.id.textTitle);
		webview = (WebView) findViewById(R.id.webNews);
		webview.getSettings().setJavaScriptEnabled(true);

		title.setText(newsItem.getTitle());
		String html = "<html><body>" + newsItem.getContent().toString() + "</body></html>";
		webview.loadData(html, "text/html", "utf-8");
 
//        final Button btnClose = (Button) findViewById(R.id.btnClose);
//        btnClose.setOnClickListener(new View.OnClickListener() {
//            public void onClick(View v) {
//                // Perform action on click
//            	finish();
//            }
//        });
//
//        final Button btnMore = (Button) findViewById(R.id.btnMore);
//        btnMore.setOnClickListener(new View.OnClickListener() {
//            public void onClick(View v) {
//                // Perform action on click
//				Intent webIntent = new Intent(Intent.ACTION_VIEW,  Uri.parse(newsItem.getLink()) );
//				startActivity(webIntent);
//            }
//        });
		
		String currTime = android.text.format.DateFormat.format(
				"yyyy-MM-dd hh:mm:ss", new java.util.Date()).toString();
		this.setTitle("UMaine News " + currTime);
	}
}
