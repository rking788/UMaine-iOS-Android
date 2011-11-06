package org.umece.android.umaine;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;


public class NewsListAdapter extends ArrayAdapter<SingleNewsItem> {  
	private ArrayList<SingleNewsItem> newsItems;
	Context context;
	
	public NewsListAdapter(Context context, ArrayList<SingleNewsItem> items) { 
		 super(context, R.layout.news_item, items);
		 newsItems = items;
		 this.context = context;
	}

	@Override
	public View getView(final int pos, View convertView, final ViewGroup parent) {
		View row;
		
		if (null == convertView) {
			LayoutInflater inflater = LayoutInflater.from(context);
			row = inflater.inflate(R.layout.news_item, parent, false);
		} else {
			row = convertView;
		}

		TextView title = (TextView) row.findViewById(R.id.NewsItemTitleText);
		TextView subTitle = (TextView) row.findViewById(R.id.NewsItemSubTitleText);
		//ImageView image = (ImageView) row.findViewById(R.id.NewsItemImage);
		 
		SingleNewsItem item = newsItems.get(pos);
		if (item != null) {
			 title.setText(item.getTitle().toString());
			 subTitle.setText(item.getDescription().toString());
			 //image.setImageResource(R.drawable.ic_launcher);
		}
		return row;
	}
}