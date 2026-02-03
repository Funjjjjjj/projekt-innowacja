public class TriggerErrorHandler {

    public static void handle(Exception e, String triggerName) {
        System.debug(LoggingLevel.ERROR, e.getMessage());
        sendErrorEmail(e, triggerName);
    }

    private static void sendErrorEmail(Exception e, String triggerName) {

        List<User> adminUsers = [
            SELECT Email
            FROM User
            WHERE IsActive = true
            AND Email != null
            AND Profile.Name = 'System Administrator'
        ];

        if (adminUsers.isEmpty()) {
            System.debug(LoggingLevel.WARN, 'No System Administrator users found to notify.');
            return;
        }

        List<String> adminEmails = new List<String>();
        for (User u : adminUsers) {
            adminEmails.add(u.Email);
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(adminEmails);
        mail.setSubject('Błąd w triggerze: ' + triggerName);

        String body =
            'Trigger: ' + triggerName + '\n\n' +
            'Message:\n' + e.getMessage() + '\n\n' +
            'StackTrace:\n' + e.getStackTraceString();

        mail.setPlainTextBody(body);

        Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail }
        );
    }
}
