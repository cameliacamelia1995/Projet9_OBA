@IsTest
public with sharing class AccountTurnOverBatch_Test {
    @IsTest
    public static void recordsAccountPassed() {
        TestDataFactory.createdProduct(10, 100, 1000, 100, 1);
        //10*100*1000-201-100;
        Decimal accountTurnOver = 900000;
        List<Account> accountUpdate;
        List<AggregateResult> resultExpeted;
        List<Order> orderUpdate = [SELECT Id, Status FROM Order WHERE Status = 'Draft'];
        Test.startTest();
        for(Order p : orderUpdate) {
            p.Status = 'Activated';
        }
    update orderUpdate;
    accountTurnOverBatch atob = new accountTurnOverBatch();
    Id batchId = Database.executeBatch(atob);
    Test.stopTest();

    accountUpdate = [SELECT Id, AccountTurnOver__c FROM Account];
    resultExpeted = [SELECT SUM(AccountTurnOver__c) AccountToExpected FROM Account];
    Decimal expectedAccTo = (Decimal)resultExpeted[0].get('AccountToExpected');
    for(Account g : accountUpdate){
        System.assertEquals(10, accountUpdate.size());
    }
    System.assertEquals(accountTurnOver, expectedAccTo);
    
    }
}