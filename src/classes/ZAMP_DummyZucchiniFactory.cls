@isTest
public class ZAMP_DummyZucchiniFactory 
{
    public static List<Zucchini__c> createList (Integer amount, TEST_DummyInsertModeEnum insertMode)
    {
    	List<Zucchini__c> zucchiniList = new List<Zucchini__c>();
    	if (amount > 0)
    	{
	    	for (Integer i=1; i<=amount; i++)
	    	{
	    		zucchiniList.add(create(TEST_DummyInsertModeEnum.NONE));
	    	}
    	}
    	
    	if      (insertMode == TEST_DummyInsertModeEnum.REAL) { 				       insert zucchiniList;  }
    	else if (insertMode == TEST_DummyInsertModeEnum.MOCK) { TEST_MockDMLHelper.mockInsert(zucchiniList); }
    	
    	return zucchiniList;
    }

	
    public static List<Zucchini__c> createList (List<Map<String,Object>> testValuesByFieldNameMapList, TEST_DummyInsertModeEnum insertMode)
    {
        return (List<Zucchini__c>) TEST_AbstractDummyFactory.createList(getPrototype(), testValuesByFieldNameMapList, insertMode, true); 
    } 
 
    // -----------------------------------------------------------------------------------------------------------------
        
    public static Zucchini__c create (Map<String,Object> testValuesByFieldNameMap, TEST_DummyInsertModeEnum insertMode)
    {
        return createList (new List<Map<String,Object>>{ testValuesByFieldNameMap} , insertMode)[0]; 
    } 

    public static Zucchini__c create (TEST_DummyInsertModeEnum insertMode) { return create (new Map<String,Object>(), insertMode);                    }
    public static Zucchini__c create ()                                    { return create (new Map<String,Object>(), TEST_DummyInsertModeEnum.NONE); }

    // -----------------------------------------------------------------------------------------------------------------
 
    private static Zucchini__c getPrototype() 
    {
        return new Zucchini__c(
        		// TODO: 
             );
    }
}