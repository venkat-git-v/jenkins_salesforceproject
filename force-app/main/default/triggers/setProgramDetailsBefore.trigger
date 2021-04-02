trigger setProgramDetailsBefore on Program_Enrollment__c (before update, before insert) {
    
   /* for (Program_Enrollment__c p: trigger.new) {
         if(p.Status__c == 'Active' && p.Account__c!=null ) { 
            p.Account_Active__c= p.Account__c; 
            p.Pro_Account_Active__c = p.Pro_Account__c;
        } else { 
            p.Account_Active__c= null; 
            p.Pro_Account_Active__c = null;
        }
    
    } */
}