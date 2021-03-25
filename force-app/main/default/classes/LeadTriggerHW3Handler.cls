public class LeadTriggerHW3Handler {
        
    public static void afterInsert(List<Lead> leads){    
        
        List<Task> leadTasks = new List<Task>();

        //Loop through the new leads list and check for Product interest change
        for(Lead newLead : leads){
            
                Task leadTask = new Task();
                leadTask.WhoId = newLead.id;
                leadTask.Subject = newLead.ProductInterest__c + ' Task';
                leadTask.Status = 'Not Started';
                
            //Create Task DueDate with diferent dates

            if(newLead.ProductInterest__c == 'Cookbook Authorship'){
                leadTask.ActivityDate = system.Today() + 30;
                }
                else if(newLead.ProductInterest__c == 'Cookbook Editing'){
                leadTask.ActivityDate = system.Today() + 15;
                }
                else if(newLead.ProductInterest__c == 'Cookbook Distribution'){
                leadTask.ActivityDate = system.Today() + 7;
            }
            leadTasks.add(leadTask);                
            
        }
        // If task lisk is not empty Create Task

        if(leadTasks.size() > 0){
        insert leadTasks;
        }
    }
    
    //Trigger.newMap passed to newLeadMap
    //Trigger.oldMap passed to oldLeadMap

    public static void afterUpdate(Map<ID, Lead> newLeadMap, Map<ID, Lead> oldLeadMap){

        // List to hold Tasks for updated leads if product interest is changed

        List<Task> leadTasks = new List<Task>();
        System.debug ('List created');

        //Map method: values() - Returns a list that contains all the values in the map.

        for(Lead updatedLead : newLeadMap.values()){

            if(updatedLead.ProductInterest__c != oldLeadMap.get(updatedLead.id).ProductInterest__c){
                system.debug('--Product interest changed.');
                Task leadTask = new Task();
                leadTask.WhoId = newLeadMap.get(updatedLead.id).id;
                leadTask.Subject = newLeadMap.get(updatedLead.id).ProductInterest__c + ' Task';
                leadTask.ActivityDate = system.Today() + 10;
                leadTask.Status = 'Not Started';
                leadTasks.add(leadTask);
            } 
            else {
                system.debug('--Product interest did not change.');
            }

        }

        // If task lisk is not empty Create Task

        if(leadTasks.size() > 0){
        insert leadTasks;
        }

    }
    
}
