({
    handleLike : function(component,event,questionId) {
       var action = component.get("c.updateLikes");
        action.setParams({
            "quesId" : questionId
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                var event = component.getEvent("CommunityTitlePageEvent");
                event.setParam("message", "the message to send" );
                event.fire();
            }
        });
    
    $A.enqueueAction(action);
    },
    deleteRecord : function(component,event,questionId) {
        var action =  component.get("c.deleteFIRecords");
        var deletetRec = component.get("v.Question");
         action.setParams({
   							 "deleteId": deletetRec.CreatedById,
    							"Id" : deletetRec.Id
						  }); 
			action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //this.doInit(component,event,helper);
                 var event = component.getEvent("CommunityTitlePageEvent");
                event.setParam("message", "the message to send" );
                event.fire();
            }
        }),
        $A.enqueueAction(action);
    },
    
    // Start change code here
    
    copyTextHelper : function(component,event,text) {
         var hiddenInput = document.createElement("input");
        hiddenInput.setAttribute("value", text);
        document.body.appendChild(hiddenInput);
        hiddenInput.select();
        document.execCommand("copy");
        document.body.removeChild(hiddenInput); 
        var orignalLabel = event.getSource().get("v.label");
        event.getSource().set("v.iconName" , 'utility:check');
        // change button label with 'copied' after copy text 
        event.getSource().set("v.label" , 'copied');
        
        // set timeout to reset icon and label value after 700 milliseconds 
        setTimeout(function(){ 
            event.getSource().set("v.iconName" , 'utility:copy_to_clipboard'); 
            event.getSource().set("v.label" , orignalLabel);
        }, 700);
        component.set("v.isCopyLink", false);
    },
    sharePostWith : function(component,event,groupId){
        var Question = component.get("v.Question");
        var action =  component.get("c.sharePost");//String feedEntityId, String groupId, String shareText
        action.setParams({
   							"feedEntityId": Question.Id,
                            "groupId" : groupId,
                            "shareText" : component.get('v.sharePostText')
                          }); 
                          
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isShareGroup', false);
                component.set('v.isShareWithFriend', false);
                component.set('v.sharePostText', null);
                let obj ={};
                component.set('v.selectedLookUpRecord', obj);
                
                var event = component.getEvent("CommunityTitlePageEvent");
                event.setParam("message", "the message to send" );
                event.fire();
            }else{
                console.log('erroe');
            }
        }),
        $A.enqueueAction(action);
    },
    getUserGroups : function(component,event,groupId){
       
        var action =  component.get("c.GetUserIdsFromGroup");//String feedEntityId, String groupId, String shareText
        
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.groupList', response.getReturnValue())
                // var event = component.getEvent("CommunityTitlePageEvent");
                // event.setParam("message", "the message to send" );
                // event.fire();
            }
        }),
        $A.enqueueAction(action);
    },

})