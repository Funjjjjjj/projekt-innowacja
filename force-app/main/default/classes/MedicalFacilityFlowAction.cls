public class MedicalFacilityFlowAction {

    @InvocableMethod(label='Uruchom Synchronizację Placówek' description='Pobiera dane z zewnętrznego API i zapisuje w Salesforce')
    public static void executeSync() {
        // Flow wywołuje tę metodę, a ona dodaje zadanie do kolejki (Queueable)
        System.enqueueJob(new MedicalFacilitySyncQueueable());
    }
}