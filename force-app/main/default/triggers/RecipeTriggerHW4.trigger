trigger RecipeTriggerHW4 on Recipe__c (before insert, before update, after update) {

    // ******Create a trigger for Recipe SObject that will process Before Insert, After Insert, Before Update and After Update.*****

    // **************This Trigger should only be run ONCE**************************

    if (RecipeTriggerHW4Handler.hasExecuted) { //references a static variable on the handler
        return;
    } else {
        RecipeTriggerHW4Handler.hasExecuted = true; //Set to true so that the trigger will not run again
    }

    
    // ****************Instantiate the Handler and set Trigger records***************

    RecipeTriggerHW4Handler handler = new RecipeTriggerHW4Handler(Trigger.new);

    // ***********First, we have a simple if/else if block separating inserts from updates*************
    // ***********This helps trigger performance and keeps triggers with lots of handlers more readable**********


    if (Trigger.isInsert) {
        if(Trigger.isBefore){
            handler.beforeInsertUpdate();
        } 
        //else if(Trigger.isAfter){
        //    handler.handleAfterInsert();
        //}    
    } 
    else if (Trigger.isUpdate){
        if(Trigger.isBefore){
            handler.beforeInsertUpdate();
        } 
    else if(Trigger.isAfter){
            handler.handleAfterUpdate();
        } 
    }
}