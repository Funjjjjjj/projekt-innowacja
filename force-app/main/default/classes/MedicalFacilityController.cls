public with sharing class MedicalFacilityController {
    @AuraEnabled(cacheable=true)
    public static Medical_Facility__c getFacilityDetails(Id recordId) {
        return [
            SELECT Name, 
                   Facility_Address__Street__s, 
                   Facility_Address__City__s, 
                   Facility_Address__PostalCode__s, 
                   Facility_Address__StateCode__s, 
                   Facility_Address__CountryCode__s
            FROM Medical_Facility__c 
            WHERE Id = :recordId 
            LIMIT 1
        ];
    }
}