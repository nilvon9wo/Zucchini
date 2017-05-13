@isTest
public class ZUKE_MatchableStepCache  
{
	@testvisible private ZUKE_MatchableStepCache(){}
	
	@testvisible private static ZUKE_StepDao zukeStepDao = new ZUKE_StepDao();
	 
	@testVisible private static Map<String, Map<String, ZUKE_Step>> stepByRegexByFeatureTypeMapSingleton;
	
	@testVisible private static Map<String, Map<String, ZUKE_Step>> getStepByRegexByFeatureTypeMap()
	{
		if (stepByRegexByFeatureTypeMapSingleton == null)
		{
			ZUKE_MatchableStepCache            cache = new ZUKE_MatchableStepCache();
			stepByRegexByFeatureTypeMapSingleton = cache.buildStepByRegexByFeatureTypeNameMap(zukeStepDao, new Map<String, Map<String, ZUKE_Step>>());
		}
		return stepByRegexByFeatureTypeMapSingleton;
	}

	public static ZUKE_Step get(String targetFeatureName, ZUKE_StepTypeEnum stepType, String stepAsString)
	{
		Map<String, Map<String, ZUKE_Step>> stepByRegexByFeatureTypeMap = getStepByRegexByFeatureTypeMap();
		String                              targetFeatureTypeKey        = getFeatureTypeKey (targetFeatureName, stepType);
		
		if (!stepByRegexByFeatureTypeMap.containsKey(targetFeatureTypeKey)) { return null; }
		
		Map<String, ZUKE_Step> stepByRegexMap = stepByRegexByFeatureTypeMap.get(targetFeatureTypeKey);
		ZUKE_Step 			   matchingStep   = get(stepByRegexMap, stepAsString);
		
		return (matchingStep != null)
				? initializeStep (matchingStep, stepAsString)
				: null;
	}
	 
	@testVisible private static ZUKE_Step get(Map<String, ZUKE_Step> stepByRegexMap, String stepAsString)
	{
		ZUKE_Step matchingStep = null;
		for (String regexString : stepByRegexMap.keySet())
		{
			if (Pattern.matches(regexString, stepAsString))
			{
				if (matchingStep == null) { matchingStep = stepByRegexMap.get(regexString); }
				else
				{
					throw new ZUKE_DuplicateStepRegexException(
						'Step "' + stepAsString + '" illegally matches two or more regex expressions in Steps: \n'
						+ ' 1. ' + matchingStep + '\n'
						+ ' 2. ' + stepByRegexMap.get(regexString) + '\n'
					); 
				}
			}
		}
		return matchingStep;
	}
	
	@testVisible private static ZUKE_Step initializeStep (ZUKE_Step matchingStep, String stepAsString)
	{
		String    stepName = UTIL_ClassHelper.getName(matchingStep);	// Create a new instance of the Step so we can initialize independantly of other instances where this step may be used. 

		ZUKE_Step step 	   = ZUKE_StepDao.get(stepName);  
			   	  step.initialize(stepAsString);						// We leave it to step implementations to determine how to extract values and match them to internal values.
		   return step; 
	}
	
	@testVisible private Map<String, Map<String, ZUKE_Step>> buildStepByRegexByFeatureTypeNameMap(ZUKE_StepDao stepDao, Map<String, Map<String, ZUKE_Step>> stepByRegexByFeatureTypeMap)
	{
		List<ZUKE_Step> stepList = stepDao.getList(); 
		for (ZUKE_Step step : stepList)
		{
			String      targetFeatureTypeKey  = getFeatureTypeKey(step);
			if (!stepByRegexByFeatureTypeMap.containsKey(targetFeatureTypeKey))
			{
				stepByRegexByFeatureTypeMap.put(targetFeatureTypeKey, new Map<String, ZUKE_Step>());
			}
			buildStepByRegexMap(stepByRegexByFeatureTypeMap.get(targetFeatureTypeKey), targetFeatureTypeKey, step);
		}
		return stepByRegexByFeatureTypeMap;
	}

	@testVisible private static void buildStepByRegexMap(Map<String, ZUKE_Step> stepByRegexMap, String targetFeatureTypeName, ZUKE_Step step)
	{
		List<String> matchableRegexList = step.getMatchableRegexList();
		for (String matchableRegex : matchableRegexList)
		{
			String regexString = matchableRegex;
			
			if (!stepByRegexMap.containsKey(regexString)) 
			{
				stepByRegexMap.put(regexString, step);
			} 
			else
			{
				throw new ZUKE_DuplicateStepRegexException(
						'Feature-Type Combination "' + targetFeatureTypeName + '" illegally offers two or more Steps to match RegEx "' + matchableRegex + '": \n'
						+ ' 1. ' + stepByRegexMap.get(regexString) + '\n'
						+ ' 2. ' + step + '\n'
					); 
			}
		}
	}
	 
	// --------------------------------------------
	
	@testVisible private static String getFeatureTypeKey (ZUKE_Step step)
	{
		return getFeatureTypeKey (step.getTargetFeatureName(), step.getType());
	}

	public static String getFeatureTypeKey (String targetFeatureName, ZUKE_StepTypeEnum stepType)
	{
		return targetFeatureName + '::' + String.valueOf(stepType);
	}

	
	
}