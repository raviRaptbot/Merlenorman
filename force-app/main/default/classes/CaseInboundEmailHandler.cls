global class CaseInboundEmailHandler implements Messaging.InboundEmailHandler {
    private final static String CASE_EMAIL_TEMPLATE = 'Case Inbound Template';
    
    public static Group CASE_QUEUE {
        get{
            if(CASE_QUEUE == null){
                CASE_QUEUE =  [SELECT Id, Name, DeveloperName, Type, Email FROM Group Where Name='Case Queue' AND Type = 'Queue' LIMIT 1];
                System.debug('CASE_QUEUE==== '+CASE_QUEUE);
            }
            return CASE_QUEUE;
        }
        set;
    }
    
    
    global Messaging.InboundEmailResult handleInboundEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope envelope
    ) {
        Savepoint sp;
        System.debug('Inside CaseInboundEmailHandler==== ');
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocumentLinks	= new List<ContentDocumentLink>();
        System.debug('CASE_QUEUE========== '+CASE_QUEUE);
        
        try{
            String inboundEmailSubject = email.subject;
            String inboundEmailAddress = email.fromAddress;
            System.debug('inboundEmailSubject=== '+inboundEmailSubject);
            System.debug('emailAddress=== '+inboundEmailAddress);
            if(!inboundEmailSubject.contains('Undelivered')){
                System.debug('Inside IF Condition');
                Case caseRecord = new Case();
                String caseNumber = getCaseNumber(email.subject);
                caseRecord = getCase(caseNumber);
                if(String.isBlank(caseNumber)){
                    System.debug('String.isBlank(caseNumber)=== ');
                    caseRecord = new Case(OwnerId = CASE_QUEUE.Id, Priority ='Medium', Origin='Customer Care');
                    caseRecord.Subject = email.subject;
                    caseRecord.Description = email.plainTextBody;
                    caseRecord.SuppliedName = email.fromName;
                    insert caseRecord;
                    List<Case> currentCaseRec = [Select Id From Case Where Subject =: email.subject LIMIT 1];
                    if(currentCaseRec.size() != null){
                        System.debug('Inside Current Case Created Content Version=====');
                        contentVersions = getContentVersions(email.binaryAttachments);
                        if (!contentVersions.isEmpty()) {
                            insert contentVersions;
                            contentDocumentLinks = getContentDocumentLinks(currentCaseRec[0].Id, contentVersions);
                            if (!contentDocumentLinks.isEmpty()) {
                                insert contentDocumentLinks;
                            }
                        }
                    }
                    
                    sendEmail(email,caseRecord.Id);
                }
            }
            
            sp = Database.setSavepoint();
        } catch (DMLException e) {
            Database.rollback(sp);
        }
        return result;
    }
    
    private Case getCase(String caseNumber) {
        List<Case> cases = new List<Case>(
            [
                SELECT Id,CaseNumber
                FROM Case
                WHERE CaseNumber = :caseNumber
                LIMIT 1
            ]
        );
        return cases.isEmpty() ? null : cases.get(0);
    }
    
    private String getCaseNumber(String subject) {
        String caseNumber = String.isNotBlank(subject)
            ? subject.substringAfter('[').substringBefore(']').trim()
            : '';
        System.debug('getCaseNumber===== '+caseNumber);
        if(String.isNotBlank(caseNumber)){
            List<String>trimEmailSubject = caseNumber.split(' ');
            if(!trimEmailSubject.isEmpty()){
                return String.isNotBlank(trimEmailSubject[2]) ? trimEmailSubject[2] : '';
            }
        }
        return '';
    }
    
    private void sendEmail(Messaging.InboundEmail email,String recordId) {
        Messaging.SingleEmailMessage emailMessage = getSingleEmail(email,recordId);
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(
                new List<Messaging.SingleEmailMessage>{ emailMessage },
                true
            );
        }
    }
    private List<ContentVersion> getContentVersions(List<Messaging.InboundEmail.BinaryAttachment> attachments) {
        List<ContentVersion> contentVersions = new List<ContentVersion>();
        if (attachments != null) {
            for (Messaging.InboundEmail.BinaryAttachment attachment : attachments) {
                contentVersions.add(getContentVersion(attachment));
            }
        }
        return contentVersions;
    }
    private List<ContentDocumentLink> getContentDocumentLinks(String relatedId, List<ContentVersion> contentVersions) {
        List<ContentDocumentLink> contentDocumentLinks = new List<ContentDocumentLink>();
        if (
            relatedId	!=	null
            &&
            contentVersions		!=	null
            &&
            !contentVersions.isEmpty()
        ) {
            for (ContentVersion oContentVersion : [
                SELECT
                Id,
                ContentDocumentId
                FROM
                ContentVersion
                WHERE
                Id = :contentVersions
            ]) {
                contentDocumentLinks.add(getContentDocumentLink(relatedId, oContentVersion));
            }
        }
        return contentDocumentLinks;
    }
    private ContentVersion getContentVersion(Messaging.InboundEmail.BinaryAttachment attachment) {
        return	new ContentVersion(
            PathOnClient	=	attachment.fileName,
            VersionData		=	attachment.body
        );
    }
    private ContentDocumentLink getContentDocumentLink(String relatedId, ContentVersion oContentVersion) {
        return	new ContentDocumentLink(
            LinkedEntityId		=	relatedId,
            ContentDocumentId	=	oContentVersion.ContentDocumentId,
            ShareType			=	'V',
            Visibility			=	'AllUsers'
        );
    }
    private Messaging.SingleEmailMessage getSingleEmail(
        Messaging.InboundEmail email,String recordId
    ) {
        String defaultOrgEmailAddress = System.Label.CaseDefaultOrgWideEmailAddress;
        EmailTemplate caseTemplate = [SELECT ID,Name,Body,HtmlValue ,Subject From EmailTemplate Where Name =:CASE_EMAIL_TEMPLATE LIMIT 1];
        Case caseRecord = [Select Id,Subject,OwnerId,CaseNumber,SuppliedName FROM Case Where Id =:recordId LIMIT 1];
        OrgwideemailAddress orgEmailAddress = [select Id,Address from OrgWideEmailAddress Where Address = :defaultOrgEmailAddress LIMIT 1];
        List<String> toAddress = new List<String>();
        toAddress.add(email.fromAddress);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String subject = caseTemplate.Subject.replace('{!Case.Subject}', caseRecord.Subject);
        system.debug('subject' + JSON.serialize(subject));
        String body = caseTemplate.body;
        /*String body = caseTemplate.HtmlValue.replace('{{{Case.SuppliedName}}}', caseRecord.SuppliedName);
        body = body.replace('{{{Case.CaseNumber}}}', caseRecord.CaseNumber);*/
        mail.setTargetObjectId(userinfo.getUserId());
        mail.setTreatTargetObjectAsRecipient(false);
        mail.setWhatId(caseRecord.Id);
        mail.setSubject(subject);
        mail.sethtmlBody(body);
        mail.saveAsActivity = true;
        mail.setToAddresses(toAddress);
        mail.setOrgWideEmailAddressId(orgEmailAddress.Id);
        mail.setInReplyTo(email.inReplyTo);
        return mail;
    }
    
}