@IsTest
private class AccountProcessorTest {
    @IsTest
    private static void TestContactNumber(){
        Account a = new Account();
                a.Name = 'Brasil Test';
         Insert a;
        
        Account b = new Account();
                b.Name = 'France Test';
         Insert b;
        
        Contact cont = New Contact();
        cont.FirstName = 'Roberto';
        cont.LastName = 'Carlos';
        cont.AccountId = a.Id;
        Insert cont;
        
        set<Id> setAccId = new Set<Id>();
        setAccId.add(a.id);
        setAccId.add(b.id);
          
        Test.startTest();
            AccountProcessor.countContacts(setAccId);
        Test.stopTest();
        
       Account ACC = [select Number_of_Contacts__c from Account where id = :a.id LIMIT 1];
       System.debug(ACC);
       System.assertEquals ( Integer.valueOf(ACC.Number_of_Contacts__c) ,1);
        ACC = [select Number_of_Contacts__c from Account where id = :b.id LIMIT 1];
       System.debug(ACC);
       System.assertEquals ( Integer.valueOf(ACC.Number_of_Contacts__c) ,0);
    }
    
    
    
}