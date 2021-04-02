@isTest
public class TestRestrictContactByName {
    @isTest static void TestInvalidName(){
        Contact con = new Contact(LastName = 'INVALIDNAME');
        
        
        Test.startTest();
        try{
            insert con;
        }
        catch (DmlException dmlEx){
            System.assertEquals('The Last Name "'+ con.LastName+'" is not allowed for DML', dmlEx.getDmlMessage(0));
        }
        Test.stopTest();
    }

}