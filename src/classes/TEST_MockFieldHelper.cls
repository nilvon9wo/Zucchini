@isTest
public class TEST_MockFieldHelper 
{
    private static Map<String, Map<String, Object>> mockValueByFieldNameByObjectMap = new Map<String, Map<String, Object>>();
    
    public static void setMockField (String key, String fieldName, Object value)
    {
        if (!mockValueByFieldNameByObjectMap.containsKey(key)) { mockValueByFieldNameByObjectMap.put(key, new Map<String, Object>()); }
        mockValueByFieldNameByObjectMap.get(key).put(fieldName, value);
    }
    
    public static void setMockField (SObject dummySObject, String fieldName, Object value)
    {
        if (dummySObject.id != null) { setMockField (dummySObject.id, fieldName, value); }
        setMockField (UTIL_MapIdentifierHelper.create(dummySObject, false), fieldName, value);  // In case we don't know the Id when we want to look for this.
    } 

    public static void setMockFields (List<SObject> newSObjectList, List<Map<String,Object>> mockValuesByFieldNameMapList)
    {
        for (Integer i=0; i<newSObjectList.size(); i++)
        {
            SObject            newSObject               = newSObjectList[i];
            Map<String,Object> mockValuesByFieldNameMap = mockValuesByFieldNameMapList[i];
            for (String fieldName : mockValuesByFieldNameMap.keySet())
            {
                setMockField (newSObject, fieldName, mockValuesByFieldNameMap.get(fieldName));
            }
        }
    }

    public static Object getMockField (String key, String fieldName)
    {
        return mockValueByFieldNameByObjectMap.get(key).get(fieldName);
    }
    
    public static Object getMockField (SObject dummySObject, String fieldName)
    {
        String key = ((dummySObject.id != null) && mockValueByFieldNameByObjectMap.containsKey(dummySObject.id))
                        ? dummySObject.id
                        : UTIL_MapIdentifierHelper.create(dummySObject, false);
                        
        return getMockField (key, fieldName);
    }
    
    public static void debug()
    {
    	for (String objectKey : mockValueByFieldNameByObjectMap.keySet())
    	{
    		Map<String, Object> mockValueByFieldName = mockValueByFieldNameByObjectMap.get(objectKey);
    		for (String fieldName : mockValueByFieldName.keySet())
    		{
    			System.debug(
    							'$$$$$$ objectName::fieldName::{{value}} : ' 
    								+ objectkey + '::' 
    								+ fieldName + '::'
    								+ '{{' + mockValueByFieldName.get(fieldName) + '}}'
    						);
    		}
    	}
    }

}