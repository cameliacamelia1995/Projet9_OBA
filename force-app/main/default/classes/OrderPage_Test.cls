@isTest
public with sharing class OrderPage_Test {
    
    @TestSetup
    static void createUser(){
        TestDataFactory.createUser();
        
    }
    @isTest 
    public static void displayOrderPage () {

        User testUser = [SELECT id FROM User WHERE LastName = 'Dupont'];
        TestDataFactory.createdProduct(1,1,100,10, 1); 
        OrderPageController orderPage = new OrderPageController();
        List<AggregateResult> resultSumOrderPage;
        List<Order> updateOrder = new List<Order>();
        updateOrder = [SELECT Id, status, NetAmount__c, TotalAmount FROM Order WHERE Status = 'draft'];

        test.startTest();
        for(Order o : updateOrder) {
            o.Status = 'Activated';
        }
        update updateOrder;
        System.runAs(testUser){
        resultSumOrderPage = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
        
    }

        Decimal result = orderPage.totalSumOrder;
        test.stopTest();
        //for (AggregateResult agg : resultSumOrderPage) {
            System.assertEquals(100,(Decimal)resultSumOrderPage[0].get('total'));
            System.assertEquals(1, updateOrder.size());
            System.assertEquals(100, orderPage.totalSumOrder);
            System.assertEquals(result, (Decimal)resultSumOrderPage[0].get('total'));
        //}
    }
}
