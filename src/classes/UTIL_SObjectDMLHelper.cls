public class UTIL_SObjectDMLHelper  
{
	public static UTIL_ResultListWrapper doInsert(List<SObject> sObjectList, boolean allOrNone)  
    {
    	return postDmlProcess('Insert', sObjectList, new UTIL_ResultListWrapper(Database.insert(sObjectList, allOrNone)));
    }

	public static UTIL_ResultListWrapper doInsert(List<SObject> sObjectList) { return doInsert(sObjectList, 				 		false); }
	public static UTIL_ResultListWrapper doInsert(SObject currentSObject) 	 { return doInsert(new List<SObject>{ currentSObject }, false); }
	
	// ------------------------------------------------------------------------------------------------------------------------------------

	public static UTIL_ResultListWrapper doUpdate(List<SObject> sObjectList, boolean allOrNone) 
    {
    	return postDmlProcess('Update', sObjectList, new UTIL_ResultListWrapper(Database.update(sObjectList, allOrNone)));
    }

	public static UTIL_ResultListWrapper doUpdate(List<SObject> sObjectList) { return doUpdate(sObjectList, 				 		false); }
	public static UTIL_ResultListWrapper doUpdate(SObject currentSObject) 	 { return doUpdate(new List<SObject>{ currentSObject }, false); }
	
	// ------------------------------------------------------------------------------------------------------------------------------------

	public static UTIL_ResultListWrapper doDelete(List<SObject> sObjectList, boolean allOrNone) 
    {
    	return postDmlProcess('Delete', sObjectList, new UTIL_ResultListWrapper(Database.delete(sObjectList, allOrNone)));
    }

	public static UTIL_ResultListWrapper doDelete(List<SObject> sObjectList) { return doDelete(sObjectList, 				 		false); }
	public static UTIL_ResultListWrapper doDelete(SObject currentSObject) 	 { return doDelete(new List<SObject>{ currentSObject }, false); }
	
	// ------------------------------------------------------------------------------------------------------------------------------------

	/* 
		DML on generic List<SObject> only allowed for insert, update, or delete  :-(
		Use the following for specific SObject implementation templates.
	
			public static UTIL_ResultListWrapper doUpsert(List<SObject> sObjectList, boolean allOrNone) 
		    {
		    	return postDmlProcess('Upsert', sObjectList, new UTIL_ResultListWrapper(Database.upsert(sObjectList, allOrNone)));
		    }
		
			public static UTIL_ResultListWrapper doUpsert(List<SObject> sObjectList) { return doUpsert(sObjectList, 				 		false); }
			public static UTIL_ResultListWrapper doUpsert(SObject currentSObject) 	 { return doUpsert(new List<SObject>{ currentSObject }, false); }
			
			// ------------------------------------------------------------------------------------------------------------------------------------
		
			public static UTIL_ResultListWrapper doUndelete(List<SObject> sObjectList, boolean allOrNone) 
		    {
		    	return postDmlProcess('Undelete', sObjectList, new UTIL_ResultListWrapper(Database.undelete(sObjectList, allOrNone)));
		    }
		
			public static UTIL_ResultListWrapper doUndelete(List<SObject> sObjectList) { return doUndelete(sObjectList, 						false); }
			public static UTIL_ResultListWrapper doUndelete(SObject currentSObject)    { return doUndelete(new List<SObject>{ currentSObject }, false); }

	*/
	
	// --------------------------------------------------------------------------------------------------------------------------------------

	public static UTIL_ResultListWrapper postDmlProcess(String operation, List<SObject> sObjectList, UTIL_ResultListWrapper resultList) 
    {
               resultList.report(operation, sObjectList);
        return resultList;
    }

	// --------------------------------------------------------------------------------------------------------------------------------------


}