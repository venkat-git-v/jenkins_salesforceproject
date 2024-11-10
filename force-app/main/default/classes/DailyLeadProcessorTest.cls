@isTest
private class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';//Midnight on 15 march
    public static List<Lead> leadList = new List<Lead>();
    @testSetup
    private static void testSetup() {
        for(Integer i=0;i<200;i++){
            leadList.add(new Lead(LastName='Test '+i,LeadSource='',Company='Briskminds'));
        }INSERT leadList;
    }
    private static testMethod void testData() {
        //All asynchronous processes w'll wun synchronously after test.stopTest();
        test.startTest();
        //Schedule the test jobs
        String jobId = System.Schedule('ScheduledApexTest', CRON_EXP, new DailyLeadProcessor());
        //Verify that the scheduled job has't run yet
        Integer newSizeIs = [SELECT count() FROM Lead WHERE LeadSource='Dreamforce'];
        Integer oldSizeIs = [SELECT count() FROM Lead WHERE LeadSource=''];
        System.assertEquals(200, oldSizeIs);
        System.assertEquals(0, newSizeIs);
        System.assertEquals(0, leadList.size());
        test.stopTest();
        //Validate that the job runs, and the records were updated successfully with the LeadSource='Dreamforce'
        System.assertEquals(200, [SELECT count() FROM Lead WHERE LeadSource='Dreamforce'], 'Records were updated successfully');
        System.assertEquals(0, [SELECT count() FROM Lead WHERE LeadSource='']);       
    }
}