public class UTIL_ResultListWrapper 
{
	private enum ResultTypeEnum { SAVE_RESULT, UPSERT_RESULT, DELETE_RESULT, UNDELETE_RESULT, SEND_EMAIL_RESULT }
	
	public class Result
	{
		private Boolean isSuccess = null;
		public  Boolean getIsSuccess() { return isSuccess; }
		
		private List<Database.Error> errorList = null;
		public  List<Database.Error> getErrorList() { return errorList; }

		private Result (Boolean isSuccess, List<Database.Error> errorList)
		{
			this.isSuccess = isSuccess;
			this.errorList = errorList;
		}
		
		public String getErrorString()
		{
			String errorString = '';
			for (Database.Error error : this.errorList) { errorString += String.valueOf(error) + '; '; }
			return errorString;
		}
	}
	
	ResultTypeEnum			        resultType	     = null;
	
	List<Database.SaveResult>       saveResultList      = null;
	List<Database.UpsertResult>     upsertResultList    = null;
	List<Database.DeleteResult>     deleteResultList    = null;
	List<Database.UndeleteResult>   undeleteResultList  = null; 
	List<Messaging.SendEmailResult> sendEmailResultList = null;
	
	public UTIL_ResultListWrapper(List<Database.SaveResult>       resultList) { this.resultType = ResultTypeEnum.SAVE_RESULT;	     this.saveResultList      = resultList; }
	public UTIL_ResultListWrapper(List<Database.UpsertResult>     resultList) { this.resultType = ResultTypeEnum.UPSERT_RESULT;	 	 this.upsertResultList    = resultList; }
	public UTIL_ResultListWrapper(List<Database.DeleteResult>     resultList) { this.resultType = ResultTypeEnum.DELETE_RESULT;	 	 this.deleteResultList    = resultList; }
	public UTIL_ResultListWrapper(List<Database.UndeleteResult>   resultList) { this.resultType = ResultTypeEnum.UNDELETE_RESULT; 	 this.undeleteResultList  = resultList; }
	public UTIL_ResultListWrapper(List<Messaging.SendEmailResult> resultList) { this.resultType = ResultTypeEnum.SEND_EMAIL_RESULT;  this.sendEmailResultList = resultList; }
	
	public Result get(Integer index)
	{
		if (this.resultType == ResultTypeEnum.SAVE_RESULT)       { return new Result (saveResultList[index].isSuccess(),       saveResultList[index].getErrors());	    }
		if (this.resultType == ResultTypeEnum.UPSERT_RESULT)     { return new Result (upsertResultList[index].isSuccess(),     upsertResultList[index].getErrors());    }
		if (this.resultType == ResultTypeEnum.DELETE_RESULT)     { return new Result (deleteResultList[index].isSuccess(),     deleteResultList[index].getErrors());	}
		if (this.resultType == ResultTypeEnum.UNDELETE_RESULT)   { return new Result (undeleteResultList[index].isSuccess(),   undeleteResultList[index].getErrors());  }
		if (this.resultType == ResultTypeEnum.SEND_EMAIL_RESULT) { return new Result (sendEmailResultList[index].isSuccess(),  sendEmailResultList[index].getErrors()); }
		return null;
	}
	
	// ----------------------------------------------------------------------------------------------------------------------------------
	
	public void report(String operation, List<SObject> sObjectList)
	{
		String failedSendResultString = '';
    	for (Integer i=1; i <= sObjectList.size(); i++) 
    	{
			SObject currentSObject = sObjectList[i-1];
			Result 	result		   = this.get(i-1);
			Boolean isSuccess	   = result.getIsSuccess();
			String	errors	       = result.getErrorString();
			
			if (Test.isRunningTest()) { testReport(currentSObject, operation, isSuccess, errors); }
			if (!isSuccess) { failedSendResultString += getFailedResultString(currentSObject); }
    	}
    	
    	if (String.isNotEmpty(failedSendResultString)) { UTIL_EmailSendHelper.sendFailedEmailNotificationToSupport(operation, failedSendResultString); }
	}
	
	public void report(String operation, List<Messaging.Email> emailList)
	{
		String failedSendResultString = '';
    	for (Integer i=1; i <= emailList.size(); i++) 
    	{
			Messaging.Email email 		   = emailList[i-1];
			Result 			result		   = this.get(i-1);
			Boolean 		isSuccess	   = result.getIsSuccess();
			String			errors	       = result.getErrorString();
			
			if (Test.isRunningTest()) { testReport('SendMailResult['+i+']', operation, isSuccess, errors); }
			if (!isSuccess) { failedSendResultString += getFailedResultString(((Messaging.SingleEmailMessage) email)); }
    	}
    	
    	if (String.isNotEmpty(failedSendResultString)) { UTIL_EmailSendHelper.sendFailedEmailNotificationToSupport(operation, failedSendResultString); }
	}

	// ----------------------------------------------------------------------------------------------------------------------------------

	private void testReport(SObject currentSObject, String operation, Boolean isSuccess, String	errors)
	{
		TEST_MockFieldHelper.setMockField(currentSObject, operation+':isSuccess', isSuccess); 
		if (!isSuccess) { TEST_MockFieldHelper.setMockField(currentSObject, operation+':errors', errors); }
	}

	private void testReport(String key, String operation, Boolean isSuccess, String	errors)
	{
		TEST_MockFieldHelper.setMockField(key, operation+':isSuccess', isSuccess); 
		if (!isSuccess) { TEST_MockFieldHelper.setMockField(key, operation+':errors', errors); }
	}
 

	// ----------------------------------------------------------------------------------------------------------------------------------
	
    private static String getFailedResultString(SObject currentSObject)
    { 
    	String valueString = '';
    	for (String key : UTIL_SObjectFieldHelper.getSObjectEditableFields(currentSObject.getSObjectType()))
    	{
    		String value = String.valueOf(currentSObject.get(key));
    		if (String.isNotBlank(value)) { valueString += key + ' : ' +  + '<br/>'; }
    	}
    	
       return String.format (
                                '<strong>Object Id:</strong>{0};<br/><strong>Values:</strong>{1};<br/>', 
                                new String[]
                                {
                                    '<a href=' + UTIL_EmailSendHelper.HOST_URL + '/' + currentSObject.id + '>' + currentSObject.id + '</a>', 
                                    valueString
                                }
                             );
    }
    
    private static String getFailedResultString(Messaging.SingleEmailMessage email)
    {
       return String.format (
                                'Object Id={0}; Recipients={1}; Target Recipient Id={2};<br/>', 
                                new String[]
                                {
                                    '<a href=' + UTIL_EmailSendHelper.HOST_URL + '/' + email.WhatId + '>' + email.WhatId + '</a>', 
                                    String.valueOf(email.toAddresses), 
                                    String.valueOf(email.TargetObjectId)
                                }
                             );
    }    
	
}