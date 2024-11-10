@isTest
private class TestVerifyDate {
    @isTest static void testDateWithin30Days() {
        
        Date d = VerifyDate.CheckDates(system.today(), system.today().addDays(20));
        System.assertEquals(d,system.today().addDays(20));
        
        d = VerifyDate.CheckDates(system.today(), system.today().addDays(40));
        Integer totalDays = Date.daysInMonth(system.today().year(), system.today().month());
        Date lastDay = Date.newInstance(system.today().year(), system.today().month(), totalDays);
        System.assertEquals( lastDay, d);
        
        d = VerifyDate.CheckDates(system.today(), system.today().addDays(-2));
        System.assertEquals(lastDay, d);
        
        
    }
  
    }