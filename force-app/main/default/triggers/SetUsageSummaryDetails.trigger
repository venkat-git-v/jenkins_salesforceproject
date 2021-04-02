trigger SetUsageSummaryDetails on Usage_Summary__c (before insert, before update) {
    for (Usage_Summary__c u: trigger.new) {
        if( u.Producer_Account__c == Null ) {
            u.Producer_Account__c = u.Summary_Producer_Account__c;
        }
        if (trigger.isUpdate){
            Usage_Summary__c OLD_R = trigger.oldMap.get(u.Id);
            for(Schema.FieldSetMember f : SObjectType.Usage_Summary__c.FieldSets.Community_User_Fields.getFields()) {
                if(String.valueOf(u.get(f.getFieldPath()))!=String.valueOf(OLD_R.get(f.getFieldPath()))) {
                    u.Last_Modified_By__c  = userinfo.getUserId();
                    u.Last_Modified_Date_Time__c  = DateTime.now();
                    break;
                }
            }
        }
    }
}