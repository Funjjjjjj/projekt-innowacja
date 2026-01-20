@RestResource(urlMapping='/MedicalFacilities/Generate')
global with sharing class MedicalFacilityRestResource {

    @HttpPost
    global static Medical_Facility__c getRandomMedicalFacility() {
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1];
        List<String> types = new List<String>{'Hospital', 'Clinic'};
        
        
        Integer typeIndex = Integer.valueOf(Math.floor(Math.random() * types.size()));
        Integer randomPhone = Integer.valueOf(Math.floor(Math.random() * 9000000) + 1000000);
        
        Medical_Facility__c randomFacility = new Medical_Facility__c(
            Name = 'Genareted',
            Email__c = 'contact' + randomPhone + '@example.com',
            Insurance_Required__c = Math.random() > 0.5, 
            Phone__c = '+1-' + randomPhone,
            Type__c = types[typeIndex],
            Website__c = 'https://www.med-facility-' + randomPhone + '.com',
            Opening_Hours__c = bh.id
        );

        randomFacility.put('Facility_Address__Street__s', '123 Medical Way');
        randomFacility.put('Facility_Address__City__s', 'Healthcare City');
        randomFacility.put('Facility_Address__PostalCode__s', '12-345'); // Usunięto podkreślnik
		randomFacility.put('Facility_Address__CountryCode__s', 'PL');
        
        return randomFacility;
    }
}