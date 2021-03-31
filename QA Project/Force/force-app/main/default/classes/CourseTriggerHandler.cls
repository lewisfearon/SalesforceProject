    public with sharing class CourseTriggerHandler {

        public static void ManageCourseEvents (List<Opportunity> opplist, Map<Id, Opportunity> oldOpps){
            List<Event> NewEvent = new List<Event>();
            //List of courses that have been newly inserted.
            List<Opportunity> oppsInsert = new List<Opportunity>();
            //List of courses that are being updated.
            List<Opportunity> oppsUpdate = new List<Opportunity>();
            //List of courses that have been set to delete.
            List<Opportunity> oppsDelete = new List<Opportunity>();
            List<Opportunity> oppsToService = new List<Opportunity>(); 
            

            //Set of course ID's.
            Set<Id> oppSet = new Set<Id>();
            
                for(Opportunity opp : opplist){
                    oppSet.add(opp.Id);

                    if(oldOpps == Null || oldOpps.get(opp.Id) == Null){
                        oppsInsert.add(opp);
                    }
    
            else if(opp.StageName == 'Cancelled' && oldOpps.get(opp.Id).StageName != 'Cancelled'){
            oppsDelete.add(opp);
            }
                else{
                     oppsUpdate.add(opp);
                }
                }

            Map<Id, Opportunity> InstructorMap = new Map<Id,Opportunity>([SELECT Id, Course_Rate__r.Instructor__c FROM Opportunity WHERE Id IN : oppSet]);
            if (oppsInsert.size()>0)
            {
            for(Opportunity oppNew : oppsInsert)
            {
                Event e = new Event();
                e.StartDateTime = oppNew.Course_Start_Date__c;
                e.EndDateTime = oppNew.CloseDate;
                e.Subject = oppNew.Course_Type__c;
                e.Location = oppNew.Location__c;
                //e.OwnerId = InstructorMap.get(oppNew.Id).Course_Rate__r.Instructor__c;
                e.WhatId = oppNew.Id;
                newEvent.add(e);
            }
            insert newEvent;

            List<User> users=[Select id, Email from User];
        List<Id> userId= new List<Id>();
        for(User u:users) {
            if (u.Email == 'lfearon@qa.com')
            {
                userId.add(u.id);
            }

        }
        EmailTemplate et=[Select id from EmailTemplate where name = 'Course Scheduled' limit 1];
        
        Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
        mail.setTargetObjectIds(userId);
        mail.setSenderDisplayName('Training Co-ordnator');
        mail.setTemplateId(et.id);
        mail.setSaveAsActivity(false);
        Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
    }
        
    

        if (oppsDelete.size()>0){
        List<Event> events = [SELECT id from Event where whatId IN:oppsDelete];
            delete events;


            List<User> users=[Select id, Email from User];
            List<Id> userId= new List<Id>();
            for(User u: users) {
                if (u.Email == 'lfearon@qa.com')
                {
                    userId.add(u.id);
                }
        
            }
            EmailTemplate et=[Select id from EmailTemplate where name = 'Course Cancelled' limit 1];
            
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(userId);
            mail.setSenderDisplayName('Training Co-ordnator');
            mail.setTemplateId(et.id);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
        
        }

    if(oppsUpdate.size()>0){
            List<Event> updateEvents = [SELECT Id, WhatId FROM Event WHERE WhatId IN : oppsUpdate];
            List<Event> updEvents = new List<Event>();
            Event e = new event();
            for(Opportunity opps : oppsUpdate ){
                e.StartDateTime = opps.Course_Start_Date__c;
                e.EndDateTime = opps.CloseDate;
                e.Location = opps.Location__c;
                e.Subject = opps.Type + ' '+ opps.Course_Start_Date__c + ' '+ opps.Course_Rate__r.Instructor__c;
            
                updEvents.add(e);
            }
        }

            if(oppsToService.size()>0){
                List<Invoice__c> invoice  = new List<Invoice__c>();
                Set<Id> oppSett = new Set<Id>();
            
                for(Opportunity opp : opplist ){
                oppSett.add(opp.Id);
                if(opp.StageName == 'Completed'){
                    oppsToService.add(opp);
                }
            }
        Set<Id> OppSetUpdate = new Set<Id>();
            for(Opportunity opps : oppsToService){
                Invoice__c inv = new Invoice__c();
                inv.RecordTypeId = Schema.SObjectType.Invoice__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
                inv.Invoice_Date__c = opps.CloseDate;
                inv.Course__c = opps.Id;
                inv.Name = 'test';
                invoice.add(inv);
        
            }
            insert invoice;
        }
    }
            } 
        
        
        
              
              
            
           

    

              