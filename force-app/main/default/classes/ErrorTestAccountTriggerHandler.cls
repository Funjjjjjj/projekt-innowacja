public class ErrorTestAccountTriggerHandler {

    public static void beforeInsert() {
        try {
            System.debug('WORK!!!');
            Integer x = 1 / 0;

        } catch (Exception e) {
            TriggerErrorHandler.handle(e, 'ErrorTestAccountTrigger');
            throw e; // rollback transakcji
        }
    }
}