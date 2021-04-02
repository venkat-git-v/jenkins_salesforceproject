global with sharing class PlatformEventRaise implements Database.Batchable<SObject>, Database.RaisesPlatformEvents{
    // class implementation
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Id ,Name,Rating,Industry, BillingAddress,BillingStreet,BillingCity, BillingCountry, BillingPostalCode,BillingState,Phone from Account  where BillingStreet!=NULL');
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Account> accs =(List<Account>) scope ; 
        List<Cloud_News__c> cnewList = new List<Cloud_News__c>();
        for(Account a : accs){
            // Create an instance of the event and store it in the newsEvent variable
            Cloud_News__c newsEvent = new Cloud_News__c(
                Location__c=a.BillingStreet, 
                Urgent__c=true, 
                News_Content__c=a.BillingStreet);
            cnewList.add(newsEvent) ;
            
        }
      //  EventBus.publish(cnewList);
        
    }
    
    global void finish(Database.BatchableContext BC){
    }
}