/**
 * @description       : Controller class of the LWC AvailableProducts
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-24-2021   jefryruiz@gmail.com   Initial Version
**/
public with sharing class AvailableProductsController {
	/**
	* @description get the Product in the priceboot associated with Order sortered by quantity.
	* @author jefryruiz@gmail.com | 04-24-2021
	* @param OrderId
	* @return List<PBEntrySortable>
	**/
	@AuraEnabled(cacheable=true)
	public static List<PBEntrySortable> getAvailableProducts(Id OrderId){
		try {
			Order order = [SELECT Pricebook2Id FROM Order WHERE id =: OrderId WITH SECURITY_ENFORCED];
			List<PricebookEntry> pbEntries = [SELECT Product2.Name,
													UnitPrice
												FROM PricebookEntry
												WHERE Pricebook2Id =: order.Pricebook2Id
												WITH SECURITY_ENFORCED];
			List<OrderItem>	OrderItems = returnOrderItemsFromOrder(OrderId);
			Map<Id, Integer> pbEntryByQuantityInOrder = new Map<Id, Integer>();
			for(OrderItem orderItem : OrderItems) {
				pbEntryByQuantityInOrder.put(orderItem.PricebookEntryId, Integer.valueOf(orderItem.Quantity));
			}
			List<PBEntrySortable> pbSortables = new List<PBEntrySortable>();
			for(PricebookEntry pbEntry : pbEntries){
				PBEntrySortable pbSortable;
				if(pbEntryByQuantityInOrder.keySet().contains(pbEntry.Id)){
					pbSortable = new PBEntrySortable(pbEntryByQuantityInOrder.get(pbEntry.Id), pbEntry);
				}else{
					pbSortable = new PBEntrySortable(0, pbEntry);
				}
				pbSortables.add(pbSortable);
			}
			pbSortables.sort();
			return pbSortables;
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	@AuraEnabled
	public static AuraResponse addProductsToOrder(List<PricebookEntry> pbList, Id OrderId){
		AuraResponse response = new AuraResponse();
		try {
			List<OrderItem> orderItemsToUpsert = new List<OrderItem>();
			List<OrderItem>	OrderItems = returnOrderItemsFromOrder(OrderId);
			Map<Id, OrderItem> orderItemsBypBEntriesIds = new Map<Id, OrderItem>();
			for(OrderItem orderItem : OrderItems){
				orderItemsBypBEntriesIds.put(orderItem.PricebookEntryId, orderItem);
			}
			if(pbList.size() > 0){
				for(PricebookEntry pbEntry : pbList){
					OrderItem orderItem= new OrderItem();
					orderItem.OrderId = OrderId;
					orderItem.PricebookEntryId = pbEntry.Id;
					orderItem.UnitPrice = pbEntry.UnitPrice;
					orderItem.Quantity = 1;
					if(orderItemsBypBEntriesIds.keySet().contains(pbEntry.Id)){
						orderItem.Quantity = 1 + orderItemsBypBEntriesIds.get(pbEntry.Id).Quantity;
						orderItem.Id = orderItemsBypBEntriesIds.get(pbEntry.Id).Id;
					}
					orderItemsToUpsert.add(orderItem);
				}
				Database.upsert(orderItemsToUpsert);
			}
			response.status = 'success';
			response.message = 'All Products have been added to the order';
		} catch (Exception e) {
			response.status = 'error';
			response.message = 'An error has occurred : ' + e.getMessage();
		}
		return response;
	}
	private static List<OrderItem> returnOrderItemsFromOrder(id OrderId){
		return [SELECT PricebookEntryId, Quantity FROM OrderItem WHERE OrderId =: OrderId WITH SECURITY_ENFORCED];
	}
	public class PBEntrySortable implements Comparable{
		@AuraEnabled public PricebookEntry pbEntry;
		@AuraEnabled public Integer productQuantityInOrder;
		public PBEntrySortable(Integer productQuantityInOrder, PricebookEntry pbEntry){
			this.pbEntry = pbEntry;
			this.productQuantityInOrder = productQuantityInOrder;
		}
		public Integer compareTo(Object compareTo){
			PBEntrySortable compareToPbEntry = (PBEntrySortable)compareTo;
			Integer value = 0;
			if(productQuantityInOrder > compareToPbEntry.productQuantityInOrder){
				value = -1;
			}else if(productQuantityInOrder < compareToPbEntry.productQuantityInOrder){
				value = 1;
			}else if(productQuantityInOrder == null && compareToPbEntry.productQuantityInOrder != null){
				value = 1;
			}else if(productQuantityInOrder != null && compareToPbEntry.productQuantityInOrder == null){
				value = -1;
			}
			return value;
		}
	}
}