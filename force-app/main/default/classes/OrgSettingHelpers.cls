/*================================================================================================*\

  # ORG SETTING HELPERS #

  This class is for reusable helper to get org-level constant values.
  
\*================================================================================================*/

public class OrgSettingHelpers {
  // #=== TEMPORARY SETTING OVERRIDE ===#

  // To temporarily override the value for a setting, use the map below. This is primarily useful
  // for test methods, but can be used in production code as well if needed.
  public static Map<String, String> overrideMap = new Map<String, String>{};

  // #=== PUBLIC HELPER METHODS ===#

  // Queries for the specified org setting record, returns null if not found. If there is a key for
  // this settingName in overrideMap, then the Value__c is overwritten in memory before returning,
  // or a dummy org setting is instantiated and returned with the override value.
  public static Org_Setting__mdt queryOrgSetting(String settingName) {
    Org_Setting__mdt[] orgSettings = [
      SELECT DeveloperName, Admin_Notes__c, Value__c
      FROM Org_Setting__mdt
      WHERE DeveloperName = :settingName
    ];

    // If there is a value in the override map then use that instead
    if (overrideMap.containsKey(settingName)) {
      if (orgSettings.isEmpty()) {
        orgSettings.add(new Org_Setting__mdt(DeveloperName = settingName));
      }

      orgSettings[0].Value__c = overrideMap.get(settingName);
    }

    return orgSettings.isEmpty() ? null : orgSettings[0];
  }

  // Returns raw "Value__c" string from the specified setting record.
  // Returns default value if record is missing or if value is a blank / null string.
  public static String getString(String settingName, String defaultValue) {
    Org_Setting__mdt orgSetting = queryOrgSetting(settingName);

    return ((orgSetting == null) || String.isBlank(orgSetting.Value__c))
      ? defaultValue
      : orgSetting.Value__c;
  }

  // Parses "Value__c" as a comma-delimited list and returns the list as a string set.
  // Returns default value if record is missing or if value is a blank / null string.
  // Note: defaultValue should also be a comma-delimited list.
  public static Set<String> getStringSet(String settingName, String defaultValue) {
    String valueString = getString(settingName, defaultValue);
    Set<String> returnSet = new Set<String>();

    if (!String.isBlank(valueString)) {
      for (String item : valueString.split(',')) {
        if (!String.isBlank(item)) {
          returnSet.add(item.trim());
        }
      }
    }

    return returnSet;
  }

  // Parses "Value__c" as a Json and returns the Map of String, String.
  // Returns null if record is missing or if value is a blank / null string.
  public static Map<String, String> getStringMap(String settingName) {
    String valueString = getString(settingName, '');
    Map<String, String> returnMap = new Map<String, String>();

    if (String.isNotBlank(valueString)) {
      Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(valueString);
      if (jsonMap != null && !jsonMap.isEmpty()) {
        for (String key : jsonMap.keySet()) {
          returnMap.put(key, String.valueOf(jsonMap.get(key)));
        }
      }
    }

    return returnMap;
  }
}