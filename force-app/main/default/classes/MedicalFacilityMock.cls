@isTest
global class MedicalFacilityMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"City__c": "Warszawa", "Type__c": "Clinic"}');
        response.setStatusCode(200);
        return response;
    }
}