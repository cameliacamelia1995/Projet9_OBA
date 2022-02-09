public with sharing class OrderPageController {
        // Cette méthode permet de calculer la somme total pour chaque ordre
        public decimal totalSumOrder {
            get {
                AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated' ];
                return (decimal)groupedResults.get('total');
            }
            set;
        }
    }
    
