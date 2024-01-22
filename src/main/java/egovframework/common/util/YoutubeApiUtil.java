package egovframework.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.Duration;
import java.util.concurrent.TimeUnit;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class YoutubeApiUtil {
	
	@Value(value="${google.youtube.api.key}")
	private String api_key;

	public String getVideoInfo(String id) throws IOException {
		String result = "";
		String apiurl = "https://www.googleapis.com/youtube/v3/videos";
		apiurl += "?id=" + URLEncoder.encode(id,"UTF-8");
		apiurl += "&key=" + api_key;
		apiurl += "&part=contentDetails";
		
		try {
			
			URL url = new URL(apiurl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
			String inputLine;
			StringBuffer response = new StringBuffer();
			while((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();
			
			result = response.toString();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public Integer getVideoDuration(String url) throws Exception {
		Integer result = null;
		String id = "";
		
		try {
			
			id = this.getIdFromUrl(url);
			if(id.equals("")) {
				return result;
			}
			
			String strInfo = this.getVideoInfo(id);
			if(!strInfo.equals("")) {
				JSONObject videoInfo = new JSONObject(strInfo);
				JSONArray items = videoInfo.getJSONArray("items");
				if(!items.isNull(0)) {
					JSONObject content = items.getJSONObject(0);
					JSONObject contentDetails = content.getJSONObject("contentDetails");
					String strDuration = contentDetails.getString("duration");
						
					Duration duration = Duration.parse(strDuration);
					long seconds = TimeUnit.MILLISECONDS.toSeconds(duration.toMillis());
					result = Long.valueOf(seconds).intValue();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String getIdFromUrl(String url) {
		String id = "";
		
		if(url.contains("youtube.com/watch")) {
			id = url.split("\\?")[1].split("=")[1];
			if(id.contains("&")) {
				id = id.split("&")[0];
			}
		} else if (url.contains("youtu.be/")) {
			id = url.split("/")[3];
			if(id.contains("?")) {
				id = id.split("\\?")[0];
			}
		}
		
		return id;
	}
}
