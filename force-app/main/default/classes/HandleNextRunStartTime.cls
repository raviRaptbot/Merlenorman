public without sharing class HandleNextRunStartTime implements Metadata.DeployCallback
{
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) 
    {
        if(result.status == Metadata.DeployStatus.SUCCEEDED)
        {
            //success
            System.debug(' ===>'+ result);
        }else{
            //not success
            System.debug(' ===> fail '+ result);
        }
        
    }
    public static list<Next_Order_Update_Run__mdt	> getMetaDataRecords()
    {
        list<Next_Order_Update_Run__mdt> nextRun = [Select Id,Search_From__c, label FROM Next_Order_Update_Run__mdt];
        return nextRun;
    }
    public  static DateTime getSearchFrom()
    {
        Next_Order_Update_Run__mdt	 nextRun = getMetaDataRecords()[0];
        return nextRun.Search_From__c;
    }
    

    public static void  setNextSearhFrom(DateTime mostRecentOrder)
    {
        try {
            Next_Order_Update_Run__mdt	 nextRun = getMetaDataRecords()[0]; //retrieving custom metadata records, using the first.
            Id customMetadataId = nextRun.Id;
            system.debug('CustomMetadata Id ' + customMetadataId);
            Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
            customMetadata.fullName = 'Next_Order_Update_Run.Execution_time'; //custom metadata name
            customMetadata.label = 'Execution_time';

            
            Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
            customField1.field = 'Search_From__c'; //the custom field API Name that you're wanting to insert/update a value of
            customField1.value = mostRecentOrder.addSeconds(-1);
            customMetadata.values.add(customField1);//add the changes to list of changes to be deployed

            Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
            mdContainer.addMetadata(customMetadata);
            
            HandleNextRunStartTime callback = new HandleNextRunStartTime();

            
            Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
            
            system.debug('jobId is ' + jobId);
            
 
 //           return 'Success';
            
        } catch (Exception e) {
            system.debug('>> Error:' + e.getMessage());
//            return e.getMessage();
        }
    }
    
    
}