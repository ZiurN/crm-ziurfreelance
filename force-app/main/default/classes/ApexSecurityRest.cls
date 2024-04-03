/**
 * @description       : 
 * @author            : jefryruiz@gmail.com
 * @group             : 
 * @last modified on  : 06-05-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   06-05-2021   jefryruiz@gmail.com   Initial Version
**/
@RestResource(urlMapping='/apexSecurityRest')
global with sharing class ApexSecurityRest {
    @HttpGet
    global static Contact doGet() {
        Id recordId = RestContext.request.params.get('id');
        Contact result;
        if (recordId == null) {
            throw new FunctionalException('Id parameter is required');
        }
        List <Contact> results = [SELECT Id, Name, Title, Top_Secret__c, Account.Name FROM Contact WHERE Id =: recordId];
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, results);
        if (!results.isEmpty()) {
            result = (Contact)securityDecision?.getRecords()[0];
            result.Description = result?.Account?.Name;
        }
        return result;
    }
    public class FunctionalException extends Exception{}
    public class SecurityException extends Exception{}
}