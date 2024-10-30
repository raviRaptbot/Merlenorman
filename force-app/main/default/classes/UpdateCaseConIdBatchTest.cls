@isTest
public class UpdateCaseConIdBatchTest {
    
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
        
        // Create a Case with matching email and null ContactId
        Case testCase = new Case(
            SuppliedEmail = 'testperson@example.com',
            ContactId  = null
        );
        insert testCase;
        
    }
    
    @isTest
    static void testUpdateCaseConIdBatch() {
        
        // Execute the batch job
        Test.startTest();
        UpdateCaseConIdBatch batch = new UpdateCaseConIdBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        Case updatedCase = [SELECT Id, ContactId FROM Case WHERE SuppliedEmail = 'testperson@example.com' LIMIT 1];
        System.assertNotEquals(null, updatedCase.ContactId, 'ContactId should be updated on Case record');
        
        Account personAccount = [SELECT Id, PersonContactId FROM Account WHERE PersonEmail = 'testperson@example.com' LIMIT 1];
        System.assertEquals(personAccount.PersonContactId, updatedCase.ContactId, 'ContactId on Case should match PersonContactId on Account');
    }
}