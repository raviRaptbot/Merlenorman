@isTest
public class HandleNextRunStartTimeTest 
{
    @isTest static void getSearchFromTest()
    {
        
        Test.startTest();
        DateTime start = HandleNextRunStartTime.getSearchFrom();
        Test.stopTest();
    }
    @isTest static void setNextSearhFromTest() 
    {
        
        Test.startTest();
        System.enqueueJob(new testqueueable());
       // HandleNextRunStartTime.setNextSearhFrom(DateTime.newInstance(2023, 11, 18, 3, 3, 3));
        Test.stopTest();
//        System.assertEquals(result, 'Success', 'Expected Success');        
    }
    
}