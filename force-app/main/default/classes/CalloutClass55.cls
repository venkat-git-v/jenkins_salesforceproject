public class CalloutClass55 {
    public static HttpCalloutMock mock = null;
    public static HttpResponse getInfoFromExternalService(Id myCaseId) {
        Case myCase = [SELECT Id, Account.Integration_Key__c FROM Case WHERE Id = :myCaseId LIMIT 1]; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/foo/bar?id=' + myCase.Account.Integration_Key__c);
        req.setMethod('GET');
        if (Test.isRunningTest() && (mock!=null)) {
            return mock.respond(req);
        } else {
            Http h = new Http();
            return h.send(req);
        }
    }
}