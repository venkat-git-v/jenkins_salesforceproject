public with sharing class CommunityTitlePageApx {
   
    public class wrappResult{
        @AuraEnabled public FeedItem FeedItemObj; 
        // @AuraEnabled public List<FeedComment> FeedCommentList; 
        @AuraEnabled public  List<List<FeedComment>> FeedCommentList; 
        @AuraEnabled public Map<Id,  Object>  likeedObjectByCommentId;
        @AuraEnabled public Map<Id, User> userById;
        @AuraEnabled public List<Map<String,String>> topicList;
        public wrappResult(FeedItem FeedItemObj, List<List<FeedComment>> FeedCommentList, Map<Id, User> userById, Map<Id,  Object>  likeedObjectByCommentId , List<Map<String,String>> topicList){
            this.FeedCommentList = FeedCommentList;
            this.FeedItemObj = FeedItemObj;
            this.userById = userById;
            this.likeedObjectByCommentId = likeedObjectByCommentId;
            this.topicList = topicList;
        }        
    }
    // fetching record from FeedItem (Question record)
    @AuraEnabled
    public static wrappResult retrieveRecord(String recordId){
        Set<Id> userId = new Set<Id>();
        Id userRecId =  userInfo.getUserId();
        FeedItem feedItemRec = [Select id, LastModifiedDate, Title, Body,CreatedById, CreatedBy.Name,CreatedDate ,LikeCount,Revision, CommentCount,BestCommentId,
                                (select CreatedById,Id, FeedItemId,FeedEntityId, InsertedById
                                 From FeedLikes where CreatedById =:userRecId or InsertedById =: userRecId )
                                From FeedItem 
                                WHERE Type ='QuestionPost' and id =: recordId LIMIT 1];
        
        userId.add(feedItemRec.CreatedById);
        userId.add(userRecId);
        Map<Id, List<FeedComment>> feedCommentById = new Map<Id, List<FeedComment>>();
        List<FeedComment> feedCommentList  = [SELECT Id, FeedItemId, ParentId,CreatedById, CreatedDate, CreatedBy.Name, Revision, LastEditDate, CommentBody, CommentType, IsRichText 
                                              FROM FeedComment 
                                              WHERE FeedItemId =: feedItemRec.Id ];
        for(FeedComment obj : feedCommentList ){
            if(!feedCommentById.containsKey(obj.CreatedById)){
                feedCommentById.put(obj.CreatedById, new List<FeedComment>());
            }
            feedCommentById.get(obj.CreatedById).add(obj);    
            userId.add(obj.CreatedById);
        }
        List<List<FeedComment>> feedCommentListOfList  = new List<List<FeedComment>>();
        for(List<FeedComment> lst : feedCommentById.values()){
            feedCommentListOfList.add(lst);
        }
        
        Map<Id, User> userById = new Map<Id, User>([SELECT Id, SmallPhotoUrl, FullPhotoUrl  FROM USER WHERE ID =:userId]);
        
       Community obj = [Select Id, Name From Community]; 
        String communityId = null ;// Network.getNetworkId(); //obj.Id;
        System.debug('>>>>>> network id >>>>>>'+communityId);

        // For getting Topic Name through ConnectedApi
        ConnectApi.TopicPage tp = ConnectApi.Topics.getTopics(communityId , feedItemRec.Id);
       List<ConnectApi.Topic> lstTp = tp.topics;
        List<Map<String,String>> topicList = new List<Map<String,String>>();

        for(ConnectApi.Topic topic : lstTp){
            Map<String,String> mapObj= new Map<String,String>();
            mapObj.put('Name',topic.Name);
            mapObj.put('Id',topic.Id);
            topicList.add(mapObj);
        }

        ConnectApi.CommentPage cp = ConnectApi.ChatterFeeds.getCommentsForFeedElement(communityId, feedItemRec.Id);
        List<ConnectApi.Comment> commentList = cp.items;
        Map<Id,  Object>  likeedObjectByCommentId = new Map<Id, Object>();
        for(ConnectApi.Comment com : commentList){
            // ConnectApi.ChatterLikePage cp = com.likes;
            if(com.myLike != null){
                Object likeRec = com.myLike;
                likeedObjectByCommentId.put(com.Id, likeRec);
            }
        }
        return new wrappResult(feedItemRec, feedCommentListOfList, userById, likeedObjectByCommentId,topicList);

    }
    
    // Insert Records in FeedComment
    @AuraEnabled
    public static FeedComment saveFCRecord(String fcId,String fcBody){
        FeedComment fc = new FeedComment();
        fc.FeedItemId = fcId;
        fc.CommentBody = fcBody;
        insert fc;
        return fc;
    }
    
    // Retrieve records form FeedComment
    @AuraEnabled
    public static List<FeedComment> retrieveFCRecord(){
        return [SELECT Id, FeedItemId, ParentId, CreatedDate, CreatedBy.Name, Revision, LastEditDate, CommentBody, CommentType, IsRichText 
                FROM FeedComment 
                Order By CreatedById
               ];
    }
    @AuraEnabled
    public static void updateBestAnswer(String questionId,String answerId){
       
        ConnectApi.QuestionAndAnswersCapabilityInput qaInput = new ConnectApi.QuestionAndAnswersCapabilityInput();
        qaInput.bestAnswerId = answerId;
        ConnectApi.QuestionAndAnswersCapability qa = ConnectApi.QuestionAndAnswers.updateQuestionAndAnswers(null,questionId, qaInput);
       // ConnectApi.QuestionAndAnswersCapability qa = ConnectApi.QuestionAndAnswers.updateQuestionAndAnswers(Network.getNetworkId(),questionId, qaInput);
    }
   
    @AuraEnabled
    public static void updateLikes(String quesId){ 
        Id userRecId =  userInfo.getUserId();
        FeedItem feedItemRec = [Select id, LikeCount,
                                (select ID, CreatedById
                                 From FeedLikes where CreatedById =:userRecId or InsertedById =: userRecId )                                
                                From FeedItem  
                                WHERE id =: quesId ];
        Id likeOrunlikeId;                       
        if(feedItemRec.FeedLikes.size() > 0){
            // need to delete
            FeedLike Obj = feedItemRec.FeedLikes[0];
            DELETE Obj;
        }else{
            // need to insert
            FeedLike fl = new FeedLike(feedItemId = feedItemRec.id);
            fl.createdById = UserInfo.getUserId();
            insert fl;
        } 
    }
    
    // for deleting we have to pass userId and Id of the current record
    @AuraEnabled
    public static void deleteRecords(String deletedId, String Id){ 
        Id uId = userInfo.getUserId();
        FeedComment feedCommentRec = [SELECT id,CreatedById From FeedComment WHERE CreatedById =:uId and id = : Id];
        DELETE feedCommentRec;  
    }
    // for deleting we have to pass userId and Id of the current record from FeedItem
    @AuraEnabled
    public static void deleteFIRecords(String deletedId, String Id){ 
        Id uId = userInfo.getUserId();
        FeedItem feedItemRec = [SELECT id,CreatedById From FeedItem WHERE CreatedById =:uId and id = : Id];
        DELETE feedItemRec;
    }
    
    @AuraEnabled
    public static Map<String,List<String>> groupByFeedCommentRecord(){
        
        Map<String,List<String>> mapObj = new  Map<String,List<String>>();
        for(FeedComment fc :[SELECT Id, FeedItemId, ParentId, CreatedDate,CreatedById , CreatedBy.Name, Revision, LastEditDate, CommentBody, CommentType, IsRichText 
                             FROM FeedComment 
                            ])
        {
            if(mapObj.containsKey(fc.CreatedById)){
                List<String> userId = mapObj.get(fc.CreatedById);
                userId.add(fc.Id);
                mapObj.put(fc.CreatedById, userId);
            }
            else{
                mapObj.put(fc.CreatedById,new List<String> {fc.CreatedById});
            }
        }
        return mapObj;
    }
    
    @AuraEnabled
    public static FeedComment updateFCDetails(String fcId,String fcBody){ 
        System.debug('>>>>> Apex class fcId >>>'+fcId);
        System.debug('>>>>> Apex class fcBody>>>'+fcBody);
      FeedComment fc = new FeedComment();
        fc.Id = fcId;
        fc.CommentBody = fcBody;
        update fc;
         System.debug('>>>>> Apex class fc >>>'+fc);
        return fc;
    }
    @AuraEnabled
    public static FeedItem updateFIDetails(String fcId,String fcBody){ 
        System.debug('>>>>> Apex class fcId >>>'+fcId);
        System.debug('>>>>> Apex class fcBody>>>'+fcBody);
      FeedItem fc = new FeedItem();
        fc.Id = fcId;
        fc.Title = fcBody;
        update fc;
         System.debug('>>>>> Apex class fc >>>'+fc);
        return fc;
    }
    @AuraEnabled
    public static string likeDislikeAnswer(String answerId, String likeId){
        if(LikeId != null) {
            //  Insert new Like 
            FeedLike fl = new FeedLike(Id = likeId);
            DELETE fl;
            return null;
        }else{
            // delete like record
            FeedLike fl = new FeedLike(FeedEntityId = answerId);
            insert fl;
            return fl.Id;
        }
    }
    @AuraEnabled
    public static void sharePost(String feedEntityId, String groupId, String shareText ){
                // Define the FeedItemInput object to pass to postFeedElement
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        if(shareText == null || shareText == ''){
            groupId = 'me';
        }
        feedItemInput.subjectId = groupId;
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = shareText;
        // The MessageBodyInput object holds the text in the post
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.add(textSegmentInput);
        feedItemInput.body = messageBodyInput;

        ConnectApi.FeedEntityShareCapabilityInput shareInput = new ConnectApi.FeedEntityShareCapabilityInput();
        shareInput.feedEntityId = feedEntityId;
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new
        ConnectApi.FeedElementCapabilitiesInput();
        feedElementCapabilitiesInput.feedEntityShare = shareInput;
        feedItemInput.capabilities = feedElementCapabilitiesInput;
        // Post the feed item.
        ConnectApi.FeedElement feedElement =
        ConnectApi.ChatterFeeds.postFeedElement(null, feedItemInput);
    }
    @AuraEnabled
    public static List<Group> GetUserIdsFromGroup(){
        List<Id> groupIds = new List<Id>();
        for(GroupMember obj :[ SELECT GroupId FROM GroupMember WHERE UserOrGroupId =: UserInfo.getUserId()]){
            groupIds.add(obj.GroupId);
        }
        return [SELECT Id, DeveloperName 
                FROM Group 
                WHERE ID =: groupIds];

    }


    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        system.debug('searchKey-->' + searchKey);

        List < sObject > returnList = new List < sObject > ();
      
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where  CollaborationType=\'Public\' AND Name  LIKE: searchKey order by createdDate DESC limit 7';
        system.debug('lstOfRecords-->' + sQuery);
       
        
        List < sObject > lstOfRecords = Database.query(sQuery);
        system.debug('lstOfRecords-->' + lstOfRecords);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}