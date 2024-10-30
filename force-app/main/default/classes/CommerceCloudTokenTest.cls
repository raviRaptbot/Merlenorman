@isTest
public class CommerceCloudTokenTest {
   @isTest static void getTokenTest()
   {

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockCalloutTestClass('Success'));
        String token = CommerceCloudToken.getToken();
        Test.stopTest();
    }

}