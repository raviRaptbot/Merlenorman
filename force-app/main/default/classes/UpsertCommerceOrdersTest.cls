@isTest
public class UpsertCommerceOrdersTest 
{
    @isTest static void testUpsert()
    {
        List<Commerce_order__c> recordsToUpsert = new List<Commerce_order__c>();
        Commerce_order__c rec1 = new Commerce_order__c();
        Commerce_order__c rec2 = new Commerce_order__c();
        rec1.order_no__c='001';
        rec1.Name = '001';
        rec2.order_no__c='002';
        rec2.Name = '002';
        recordsToUpsert.add(rec1);
        recordsToUpsert.add(rec2);
        
        Test.startTest();
        System.enqueueJob(new UpsertCommerceOrders(recordsToUpsert, DateTime.now()));
        Test.stopTest();
        
        List<Commerce_order__c> recs = [SELECT Name from Commerce_order__c];
        Integer count = recs.size();
        System.assertEquals(count, 2);

        
        
    }
    
}