public with sharing class AppointmentController {
    @AuraEnabled(cacheable=true)
    public static List<SObject> getAvailableDoctors(Id facilityId, String specialization) {
        List<Doctor_Facility_Assignment__c> assignments = [
            SELECT Person__r.Id, Person__r.Name 
            FROM Doctor_Facility_Assignment__c 
            WHERE Medical_Facility__c = :facilityId 
            AND Person__r.Specialization__c = :specialization
            ORDER BY Person__r.Name ASC
        ];
        List<SObject> doctors = new List<SObject>();
        for(Doctor_Facility_Assignment__c dfa : assignments) {
            doctors.add(dfa.Person__r);
        }
        
        return doctors;
    }
}