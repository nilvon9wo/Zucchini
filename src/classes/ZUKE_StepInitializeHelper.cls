@isTest
public class ZUKE_StepInitializeHelper 
{
	public static Matcher getMatcher(ZUKE_Step step, String stepAsString)
	{
		List<String> stepRegexList = step.getMatchableRegexList();
		
		for (String stepRegex : stepRegexList)
		{
			Pattern p = Pattern.compile(stepRegex);
			Matcher matcher = p.matcher(stepAsString);
			if (matcher.matches()) { return matcher; }
		}
		 
		throw new ZUKE_UnmatchableStepException (step, stepAsString);	// This should NEVER happen!
	}
}