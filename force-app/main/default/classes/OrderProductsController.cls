/**
 * @description       : Controller Class of the LWC OrderProducts
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
public with sharing class OrderProductsController {
	@AuraEnabled
	public static List<OrderItem> getOrderItems(Id OrderId){
		try {
			return [SELECT Product2.Name,
						Quantity,
						UnitPrice,
						TotalPrice
					FROM OrderItem
					WHERE OrderId =: OrderId
					WITH SECURITY_ENFORCED];
		} catch (Exception e) {
			throw new AuraHandledException(e.getMessage());
		}
	}
	@AuraEnabled
	public static Response activateOrder(Id OrderId){
		Response frontResponse = new Response();
		try {
			Order order = [SELECT Status,
								Account.AccountNumber,
								OrderNumber,
								Type
							FROM Order
							WHERE Id =: OrderId
							WITH SECURITY_ENFORCED];
			List<OrderItem> orderItems = [SELECT Product2.Name,
											Quantity,
											UnitPrice,
											TotalPrice,
											OrderItemNumber
										FROM OrderItem
										WHERE OrderId =: OrderId
										WITH SECURITY_ENFORCED];
			String msgBody = buildHttpReqBody(order, orderItems);
			httpResponse response = CalloutUtils.call(msgBody, 'https://orderconfirmation.requestcatcher.com/', 'POST');
			if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
				order.Status = 'Activated';
				Database.SaveResult result = Database.update(order);
				if(result.isSuccess()){
					frontResponse.status = 'success';
					frontResponse.message = 'Order Activated successfully';
					frontResponse.orderStatus = 'Activated';
				}else {
					frontResponse.status = 'error';
					frontResponse.message = result.getErrors()[0].getMessage();
				}
			}else{
				frontResponse.status = 'error';
				frontResponse.message = 'Call to External System Failed';
				frontResponse.orderStatus = 'Draft';
			}
		} catch (Exception e) {
			frontResponse.status = 'error';
			frontResponse.message = e.getMessage();
		}
		return frontResponse;
	}

	private static String buildHttpReqBody(Order order, List<OrderItem> orderItems){
		ConfirmationRequest request = new ConfirmationRequest();
		request.accountNumber = order.Account.AccountNumber;
		request.orderNumber = order.OrderNumber;
		request.status = order.Status;
		request.type = order.Type;
		request.orderProducts = new List<ConfirmationRequest.OrderProducts>();
		if(OrderItems.size() > 0){
			for(OrderItem orderItem: OrderItems){
				ConfirmationRequest.OrderProducts orderProduct = new ConfirmationRequest.OrderProducts();
				orderProduct.code = orderItem.OrderItemNumber;
				orderProduct.name = orderItem.Product2.Name;
				orderProduct.quantity = orderItem.Quantity;
				orderProduct.unitPrice = orderItem.UnitPrice;
				request.orderProducts.add(orderProduct);
			}
		}
		return JSON.serialize(request);
	}
	public class Response extends AuraResponse {
		@AuraEnabled public String orderStatus;
	}
}