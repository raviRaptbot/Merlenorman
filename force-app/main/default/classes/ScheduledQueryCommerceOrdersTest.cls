@isTest
public class ScheduledQueryCommerceOrdersTest 
{
    @isTest static void execute()
    {
        
        Test.startTest();
        SchedulableContext SC = null;
        ScheduledQueryCommerceOrders Q = new ScheduledQueryCommerceOrders();
        Q.execute(SC);
        Test.stopTest();
    }

}