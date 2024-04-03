/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Test Class for class GetColorsController
*/
@isTest
public with sharing class GetColorsControllerTest {
    private static Account testAccount = new Account(Name = 'Test Account');
	private static String apiResponseOK = '{' +
			'"color": "random color: #A5A4D6",' +
			'"colorCode": "#A5A4D6",' +
			'"colorDate": "2022-05-25T17:26:28.218Z"' +
		'}';
	private static String apiResponseError = '{' +
		'"message": "Not Account in request"' +
	'}';
	static {
		insert testAccount;
	}
	@isTest
	private static void getColorsFromApiAndReturnToFront () {
		ApiColorsMock mock = new ApiColorsMock(200, apiResponseOK);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		GetColorsController.AuraResponse frontResponse = GetColorsController.getColorsFromApi(testAccount.Id);
		Test.stopTest();
		System.assert(frontResponse != null, 'La respuesta debe ser diferente de nula');
		System.assertEquals('success', frontResponse.status, 'El estado no es el esperado');
		System.assertEquals('New color added!', frontResponse.message, 'El estado no es el esperado');
		System.assert(frontResponse.colorInfo != null, 'La info del color debe ser diferente de nula');
		System.assertEquals('random color: #A5A4D6', frontResponse.colorInfo.color, 'El color no es el esperado');
		System.assertEquals('#A5A4D6', frontResponse.colorInfo.colorCode, 'El color no es el esperado');
		System.assertEquals(DateTime.newInstanceGMT(2022, 5, 25, 17, 26, 28), frontResponse.colorInfo.colorDate, 'La hora no es la indicada');
		List<Color_By_Account__c> colorsFromAccount = [SELECT Name, Color_Code__c FROM Color_By_Account__c WHERE Account__c =: testAccount.Id];
		System.assertEquals(1, colorsFromAccount.size(), 'Debe haber solo un color');
		System.assertEquals('random color: #A5A4D6', colorsFromAccount[0].Name, 'El color no es el esperado');
		System.assertEquals('#A5A4D6', colorsFromAccount[0].Color_Code__c, 'El color no es el esperado');
	}
	@isTest
	private static void getErrorFromApiAndReturnMessageToFront () {
		ApiColorsMock mock = new ApiColorsMock(400, apiResponseError);
		Test.setMock(HttpCalloutMock.class, mock);
		Test.startTest();
		GetColorsController.AuraResponse frontResponse = GetColorsController.getColorsFromApi(testAccount.Id);
		Test.stopTest();
		System.assert(frontResponse != null, 'La respuesta debe ser diferente de nula');
		System.assertEquals('warning', frontResponse.status, 'El estado no es el esperado');
		System.assertEquals('Not Account in request', frontResponse.message, 'El estado no es el esperado');
		System.assert(frontResponse.colorInfo == null, 'La info del color debe ser diferente de nula');
		List<Color_By_Account__c> colorsFromAccount = [SELECT Name, Color_Code__c FROM Color_By_Account__c WHERE Account__c =: testAccount.Id];
		System.assert(colorsFromAccount.isEmpty(), 'no debe haber color');
	}
	@isTest
	private static void returnLastColorToFront () {
		List<Color_By_Account__c> colorsToInsert = new List<Color_By_Account__c>();
		for (Integer i = 0; i < 5; i++) {
			Color_By_Account__c colorToInsert = new Color_By_Account__c(
				Name = 'random color: #A5A4D' + i,
				Color_Code__c = '#A5A4D' + i,
				Account__c = testAccount.Id,
				Loaded_Date__c = DateTime.newInstanceGMT(2022, 5, 25, 17, 20 + i, 00)
			);
			colorsToInsert.add(colorToInsert);
		}
		insert colorsToInsert;
		Test.startTest();
		GetColorsController.AuraResponse frontResponse = GetColorsController.getLastColor(testAccount.Id);
		Test.stopTest();
		System.assert(frontResponse != null, 'La respuesta debe ser diferente de nula');
		System.assertEquals('success', frontResponse.status, 'El estado no es el esperado');
		System.assertEquals('Last Color Updated!', frontResponse.message, 'El estado no es el esperado');
		System.assert(frontResponse.colorInfo != null, 'La info del color debe ser diferente de nula');
		System.assertEquals('random color: #A5A4D4', frontResponse.colorInfo.color, 'El color no es el esperado');
		System.assertEquals('#A5A4D4', frontResponse.colorInfo.colorCode, 'El color no es el esperado');
		System.assertEquals(DateTime.newInstanceGMT(2022, 5, 25, 17, 24, 00), frontResponse.colorInfo.colorDate, 'La hora no es la indicada');
	}
	@isTest
	private static void ifThereIsNotColorsReturnMessage () {
		Test.startTest();
		GetColorsController.AuraResponse frontResponse = GetColorsController.getLastColor(testAccount.Id);
		Test.stopTest();
		System.assert(frontResponse != null, 'La respuesta debe ser diferente de nula');
		System.assertEquals('warning', frontResponse.status, 'El estado no es el esperado');
		System.assertEquals('No Colors to Show!', frontResponse.message, 'El estado no es el esperado');
		System.assert(frontResponse.colorInfo == null, 'La info del color debe ser diferente de nula');
	}
}