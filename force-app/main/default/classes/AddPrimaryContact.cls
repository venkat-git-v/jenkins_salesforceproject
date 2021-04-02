public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;
    
    public AddPrimaryContact(Contact c, String st) {
        this.contact = c;
        this.state = st;
    }
    
    public void execute(QueueableContext context) {
        List<Account> accountList = [SELECT ID, Name,
                                     (Select id, FirstName, LastName from Contacts)
                                     FROM ACCOUNT WHERE BillingState = :state
                                     LIMIT 200];
        
        List<Contact> contactList = new List<Contact>();
        
        for(Account acc : accountList) {
//            Contact newContact = contact.clone(false, false, false, false);
//            newContact.AccountID = acc.Id;
//            contactList.add(newContact);
        }
        
        insert contactList;    
    }
    
}