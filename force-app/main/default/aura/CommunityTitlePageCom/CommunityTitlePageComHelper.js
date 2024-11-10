({
    question: function(component, event) {
        var action = component.get("c.retrieveRecord");
        var recordId = component.get("v.recordId");
        console.log('>>> recordId >>> ',recordId);
        action.setParams({
            "recordId" : recordId 
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.userById", res.userById);
                component.set("v.likeByCommentId", res.likeedObjectByCommentId);
                
                //var topic;
                // for(let i=0 ; i< res.testTopicObject.length; i++){
                //     testTopic = res.testTopicObject[i].Name;
                // }
                component.set("v.topicList",res.topicList);
                console.log('>>> res T T ',res);

                var userId = $A.get("$SObjectType.CurrentUser.Id");
                let imageUrl = '/assets/images/avatar1.jpg';
                if(res.userById[userId] != null && res.userById[userId] != undefined){
                    imageUrl = res.userById[userId].SmallPhotoUrl;
                }
                component.set('v.currentUserProfle',imageUrl);
                component.set("v.bestAnswerId", res.FeedItemObj.BestCommentId); 
                
                if(res.FeedItemObj.BestCommentId != null && res.FeedItemObj.BestCommentId != undefined){
                    let rec;         
                    for(let i =0 ; i< res.FeedCommentList.length;i++){
                        let recList = res.FeedCommentList[i];
                        for(let j =0 ; j<recList.length;j++){
                            let record = recList[j];
                            if(record.Id == res.FeedItemObj.BestCommentId){
                                rec = record;
                            }
                        }
                    }
                    if(rec != null && rec != undefined && rec !=''){
                        component.set("v.bestAnswer",rec);
                        component.set("v.isBestAnswerShow",true);               
                    }  
                    
                }else{
                    component.set("v.isBestAnswerShow",false);
                    component.set("v.bestAnswer",null);
                }
                component.set("v.feedItem", res.FeedItemObj);
                component.set("v.feedComment", res.FeedCommentList);
                component.set('v.isShowHeader', true);
                
                component.set("v.IsRichText",false);
                
                if(res.FeedItemObj.LikeCount == 0){
                    component.set("v.isLike",true);
                }
                else{
                    component.set("v.isLike",false);
                }
                
            }
            
        });
        $A.enqueueAction(action);
    }    
})