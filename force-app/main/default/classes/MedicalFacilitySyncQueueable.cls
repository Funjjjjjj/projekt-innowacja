public class MedicalFacilitySyncQueueable implements System.Queueable, Database.AllowsCallouts {
    
    public void execute(QueueableContext context) {
        String endpoint = 'https://agentforce-cw--inn2.sandbox.my.salesforce.com/services/apexrest/MedicalFacilities/Generate';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); 
        request.setHeader('Content-Type', 'application/json');

        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                Medical_Facility__c facility = (Medical_Facility__c) JSON.deserialize(
                    response.getBody(), 
                    Medical_Facility__c.class
                );
                
                insert facility;
                System.debug('Pomyślnie dodano obiekt: ' + facility.Id);
            } else {
                System.debug('Błąd API: Status ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Wyjątek podczas synchronizacji: ' + e.getMessage());
        }
    }
}