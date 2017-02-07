@isTest
public class TEST_AbstractDummyFactory 
{ 
    public static List<SObject> createList (
                                                SObject                     prototypeSObject, 
                                                List<Map<String,Object>>    testValuesByFieldNameMapList, 
                                                TEST_DummyInsertModeEnum    insertMode, 
                                                Boolean                     insertWithSetupUSer
                                            )
    {
        List<SObject>            newSObjectList               = new List<SObject>();
        List<Map<String,Object>> mockValuesByFieldNameMapList = new List<Map<String,Object>>();
            
        for (Map<String,Object> testValuesByFieldNameMap : testValuesByFieldNameMapList)
        {  
            SObject newSObject = prototypeSObject.clone();

            Map<String,Object> mockValuesByFieldNameMap = new Map<String,Object>();
            for (String fieldName : testValuesByFieldNameMap.keySet())
            {
                Object value            = TEST_IntentionalNull.isNotInstance(testValuesByFieldNameMap.get(fieldName))  
                                                ? testValuesByFieldNameMap.get(fieldName)
                                                : null;

                Boolean isEditableField = UTIL_SObjectFieldHelper.isEditableField(prototypeSObject.getSObjectType(), fieldName);  
                if (isEditableField) {               newSObject.put(fieldName, value); }
                else                 { mockValuesByFieldNameMap.put(fieldName, value); } 
            }
            
            newSObjectList.add(newSObject);
            mockValuesByFieldNameMapList.add(mockValuesByFieldNameMap);
        }   
 
        if          (insertMode == TEST_DummyInsertModeEnum.MOCK)           { TEST_MockDMLHelper.mockInsert  ( newSObjectList );  }  
        else if     (insertMode == TEST_DummyInsertModeEnum.REAL)  
        { 
            if (insertWithSetupUser) { System.runAs(TEST_DummyUserFactory.SETUP_DATA_CREATION_USER){ insert    newSObjectList;   }}
            else                     {                                                               insert    newSObjectList;    }    
        }  
                
        TEST_MockFieldHelper.setMockFields (newSObjectList, mockValuesByFieldNameMapList);
                 
        return newSObjectList; 
    }   

    public static SObject create (SObject prototypeSObject, Map<String,Object> testValuesByFieldNameMap, TEST_DummyInsertModeEnum insertMode, Boolean insertWithSetupUSer)
    {
        return createList (prototypeSObject, new List<Map<String,Object>>{ testValuesByFieldNameMap }, insertMode, insertWithSetupUSer)[0];
    }
}