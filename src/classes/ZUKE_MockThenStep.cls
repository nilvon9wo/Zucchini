@isTest
public class ZUKE_MockThenStep implements ZUKE_Step
{
	@testVisible private final  String				DUMMY_TARGET_FEATURE_NAME  = 'DummyFeatureName';
		
	public String getTargetFeatureName()			{ return DUMMY_TARGET_FEATURE_NAME;  }
	public String getStepAsString()					{ return null;  }
	public ZUKE_StepTypeEnum getType()				{ return ZUKE_StepTypeEnum.THEN_STEP;  }
	public List<String> getMatchableRegexList()		{ return new List<String> { '^Then$' };  }
	public void initialize(String stepAsString)		{}
	public boolean test(ZUKE_Scenario scenario)		{ return null;  } 	
}