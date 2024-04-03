@isTest
public with sharing class ApiColorsParserTest {
    private static String apiResponseOK = '{' +
		'"color": "random color: #A5A4D6",' +
		'"colorCode": "#A5A4D6",' +
		'"colorDate": "2022-05-25T17:26:28.218Z"' +
	'}';
	private static String apiResponseError = '{' +
		'"message": "Not Account in request"' +
	'}';
	@isTest
	private static void testParserResponseOk () {
		ApiColorsParser parsed = (ApiColorsParser) JSON.deserialize(apiResponseOK, ApiColorsParser.class);
		System.assert(parsed != null, 'El objeto es diferente de nulo');
		System.assert(parsed.message == null, 'No debe haber ningún mensaje');
		System.assertEquals('random color: #A5A4D6', parsed.color, 'El nombre del color no es el indicado');
		System.assertEquals('#A5A4D6', parsed.colorCode, 'El nombre del color no es el indicado');
		System.debug(parsed.colorDate);
		System.assertEquals(DateTime.newInstanceGMT(2022, 5, 25, 17, 26, 28), parsed.colorDate, 'La hora no es la indicada');
	}
	@isTest
	private static void testParserResponseError () {
		ApiColorsParser parsed = (ApiColorsParser) JSON.deserialize(apiResponseError, ApiColorsParser.class);
		System.assert(parsed != null, 'El objeto es diferente de nulo');
		System.assert(parsed.message != null, 'Debe haber ningún mensaje');
		System.assertEquals('Not Account in request', parsed.message, 'El mensaje no es el esperado');
	}
}