public class AccountTurnOverBatch implements Database.Batchable<sObject> {
    // collect the batches of records or objects to be passed to execute
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [SELECT Id, AccountTurnOver__c,
            (SELECT AccountId, NetAmount__c FROM Orders WHERE Status = 'Activated')
            FROM Account]);
    }
    // process each batch of records
    public void execute(Database.BatchableContext bc, List<Account> accountBatch){
        //La première boucle concerne le compte de la liste accountBatch
        for (Account a : accountBatch) {
            //On initialise a 0
            a.AccountTurnOver__c = 0;
            //Condition pour que la liste d'orders du compte A ne soit pas vide 
            if (a.Orders != null && a.Orders.size()> 0) {
            //Puis le seconde boucle concerne la liste des orders du compte a
            for (Order o : a.Orders) {
                if(o.NetAmount__c != null) {
            a.AccountTurnOver__c += o.NetAmount__c;
                    }
                }
            }
            // comptage de la variable traité
            recordsProcessed += 1; 
        }
        update accountBatch;
    }
    // execute any post-processing operation
    public void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }
}
