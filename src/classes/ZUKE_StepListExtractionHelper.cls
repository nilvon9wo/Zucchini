@isTest
public class ZUKE_StepListExtractionHelper 
{
	@testVisible private String scenarioAsString;
	
	@testVisible private ZUKE_StepListExtractionHelper(String scenarioAsString) 
	{
		 this.scenarioAsString = scenarioAsString; 
	}
	
	public static Map<ZUKE_StepTypeEnum, List<String>> buildStepListByStepTypeMap(String scenarioAsString) 
	{
		ZUKE_StepListExtractionHelper        helper  = new ZUKE_StepListExtractionHelper(scenarioAsString);
		Map<ZUKE_StepTypeEnum, List<String>> listMap = helper.doBuildStepListByStepTypeMap(); 
	 						          return listMap;
	}

	@testVisible public Map<ZUKE_StepTypeEnum, List<String>> doBuildStepListByStepTypeMap()
	{
		Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap = new Map<ZUKE_StepTypeEnum, List<String>>();

		putStepsAsString (stepAsStringListByStepTypeMap, ZUKE_StepTypeEnum.GIVEN_STEP, 'Given', false, 'When', new Set<String>{ 'Then'          });
		putStepsAsString (stepAsStringListByStepTypeMap, ZUKE_StepTypeEnum.WHEN_STEP,  'When',  true,  'Then', new Set<String>{ 'Given'         });
		putStepsAsString (stepAsStringListByStepTypeMap, ZUKE_StepTypeEnum.THEN_STEP,  'Then',  true,  null  , new Set<String>{ 'Given', 'When' });

		  		  return stepAsStringListByStepTypeMap;
	}

	// -----------------------------------------------------------------------------------------------	

	@testVisible private void putStepsAsString(Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap, ZUKE_StepTypeEnum stepType, String targetKeyword, Boolean isRequired, String nextKeyword, Set<String> forbiddenKeywordSet)
	{
		String stepsAsString = extractStepsAsString(targetKeyword, false, nextKeyword, forbiddenKeywordSet);
 	    stepAsStringListByStepTypeMap.put(stepType, extractStepsAsStringList(stepsAsString));  
	}

	// -----------------------------------------------------------------------------------------------	
	
	@testVisible private String extractStepsAsString(String targetKeyword, Boolean isRequired, String nextKeyword, Set<String> forbiddenKeywordSet)
	{
		Integer matchCount = scenarioAsString.countMatches(targetKeyword + ' ');
		validateKeywordCount (targetKeyword, isRequired, matchCount);
		
		String stepsAsString = null;
		if (matchCount > 0)
		{
			stepsAsString = scenarioAsString.substringAfter(targetKeyword + ' ');
			
			if ((String.isNotBlank(nextKeyword)) && (stepsAsString.contains(nextKeyword + ' ')))
			{
				stepsAsString = stepsAsString.substringBefore(nextKeyword + ' ');
			}

			checkForKeywordAbuse(stepsAsString, targetKeyword, nextKeyword, forbiddenKeywordSet);
		}

		return stepsAsString;
	}
	
	@testVisible private void validateKeywordCount (String targetKeyword, Boolean isRequired, Integer matchCount)
	{
		if (matchCount > 1)
		{
			throwMalformedScenerioException('Scenario must NOT use keyword "' +  targetKeyword  + '" more than once. ');
		}
		else if (matchCount == 0)
		{
			if (isRequired) { throwMalformedScenerioException('Scenario must use keyword "' +  targetKeyword  + '" EXACTLY once. '); }
			else			{ System.debug(LoggingLevel.WARN, '!!!!! Scenario has not used keyword "' + targetKeyword + '".');       }
		}
	}
	
	@testVisible private void checkForKeywordAbuse(String stepsAsString, String targetKeyword, String nextKeyword, Set<String> forbiddenKeywordSet)
	{
		if (!forbiddenKeywordSet.isEmpty())
		{
			for (String forbiddenKeyword : new List<String>(forbiddenKeywordSet))
			{
				if (stepsAsString.contains(forbiddenKeyword + ' '))
				{
					throwMalformedScenerioException(
													'It is forbidden to use keyword "' + forbiddenKeyword  + '" after "' +  targetKeyword + '"'  
													+ ( (String.isNotBlank(nextKeyword)) ? ' and before "' + nextKeyword + '"' : '' )
													+ '.  ' 
								);
				}
			}
		}
	}

	// -----------------------------------------------------------------------------------------------	
	
	@testVisible private List<String> extractStepsAsStringList(String stepsAsString)
	{
		if (String.isBlank(stepsAsString)) { return null; }
		
		List<String> stepAsStringList = new List<String>();
		
		String remainingStepsAsString = stepsAsString;
		
		while (String.isNotBlank(remainingStepsAsString))
		{
			Map<String, String> stepDivisionMap = buildStepDivisionMap(remainingStepsAsString);
			stepAsStringList.add(stepDivisionMap.get('before').trim());
			remainingStepsAsString = stepDivisionMap.get('after');
		}
		
		return stepAsStringList;
	}
	
	@testVisible private Map<String, String> buildStepDivisionMap(String remainingStepsAsString)
	{
		if (remainingStepsAsString.contains('Or '))
		{
			throw new ZUKE_MalformedScenarioException ('"Or" is not a supported conjunction.  Please create multiple scenarios.');
		}
		
		Map<String, String> stringBeforeAndMap = splitBeforeKeyword (remainingStepsAsString, 'And');
		Map<String, String> stringBeforeButMap = splitBeforeKeyword (remainingStepsAsString, 'But');
		
		Boolean hasAnd = String.isNotBlank(stringBeforeAndMap.get('after'));
		Boolean hasBut = String.isNotBlank(stringBeforeButMap.get('after'));
		
		if      (!hasAnd && !hasBut) { return buildStepDivisionMap(remainingStepsAsString, null	); }
		else if (!hasAnd || !hasBut) { return (hasAnd) ? stringBeforeAndMap : stringBeforeButMap;  }
		
		Integer beforeAndLength = stringBeforeAndMap.get('before').length();
		Integer beforeButLength = stringBeforeButMap.get('before').length();
  		return (beforeAndLength < beforeButLength) ? stringBeforeAndMap : stringBeforeButMap;
	}
	
	@testVisible private Map<String, String> splitBeforeKeyword (String remainingStepsAsString, String keyword)
	{
		List<String> splitList = remainingStepsAsString.split('\\b'+keyword+'\\b', 2);

			return new Map<String, String>
					{
						'before' => (splitList[0].trim()),
						'after'  => ((splitList.size() > 1) ? (splitList[1].trim()) : null) 
					};
	}
	
	@testVisible private Map<String, String> buildStepDivisionMap(String beforeString, String afterString)
	{
			return new Map<String, String>
					{
						'before' => beforeString,
						'after'  => afterString
					};
	}

	// -----------------------------------------------------------------------------------------------	
	
	@testVisible private void throwMalformedScenerioException(String errorMessage)
	{
			errorMessage += '  Scenario = ' + scenarioAsString;
			throw new ZUKE_MalformedScenarioException (errorMessage);
	}
}