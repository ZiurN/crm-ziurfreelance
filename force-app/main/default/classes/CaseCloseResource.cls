@RestResource(urlMapping='/opportunity/*/close')
global with sharing class CaseCloseResource {
	@HttpPost
	global static void closeCase(String closeReason) {
		Set<Id> caseIds = new Set<Id>{RestContext.request.requestURI.split('/')[2]};
		CaseService.closeCases(caseIds, closeReason);
	}
}