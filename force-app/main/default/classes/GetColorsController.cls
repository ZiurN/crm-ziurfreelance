/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Controller Class of the Aura GetColor
*/
public with sharing class GetColorsController {
	private static String URL = 'https://apitestjefersonsf2.herokuapp.com/avalian/get-color';
	@AuraEnabled
	public static AuraResponse getColorsFromApi(String AccountId) {
		Request req = new Request(AccountId);
		String stringReq = JSON.serialize(req);
		System.debug(stringReq);
		HttpResponse response = CalloutUtils.call(stringReq, URL, 'POST');
		System.debug(response.getBody());
		ApiColorsParser colorInfo = (ApiColorsParser) JSON.deserialize(response.getBody(), ApiColorsParser.class);
		AuraResponse frontResponse = new AuraResponse();
		if (response.getStatusCode() >= 200 && response.getStatusCode() < 300) {
			frontResponse.status = 'success';
			frontResponse.message = 'New color added!';
			frontResponse.colorInfo = colorInfo;
			createColorRecord(colorInfo, AccountId);
		} else {
			frontResponse.status = 'warning';
			frontResponse.message = colorInfo.message != null ? colorInfo.message: 'Error Calling API';
		}
		return frontResponse;
	}
	@AuraEnabled
	public static AuraResponse getLastColor(String AccountId) {
		List<Color_By_Account__c> colorsFromAccount = [SELECT
														Name,
														Color_Code__c,
														Loaded_Date__c
													FROM Color_By_Account__c
													WHERE Account__c =: AccountId
													ORDER BY Loaded_Date__c DESC
													LIMIT 1];
		AuraResponse frontResponse = new AuraResponse();
		if (!colorsFromAccount.isEmpty()) {
			frontResponse.status = 'success';
			frontResponse.message = 'Last Color Updated!';
			ApiColorsParser colorInfo = new ApiColorsParser();
			colorInfo.color = colorsFromAccount[0].Name;
			colorInfo.colorCode = colorsFromAccount[0].Color_Code__c;
			colorInfo.colorDate =  colorsFromAccount[0].Loaded_Date__c;
			frontResponse.colorInfo = colorInfo;
		} else {
			frontResponse.status = 'warning';
			frontResponse.message = 'No Colors to Show!';
		}
		return frontResponse;
	}
	private static void createColorRecord (ApiColorsParser colorInfo, String accountId) {
		Color_By_Account__c newColor = new Color_By_Account__c(
			Name = colorInfo.color,
			Color_Code__c = colorInfo.colorCode,
			Account__c = accountId,
			Loaded_Date__c = colorInfo.colorDate
		);
		insert newColor;
	}
	public class AuraResponse {
		@AuraEnabled public string status {get;set;}
		@AuraEnabled public string message {get;set;}
		@AuraEnabled public ApiColorsParser colorInfo {get; set;}
	}
	public class Request {
		public String accountId {get; set;}
		public Request(String AccountId) {
			this.accountId = AccountId;
		}
	}
}