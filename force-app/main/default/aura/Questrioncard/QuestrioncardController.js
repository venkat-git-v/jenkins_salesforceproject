({
    doInit : function(component, event, helper) {
        let Question = component.get('v.Question');
        let likes = Question.FeedLikes;
        
        if(likes == 'undefined' || likes == null  || likes.length <= 0){
            component.set("v.isLike",false);
        }else {
            for(let i= 0; i<likes.length;i++){
                if(likes[i].FeedItemId == Question.Id){
                    component.set("v.isLike",true);
                }
            }
        }
        let userById = component.get('v.userById');
        let imageUrl = '/assets/images/avatar1.jpg';
        if(userById[Question.CreatedById] != null && userById[Question.CreatedById] != undefined){
            imageUrl = userById[Question.CreatedById].SmallPhotoUrl;
        }
        component.set('v.imageUrl',imageUrl);
    },
    // Like button 
    like : function(component, event, helper) {
        
        var quesId = component.get('v.Question');
        var questionId = quesId.Id;
        helper.handleLike(component, event,questionId);
    },
    editAndDelete : function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue === 'Edit'){
            component.set("v.isOpen", true);
        }else{
            helper.deleteRecord(component,event,helper);  
        }
    },
    
    // if we click answer button in question feed that time it will open like textArea field and post the answer
    sendAnswer : function(component, event, helper) {
       component.set("v.IsRichText",true);   

    },
    // edit button model pop up
    saveModal : function(component, event, helper){
        var feed = component.get("v.Question");
        var question = feed.Id;
        var action = component.get("c.updateFIDetails");
        action.setParams({ 
            "fcId": question,
            "fcBody" :feed.Title
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
             if (state === "SUCCESS") {
                 var event = component.getEvent("CommunityTitlePageEvent");
                event.setParam("message", "the message to send" );
                event.fire();
            }            
        });
        $A.enqueueAction(action);
        component.set("v.isOpen", false);
    },
    closeEditModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    
    // Share button Code
    selectShare : function(component, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        if(selectedMenuItemValue =='CopyLink')
        {
            var question =JSON.parse(JSON.stringify(component.get('v.Question')));
            var url1= window.location.href;
            var n = url1.indexOf("://");
            var n1 = url1.indexOf("-dev");
            
            var userNametoTakeFromURL='';
            for(var i=n+3;i<n1;i++){
                
                userNametoTakeFromURL=userNametoTakeFromURL+url1.charAt(i);
                
            }
            console.log(userNametoTakeFromURL);
            
            var url =  'https://'+userNametoTakeFromURL+'-dev-ed.lightning.force.com/lightning/r/'+question.Id+'/view';
            console.log(url);
            component.set('v.copiedLinkToShare',url);
            component.set("v.isCopyLink",true);
        }
        else if(selectedMenuItemValue == 'ShareWithGroup'){

            component.set("v.isShareGroup",true);
        }
            else if(selectedMenuItemValue == 'ShareWithFollowers'){
                component.set("v.isShareWithFriend",true);
            }
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isCopyLink", false);
        component.set("v.isShareGroup", false);
        component.set("v.isShareWithFriend", false);

       
    },
    copyHardcoreText : function(component, event, helper) {
        var textForCopy = component.get('v.copiedLinkToShare');
        console.log('textForCopy',textForCopy);
        // calling common helper class to copy selected text value
        helper.copyTextHelper(component,event,textForCopy);
    },
    PopupShareHandler : function(component, event, helper) {
        component.set("v.isShareGroup", false);
        component.set("v.isShareWithFriend", false);
    },
    istestTopichandler : function(component, event, helper) {
        // alert("No topics are there");
    },
    sharePosthandler :  function(component, event, helper) {
        let groupId = '';
        var group = component.get('v.selectedLookUpRecord');
        console.log(JSON.stringify(group));
        let ownId =  group.Id;
        if(ownId== null || ownId == undefined){
            groupId = 'me';
        }else{
            groupId = ownId;
        }
        
        helper.sharePostWith(component, event, groupId);
    },


})