({
    doInit : function(component, event, helper) {
        
        var action2 = component.get("c.getPendingApprovals");
        action2.setCallback(this, function(response) {
            var targetList = response.getReturnValue();
            component.set("v.targets", targetList);
        })
        $A.enqueueAction(action2);
        
        
        
    }
})