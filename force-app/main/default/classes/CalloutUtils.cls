/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Class to make external callouts
*/
public without sharing class CalloutUtils {
	public static HttpResponse call(String msgBody, String endpoint, String method){
		HttpRequest request = new HttpRequest();
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setBody(msgBody);
		System.debug(request.getBody());
		request.setEndpoint(endpoint);
		request.setMethod(method);
		Http h = new Http();
		HttpResponse response = h.send(request);
		return response;
	}
}