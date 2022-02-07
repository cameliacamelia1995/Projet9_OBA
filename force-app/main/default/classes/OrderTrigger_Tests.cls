@isTest
public with sharing class OrderTrigger_Tests {
    @isTest
    public static void calculateOrderNetAmountManyObject() {
        //Appeler la classe + méthode de la dataFactory + changer les paramètres avec les valeurs 
        // qui correspond a chaque champs de la méthode
        TestDataFactory.createdProduct(2, 2, 1000, 100, 1);
        //Création d'une variable pour y ajouter le résultat attendue
        Decimal resultCalcule = 3600;
        //Création de la liste aggragateResult qui va permettre de calculer la somme des NetAmount
        List<AggregateResult> result;
        //Création d'une liste qui requête le champs statut des orders
        List<Order> searchOrderFields = [SELECT Id,Status FROM Order WHERE Status = 'Draft'];
        Test.startTest();
        // pour chaque order o de la liste searchOrderFields, je met sur le statut sur activated 
        for(Order o : searchOrderFields) {
            o.Status = 'Activated'; 
        }
        update searchOrderFields;
        Test.stopTest();
        result = [SELECT SUM(NetAmount__c) totalSum FROM Order WHERE Status = 'Activated'];
        // Création de la variable qui va permettre d'obtenir la valeur de totalSum
        for(AggregateResult r : result) {
        Decimal resultUpdate = (Decimal)r.get('totalSum');
        System.assertEquals(resultCalcule, resultUpdate);
        }
    }
    @isTest 
    public static void calculateShipmentCost() {
        //Méthode qui test le changement du shipmentCost
        TestDataFactory.createdProduct(5, 5, 1000, 0, 1);
        Decimal resultCalcule = 2500;
        List<Order> searchOrderFields = [SELECT Id, Status, ShipmentCost__c FROM Order WHERE Status = 'Draft']; 
        List<AggregateResult> getTotalAmount;
        Test.startTest();
        for(Order o : searchOrderFields) {
            o.shipmentCost__c = 100; 
            o.Status = 'Activated';
        }
        update searchOrderFields; 
        Test.stopTest();
        getTotalAmount = [SELECT SUM(TotalAmount) totalAmountSum, SUM(NetAmount__c) totalNetAmount FROM Order WHERE Status = 'Activated']; 
        for(AggregateResult gta : getTotalAmount){
            Decimal getTotalAmountResult = (Decimal)gta.get('totalAmountSum');
            Decimal getNetAmount = (Decimal)gta.get('totalNetAmount');
            System.assertEquals(resultCalcule, (getTotalAmountResult - getNetAmount));
        }
    }
    @isTest 
    public static void calculateOrderTotalAmount() {
        //Methode qui calcule que netAmount = TotalAmount
        TestDataFactory.createdProduct(5, 5, 1000, 0, 1);
        List<Order> searchOrderFields = [SELECT Id, Status, ShipmentCost__c FROM Order WHERE Status = 'Draft']; 
        List<AggregateResult> getTotalAmount;
        Test.startTest();
        for(Order o : searchOrderFields) {
            o.Status = 'Activated';
            o.ShipmentCost__c = null;
        }
        update searchOrderFields; 
        Test.stopTest();
        getTotalAmount = [SELECT SUM(TotalAmount) totalAmountSum, SUM(NetAmount__c) totalNetAmount FROM Order WHERE Status = 'Activated']; 
        for(AggregateResult gta : getTotalAmount){
            Decimal getTotalAmountResult = (Decimal)gta.get('totalAmountSum');
            Decimal getNetAmount = (Decimal)gta.get('totalNetAmount');
                     System.assertEquals(getTotalAmountResult,getNetAmount);
        }
    }
    @isTest
    public static void calculateMaxRecords() {
        //Appeler la classe + méthode de la dataFactory + changer les paramètres avec les valeurs 
        // qui correspond a chaque champs de la méthode
        TestDataFactory.createdProduct(200, 1, 1000, 100, 1);
        //Création d'une variable pour y ajouter le résultat attendue
        Decimal resultCalcule = 180000;
        //Création de la liste aggragateResult qui va permettre de calculer la somme des NetAmount
        List<AggregateResult> result;
        //Création d'une liste qui requête le champs statut des orders
        List<Order> searchOrderFields = [SELECT Id,Status FROM Order WHERE Status = 'Draft'];
        Test.startTest();
        // pour chaque order o de la liste searchOrderFields, je met sur le statut sur activated 
        for(Order o : searchOrderFields) {
            o.Status = 'Activated'; 
        }
        update searchOrderFields;
        Test.stopTest();
        result = [SELECT SUM(NetAmount__c) totalSum FROM Order WHERE Status = 'Activated'];
        // Création de la variable qui va permettre d'obtenir la valeur de totalSum
        for(AggregateResult r : result) {
        Decimal resultUpdate = (Decimal)r.get('totalSum');
        System.assertEquals(resultCalcule, resultUpdate);
        }
    }
    @isTest
    public static void calculateTurnOver() {
        //Appeler la classe + méthode de la dataFactory + changer les paramètres avec les valeurs 
        // qui correspond a chaque champs de la méthode
        TestDataFactory.createdProduct(200, 1, 1000, 0, 1);
        //Création d'une variable pour y ajouter le résultat attendue
        Decimal resultCalcule = 200000;
        //Création de la liste aggragateResult qui va permettre de calculer la somme des NetAmount
        List<AggregateResult> result;
        List<AggregateResult> resultTurnOver;
        //Création d'une liste qui requête le champs statut des orders
        List<Order> searchOrderFields = [SELECT Id,Status FROM Order WHERE Status = 'Draft'];
        Test.startTest();
        // pour chaque order o de la liste searchOrderFields, je met sur le statut sur activated 
        for(Order o : searchOrderFields) {
            o.Status = 'Activated'; 
        }
        update searchOrderFields;
        Test.stopTest();
        result = [SELECT SUM(NetAmount__c) totalSum FROM Order WHERE Status = 'Activated'];
        resultTurnOver = [SELECT SUM(AccountTurnOver__c) acctsSum FROM Account];
        // Création de la variable qui va permettre d'obtenir la valeur de totalSum
        Decimal resultUpdate = (Decimal)result[0].get('totalSum');
        Decimal resultSumTo = (Decimal)resultTurnOver[0].get('acctsSum');
        System.assertEquals(resultUpdate, resultSumTo);
        System.assertEquals(resultUpdate, resultCalcule);
        System.assertEquals(resultCalcule, resultSumTo);
        }
    }