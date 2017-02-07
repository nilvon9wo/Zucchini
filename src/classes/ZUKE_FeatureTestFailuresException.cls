public class ZUKE_FeatureTestFailuresException extends Exception
{
	private List<ZUKE_FeatureTestFailureException> testFailureExceptionList = null;
	public  List<ZUKE_FeatureTestFailureException> getTestFailureExceptionList() { return testFailureExceptionList; }
	
	public ZUKE_FeatureTestFailuresException(ZUKE_Feature feature, List<ZUKE_FeatureTestFailureException> testFailureExceptionList)
	{
		this(feature.getName() + ' has ' + testFailureExceptionList.size() + ' failed scenario tests.');
		this.testFailureExceptionList = testFailureExceptionList;
		debug();
	}
	
	@testVisible private void debug()
	{
		for (ZUKE_FeatureTestFailureException testFailureException : testFailureExceptionList)
		{
			System.debug(LoggingLevel.ERROR, '!!!!! ' + testFailureException.getMessage()); 
		}
	}
}