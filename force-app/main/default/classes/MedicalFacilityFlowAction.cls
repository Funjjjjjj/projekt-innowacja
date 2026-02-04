public class MedicalFacilityFlowAction {

    @InvocableMethod(label='Uruchom Synchronizację Placówek' description='Pobiera dane z zewnętrznego API i zapisuje w Salesforce')
    public static void executeSync() {
        System.enqueueJob(new MedicalFacilitiesQueueable());
    }
}