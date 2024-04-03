/**
 * @author		: Jeferson Ruiz
 * @date		: 25/05/2033
 * @description	: Class to deserialize the Api of Colors
*/
public with sharing class ApiColorsParser {
	@AuraEnabled public String color {get; set;}
	@AuraEnabled public String colorCode {get; set;}
	@AuraEnabled public DateTime colorDate {get; set;}
	@AuraEnabled public String message {get; set;}
}