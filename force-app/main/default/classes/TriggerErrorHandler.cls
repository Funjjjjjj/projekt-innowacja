public class TriggerErrorHandler {

    private static final String ADMIN_EMAIL = '251147@edu.p.lodz.pl';

    public static void handle(Exception e, String triggerName) {
        sendErrorEmail(e, triggerName);
        System.debug(LoggingLevel.ERROR, e.getMessage());
    }

    private static void sendErrorEmail(Exception e, String triggerName) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { ADMIN_EMAIL });
        mail.setSubject('Błąd w triggerze: ' + triggerName);

        String body =
            'Trigger: ' + triggerName + '\n\n' +
            'Message: ' + e.getMessage() + '\n\n' +
            'StackTrace:\n' + e.getStackTraceString();

        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}