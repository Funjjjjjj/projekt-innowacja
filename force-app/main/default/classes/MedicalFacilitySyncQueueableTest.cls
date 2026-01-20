@isTest
private class MedicalFacilitySyncQueueableTest {
    
    @isTest
    static void testCalloutSuccess() {
        Test.setMock(HttpCalloutMock.class, new MedicalFacilityMock());
        
        Test.startTest();
        System.enqueueJob(new MedicalFacilitySyncQueueable());
        Test.stopTest(); 
        
        List<Medical_Facility__c> facilities = [SELECT Id FROM Medical_Facility__c];
        
        System.assertEquals(1, facilities.size(), 'Powinien zostać utworzony jeden rekord po otrzymaniu odpowiedzi 200');
    }
}