trigger ErrorTestAccountTrigger on Account (before insert) {
    ErrorTestAccountTriggerHandler.beforeInsert();
}