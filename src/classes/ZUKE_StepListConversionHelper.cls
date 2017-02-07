@isTest
public class ZUKE_StepListConversionHelper 
{
	String 								 featureName;
	Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap;
	 
	private static Map<String, List<ZUKE_UnmatchableStepException>> unmatchableStepExceptionByFeatureNameMap = new Map<String,  List<ZUKE_UnmatchableStepException>>();
	public  static List<ZUKE_UnmatchableStepException> getUnmatchedStepExceptionList(String featureName) { return unmatchableStepExceptionByFeatureNameMap.get(featureName); }
	 
	@testVisible private ZUKE_StepListConversionHelper(String featureName, Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap)
	{
		this.featureName				   = featureName;
		this.stepAsStringListByStepTypeMap = stepAsStringListByStepTypeMap;
	}
	
	public static List<ZUKE_Step> convertStringMapToStepList(String featureName, Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap)
	{
		ZUKE_StepListConversionHelper helper = new ZUKE_StepListConversionHelper(featureName, stepAsStringListByStepTypeMap);
							   return helper.convert();
	}
	 
	@testVisible private List<ZUKE_Step> convert()
	{
		List<ZUKE_Step> stepList = new List<ZUKE_Step>(); 
						addAll(stepList, convert(ZUKE_StepTypeEnum.GIVEN_STEP, stepAsStringListByStepTypeMap.get(ZUKE_StepTypeEnum.GIVEN_STEP)));
						addAll(stepList, convert(ZUKE_StepTypeEnum.WHEN_STEP,  stepAsStringListByStepTypeMap.get(ZUKE_StepTypeEnum.WHEN_STEP )));
						addAll(stepList, convert(ZUKE_StepTypeEnum.THEN_STEP,  stepAsStringListByStepTypeMap.get(ZUKE_StepTypeEnum.THEN_STEP )));
		 		 return stepList;
	}
	
	@testVisible private void addAll(List<ZUKE_Step> targetStepList, List<ZUKE_Step> additionalStepList)
	{
		if (additionalStepList != null) { targetStepList.addAll(additionalStepList); } 
	}
	
	@testVisible private List<ZUKE_Step> convert(ZUKE_StepTypeEnum stepType, List<String> stepAsStringList)
	{
		if ((stepAsStringList == null) || stepAsStringList.isEmpty()) { return null; }
		
		List<ZUKE_Step> stepList = new List<ZUKE_Step>(); 
		for (String stepAsString : stepAsStringList)
		{
			try { stepList.add(convert(stepType, stepAsString)); }
			catch (ZUKE_UnmatchableStepException e)
			{
				addToUnmatchableStepExceptionpByFeatureNameMap(e);
			}
		}
		return stepList;
	}
	
	@testVisible private ZUKE_Step convert(ZUKE_StepTypeEnum stepType, String stepAsString)
	{
		ZUKE_Step step = ZUKE_MatchableStepCache.get(featureName, stepType, stepAsString); 
		if (step == null) 
		{ 
			String featureType = ZUKE_MatchableStepCache.getFeatureTypeKey(featureName, stepType);
			throw new ZUKE_UnmatchableStepException(featureName, stepType, stepAsString);
		}
		return step; 
	}
	
	@testVisible private void addToUnmatchableStepExceptionpByFeatureNameMap (ZUKE_UnmatchableStepException ex)
	{
		if (!unmatchableStepExceptionByFeatureNameMap.containsKey(featureName)) 
		{ 
			unmatchableStepExceptionByFeatureNameMap.put(featureName, new List<ZUKE_UnmatchableStepException>()); 
		}
		
		unmatchableStepExceptionByFeatureNameMap.get(featureName).add(ex);
	}
}