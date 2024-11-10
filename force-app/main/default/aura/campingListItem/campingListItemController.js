({
	 packItem : function(component, event, helper) {
        
        var a = component.get("v.item", true);
        a.Name = 'Item2';
        a.Quantity__c = 10;
        a.Price__c = 100;
        a.Packed__c = true;
        component.set("v.item",a);
        
        var btnClicked = event.getSource();
        btnClicked.set("v.disabled",true);
        
    }
})