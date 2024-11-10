trigger TestTrigger on Account (after insert, after update) {

List<Account> accList = new List<account>();

Set<Id> firstAcctIds = new Set<Id>();
Set<Id> lastAcctIds = new Set<Id>();

// Separate your "first" type accounts from your "last" type accounts
for(Account acct : Trigger.new){
    if(acct.Type == 'First'){
        firstAcctIds.add(acct.Id);
    } else if (acct.Type == 'Last'){
        lastAcctIds.add(acct.Id);
    }
}

// Populate the address fields of all the "before" accounts with the values from the contact
for(Contact firstContact: [SELECT Id, AccountId, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode FROM Contact WHERE AccountId IN :firstAcctIds ORDER BY CreatedDate ASC LIMIT 1]){
    Account a = Trigger.newMap.get(firstContact.AccountId);
    a.BillingStreet = firstContact.MailingStreet;
    a.BillingCity = firstContact.MailingCity;
    a.BillingState = firstContact.MailingState;
    a.BillingCountry = firstContact.MailingCountry;
    a.BillingPostalCode = firstContact.MailingPostalCode;
    accList.add(a);
}

// Populate the address fields of all the "last" accounts with the values from the contact
for(Contact lastContact: [SELECT Id, AccountId, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode FROM Contact WHERE AccountId IN :lastAcctIds ORDER BY CreatedDate DESC LIMIT 1]){
    Account a = Trigger.newMap.get(lastContact.AccountId);
    a.BillingStreet = lastContact.MailingStreet;
    a.BillingCity = lastContact.MailingCity;
    a.BillingState = lastContact.MailingState;
    a.BillingCountry = lastContact.MailingCountry;
    a.BillingPostalCode = lastContact.MailingPostalCode;
    accList.add(a);
}

// And you're done!
if(!accList.isEmpty()) {
    update accList;
}
}