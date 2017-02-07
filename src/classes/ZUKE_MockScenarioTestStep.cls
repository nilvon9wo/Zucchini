@isTest
public class ZUKE_MockScenarioTestStep implements ZUKE_Step
{
	@testVisible private final  String				DUMMY_TARGET_FEATURE_NAME  = 'DummyFeatureName';
		
	@testVisible private Boolean result = null;
		
	public String getTargetFeatureName()			{ return DUMMY_TARGET_FEATURE_NAME;  }
	public String getStepAsString()					{ return 'Mock Scenario Test Step String';  }
	public ZUKE_StepTypeEnum getType()				{ return ZUKE_StepTypeEnum.GIVEN_STEP;  }
	public List<String> getMatchableRegexList()		{ return new List<String> { '^ZUKE_MockScenarioTestStep' };  }
	public void initialize(String stepAsString)		{}
	
	public boolean test(ZUKE_Scenario scenario)		
	{ 
		if (result == null) { throw new ZUKE_AssertException(); }
		return result;  
	} 	
}