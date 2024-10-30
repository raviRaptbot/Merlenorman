/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Commerce_orderTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_Commerce_orderTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Commerce_order__c());
    }
}