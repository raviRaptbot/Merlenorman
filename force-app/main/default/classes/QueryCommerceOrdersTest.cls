@isTest
public class QueryCommerceOrdersTest 
{
   @isTest static void executeHttpTest()
   {
       
       /* Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutTestClass('Success'));
        QueryCommerceOrders Q = new QueryCommerceOrders();
        Q.executeHttp();
        Test.stopTest();*/
        

        //Test.startTest();
        //QueryCommerceOrdersQueueable queryCommerce = new QueryCommerceOrdersQueueable(0, 0, 0, True);
        Test.setMock(HttpCalloutMock.class, new MockCalloutTestClass('Success'));
        System.enqueueJob(new QueryCommerceOrdersQueueable(0, 0, 0, True));
        //Test.stopTest();
    }

}