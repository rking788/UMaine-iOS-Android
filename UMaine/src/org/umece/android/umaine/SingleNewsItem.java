package org.umece.android.umaine;

public class SingleNewsItem {
	private String pubDate;
	private String title;
	private String description;
	private String link;
	private String content;
	
	public String getPubDate() { return pubDate; }
	public String getTitle() { return title;}
	public String getDescription(){ return description; }
	public String getLink() { return link; }
	public String getContent() { return content; }
	
	public SingleNewsItem( String _pubDate, String _title, String _description, String _content, String _link) {
		pubDate = _pubDate;
		description = _description;
		title = _title;
		link = _link;
		content = _content;
	}
	
	@Override
	public String toString() {
		return title;
	}
}