({
	getLastColorFromApex : function (component, recordId) {
		component.set('v.isLoading', true);
		var action = component.get("c.getLastColor");
		action.setParams({
			AccountId : recordId
		});
		action.setCallback(this, function(res) {
			this.apexCallBack(component, res);
		});
		$A.enqueueAction(action);
	},
	getColorsFromApiFromApex: function (component, recordId) {
		component.set('v.isLoading', true);
		var action = component.get("c.getColorsFromApi");
		action.setParams({
			AccountId : recordId
		});
		action.setCallback(this, function(res) {
			this.apexCallBack(component, res);
			$A.get('e.force:refreshView').fire();
		});
		$A.enqueueAction(action);
	},
	apexCallBack : function (component, res) {
		if (res.getState() === "SUCCESS") {
			let response = res.getReturnValue();
			if (response.status == 'success') {
				console.log(JSON.parse(JSON.stringify(response)));
				component.set('v.colorInfo', response.colorInfo);
				component.set('v.haveColors', true);
				this.sendMessageToUser('', response.status, response.message);
			} else {
				this.sendMessageToUser('', response.status, response.message);
			}
		} else {
			console.log(JSON.parse(JSON.stringify(res.getReturnValue())));
			this.sendMessageToUser('Error!', 'error', 'Error calling Apex!');
		}
		component.set('v.isLoading', false);
		console.log(component.get('v.isLoading'));
	},
	sendMessageToUser: function (title, status, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": status,
			"message": message
		});
		toastEvent.fire();
	}
})