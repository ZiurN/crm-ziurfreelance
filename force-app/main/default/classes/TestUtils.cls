/**
 * @description       : 
 * @author            : jefryruiz@gmail.com
 * @group             : 
 * @last modified on  : 04-25-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   04-25-2021   jefryruiz@gmail.com   Initial Version
**/
@isTest
public class TestUtils {
    public static List<PricebookEntry> getPbEntriesByPbName(String pbName){
		return [SELECT Product2.Name, UnitPrice FROM PricebookEntry WHERE Pricebook2.Name =: pbName LIMIT 5];
	}
	public static Order returnOrder(String orderName){
		return [SELECT id, Status FROM Order WHERE Name =: orderName LIMIT 1];
	}
}