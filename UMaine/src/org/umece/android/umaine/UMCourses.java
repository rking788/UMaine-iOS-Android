package org.umece.android.umaine;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Formatter;
import java.util.List;
import java.lang.String;

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
import android.content.DialogInterface;
import android.os.Bundle;
import android.text.Spannable;
import android.text.style.StyleSpan;
import android.view.ContextMenu;
import android.view.ContextMenu.ContextMenuInfo;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.AdapterContextMenuInfo;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;

public class UMCourses extends Activity {
	
	/* PHP script */
	private static final String SERVER_SCRIPT = "http://with.eece.maine.edu/sample.php";
	
	/* Post Values for data to be queried */
	private static final String POST_DEPARTS = "departments";
	private static final String POST_COURSENUM = "coursenums";
	private static final String POST_SECTIONS = "sections";
	private static final String POST_ADDCOURSE = "addcourse";
	
	/* Dialog Types */
	private static final int DIALOG_ADD_COURSE = 0;
	
	public ArrayAdapter<CharSequence> departadapter;
	public ArrayAdapter<CharSequence> coursenumadapter;
	public ArrayAdapter<CharSequence> sectionadapter;
	public ArrayAdapter<Spannable> courselistadapter;
	
	private String selectedDepart; 
	private String selectedCourseNum;
	private String selectedSection;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.courses);
        
        /* Create the adapters for the spinners and leave the courselist adapter as null
         * so we know it needs to be created when the first course is added
         */
        departadapter = new ArrayAdapter<CharSequence>(this, android.R.layout.simple_spinner_item);
        departadapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        coursenumadapter = new ArrayAdapter<CharSequence>(this, android.R.layout.simple_spinner_item);
        coursenumadapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        sectionadapter = new ArrayAdapter<CharSequence>(this, android.R.layout.simple_spinner_item);
        sectionadapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        courselistadapter = null;
        
        try{
            doHttpStuff(POST_DEPARTS);    	
        }
        catch(Exception e){
        	throw new RuntimeException(e);
        }
    }
    
    /* Create a context menu on long presses on the course list */
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenuInfo menuInfo){
    	super.onCreateContextMenu(menu, v, menuInfo);
    	MenuInflater inflater = getMenuInflater();
    	inflater.inflate(R.menu.delete_course_conmenu, menu);
    }
    
    /* Remove the selected item from the course listview */
    @Override
    public boolean onContextItemSelected(MenuItem item){
		AdapterContextMenuInfo info = (AdapterContextMenuInfo) item.getMenuInfo();
		switch(item.getItemId()){
		case R.id.delete:
			courselistadapter.remove(courselistadapter.getItem((int) info.id));
			return true;
		default:
			return super.onContextItemSelected(item);
		}
    }
    
    /* Create the options menu at the bottom of the screen */
    @Override
    public boolean onCreateOptionsMenu(Menu menu){
    	MenuInflater inflater = getMenuInflater();
    	inflater.inflate(R.menu.courses_menu, menu);
    	return true;
    }
    
    /* What should be done when the options menu items are selected
     * Currently only the add course button is implemented
     */
    @Override
    public boolean onOptionsItemSelected(MenuItem item){
    	/* An item was selected from the options menu */
    	switch(item.getItemId()){
    	case R.id.addcourse:
    		showDialog(DIALOG_ADD_COURSE);
    		return true;
    	default:
    		return super.onOptionsItemSelected(item);
    	}
    }
    
    @Override
    protected Dialog onCreateDialog(int id){
    	
    	switch(id){
    	case DIALOG_ADD_COURSE:
    		/* The layout needs to be inflated because the dialog has not been created yet
    		 * without inflating it, the program will crash when setting the adapter or retrieving
    		 * any item from the dialog layout
    		 */
    		LayoutInflater inflater = (LayoutInflater) this.getSystemService(LAYOUT_INFLATER_SERVICE);
    		View layout = inflater.inflate(R.layout.addcoursedialog, (ViewGroup)findViewById(R.id.addcourseroot));
    		
    		/* Get references to the spinners */
    		final Spinner departspin = (Spinner) layout.findViewById(R.id.spinner);
    		final Spinner coursenumspin = (Spinner) layout.findViewById(R.id.coursenumspin);
    		final Spinner sectionspin = (Spinner) layout.findViewById(R.id.sectionspin);
    		
    		/* Build the alert dialog for adding courses */
    		AlertDialog.Builder ad = new AlertDialog.Builder(this)
    		.setTitle("Add a course.")
    		.setPositiveButton("Add", new DialogInterface.OnClickListener() {
				
				public void onClick(DialogInterface dialog, int which) {
					try{
						selectedDepart = departspin.getSelectedItem().toString();
						selectedCourseNum = coursenumspin.getSelectedItem().toString();
						selectedSection = sectionspin.getSelectedItem().toString();
						doHttpStuff(POST_ADDCOURSE);
					}
					catch (Exception e){
						throw new RuntimeException(e);
					}
				}
			})
    		.setNegativeButton("Cancel", null)
    		.setView(layout);
    		AlertDialog d = ad.create();
    
    		/* Departments Spinner */
    		departspin.setAdapter(departadapter);
    		departspin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
    		    public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
    		    	try{
    		    		selectedDepart = departadapter.getItem(position).toString();
    		    		
    		    		/* Refresh the course number spinner */
    		    		coursenumadapter.clear();
    		    		doHttpStuff(POST_COURSENUM);
    		    		coursenumspin.setSelection(0);
    		    		selectedCourseNum = coursenumspin.getSelectedItem().toString();
    		    		
    		    		/* Refresh the section number spinner */
    		    		sectionadapter.clear();
    		    		doHttpStuff(POST_SECTIONS);
    		    	}
    		    	catch(Exception e){
    		    		throw new RuntimeException(e);
    		    	}
    		    }

    		    public void onNothingSelected(AdapterView<?> parentView) {
    		        // do nothing?
    		    }
    		});
    		
    		/* Course number spinner */
    		coursenumspin.setAdapter(coursenumadapter);
    		coursenumspin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
    		    public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
    		    	try{
    		    		selectedCourseNum = coursenumadapter.getItem(position).toString();
    		    		sectionadapter.clear();
    		    		doHttpStuff(POST_SECTIONS);
    		    	}
    		    	catch(Exception e){
    		    		throw new RuntimeException(e);
    		    	}
    		    }

    		    public void onNothingSelected(AdapterView<?> parentView) {
    		        // do nothing?
    		    }
    		});
    		
    		/* Section number spinner */
    		sectionspin.setAdapter(sectionadapter);
    		sectionspin.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener(){
    		    public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
    		    	try{
    		    		selectedSection = sectionadapter.getItem(position).toString();
    		    	}
    		    	catch(Exception e){
    		    		throw new RuntimeException(e);
    		    	}
    		    }

    		    public void onNothingSelected(AdapterView<?> parentView) {
    		        // do nothing?
    		    }
    		});
    		
    		return d;
    	}
    	
    	return null;
    }
    
    /* Create a spannable for the course to be added.
     * should include bold text for department, course number, and description
     */
    private Spannable createCourseSpannable(List<String> courseinfo){
    	String dep, num, title, inst, sec, days, starttime, endtime;
    	Formatter formatter = new Formatter();
    	
    	/* Should handle the case where there is no start time or end time */
    	/* Department */
    	dep = courseinfo.get(0);
    	/* Course Number */
    	num = courseinfo.get(1);
    	/* Section */
    	sec = courseinfo.get(2);
    	/* Title */
    	title = courseinfo.get(3);
    	/* Start Time */
    	starttime = courseinfo.get(4);
    	/* End Time */
    	endtime = courseinfo.get(5);
    	/* Days */
    	days = courseinfo.get(6);
    	/* Instructor */
    	inst = courseinfo.get(7);
    	
    	/* Handle the case where the start and end times as well as the days may be empty */
    	/* TODO: In some cases the instructor is even empty ARH 397 */
    	if (days.length() == 0)
    		formatter = formatter.format("%s %s - %s\n\t%s Section: %s", dep, num, title, inst, sec);
    	else if(days.length() != 0)
    		formatter = formatter.format("%s %s - %s\n\t%s Section: %s\n\t%s\t%s-%s", dep, num, title, inst, sec, days, starttime, endtime);
    	
    	EditText text = new EditText(this);
    	text.setText(formatter.toString());
    	
    	Spannable span = text.getText();
    	span.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), 0, (dep.length()+num.length()+title.length()+4), Spannable.SPAN_INCLUSIVE_EXCLUSIVE);
    	
    	return span;
    }
    
    public void doHttpStuff(String postVal) throws Exception{
    	BufferedReader in = null;
    	List<String> ci = null;
		
    	try {
    		HttpClient client = new DefaultHttpClient();
    		HttpPost request = new HttpPost(SERVER_SCRIPT);
    		
    		List<NameValuePair> postParams = new ArrayList<NameValuePair>();
    		postParams.add(new BasicNameValuePair("field", postVal));
    		
    		if(postVal.equals(POST_COURSENUM)){
    			/* If selecting course numbers we need to know the department */
    			postParams.add(new BasicNameValuePair(POST_DEPARTS, selectedDepart));
    		}
    		else if(postVal.equals(POST_SECTIONS)){
    			/* If requesting section numbers then we need department and course number */
    			postParams.add(new BasicNameValuePair(POST_DEPARTS, selectedDepart));
    			postParams.add(new BasicNameValuePair(POST_COURSENUM, selectedCourseNum));
    		}
    		else if(postVal.equals(POST_ADDCOURSE)){
    			ci = new ArrayList<String>();
    			
    			/* If adding a course we need to know department, course number, and section */
    			postParams.add(new BasicNameValuePair(POST_DEPARTS, selectedDepart));
        		postParams.add(new BasicNameValuePair(POST_COURSENUM, selectedCourseNum));
        		postParams.add(new BasicNameValuePair(POST_SECTIONS, selectedSection));
        		
            	/* If the adapter for the course list hasn't been created yet then create 
            	 * it and set the adapter of the list view 
            	 */
            	if(courselistadapter == null){
                	ListView lv = (ListView) findViewById(R.id.courseslist);
                	courselistadapter = new ArrayAdapter<Spannable>(this, R.layout.list_item);
                	lv.setAdapter(courselistadapter);
                	registerForContextMenu(lv);
            	}
        		
        		/* Insert the info we already know */
        		ci.add(selectedDepart);
        		ci.add(selectedCourseNum);
        		ci.add(selectedSection);
    		}
    		
    		UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParams);
    		
    		request.setEntity(formEntity);
    		HttpResponse response = client.execute(request);
    		in = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

    		String line = "";
    		while ((line = in.readLine()) != null){
    			if(postVal.equals(POST_DEPARTS)){
    				departadapter.add(line);
    			}
    			else if(postVal.equals(POST_COURSENUM)){
    				coursenumadapter.add(line);
    			}
    			else if(postVal.equals(POST_SECTIONS)){
    				sectionadapter.add(line);
    			}
    			else if(postVal.equals(POST_ADDCOURSE)){
    				ci.add(line);
    			}
    		}
    		
    		/* Create a Spannable for the new course information and add it the list view */
    		if(postVal.equals(POST_ADDCOURSE)){
    			/* Add the new course Spannable to the list view adapter */
        		Spannable span = createCourseSpannable(ci);
        		courselistadapter.add(span);
        	}
    		
    		in.close();
    		
    	}finally{
    		if(in != null){
    			try{
    				in.close();
    			}
    			catch(IOException e){
    				throw new RuntimeException(e);
    			}
    		}
    	}
    }
}
