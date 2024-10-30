@isTest
public class UpdateCommOrdConIdBatchTest {
    
    @testSetup
    public static void setupTestData() {
        // Create a Person Account Record Type if it doesn't exist
        String personAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        // Create a Commerce Order with matching email and null Contact__c
        Commerce_order__c testOrder = new Commerce_order__c(
            email__c = 'testperson@example.com',
            Contact__c = null
        );
        insert testOrder;
        
        // Create a Person Account
        Account personAccount = new Account(
            RecordTypeId = personAccountRecordType,
            FirstName = 'Test',
            LastName = 'Person',
            PersonEmail = 'testperson@example.com'
        );
        insert personAccount;
        
    }
    
    @isTest
    static void testUpdateCommOrdConIdBatch() {
        
        // Start the batch job
        Test.startTest();
        UpdateCommOrdConIdBatch batch = new UpdateCommOrdConIdBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify that the Commerce Order's Contact__c is updated
        Commerce_order__c updatedOrder = [SELECT Id, Contact__c FROM Commerce_order__c WHERE email__c = 'testperson@example.com' LIMIT 1];
        System.assertNotEquals(null, updatedOrder.Contact__c, 'Contact__c should be updated on Commerce Order record');
        
        Account personAccount = [SELECT Id, PersonContactId FROM Account WHERE PersonEmail = 'testperson@example.com' LIMIT 1];      
        System.assertEquals(personAccount.PersonContactId, updatedOrder.Contact__c, 'Contact__c on Order should match PersonContactId on Account');
    }
}