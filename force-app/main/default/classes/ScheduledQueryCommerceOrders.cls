/* Run a Schedule Class for 10 minutes:- 
System.schedule('QueryCommerceOrders at 00 mins', '0 0 * * * ?', new ScheduledQueryCommerceOrders());
System.schedule('QueryCommerceOrders at 10 mins', '0 10 * * * ?', new ScheduledQueryCommerceOrders());
System.schedule('QueryCommerceOrders at 20 mins', '0 20 * * * ?', new ScheduledQueryCommerceOrders());
System.schedule('QueryCommerceOrders at 30 mins', '0 30 * * * ?', new ScheduledQueryCommerceOrders());
System.schedule('QueryCommerceOrders at 40 mins', '0 40 * * * ?', new ScheduledQueryCommerceOrders());
System.schedule('QueryCommerceOrders at 50 mins', '0 50 * * * ?', new ScheduledQueryCommerceOrders());
*/
global class ScheduledQueryCommerceOrders implements Schedulable {
   global void execute(SchedulableContext SC) {
     // QueryCommerceOrders Q = new QueryCommerceOrders(); 
      if(Test.isRunningTest()){
         return;
         }
      //Q.executeHttp();
      System.enqueueJob(new QueryCommerceOrdersQueueable(0, 0, 0, True)); 
   }
}