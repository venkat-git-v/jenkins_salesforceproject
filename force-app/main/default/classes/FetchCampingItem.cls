public with sharing class FetchCampingItem  {
    @AuraEnabled
    public List<Camping_Item__c> listcamp { get; set; }
    
    public FetchCampingItem (){
    
    listcamp= new List<Camping_Item__c>();
    listcamps();
    
    }

public List<Camping_Item__c>  listcamps(){

  listcamp=[select id, name  from Camping_Item__c limit 5];
  
  return listcamp;
}


}