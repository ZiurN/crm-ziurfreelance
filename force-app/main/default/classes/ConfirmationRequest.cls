/**
 * @description       : Serializer and deserializer class
 * @author            : jefryruiz@gmail.com
 * @group             :
 * @last modified on  : 04-26-2021
 * @last modified by  : jefryruiz@gmail.com
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   04-26-2021   jefryruiz@gmail.com   Initial Version
**/
public class ConfirmationRequest {
	public String accountNumber;
	public String orderNumber;
	public String type;
	public String status;
	public List<OrderProducts> orderProducts;
	public class OrderProducts {
		public String name;
		public String code;
		public Double unitPrice;
		public Double quantity;
	}
}