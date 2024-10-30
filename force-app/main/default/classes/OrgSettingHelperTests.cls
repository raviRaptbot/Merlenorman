/*================================================================================================*\
  # ORG SETTING HELPER TESTS #
\*================================================================================================*/

@isTest
public class OrgSettingHelperTests {
    // #=== SETTINGS ===#

    public static String TEST_SETTING_NAME = 'BatchJobStatusForCase';
    public static String TEST_SETTING_VALUE = 'ON';

    // Override map for testing
    private static Map<String, String> overrideMap = new Map<String, String>();

    // #=== TEST SETUP ===#
    
    @testSetup
    static void setup() {
        // Initialize the overrideMap if needed
        OrgSettingHelpers.overrideMap = new Map<String, String>();
        
        // You can also create any necessary Org Setting records here if applicable
        // Example: insert new Org_Setting__mdt records if needed
    }

    // #=== TRIGGER TEST METHODS ===#

    @isTest
    public static void testGetString() {
        String missingSettingName = 'TestSetting_XYZ1_NOTREAL';
        String defaultValue = '***Default-Value***';
        String overrideValue = 'overwritten value 123';

        Test.startTest();

        // Test getting a non-existent string returns the default value
        System.assertEquals(defaultValue, OrgSettingHelpers.getString(missingSettingName, defaultValue), 
            'Expected default value when setting does not exist.');

        // Spoof existence of the setting using the override map
        OrgSettingHelpers.overrideMap.put(missingSettingName, overrideValue);
        System.assertEquals(overrideValue, OrgSettingHelpers.getString(missingSettingName, defaultValue), 
            'Expected overridden value when setting is spoofed.');

        // Test getting a real setting returns the expected value
        System.assertEquals(TEST_SETTING_VALUE, OrgSettingHelpers.getString(TEST_SETTING_NAME, defaultValue), 
            'Expected real setting value.');

        // Overwrite the real setting with an override
        OrgSettingHelpers.overrideMap.put(TEST_SETTING_NAME, overrideValue);
        System.assertEquals(overrideValue, OrgSettingHelpers.getString(TEST_SETTING_NAME, defaultValue), 
            'Expected overridden value when real setting is overridden.');

        Test.stopTest();
    }

    @isTest
    public static void testGetStringSet() {
        Test.startTest();

        String settingName = 'TestSetting_ListValue_ZZBX';
        
        // Test conversion of a string to a Set
        Set<String> expectedSet = new Set<String>{'one', 'TWO', 'three'};
        System.assertEquals(expectedSet, OrgSettingHelpers.getStringSet(settingName, '  one ,,,   TWO,\nthree\n'), 
            'Expected set of strings from input string.');

        Test.stopTest();
    }

    @isTest
    public static void testGetStringMap() {
        Test.startTest();

        String settingName = 'ZS_Status_To_Tenant_Status_Mapping';

        // Test that the string map is not null and has expected content
        Map<String, String> resultMap = OrgSettingHelpers.getStringMap(settingName);
        
        System.assertNotEquals(null, resultMap, 'Expected non-null map from settings.');
        
        // Optionally check for specific entries in the map if applicable

        Test.stopTest();
    }
}