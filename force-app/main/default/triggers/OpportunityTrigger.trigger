trigger OpportunityTrigger on Opportunity (before update,after update, before delete) {
  
    for (opportunity opp : Trigger.new) {
      if (opp.Amount < 5000) {
          opp.addError('Opportunity amount must be greater than 5000');
      }
         }    
        
  

         if (Trigger.isBefore && Trigger.isDelete) {
          Set <Id> accountIds = new Set<Id>();
          for (Opportunity opp : Trigger.old) {
             accountIds.add(opp.AccountId);
          }
          Map <Id, Account> accountsWithBanking = new Map<Id, Account>();
          List<Account> accountsForOpps = [SELECT Id, Industry FROM Account WHERE Id IN :accountIds];
          for (Account acc : accountsForOpps) {
            if (acc.Industry == 'Banking') {
              accountsWithBanking.put(acc.Id, acc);
            }
          }
          for (Opportunity opps : Trigger.old) {
            if (opps.StageName == 'Closed Won' && accountsWithBanking.containsKey(opps.AccountId)) {
              opps.addError('Cannot delete closed opportunity for a banking account that is won');
            }
          }
          }

    if (trigger.isBefore && trigger.isUpdate) {
      Set<Id> accountIds = new Set<Id>();
      for (Opportunity opp : trigger.new) {
        accountIds.add(opp.AccountId);
      }
      Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
      List<Contact> contacts = [SELECT Id, Title, AccountId FROM Contact WHERE AccountId IN :accountIds];
      for(Contact con : contacts) {
        if (con.Title == 'CEO') {
          accountToContactMap.put(con.AccountId, con);
        }  
        for (Opportunity opp : trigger.new) {
          if (accountToContactMap.containsKey(opp.AccountId)) {
            opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;    
          }
        }   
     }
    }
  
    
}
