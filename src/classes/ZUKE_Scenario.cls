public virtual class ZUKE_Scenario  
{
	public static final String SCENARIO_KEYWORD = 'Scenario:';
	 
	@testVisible private String	   name;
				 public  String getName() { return name; }
	
	@testVisible private ZUKE_Feature    feature;
				 public  ZUKE_Feature getFeature() { return feature; }
	
	@testVisible private String             scenarioAsString; 
				 public  String getScenarioAsString() { return scenarioAsString; }

	@testVisible private List<ZUKE_Step> 	stepList				{ get; set; } 
	
	@testVisible private Map<String, Object> scenarioValuesbyNameMap 	= new Map<String, Object>();
	public  Map<String, Object> getScenarioValuesbyNameMap() { return scenarioValuesbyNameMap; }
	 
	public ZUKE_Scenario(ZUKE_Feature feature, String scenarioAsString) 
	{ 
		this.feature = feature;
		this.scenarioAsString = scenarioAsString;
		setName(scenarioAsString); 

		Map<ZUKE_StepTypeEnum, List<String>> stepAsStringListByStepTypeMap = ZUKE_StepListExtractionHelper.buildStepListByStepTypeMap(scenarioAsString);
		stepList = ZUKE_StepListConversionHelper.convertStringMapToStepList(feature.getName(), stepAsStringListByStepTypeMap);
	}	 

	@testVisible private ZUKE_Scenario(String scenarioAsString)
	{
		System.debug(LoggingLevel.WARN, '!!!!! Using test constructor without Feature parameter; limited functionality available');
		this.scenarioAsString = scenarioAsString;
	}

	@testVisible private void setName(String scenaroString) 
	{
		String firstStepKeyWord = getFirstStepKeyWord();
		name = scenaroString.subStringBefore(firstStepKeyWord).trim();
		if (name.contains('\n')) { name = scenaroString.subStringBefore('\n').trim(); }
	}

	@testVisible private String getFirstStepKeyWord()
	{
		if 		(scenarioAsString.countMatches('Given ') > 0)  { return 'Given'; }
		else if (scenarioAsString.countMatches('When ')  > 0)  { return 'When';  }
		// We don't check for 'Then' because while a valid keyword, scenarios require "When" and (optionally) "Given" to be before.
		
		throw new ZUKE_IncompleteScenarioException ('Scenario requires at least one step indicated with the keyword "Given" or "When".  Scenario = ' + scenarioAsString);
	}
	
	public virtual boolean test()
	{
		for (ZUKE_Step step : stepList)
		{
			Boolean   testFails       = false;
			Exception caughtException = null;
			try  {  if ((step != null) && (!step.test(this))) { testFails = true; } }
			
			// IMPORTANT NOTE:  Can NOT catch System.AssertException
			catch (Exception ex) 
			{ 
				testFails       = true;
				caughtException = ex;
			}
			
			if (testFails) {  throw new ZUKE_ScenarioTestFailureException(this, step, caughtException); }
			
		}
		return true;		
	}
	
}