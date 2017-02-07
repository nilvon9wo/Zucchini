public class UTIL_SObjectFieldHelper 
{
	private static Map<Schema.SObjectType,Set<String>>	editableFieldSetBySObjectTypeCache = new Map<Schema.SObjectType,Set<String>>();
	
 	public static Set<String> getSObjectEditableFields(Schema.SObjectType sObjectType) 
 	{
 		if (editableFieldSetBySObjectTypeCache.containsKey(sObjectType))  { return editableFieldSetBySObjectTypeCache.get(sObjectType);  }
 		else if (sObjectType == null) 									  { return null; 											     } 

        Map<String, Schema.SObjectField> objectFieldsMap 	  = sObjectType.getDescribe().Fields.getMap();
        Set<String> 					 editableFieldNameSet = new Set<String>();
        if (objectFieldsMap != null) 
        {
            for (Schema.SObjectField objectField : objectFieldsMap.values()) 
            {
                Schema.DescribeFieldResult objectFieldDescribe = objectField.getDescribe();
                if (objectFieldDescribe.isCreateable()) 														// field is creatable
                { 
                	String editableFieldName = (objectFieldDescribe.getName()).toLowerCase();
                	editableFieldNameSet.add(editableFieldName); 
                } 
            }
        }

		editableFieldSetBySObjectTypeCache.put(sObjectType, editableFieldNameSet);            
        return editableFieldNameSet;
    }

	// ----------------------------------------------------------------------------------------------------------------------------------------
	
	public static Boolean isEditableField(Schema.SObjectType sObjectType, String fieldName) 
	{
		return (getSObjectEditableFields(sObjectType)).contains(fieldName.toLowerCase());
	} 
}