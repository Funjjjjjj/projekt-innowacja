public with sharing class FacilityController {
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getFacilityHours(Id facilityId) {
        Medical_Facility__c fac = [
            SELECT 
                Facility_Hours__r.Monday_Open__c, Facility_Hours__r.Monday_Close__c,
                Facility_Hours__r.Tuesday_Open__c, Facility_Hours__r.Tuesday_Close__c,
                Facility_Hours__r.Wednesday_Open__c, Facility_Hours__r.Wednesday_Close__c,
                Facility_Hours__r.Thursday_Open__c, Facility_Hours__r.Thursday_Close__c,
                Facility_Hours__r.Friday_Open__c, Facility_Hours__r.Friday_Close__c,
                Facility_Hours__r.Saturday_Open__c, Facility_Hours__r.Saturday_Close__c,
                Facility_Hours__r.Sunday_Open__c, Facility_Hours__r.Sunday_Close__c
            FROM Medical_Facility__c 
            WHERE Id = :facilityId 
            LIMIT 1
        ];

        if (fac.Facility_Hours__r == null) return null;

        Map<String, String> hoursMap = new Map<String, String>();
        hoursMap.put('Monday', formatTime(fac.Facility_Hours__r.Monday_Open__c, fac.Facility_Hours__r.Monday_Close__c));
        hoursMap.put('Tuesday', formatTime(fac.Facility_Hours__r.Tuesday_Open__c, fac.Facility_Hours__r.Tuesday_Close__c));
        hoursMap.put('Wednesday', formatTime(fac.Facility_Hours__r.Wednesday_Open__c, fac.Facility_Hours__r.Wednesday_Close__c));
        hoursMap.put('Thursday', formatTime(fac.Facility_Hours__r.Thursday_Open__c, fac.Facility_Hours__r.Thursday_Close__c));
        hoursMap.put('Friday', formatTime(fac.Facility_Hours__r.Friday_Open__c, fac.Facility_Hours__r.Friday_Close__c));
        hoursMap.put('Saturday', formatTime(fac.Facility_Hours__r.Saturday_Open__c, fac.Facility_Hours__r.Saturday_Close__c));
        hoursMap.put('Sunday', formatTime(fac.Facility_Hours__r.Sunday_Open__c, fac.Facility_Hours__r.Sunday_Close__c));
        
        return hoursMap;
    }

    private static String formatTime(Time open, Time close) {
        if (open == null || close == null) return 'Closed';
        
        String openStr = String.valueOf(open).substring(0, 5);
        String closeStr = String.valueOf(close).substring(0, 5);
        return openStr + ' - ' + closeStr;
    }
}