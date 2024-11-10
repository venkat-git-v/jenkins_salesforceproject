public class OppShareActions {
    
    public static OpportunityShare getOppShareObject(Opportunity opportunity, User user){
        OpportunityShare ops = new OpportunityShare();
        ops.OpportunityId = opportunity.Id;
        ops.UserOrGroupId = user.Id;
        ops.RowCause = 'Manual'; 
        ops.OpportunityAccessLevel = 'Read';
        return ops;
    }
    public static void newOpp(Opportunity opp, List<OpportunityShare> tobeInserted){
        List<User> users = [SELECT Id FROM User WHERE ContactId =: opp.ContactId];
        if(null != users && users.size() >0){
            OpportunityShare opps = getOppShareObject(opp, users[0]);
            tobeInserted.add(opps);
        }
    }
    
    public static void execute(List<Opportunity> Opportunities, Map<Id, Opportunity> oldMap){
        List<OpportunityShare> tobeDeletedOppShare = new List<OpportunityShare>();
        List<OpportunityShare> tobeInsertedOppShare = new List<OpportunityShare>();
   
        for(Opportunity opp : Opportunities) {
            List<User> users = null;
            tobeDeletedOppShare = new List<OpportunityShare>();
            tobeInsertedOppShare = new List<OpportunityShare>();

             //System.debug('Get Old Value');
            
            if( oldMap != null){
                Opportunity oldOpp = oldMap.get(opp.Id);
                if(opp.ContactId!= oldOpp.ContactId|| opp.OwnerId != oldOpp.OwnerId){
                    if(opp.ContactId!= null){
                        newOpp(opp, tobeInsertedOppShare);
                     }
                     
                     if(oldOpp.ContactId!= null){
                        users = [SELECT Id FROM User WHERE ContactId =: oldOpp.ContactId];
                        if(null != users && users.size() >0){
                            List<OpportunityShare> shares = [SELECT Id FROM OpportunityShare WHERE OpportunityId =: opp.Id AND UserOrGroupId =: users[0].Id And RowCause = 'Manual'];
                            tobeDeletedOppShare.addAll(shares);
                        }
                    }
                
                }
            }else{
                if(opp.ContactId!= null){
                    newOpp(opp, tobeInsertedOppShare);
                }    
            }
            
            System.debug('test - '+tobeDeletedOppShare);
            System.debug('test1 - '+tobeInsertedOppShare);
            
            if(tobeDeletedOppShare.size() > 0){
                delete tobeDeletedOppShare;
            }
            if(tobeInsertedOppShare.size() > 0){
                insert tobeInsertedOppShare;
            }
        }
    }
}