trigger OppShare on Opportunity (after insert, after update) {
    List<Opportunity> Opportunities = Trigger.New;
    Map<Id, Opportunity> oldMap = Trigger.oldMap;
    OppShareActions.execute(Opportunities, oldMap);
}