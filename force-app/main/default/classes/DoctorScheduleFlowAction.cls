public class DoctorScheduleFlowAction {

    @InvocableMethod(label='Uruchom Synchronizację Grafiku Lekarzy' description='Pobiera dane z zewnętrznego API i zapisuje w Salesforce')
    public static void executeSync() {
		System.enqueueJob(new DoctorWorkSchedulesQueueable());
    }
}