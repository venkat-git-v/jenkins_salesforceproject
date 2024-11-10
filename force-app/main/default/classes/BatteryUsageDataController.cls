public class BatteryUsageDataController {
    
    
    @AuraEnabled
    public static Boolean checkReportSubms(string rsID) {
      List<Report_Submission__c> reportSubList = [Select Id,Account__c,Registration_Detail__c,Status__c,Producer_Account__c From Report_Submission__c Where Id =:rsID AND Status__c = 'Not Started'];
       // List<Usage_Summary__c> reportSubList = [Select Id,Report_Submission__c From Usage_Summary__c Where Report_Submission__c =:rsID limit 2];
        if(reportSubList.size() == 0){
             return false;
        }else{
             return true;
        }
    }
    @AuraEnabled
    public static List<usageDataWrapper> getUsageData() {
      List<usageDataWrapper> usageWrapperList = New List<usageDataWrapper>(); 
        Integer currentYear = Date.Today().Year();
        Map<string,usageDataWrapper> usageMap = New Map<String,usageDataWrapper>{'Small single use batteries' => New usageDataWrapper('Small single use batteries'),'Small rechargeable batteries' => New usageDataWrapper('Small rechargeable batteries'),'Large batteries' => New usageDataWrapper('Large batteries')};
        Date pastDate = date.newinstance((currentYear -3), 12, 31);
        List<Usage_Data__c> UsageDataList = [Select Id,Quantity__c,Category__c,Program__c,Year__c From Usage_Data__c Where Program__c = 'Batteries' AND Year__c >=: pastDate];
        for(Usage_Data__c UdVar : UsageDataList){
            if(usageMap.containsKey(UdVar.Category__c) && UdVar.Year__c.Year() == (currentYear-3)){
              usageMap.get(UdVar.Category__c).year1 = Integer.ValueOf(UdVar.Quantity__c);
                usageMap.get(UdVar.Category__c).year1Id = UdVar.Id;
            }
            if(usageMap.containsKey(UdVar.Category__c) && UdVar.Year__c.Year() == (currentYear-2)){
              usageMap.get(UdVar.Category__c).year2 = Integer.ValueOf(UdVar.Quantity__c);
                usageMap.get(UdVar.Category__c).year2Id = UdVar.Id;
            }
            if(usageMap.containsKey(UdVar.Category__c) && UdVar.Year__c.Year() == (currentYear-1)){
              usageMap.get(UdVar.Category__c).year3 = Integer.ValueOf(UdVar.Quantity__c);
                usageMap.get(UdVar.Category__c).year3Id = UdVar.Id;
            }
            
        }
        system.debug('usageMap='+usageMap);
        system.debug('usageMapV='+usageMap.Values());
        return usageMap.Values();
    }
  @AuraEnabled
    public static void createUsageData(List<usageDataWrapper> usageDataWrapperList,string rsID ,double totalFee) {
      system.debug('usageDataWrapperList=='+usageDataWrapperList); 
        Integer currentYear = Date.Today().Year();
        List<Usage_Data__c> usageDataToInsert = New List<Usage_Data__c>();
        List<Usage_Summary__c> usageSummaryToInsert = New List<Usage_Summary__c>();
        Map<Integer,Usage_Summary__c > usageSummaryMap = New Map<Integer,Usage_Summary__c>();
        List<Report_Submission__c> reportSubList = [Select Id,Account__c,Registration_Detail__c,Status__c,Producer_Account__c,Account__r.Primary_Contact__c From Report_Submission__c Where Id =:rsID Limit 1];
        List<Product2> productList = [Select Id,Name,ProductCode From Product2 Where Name ='Registry Fees - Batteries'];
        List<Pricebook2> Pricebook2List = [Select Id,Name From Pricebook2 Where Name ='Registry Price Book'];
        PricebookEntry pbe = [ SELECT Id,Product2Id,Pricebook2Id,UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :Pricebook2List[0].Id AND isActive = true AND ProductCode =: productList[0].ProductCode LIMIT 1];
        for(Usage_Summary__c usVar : [Select Id,Date__c From Usage_Summary__c Where Report_Submission__c =:rsID AND Program__c = 'Batteries']){
          usageSummaryMap.put(usVar.Date__c.Year(),usVar);   
        }
        for( integer i = currentYear -3 ; i < currentYear ; i++){
            Usage_Summary__c uSumVar = New Usage_Summary__c();
            uSumVar.Account__c = reportSubList[0].Account__c;
            uSumVar.Registration_Detail__c = reportSubList[0].Registration_Detail__c;
            uSumVar.Producer_Account__c = reportSubList[0].Producer_Account__c;
            uSumVar.Report_Submission__c = reportSubList[0].Id; 
            uSumVar.Status__c = 'In Progress';
            uSumVar.Program__c = 'Batteries';
            uSumVar.Date__c = date.newinstance((i), 01, 01);
            if(!usageSummaryMap.containsKey(i))
              usageSummaryToInsert.add(uSumVar);
        }
        if(usageSummaryToInsert.size() > 0) Insert usageSummaryToInsert;
        system.debug('usageSummaryToInsert=='+usageSummaryToInsert);
        
        for(Usage_Summary__c usVar : usageSummaryToInsert){
          usageSummaryMap.put(usVar.Date__c.Year(),usVar);   
        }
        
        for(usageDataWrapper wVar : usageDataWrapperList){
            if(wVar.year1 <> Null && wVar.year1 > 0){
              Usage_Data__c UDVar = New Usage_Data__c(); 
              UDVar.Year__c = date.newinstance((currentYear -3), 12, 31);
                UDVar.Count__c  = wVar.year1;
                UDVar.Quantity__c   = wVar.year1;
                UDVar.Category__c = wVar.type;
                UDVar.Program__c = 'Batteries';                
                UDVar.Account__c = reportSubList[0].Account__c;
                UDVar.Registration_Detail__c = reportSubList[0].Registration_Detail__c;
                UDVar.Producer_Account__c = reportSubList[0].Producer_Account__c;
                UDVar.Report_Submission__c = reportSubList[0].Id;
                UDVar.Usage_Summary__c = usageSummaryMap.get(currentYear - 3).Id;
                if(string.IsNotBlank(wVar.year1Id))
                  UDVar.Id = wVar.year1Id;
                usageDataToInsert.add(UDVar);
            }
            if(wVar.year2 <> Null && wVar.year2 > 0){
              Usage_Data__c UDVar = New Usage_Data__c(); 
              UDVar.Year__c = date.newinstance((currentYear -2), 12, 31);
                UDVar.Count__c  = wVar.year2;
                UDVar.Quantity__c   = wVar.year2;
                UDVar.Category__c = wVar.type;
                UDVar.Program__c = 'Batteries';                
                UDVar.Account__c = reportSubList[0].Account__c;
                UDVar.Registration_Detail__c = reportSubList[0].Registration_Detail__c;
                UDVar.Producer_Account__c = reportSubList[0].Producer_Account__c;
                UDVar.Report_Submission__c = reportSubList[0].Id;
                UDVar.Usage_Summary__c = usageSummaryMap.get(currentYear - 2).Id;
                if(string.IsNotBlank(wVar.year2Id))
                  UDVar.Id = wVar.year2Id;
                usageDataToInsert.add(UDVar);
            }
            
            if(wVar.year3 <> Null && wVar.year3 > 0){
              Usage_Data__c UDVar = New Usage_Data__c(); 
              UDVar.Year__c = date.newinstance((currentYear - 1), 12, 31);
                UDVar.Count__c  = wVar.year3;
                UDVar.Quantity__c   = wVar.year3;
                UDVar.Category__c = wVar.type;
                UDVar.Program__c = 'Batteries';                
                UDVar.Account__c = reportSubList[0].Account__c;
                UDVar.Registration_Detail__c = reportSubList[0].Registration_Detail__c;
                UDVar.Producer_Account__c = reportSubList[0].Producer_Account__c;
                UDVar.Report_Submission__c = reportSubList[0].Id;
                UDVar.Usage_Summary__c = usageSummaryMap.get(currentYear - 1).Id;
                if(string.IsNotBlank(wVar.year3Id))
                  UDVar.Id = wVar.year3Id;
                usageDataToInsert.add(UDVar);
            }
        }
        
        system.debug('usageDataToInsert=='+usageDataToInsert);
        if(usageDataToInsert.size() > 0) Upsert usageDataToInsert;
        Order Ord = New Order(); 
        Ord.AccountId = reportSubList[0].Account__c;
        Ord.Registration_Detail__c = reportSubList[0].Registration_Detail__c;              
        Ord.Report_Submission__c = reportSubList[0].Id;
        Ord.BillToContactId = reportSubList[0].Account__r.Primary_Contact__c;
        Ord.Type = 'Invoice';
        Ord.Status = 'Initiated';
        Ord.EffectiveDate = system.today();
       // Ord.Payment_Method__c = 'Cheque';
        //Ord.TotalAmount = totalFee;
        Insert Ord;
        
        OrderItem Oi = New OrderItem();
        Oi.Account__c = reportSubList[0].Account__c;
        Oi.Quantity = 1;
        Oi.Product2Id = productList[0].Id;
        Oi.UnitPrice = totalFee;
        Oi.OrderId = Ord.Id;
        //Oi.Pricebook2Id = Pricebook2List[0].Id;
        Oi.PricebookEntryId = pbe.Id;  
        Insert Oi;
        
        reportSubList[0].status__C = 'In Progress';
        Update reportSubList[0];
        
    }
    
    public class usageDataWrapper{
        @AuraEnabled public string type {get;set;}
        @AuraEnabled public Integer year1{get;set;}
        @AuraEnabled public Integer year2 {get;set;}
        @AuraEnabled public Integer year3 {get;set;}
        @AuraEnabled public string year1Id {get;set;}
        @AuraEnabled public string year2Id {get;set;}
        @AuraEnabled public string year3Id {get;set;}
        public usageDataWrapper(string type){
          year1 = 0;   
            year2 = 0;   
            year3 = 0; 
            this.type = type;
        }
        public usageDataWrapper(){
          year1 = 0;   
            year2 = 0;   
            year3 = 0; 
        }
    }
}