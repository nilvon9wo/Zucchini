public class ZUKE_ScenarioTestFailureException extends Exception 
{
	public ZUKE_ScenarioTestFailureException(ZUKE_Scenario scenario, ZUKE_Step step, Exception ex)
	{
		this (createErrorMessage(scenario, step, ex));
	}
	
	@testVisible private static String createErrorMessage(ZUKE_Scenario scenario, ZUKE_Step step, Exception ex)
	{
		String errorMessage = 'Failure executing test '
								+ scenario.getFeature().getName() + '::'
								+ scenario.getName() 			  + '::'
								+ '{{' + step.getStepAsString() + '}}\n'
								+ 'Scenario String: ' + scenario.getScenarioAsString() + '\n';
		
		if (ex != null) 
		{
			errorMessage += ex.getTypeName() + ': ' 
						 + ex.getMessage() + '\n';
						 + ex.getStackTraceString();
		}
		
		return errorMessage;
	}
}