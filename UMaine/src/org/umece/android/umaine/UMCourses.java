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
import android.os.Bundle;
import android.text.Spannable;
import android.text.style.BackgroundColorSpan;
import android.text.style.StyleSpan;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

public class UMCourses extends Activity {
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.courses);

        try{
            doHttpStuff();    	
        }
        catch(Exception e){
        	throw new RuntimeException(e);
        }
    }
    
    public void doHttpStuff() throws Exception{
    	final String[] COUNTRIES = new String[] {
    		    "Afghanistan", "\t<b>Albania</b>", "Algeria", "American Samoa", "Andorra",
    		    "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina",
    		    "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan",
    		    "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium",
    		    "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia",
    		    "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory",
    		    "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burundi",
    		    "Cote d'Ivoire", "Cambodia", "Cameroon", "Canada", "Cape Verde"};
    	
    	BufferedReader in = null;
    	TextView tv = null;
    	ListView lv = (ListView) findViewById(R.id.courseslist);
    	lv.setTextFilterEnabled(true);
    	List<String> courses = new ArrayList<String>();
    	tv = new TextView(this);
    	tv.setText("Text here");

    	EditText newet = new EditText(this);
    	newet.setText("Text\n\there");
    	
    	Spannable str = newet.getText();
    	str.setSpan(new StyleSpan(android.graphics.Typeface.ITALIC), 0, str.length(), Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
    	List<Spannable> newone = new ArrayList<Spannable>();
    	newone.add(str);
    	
    	lv.setAdapter(new ArrayAdapter<Spannable>(this, R.layout.list_item, newone));
    	
    	try {
    		HttpClient client = new DefaultHttpClient();
    		HttpPost request = new HttpPost("http://with.eece.maine.edu/sample.php");
    		
    		List<NameValuePair> postParams = new ArrayList<NameValuePair>();
    		postParams.add(new BasicNameValuePair("one", "thevalueone"));
    		
    		UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParams);
    		
    		request.setEntity(formEntity);
    		HttpResponse response = client.execute(request);
    		in = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));
    		
    		StringBuffer sb = new StringBuffer("");
    		
    		String line = "";
    		String NL = System.getProperty("line.separator");
    		while ((line = in.readLine()) != null){
    			sb.append(NL);
    			sb.append(line);
    			sb.append(NL);
    	
    			courses.add(sb.toString());
    			
    			sb.setLength(0);
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
