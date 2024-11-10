global class AccountProcessor {
    @future
    public static void countContacts(Set<Id> AccoundIds){
        List<Account> ListAccounts = [SELECT Id, Name, Number_of_Contacts__c, (SELECT Id FROM Contacts) FROM Account WHERE id in :AccoundIds];
        
        
        for(Account acc: ListAccounts)
        {
            List<Contact> Con = acc.Contacts;
            
            if(!Con.isEmpty())
            {
                acc.Number_of_Contacts__c = Con.size();
            }
            else
            {
                
                acc.Number_of_Contacts__c = 0;
            }
            
        }
        update ListAccounts;
    }
    
    
}