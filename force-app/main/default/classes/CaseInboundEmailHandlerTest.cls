@istest
public class CaseInboundEmailHandlerTest  {
    
   @isTest static void testCaseInboundEmailService()
   {
      
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       // intialize the list string to store emails.
       List<string> emails = new List<string>{'test@gmail.com','testEmail123@gmail.com'};
      
      email.subject = 'Create Case Record';
      email.fromAddress = 'customerCare@merlenorman.com';
      //assigning the emails to toAddresses 
      email.toAddresses = emails;
      email.plainTextBody = 'Testing Email from the inbound email service.';
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.txt';
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
      CaseInboundEmailHandler  testInbound=new CaseInboundEmailHandler ();
      testInbound.handleInboundEmail(email, env);
      Case testCase = [Select Id, Subject From Case Where Subject = 'Create Case Record' Limit 1]; 
      System.assertEquals(email.subject ,testCase.Subject);
   }
    
    @isTest static void testCaseInboundEmailServiceUndelivered()
   {
      
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
       // intialize the list string to store emails.
       List<string> emails = new List<string>{'test@gmail.com','testEmail123@gmail.com'};
      
      email.subject = 'Undelivered email for customer care';
      email.fromAddress = 'customerCare@merlenorman.com';
      //assigning the emails to toAddresses 
      email.toAddresses = emails;
      email.plainTextBody = 'Testing Email from the inbound email service.';
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfileone.txt';
      attachment.mimeTypeSubType = 'text/plain';
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
     
      CaseInboundEmailHandler testInbound = new CaseInboundEmailHandler();
      testInbound.handleInboundEmail(email, env);
      List<Case> testCase = [Select Id, Subject From Case Where Subject = 'Undelivered email for customer care' Limit 1]; 
      System.assertEquals(0 ,testCase.size());

   }
}