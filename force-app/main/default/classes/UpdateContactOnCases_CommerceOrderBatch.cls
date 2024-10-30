/**
* @description : Batch job to update Case and Commerce Order records with the PersonContactId from Person Account records.
* 
* This batch process checks if the update for Cases and Orders is enabled via configuration settings, 
* Then queries relevant Person Accounts modified in the past 24 hours. For each Person Account with an email and no linked 
* Contact ID in the Case or Commerce Order records, it assigns the PersonContactId.
* 
* @author : AllCloud User
* @last modified on  : 29-10-2024
* @last modified by  : AllCloud User      

*/

public class UpdateContactOnCases_CommerceOrderBatch implements Database.Batchable<SObject>,Schedulable {
    
    // Configuration to check if Case and Order updates should be processed 
    private String ExecuteCaseContactUpdateBatch = OrgSettingHelpers.getString('ExecuteCaseContactUpdateBatch', 'False');
    private String ExecuteCommerceOrderUpdateBatch = OrgSettingHelpers.getString('ExecuteCommerceOrderUpdateBatch', 'False');
    
    // Queries Person Account records modified in the past 24 hours.
    public Database.QueryLocator start(Database.BatchableContext context) {
        
        DateTime lastModifiedDate_24HoursBefore = Datetime.now().AddDays(-1);
        
        if (ExecuteCaseContactUpdateBatch.equalsIgnoreCase('True') || ExecuteCommerceOrderUpdateBatch.equalsIgnoreCase('True')) {
            String query = 'SELECT Id, RecordType.Name, RecordType.DeveloperName, PersonEmail, PersonContactId ' +
                'FROM Account ' +
                'WHERE RecordType.DeveloperName = \'PersonAccount\' ' +
                'AND PersonEmail != null ' +
                'AND LastModifiedDate >= :lastModifiedDate_24HoursBefore ';
            return Database.getQueryLocator(query);
        } else {
            return null;
        }
    }
    
    // Updates Case and Order records with PersonContactId.
    public void execute(Database.BatchableContext context, List<Account> accList) {
        
        List<String> emailAddresses = new List<String>();
        Map<String, Id> emailToContactIdMap = new Map<String, Id>();
        
        // Build a map of PersonEmail to Contact Id
        for (Account acc : accList) {
            emailAddresses.add(acc.PersonEmail);
            emailToContactIdMap.put(acc.PersonEmail, acc.PersonContactId);
        }
        
        // Update Case records to link with Person Contact if batch job for Cases is enabled.
        if(ExecuteCaseContactUpdateBatch.equalsIgnoreCase('True')){
            List<Case> casesToUpdate = [SELECT Id, SuppliedEmail FROM Case WHERE SuppliedEmail IN :emailAddresses AND ContactId = NULL];
            
            for (Case c : casesToUpdate) {
                c.ContactId = emailToContactIdMap.get(c.SuppliedEmail);
            }
            if (!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }  
        }
        
        // Update Commerce Orders records to link with Person Contact if batch job for Cases is enabled.
        if(ExecuteCommerceOrderUpdateBatch.equalsIgnoreCase('True')){
            List<Commerce_order__c> ordersToUpdate  = [SELECT Id, email__c, Contact__c FROM Commerce_order__c  
                                                       WHERE email__c IN :emailAddresses AND Contact__c = NULL];
            for (Commerce_order__c o : ordersToUpdate) {
                o.Contact__c = emailToContactIdMap.get(o.email__c);
            }
            if (!ordersToUpdate.isEmpty()) {
                update ordersToUpdate;
            }
        }
    }
    
    public void finish(Database.BatchableContext context) {
        System.debug('updated succesfully');
    }
    public void execute(SchedulableContext context){
        // Implement the scheduling logic here
        UpdateContactOnCases_CommerceOrderBatch batchJob = new UpdateContactOnCases_CommerceOrderBatch();
        Database.executeBatch(batchJob,200); 
        //Here you can also declare batchSize = 200 at starting & use it here. 
    }
}