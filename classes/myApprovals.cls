public with sharing class myApprovals {

    @AuraEnabled
public static User getCurrentUser() {
    
    User currentUser = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
   
    return currentUser;
}
    
    @AuraEnabled
public static List<Id> getPendingApprovals() {
   
    User currentUser = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    
    Id currentUserId = currentUser.Id;
    
    
    Set <Id> GroupSet = new Set<Id>();
    
    for (Group thisGroup : [SELECT Id from Group WHERE Id In (SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId())])
    {
        GroupSet.add (thisGroup.Id);
        system.debug ('group set add: ' + thisGroup.Id);
        
    }
    
    GroupSet.add(UserInfo.getUserId());
        
    
    // find the queues that have the groups or the user id
    
    Set <Id> QueueSet = new Set<Id>();
    for (Group thisQueue : [Select Id from Group WHERE Type = 'Queue' AND Id IN (SELECT GroupId FROM GroupMember WHERE UserOrGroupId IN :GroupSet)])
    {
        QueueSet.add(thisQueue.Id);
    }
    
    QueueSet.add(UserInfo.getUserId());
    
    
    
    List<Id> targets = new List<Id>();
    List<String> recordNames = new List<String>();
    List<String> objNames = new List<String>();
    List<String> submittedBy = new List<String>();
    
    for (Id queueId : QueueSet)
    {
        
    system.debug ('this queue id: ' + queueId);
        
	for (ProcessInstanceWorkItem workItem : 
         [SELECT ProcessInstance.TargetObjectId FROM ProcessInstanceWorkItem 
    		WHERE ProcessInstance.Status = 'Pending' AND ActorId = :queueId]) 
    {
        
        Id targetRecordId = workItem.ProcessInstance.TargetObjectId;
        
       

        
        targets.add(workItem.Id);
        
        system.debug('Adding target Id: ' + workItem.ProcessInstance.TargetObjectId );
    }

    }
    
    return targets;
    
    
}

}