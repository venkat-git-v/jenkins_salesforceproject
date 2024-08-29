public class AccountCtrl {
    
    /** Method to implement Apex Wire Method to a property, apex wire method to a function and 
    Call an Apex Method Imperatively  **/
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountDataList(String searchKey) {
        
        List<Account> accObjList = [SELECT  Id, Name From Account Limit 5];
        
        return accObjList;
    } 
 
    /** Method to get Account in search result **/
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(String searchKey) {
        searchKey = '%' + searchKey + '%';
        List<Account> accList = [SELECT  Id, Name, Industry, Phone, Type From Account WHERE Name LIKE :searchKey];

        return accList;
    }
}