@isTest
public class ZUKE_DummyZucchiniSettingFactory 
{
	private static Id DUMMY_FOLDER_ID;
	
	static
	{
		if (DUMMY_FOLDER_ID == null)
		{
			Folder dummyFolder = [
									SELECT id 
									FROM Folder 
									WHERE (Type =: 'Document')
									LIMIT 1
							  	];
			DUMMY_FOLDER_ID = dummyFolder.id;							  
		}
	}
	
	public static List<Zucchini_Setting__c> createList (List<Map<String,Object>> testValuesByFieldNameMapList, TEST_DummyInsertModeEnum insertMode)
	{
		return (List<Zucchini_Setting__c>) TEST_AbstractDummyFactory.createList(getPrototype(), testValuesByFieldNameMapList, insertMode, false);
	}

	// -----------------------------------------------------------------------------------------------------------------
		
	public static Zucchini_Setting__c create (Map<String,Object> testValuesByFieldNameMap, TEST_DummyInsertModeEnum insertMode)
	{
		return createList (new List<Map<String,Object>>{ testValuesByFieldNameMap} , insertMode)[0]; 
	} 

    public static Zucchini_Setting__c create (TEST_DummyInsertModeEnum insertMode) { return create (new Map<String,Object>(), insertMode);                    }
    public static Zucchini_Setting__c create ()                                    { return create (new Map<String,Object>(), TEST_DummyInsertModeEnum.NONE); }

	// -----------------------------------------------------------------------------------------------------------------

	private static Zucchini_Setting__c getPrototype()
	{
        return new Zucchini_Setting__c(
             				Step_Class_Template_Folder_Id__c = DUMMY_FOLDER_ID
             );
	}

}