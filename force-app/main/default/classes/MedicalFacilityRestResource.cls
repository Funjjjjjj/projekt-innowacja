@RestResource(urlMapping='/MedicalFacilities/Generate')
global with sharing class MedicalFacilityRestResource {

    @HttpPost
    global static Medical_Facility__c getRandomMedicalFacility() {
        // Sample data for randomization
        List<String> cities = new List<String>{'San Francisco', 'London', 'Tokyo', 'Berlin', 'Mumbai'};
        List<String> types = new List<String>{'Hospital', 'Clinic'};
        List<String> streets = new List<String>{'123 Health Ave', '456 Wellness Blvd', '789 Care St'};
        
        // Random Generators
        Integer cityIndex = Integer.valueOf(Math.floor(Math.random() * cities.size()));
        Integer typeIndex = Integer.valueOf(Math.floor(Math.random() * types.size()));
        Integer streetIndex = Integer.valueOf(Math.floor(Math.random() * streets.size()));
        Integer randomPhone = Integer.valueOf(Math.floor(Math.random() * 9000000) + 1000000);
        
        // Construct the ephemeral object
        Medical_Facility__c randomFacility = new Medical_Facility__c(
            Name = 'Genareted',
            City__c = cities[cityIndex],
            Country__c = 'Global Operations',
            Email__c = 'contact' + randomPhone + '@example.com',
            Insurance_Required__c = Math.random() > 0.5, // Random true/false
            Opening_Hours__c = '09:00-17:00',
            Phone__c = '+1-' + randomPhone,
            Postal_Code__c = String.valueOf(Integer.valueOf(Math.floor(Math.random() * 90000) + 10000)),
            Street_Address__c = streets[streetIndex],
            Type__c = types[typeIndex],
            Website__c = 'https://www.med-facility-' + randomPhone + '.com'
        );

        return randomFacility;
    }
}