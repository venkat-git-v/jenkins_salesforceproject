@isTest

public class AddPrimaryContactTest {
    
    @isTest static void apctest() {
        
        List<Account> testList = new List<Account>();
        
        for(Integer i; i < 50; i++) {
            Account cal = new Account();
            cal.Name = 'California ' + i;
            cal.BillingState = 'CA';
            testList.add(cal);

            Account ny = new Account();
            ny.Name = 'New York ' + i;
            ny.BillingState = 'NY';
            testList.add(ny);
        }

        insert testList;

        contact testContact = new Contact();
        testContact.FirstName = 'Evelyn';
        testContact.LastName = 'Maguire';
        insert testContact;
        String testState = 'CA';

        AddPrimaryContact testAPC = new AddPrimaryContact(testContact, testState);

        Test.startTest();
            System.enqueueJob(testAPC);
        Test.stopTest();   
    }
   }