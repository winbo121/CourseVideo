package egovframework.common.component.rest.logging;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.http.HttpRequest;
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpResponse;
import lombok.extern.slf4j.Slf4j;

/** REST TEMPLATE 에서 사용할 인터셉터  **/
@Slf4j
public class LoggingRequestInterceptor implements ClientHttpRequestInterceptor {

	@Override
	public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution) throws IOException {

		/** REQUEST LOG 출력  **/
		this.loggingRequest(request, body);

		ClientHttpResponse response = execution.execute(request, body);

        /** RESPONSE LOG 출력  **/
        this.loggingResponse(response);

        return response;
	}

	/** 요청 전문 로깅 **/
    private void loggingRequest(HttpRequest request, byte[] body) throws IOException {
    	log.info("request");
    	log.info("request uri : {}", request.getURI());
    	log.info("request method : {}", request.getMethod());
       	log.info("request header : {}", request.getHeaders());
       	log.info("request body : {}", new String( body, StandardCharsets.UTF_8 ));
    }




    /** INPUT STREAM -> String **/
    private String readInputStream( InputStream input_stream, Function<BufferedReader, String> function  ) throws IOException {
        try(  BufferedReader buffered_reader = new BufferedReader(new InputStreamReader( input_stream, StandardCharsets.UTF_8  )); ){
        	return function.apply( buffered_reader );
        }
    }

    /** 응답전문 로깅 **/
    private void loggingResponse(ClientHttpResponse response) throws IOException {

    	Function<BufferedReader, String> function = buffered_reader -> {
    		 String response_body = buffered_reader.lines()
    		 													.collect( Collectors.joining("\n") );
    		return response_body;
    	};

    	String response_body = this.readInputStream( response.getBody(), function );
        log.info("response");
    	log.info("response status code : {}", response.getStatusCode());
       	log.info("response header : {}", response.getHeaders());
       	log.info("response body : {}", response_body );

    }

}
