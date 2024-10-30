public class UpdateCaseConIdBatch implements Database.Batchable<SObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext Batchable) {
        // Use the helper to get the setting value
        String batchJobStatus = OrgSettingHelpers.getString('BatchJobStatusForCase', 'ON'); // Default to 'ON'

        if (batchJobStatus == 'OFF') {
            return null; 
        } else {
            String Casesquery = 'SELECT Id, ContactId, SuppliedEmail FROM Case WHERE SuppliedEmail != null AND ContactId = null';
            return Database.getQueryLocator(Casesquery);
        }
    }

    public void execute(Database.BatchableContext Batchable, List<Case> cases) {
        if (!cases.isEmpty()) {
            List<Case> casesToUpdate = new List<Case>();

            Map<String, Id> emailToPersonAccountMap = new Map<String, Id>();
            for (Account acc : [
                SELECT Id, PersonContactId, PersonEmail 
                FROM Account 
                WHERE RecordType.DeveloperName = 'PersonAccount' 
                AND PersonEmail != null
            ]) {
                emailToPersonAccountMap.put(acc.PersonEmail, acc.PersonContactId);
            }

            for (Case caseWithoutContact : cases) {
                if (emailToPersonAccountMap.containsKey(caseWithoutContact.SuppliedEmail)) {
                    caseWithoutContact.ContactId = emailToPersonAccountMap.get(caseWithoutContact.SuppliedEmail);
                    casesToUpdate.add(caseWithoutContact);
                }
            }

            if (!casesToUpdate.isEmpty()) {
                try {
                    update casesToUpdate;
                } catch (DmlException e) {
                    System.debug('Error updating cases: ' + e.getMessage());
                }
            }
        }
    }

    public void finish(Database.BatchableContext Batchable) {
    }
}