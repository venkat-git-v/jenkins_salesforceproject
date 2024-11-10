declare module "@salesforce/apex/CommunityTitlePageApx.retrieveRecord" {
  export default function retrieveRecord(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.saveFCRecord" {
  export default function saveFCRecord(param: {fcId: any, fcBody: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.retrieveFCRecord" {
  export default function retrieveFCRecord(): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.updateBestAnswer" {
  export default function updateBestAnswer(param: {questionId: any, answerId: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.updateLikes" {
  export default function updateLikes(param: {quesId: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.deleteRecords" {
  export default function deleteRecords(param: {deletedId: any, Id: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.deleteFIRecords" {
  export default function deleteFIRecords(param: {deletedId: any, Id: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.groupByFeedCommentRecord" {
  export default function groupByFeedCommentRecord(): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.updateFCDetails" {
  export default function updateFCDetails(param: {fcId: any, fcBody: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.updateFIDetails" {
  export default function updateFIDetails(param: {fcId: any, fcBody: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.likeDislikeAnswer" {
  export default function likeDislikeAnswer(param: {answerId: any, likeId: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.sharePost" {
  export default function sharePost(param: {feedEntityId: any, groupId: any, shareText: any}): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.GetUserIdsFromGroup" {
  export default function GetUserIdsFromGroup(): Promise<any>;
}
declare module "@salesforce/apex/CommunityTitlePageApx.fetchLookUpValues" {
  export default function fetchLookUpValues(param: {searchKeyWord: any, ObjectName: any}): Promise<any>;
}
