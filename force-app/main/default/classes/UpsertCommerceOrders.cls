public class UpsertCommerceOrders implements Queueable

{
    public List<Commerce_order__c> recordsToUpsert;
    public DateTime mostRecentOrder;
    public UpsertCommerceOrders(List<Commerce_order__c> recordsToUpsert, DateTime mostRecentOrder)
    {
        this.recordsToUpsert = recordsToUpsert;
        this.mostRecentOrder = mostRecentOrder;
    }
    public void execute(QueueableContext context) {

		System.debug('--->List Size =' + recordsToUpsert.size() );
        System.debug('--->BeforeUpsertRecords = ' + recordsToUpsert);
        upsert recordsToUpsert order_no__c;
        System.debug('--->AfterUpsertRecords =  ' + recordsToUpsert);
		SetNextStartTime(mostRecentOrder);

    }
    
	@Future
    public static void SetNextStartTime(DateTime mostRecentOrder)
    {
        HandleNextRunStartTime.setNextSearhFrom(mostRecentOrder);         
        
    }
}