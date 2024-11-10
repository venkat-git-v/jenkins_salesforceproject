trigger ClosedOpportunityTrigger on Opportunity (after insert,after update) {
       
    List<Task> taskInsert = new List<Task>();
    for(Opportunity o : Trigger.new){
        if(o.StageName == 'Closed Won') taskInsert.add(new Task(Subject = 'Follow Up Test Task', WhatId = o.Id));
    }
    if(taskInsert.size() > 0) insert taskInsert;
    
}