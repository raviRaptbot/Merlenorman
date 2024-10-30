public class UpdateCommOrdConIdBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext Batchable) {
        // Use OrgSettingHelpers to get the status of the batch job
        String batchJobStatus = OrgSettingHelpers.getString('BatchJobStatusForCommerceOrder', 'ON');
        
        if (batchJobStatus == 'OFF') {
            return null; 
        } else {
            String CommerceOrderquery = 'SELECT Id, Contact__c, email__c FROM Commerce_order__c WHERE email__c != null AND Contact__c = null';
            return Database.getQueryLocator(CommerceOrderquery);
        }
    }
    
    public void execute(Database.BatchableContext Batchable, List<Commerce_order__c> ListOfComOrder) {
        if (ListOfComOrder != null && !ListOfComOrder.isEmpty()) {
            List<Commerce_order__c> commOrderToUpdate = new List<Commerce_order__c>();
            
            Map<String, Id> emailToPersonAccountMap = new Map<String, Id>();
            for (Account acc : [
                SELECT Id, PersonContactId, PersonEmail 
                FROM Account 
                WHERE RecordType.DeveloperName = 'PersonAccount' 
                AND PersonEmail != null
            ]) {
                emailToPersonAccountMap.put(acc.PersonEmail, acc.PersonContactId);
            }
            
            // List to hold Commerce Orders that need to be updated
            for (Commerce_order__c commOrd : ListOfComOrder) {
                if (commOrd.email__c != null && emailToPersonAccountMap.containsKey(commOrd.email__c)) {
                    commOrd.Contact__c = emailToPersonAccountMap.get(commOrd.email__c); 
                    commOrderToUpdate.add(commOrd);
                }
            }
            
            // Update Commerce Orders if there are any to update
            if (!commOrderToUpdate.isEmpty()) {
                try {
                    update commOrderToUpdate;
                } catch (DmlException e) {
                    // Handle any DML exceptions here
                    System.debug('Error updating Commerce Orders: ' + e.getMessage());
                }
            }
        }
    }
    
    public void finish(Database.BatchableContext Batchable) {
        // Optional: Add any post-processing logic here
    }
}