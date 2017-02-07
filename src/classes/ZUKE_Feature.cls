public virtual class ZUKE_Feature 
{
	@testVisible private static ZUKE_StaticResourceDao staticResourceDao = new ZUKE_StaticResourceDao();
	
	@testVisible private String    name;
	public  String getName() { return name; }
	 
	@testVisible private String 			 featureAsString;
	@testVisible private List<ZUKE_Scenario> scenarioList;  
	
	public ZUKE_Feature(String name, List<ZUKE_Scenario> scenarioList) 
	{ 
		this.name         = name;
		this.scenarioList = scenarioList; 
	}
	 
	public ZUKE_Feature(String staticResourceName)
	{
		name = staticResourceName;
		StaticResource resource = staticResourceDao.get(name);
		convert(resource.body);
	}
	
	// ---------------------------------------------------------------------------------------
	
	public boolean test()
	{
		List<ZUKE_FeatureTestFailureException> testFailureExceptionList = new List<ZUKE_FeatureTestFailureException>();
				
		for (Zuke_Scenario scenario : scenarioList)
		{
			Boolean   testFails       = false;
			Exception caughtException = null;
			
			try { if (!scenario.test()) { testFails = true;  /** This should never happen! **/ } } 

			// IMPORTANT NOTE:  Can NOT catch System.AssertException
			catch (Exception ex)
			{ 
				testFails       = true;
				caughtException = ex;
			}
			
			if (testFails) 
			{
				testFailureExceptionList.add(new ZUKE_FeatureTestFailureException(this, scenario, caughtException));
			}
		}
		
		List<ZUKE_UnmatchableStepException> unmatchedStepExceptionList = ZUKE_StepListConversionHelper.getUnmatchedStepExceptionList(name);
		if ((unmatchedStepExceptionList != null) && (!unmatchedStepExceptionList.isEmpty()))
		{
			throw new ZUKE_UnmatchableStepsException(this, unmatchedStepExceptionList);	
		}
		
		if (!testFailureExceptionList.isEmpty())
		{
			throw new ZUKE_FeatureTestFailuresException(this, testFailureExceptionList);
		}

		return true;		
	}
	
	public static Boolean test(String staticResourceName)
	{
		return (new ZUKE_Feature(staticResourceName)).test(); 
	}
	
	// ---------------------------------------------------------------------------------------
	
	
	@testVisible private void convert (blob featureResourceBodyBlob)
	{
		featureAsString = featureResourceBodyBlob.toString();
		buildScenarioList();
	}
	
	@testVisible private void buildScenarioList()
	{
		if (String.isNotBlank(featureAsString))
		{ 
			Integer remainingScenarioCount = getScenarioCount();
			if (remainingScenarioCount > 0)
			{
				buildScenarioList(remainingScenarioCount);
			}
			else
			{
				throw new ZUKE_IncompleteFeatureException('Feature named "' + name + '" requires at least one Scenario. Feature As String =  ' + featureAsString);	
			} 
		}
		else
		{
			throw new ZUKE_IncompleteFeatureException('Feature named "' + name + '" must not be blank.');	
		} 
	}   
	
	@testVisible private void buildScenarioList(Integer remainingScenarioCount)
	{
		scenarioList = new List<ZUKE_Scenario>();
		String featureAsStringAux = featureAsString;
		while (remainingScenarioCount > 0)
		{
			String scenarioString = featureAsStringAux.subStringAfter(ZUKE_Scenario.SCENARIO_KEYWORD);	// Removes everything before first instance of keyword, inclusive
					
			if (remainingScenarioCount > 1)
			{
				featureAsStringAux = scenarioString;														// Copies remainder for future processing
				scenarioString   = scenarioString.subStringBefore(ZUKE_Scenario.SCENARIO_KEYWORD);		// Limits value to single scenario's String.
			}
			 
			addToScenarioList(scenarioString); 
			remainingScenarioCount--;
		}
	}
	
	@testVisible private virtual void addToScenarioList(String scenarioString)
	{
		scenarioList.add(new ZUKE_Scenario(this, scenarioString));
	}
	
	@testVisible private Integer getScenarioCount() { return featureAsString.countMatches(ZUKE_Scenario.SCENARIO_KEYWORD); } 
	
	
}