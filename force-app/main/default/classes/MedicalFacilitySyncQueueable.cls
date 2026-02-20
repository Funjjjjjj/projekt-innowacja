public class MedicalFacilitySyncQueueable implements System.Queueable, Database.AllowsCallouts {
    
    public void execute(QueueableContext context) {
        SalesforceOAuthClient medicalFacilities = new SalesforceOAuthClient();
        medicalFacilities.callMedicalFacilities();
        
        DoctorWorkSchedulesUpdate doctorWorkSchedulesUpdate = new DoctorWorkSchedulesUpdate();
		doctorWorkSchedulesUpdate.callDoctorWorkSchedules();
    }
}