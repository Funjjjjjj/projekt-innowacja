public class MedicalFacilitiesQueueable 
    implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {
        SalesforceOAuthClient medicalFacilities = new SalesforceOAuthClient();
        medicalFacilities.callMedicalFacilities();
    }
}