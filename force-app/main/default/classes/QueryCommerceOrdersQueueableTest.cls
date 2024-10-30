@isTest
public class QueryCommerceOrdersQueueableTest {
    @isTest static void executeCommerceCloudCallout(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutTestClass('Success'));
        System.enqueueJob(new QueryCommerceOrdersQueueable(0, 0, 0, True));
        Test.stopTest();
    }
    

}