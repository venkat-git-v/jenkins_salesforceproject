public class ManagingAccountAndContacts {
        public void isAfterUpdate(List<Account> accList){
            updateAddressToContacts(accList);
        }
    
        public void updateAddressToContacts(List<Account> accList){
             Map<Id,Account> mapOfIdToAccount = new Map<Id,Account>();
            List<contact>    lstOfUpdcontacts = new List<Contact>();
            for(Account acc:accList){
            mapOfIdToAccount.put(acc.id,acc);// Map the ID of accounts
            }
            //the query below returns all the mailing address of contacts associated to the account being updated
            List<Contact> contactList =[select accountId,MailingStreet,MailingCity, MailingState,MailingPostalCode,MailingCountry 
                                        from Contact where AccountId IN:accList];
               Account newAcc;
            for(Contact con: contactList){
                newAcc = mapOfIdToAccount.get(con.AccountId);// assigns the new value of mailing address
                con.MailingStreet = newAcc.BillingStreet; 
                con.MailingCity = newAcc.BillingCity;
                con.MailingState = newAcc.BillingPostalCode;
                con.MailingCountry = newAcc.BillingCountry;
                
                lstOfUpdcontacts.add(con);     
            }
            if(!lstOfUpdcontacts.IsEmpty()){
            update lstOfUpdcontacts;
            }
        }        
        
}