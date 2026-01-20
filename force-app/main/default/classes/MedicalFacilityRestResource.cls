@RestResource(urlMapping='/MedicalFacilities/Generate')
global with sharing class MedicalFacilityRestResource {

    @HttpPost
    global static Medical_Facility__c getRandomMedicalFacility() {
        // Sample data for randomization
        List<String> types = new List<String>{'Hospital', 'Clinic'};
        
        // Random Generators
        Integer typeIndex = Integer.valueOf(Math.floor(Math.random() * types.size()));
        Integer randomPhone = Integer.valueOf(Math.floor(Math.random() * 9000000) + 1000000);
        
        // Construct the ephemeral object
        Medical_Facility__c randomFacility = new Medical_Facility__c(
            Name = 'Genareted',
            Email__c = 'contact' + randomPhone + '@example.com',
            Insurance_Required__c = Math.random() > 0.5,
            Phone__c = '+1-' + randomPhone,
            Type__c = types[typeIndex],
            Website__c = 'https://www.med-facility-' + randomPhone + '.com'
        );

        return randomFacility;
    }
}