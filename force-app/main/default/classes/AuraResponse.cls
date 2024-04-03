/**
 * @description       : Class to build front responses
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
public virtual class AuraResponse {
    @AuraEnabled public String status {get; set;}
	@AuraEnabled public String message {get; set;}
}