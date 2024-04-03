({
	init : function (component, event, helper) {
		var recordId = component.get('v.recordId');
		helper.getLastColorFromApex(component, recordId);
	},
    handleClick : function (component, event, helper) {
		var recordId = component.get('v.recordId');
		helper.getColorsFromApiFromApex(component, recordId);
    }
})