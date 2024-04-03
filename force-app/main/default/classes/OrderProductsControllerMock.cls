/**
 * @description       : Confirmation API call mock
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
@isTest
public class OrderProductsControllerMock implements HttpCalloutMock {
	public Integer statusCode;
	public OrderProductsControllerMock(Integer statusCode) {
		this.statusCode = statusCode;
	}
	public HTTPResponse respond(HTTPRequest req) {
		System.assert(req != null, 'No request found');
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"example":"test"}');
		res.setStatusCode(statusCode);
		return res;
	}
}