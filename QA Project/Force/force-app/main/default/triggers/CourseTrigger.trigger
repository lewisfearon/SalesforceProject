trigger CourseTrigger on Opportunity (before insert, after insert, after delete, after update) {
    if(UpdateCheck.check == true){
         if (trigger.isInsert){
            CourseTriggerHandler.ManageCourseEvents(Trigger.new, Trigger.oldMap);
            
            

        }
        
        else if(trigger.isUpdate){
            UpdateCheck.check = false;
            CourseTriggerHandler.ManageCourseEvents(Trigger.new, Trigger.oldMap);
            
            
           

        }
    else if(trigger.isAfter){
        
    }
    } 
}

