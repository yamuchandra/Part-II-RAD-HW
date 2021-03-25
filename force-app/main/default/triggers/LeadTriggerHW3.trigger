trigger LeadTriggerHW3 on Lead (after insert, after update) {
    
    if (Trigger.isInsert) {
        if(Trigger.isAfter) {  
            LeadTriggerHW3Handler.afterInsert(trigger.new);
        }
    }
    else if (Trigger.isUpdate) {
        
        if(Trigger.isAfter){
            LeadTriggerHW3Handler.afterUpdate(trigger.newMap, trigger.oldMap);
        
      }
      }    
}