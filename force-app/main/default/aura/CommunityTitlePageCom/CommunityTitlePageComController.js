({
    doInit : function(component, event, helper) {
        console.log('inside doinit method parent');
        helper.question(component, event);  
    },
  
    // Write answer -> insert record
    Submit : function(component, event, helper) {
        var feed = component.get("v.newFeedCommentBody");
        var question = component.get("v.feedItem");
        var action = component.get("c.saveFCRecord");
        action.setParams({ 
            "fcId": question.Id,
            "fcBody" :feed
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.newFeedCommentBody",null);
                helper.question(component, event);
            }            
        });
        $A.enqueueAction(action);
    },
    IsChange : function(component, event, helper) {
        var Change = component.set("v.IsRichText",true);
    },
})