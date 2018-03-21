({
    doInit : function(component, event, helper) {
        var action = component.get("c.getApprovalDetails");
        action.setParams({"recordId": component.get("v.approvalId")});
        action.setCallback(this, function(response) {
            var resultMap = response.getReturnValue();
            component.set("v.resultMap", resultMap);
        })
        $A.enqueueAction(action);
        
    }
})