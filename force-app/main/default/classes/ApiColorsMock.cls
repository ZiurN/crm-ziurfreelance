/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Class to Mock responses from Colors API
*/
@isTest
public with sharing class ApiColorsMock implements HttpCalloutMock {
	public Integer statusCode;
	public String responseBody;
    public ApiColorsMock(Integer statusCode, String responseBody) {
		this.statusCode = statusCode;
		this.responseBody = responseBody;
    }
	public HTTPResponse respond(HTTPRequest req) {
		System.assert(req != null, 'No request found');
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody(responseBody);
		res.setStatusCode(statusCode);
		return res;
	}
}