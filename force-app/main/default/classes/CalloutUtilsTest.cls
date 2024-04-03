/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Test Class for class CalloutUtils
*/
@isTest
public with sharing class CalloutUtilsTest {
	private static String URL = 'https://apitestjefersonsf2.herokuapp.com/herokuapp.com/avalian/get-color';
	private static String request = '{"accountId" : "123456"}';
	private static String apiResponseOK = '{' +
		'"color": "random color: #A5A4D6",' +
		'"colorCode": "#A5A4D6",' +
		'"colorDate": "2022-05-25T17:26:28.218Z"' +
	'}';
	private static String apiResponseError = '{' +
		'"message": "Not Account in request"' +
	'}';
    @isTest
	private static void checkResponseOk () {
		ApiColorsMock mock = new ApiColorsMock(200, apiResponseOK);
		Test.setMock(HttpCalloutMock.class, mock);
		HttpResponse response = CalloutUtils.call(request, URL, 'POST');
		System.assertEquals(apiResponseOK, response.getBody(), 'El body no es el esperado');
	}
	@isTest
	private static void checkResponseError () {
		ApiColorsMock mock = new ApiColorsMock(400, apiResponseError);
		Test.setMock(HttpCalloutMock.class, mock);
		HttpResponse response = CalloutUtils.call(request, URL, 'POST');
		System.assertEquals(apiResponseError, response.getBody(), 'El body no es el esperado');
	}
}