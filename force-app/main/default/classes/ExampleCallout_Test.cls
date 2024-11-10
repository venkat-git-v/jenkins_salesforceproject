@isTest(seeAllData=False)
private class ExampleCallout_Test{

  static Case getTestCase(){
    Case myCase = new Case(Subject = 'Test');
    insert myCase;
    return myCase;
  }

  static testMethod void shouldBeAbleToGetData(){
    Case myCase = getTestCase();
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock());
    HttpResponse res = CalloutClass.getInfoFromExternalService(myCase.Id);
    Test.stopTest();
  }
}