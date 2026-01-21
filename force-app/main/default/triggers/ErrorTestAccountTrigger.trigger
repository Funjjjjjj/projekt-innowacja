trigger ErrorTestAccountTrigger on Account (before insert) {
    try {
        Integer x = 1 / 0;
    } catch (Exception e) {
        TriggerErrorHandler.handle(e, 'ErrorTestAccountTrigger');
        throw e; 
    }
    //insert new Account(Name = 'Test Error');
}