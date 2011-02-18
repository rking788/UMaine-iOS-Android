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
    	BufferedReader in = null;
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
    		}
    		in.close();
    		
    		String result = sb.toString();
    		TextView tv = (TextView) findViewById(R.id.courseslabel);
    		tv.append(result);
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
