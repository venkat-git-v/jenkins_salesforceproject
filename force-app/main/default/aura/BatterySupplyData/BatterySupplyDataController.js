({
    // function call on component Load
    doInit: function(component, event, helper) {
    	var d = new Date();
        var yearVar = d.getFullYear();
        component.set("v.currentYear", yearVar);
        
        helper.checkStatus(component, event);
        helper.getData(component, event);

    },
 
    // function for save the Records 
    Save: function(component, event, helper) {
            var action = component.get("c.createUsageData");
            action.setParams({
                "usageDataWrapperList": component.get("v.WrapperList"),
                "rsID" : component.get("v.recordId"),
                "totalFee" : component.get("v.totalFee")
            });
            console.log('====RECORD====='+ component.get('v.recordId'));
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    $A.get('e.force:refreshView').fire();
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
    },
  calculateFees: function(component, event, helper) {
    	var allRows = component.get("v.WrapperList");
        var	totalFee = (((+allRows[0].year1 + +allRows[0].year2 + +allRows[0].year3)/3)*.3)*1.25 + +(((+allRows[1].year1 + +allRows[1].year2 + +allRows[1].year3)/3)*.3)*1.25 + +(((+allRows[2].year1 + +allRows[2].year2 + +allRows[2].year3)/3)*.3)*1.25;    
        component.set('v.totalFee',totalFee.toFixed(2));    
    }

})