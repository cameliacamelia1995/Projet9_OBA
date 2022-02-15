// Cette classe contient les triggers qui sont déclenché lors d'un événement dans l'objet order
trigger OrderTrigger on Order (before update, after update) {
    OrderTriggerHandler calculateOrder = new OrderTriggerHandler();
    
        if (Trigger.isBefore) {
            calculateOrder.calculateOrderNetAmount(Trigger.new);
        }
    
        if (Trigger.isAfter) {
            calculateOrder.calculateAccountTurnOver(Trigger.new);
        }
    }