@isTest
public class UpdateContactOnCases_OrderBatchTest {
	
    @testSetup
    public static void setupTestData() {
        
        //Get the Person Account Record Type.
       String personAccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		
        // Create a Commerce Order with null Contact__c
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
    static void testPersonContactLinkCaseAndOrders() {   
        
        UpdateContactOnCases_CommerceOrderBatch batchJob = new UpdateContactOnCases_CommerceOrderBatch();
        Test.startTest();
        Database.executeBatch(batchJob);
        Test.stopTest();

        // Verify that the Case's ContactId is updated
        Case updatedCase = [SELECT Id, ContactId FROM Case WHERE SuppliedEmail = 'testperson@example.com' LIMIT 1];
        System.assertNotEquals(null, updatedCase.ContactId, 'ContactId should be updated on Case record');
        
        // Verify that the Commerce Order's Contact__c is updated
        Commerce_order__c updatedOrder = [SELECT Id, Contact__c FROM Commerce_order__c WHERE email__c = 'testperson@example.com' LIMIT 1];
        System.assertNotEquals(null, updatedOrder.Contact__c, 'Contact__c should be updated on Commerce Order record');

        // Additional assertions for correct linking
        Account personAccount = [SELECT Id, PersonContactId FROM Account WHERE PersonEmail = 'testperson@example.com' LIMIT 1];
        System.assertEquals(personAccount.PersonContactId, updatedCase.ContactId, 'ContactId on Case should match PersonContactId on Account');
        System.assertEquals(personAccount.PersonContactId, updatedOrder.Contact__c, 'Contact__c on Order should match PersonContactId on Account');
    }
}