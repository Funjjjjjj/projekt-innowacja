public class DoctorWorkSchedulesQueueable 
    implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext context) {
        DoctorWorkSchedulesUpdate updater = new DoctorWorkSchedulesUpdate();
        updater.callDoctorWorkSchedules();
    }
}