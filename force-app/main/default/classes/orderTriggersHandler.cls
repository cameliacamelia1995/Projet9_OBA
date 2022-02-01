// Cette classe contient la logique du code pour l'objet Order
public class orderTriggersHandler {
    //Cette méthode est appelé avantla MAJ de l'order
    public void calculateOrderNetAmount(List<Order> triggerOrder) {
    for(Order o : triggerOrder) {
        if (o.ShipmentCost__c != null)  {
            o.NetAmount__c = o.TotalAmount - o.ShipmentCost__c; 
        }
        else {
            o.NetAmount__c = o.TotalAmount;
        }
    }
    }
    //Cette méthode est appelé après la MAJ de l'order
    public void calculateAccountTurnOver(List<Order> triggerOrders) {
//Création d'une liste vide pour l'id du compte
        Set<Id> idAccount = new Set<Id>();
        //On récupère l'id des comptes relatives au orders et on l'ajoute au set ID crée
        for(Order o : triggerOrders) {
            idAccount.add(o.AccountId);
        }
        // 1) Je crée une liste de compte, je selectionne les champs dont j'ai besoins
        // 2) L'ID de ses comptes se trouve dans le set que j'ai crée au dessus
        // 3) Je récupère aussi les champs des orders de ses comptes là ou leur statut est activé
        List<Account> accountUpdateList = [SELECT Id, AccountTurnOver__c,
        (SELECT Id, NetAmount__c FROM Orders WHERE Status = 'Activated')
        FROM Account WHERE Id IN : idAccount];
        for(Account a : accountUpdateList) {
            Decimal AccountTo = 0;
            // Pour chaque ordre de la liste de compte on fait le calcul
            for(Order o : a.Orders) {
                AccountTo += o.NetAmount__c; 
            }
            //ajout de la valeur de netAmmout dans la variable AccountTo et assignation de cette valeur au champs du compte AccountTurnOver
            a.AccountTurnOver__C = AccountTo;
        }
        update accountUpdateList;
    
    }
}