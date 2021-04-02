trigger CloudNewsTrigger  on Cloud_News__c (after insert) {
// List to hold all cases to be created.
    List<Case> cases = new List<Case>();
    
    
    // Iterate through each notification.
    for (Cloud_News__c event : Trigger.New) {
        if (event.Urgent__c == true) {
            // Create Case to dispatch new team.
            Case cs = new Case();
            cs.Priority = 'High';
            cs.Subject = 'News team dispatch to ' +event.Location__c;
            cases.add(cs);
        }
    }
    
    // Insert all cases corresponding to events received.
    insert cases;
}