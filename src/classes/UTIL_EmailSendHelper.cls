public class UTIL_EmailSendHelper 
{
	public static final String HOST_URL = System.URL.getSalesforceBaseURL().getHost();
	
	public static UTIL_ResultListWrapper sendEmail(List<Messaging.Email> emailList, boolean allOrNone) 
    {
    	return postSendMailProcess(emailList, new UTIL_ResultListWrapper(Messaging.sendEmail(emailList, allOrNone))); 
    }

	public static UTIL_ResultListWrapper sendMails(List<Messaging.Email> emailList) { return sendEmail(emailList, false); }

	// --------------------------------------------------------------------------------------------------------------------------------------

	public static UTIL_ResultListWrapper sendEmail(List<Messaging.SingleEmailMessage> emailList, boolean allOrNone) 
    {
    	return postSendMailProcess(emailList, new UTIL_ResultListWrapper(Messaging.sendEmail(emailList, allOrNone))); 
    }

	public static UTIL_ResultListWrapper sendMails(List<Messaging.SingleEmailMessage> emailList) { return sendEmail(emailList, false); }

	// --------------------------------------------------------------------------------------------------------------------------------------

	private static UTIL_ResultListWrapper postSendMailProcess(List<Messaging.Email> emailList, UTIL_ResultListWrapper resultList) 
    {
               resultList.report('Send Email', emailList);
        return resultList; 
    }

    // -----------------------------------------------------------------------------------------------------------------------

    // @see http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_forcecom_email_outbound.htm
    public static void sendNotificationMail(List<String> addressList, String subject, String messageBody, Boolean useHTMLBody, LoggingLevel loggingLevel, String logPrefix)
    {
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage email = createMail (addressList, subject, messageBody, useHTMLBody, loggingLevel, logPrefix);
        if (loggingLevel != null) { System.debug (loggingLevel, logPrefix + email); }
        sendEmail(new List<Messaging.SingleEmailMessage> { email }, false);
    } 
    
    public static void sendNotificationMail(List<String> addressList, String subject, String messageBody) 
    {
    	sendNotificationMail(addressList, subject, messageBody, false, null, null);
    }
    
    public static void sendNotificationMail(String addressee, String subject, String messageBody)
    {
        sendNotificationMail(new List<String> {addressee}, subject, messageBody, false, null, null);
    }

    public static void sendFailedEmailNotificationToSupport(String operation, String failedEmailSendResultString)
    {
        String supportEmailAddress = General_Settings__c.getInstance().Support_Email__c; 
        if (String.isEmpty(supportEmailAddress)) 
        { 
            System.debug (LoggingLevel.ERROR, '!!!!! General_Settings__c.getInstance().Support_Email__c not set.');
            return; 
        }
        
        String subject = 'A ' + operation + ' has failed; untransacted data is itemized below:';
        sendNotificationMail((new List<String> { supportEmailAddress }), (subject), (subject + ':<br/>' + failedEmailSendResultString), true, Logginglevel.ERROR, '---- Failed ' + operation + ': ');
    }

    // -----------------------------------------------------------------------------------------------------------------------

    public static Messaging.SingleEmailMessage createMail(sObject currentSObject, Id templateId, String[] addressArray, Id targetUserId) 
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage ();
                                     email.settoAddresses(addressArray); 
                                     email.setTargetObjectId(targetUserId);   //setting this field is workaround to support email template. If it's not defined template can not be used.
                                     email.setTemplateID(templateId);
                                     email.setWhatId(currentSObject.id);
								//   email.setorgWideEmailAddressId(General_Settings__c.getInstance().Org_Wide_Email_Address__c);
                                     email.setSaveAsActivity (false);
                              return email;
    }

    public static Messaging.SingleEmailMessage createMail (List<String> addressList, String subject, String messageBody, Boolean useHTMLBody, LoggingLevel loggingLevel, String logPrefix)
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                                     email.setToAddresses(addressList);
                                     email.setSubject(subject);
                                     
        if (useHTMLBody) {           email.setHtmlBody(messageBody);      }
        else             {           email.setPlainTextBody(messageBody); }
        
                                     email.saveAsActivity = false;
                              return email;
    }

    public static Messaging.SingleEmailMessage createMail (List<String> addressList, String subject, String messageBody)
    {
    	return createMail(addressList, subject, messageBody, false, null, null);
    }

}