public with sharing class myApprovalItems {
    
    @AuraEnabled
public static Map<String,String> getApprovalDetails(Id recordId) {
    
    String recordType = '';
    String recordName = '';
    String submittedBy = '';
    
    Map <String, String> resultMap = new Map<String, String>();
    
    
    ProcessInstanceWorkItem targetItem = [SELECT ProcessInstance.TargetObjectId, CreatedBy.Name FROM ProcessInstanceWorkItem where Id = :recordId LIMIT 1];
    
    Id targetId = targetItem.ProcessInstance.TargetObjectId;
    
    submittedBy = targetItem.CreatedBy.Name;
    resultMap.put('submittedBy', submittedBy);

    
    recordType = targetId.getSObjectType().getDescribe().getName();
    
    resultMap.put('recordType', recordType);
    
    sObject sObj = Database.query('SELECT Name, CreatedById from ' + recordType + ' Where Id = \'' + targetId + '\'');
    
    
    recordName = (String)sObj.get('Name');
    
    resultMap.put('recordName', recordName);
  
    
    return resultMap;
}

}