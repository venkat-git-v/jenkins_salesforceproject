public with sharing class ContactListController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactList() {
        List<Contact> contactList = [SELECT Id, FirstName, LastName FROM Contact WITH SECURITY_ENFORCED];
        if(contactList.size()<5) {
            throw new AuraHandledException('Contacts cannot be less than 5');
        }
        return contactList;
    }
}