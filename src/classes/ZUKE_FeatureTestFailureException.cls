public class ZUKE_FeatureTestFailureException extends Exception 
{
	public ZUKE_FeatureTestFailureException(ZUKE_Feature feature, ZUKE_Scenario scenario, Exception ex)
	{
		this (createErrorMessage(feature, scenario, ex));
	}
	
	@testVisible private static String createErrorMessage(ZUKE_Feature feature, ZUKE_Scenario scenario, Exception ex)
	{
		String errorMessage = 'Failure executing test '
								+ feature.getName() 			  + '::'
								+ scenario.getName() 			  + '\n';
		
		if (ex != null) 
		{
			errorMessage += ex.getTypeName() + ': ' 
						 + ex.getMessage() + '\n';
						 + ex.getStackTraceString();
		}
		
		return errorMessage;
	}
}