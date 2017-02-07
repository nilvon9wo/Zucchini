public class ZUKE_UnmatchableStepException extends Exception
{
	String 				targetFeatureName = null; 
	ZUKE_StepTypeEnum 	stepType	      = null; 
	String 				stepAsString	  = null;
	
	public ZUKE_UnmatchableStepException(String targetFeatureName, ZUKE_StepTypeEnum stepType, String stepAsString)
	{
		this('Step "' + stepAsString + '" can not be matched for "' + ZUKE_MatchableStepCache.getFeatureTypeKey(targetFeatureName, stepType) + '". ');
		this.targetFeatureName = targetFeatureName;
		this.stepType		   = stepType;
		this.stepAsString      = stepAsString;
	}
	
	public ZUKE_UnmatchableStepException (ZUKE_Step step, String stepAsString)
	{
		this(step.getTargetFeatureName(), step.getType(), stepAsString);
	}
	
	public void debug()
	{ 
				System.debug(LoggingLevel.ERROR, '!!!!! '+ this.getMessage()); 
				System.debug(LoggingLevel.DEBUG,  '***** To create a template class, anonymously execute: '
								+ ' ZUKE_StepTemplateHelper.createTemplateDocument(' 
										+ '\'' + targetFeatureName + '\', ' 
										+ ' ZUKE_StepTypeEnum.' + String.valueOf(stepType) + ', ' 
										+ '\'' + stepAsString + '\'' 
								+ ');'
							); 
	}
}