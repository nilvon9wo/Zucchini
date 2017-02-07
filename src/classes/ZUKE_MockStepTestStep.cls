@isTest
public class ZUKE_MockStepTestStep implements ZUKE_Step
{
	@testVisible private final  String				DUMMY_TARGET_FEATURE_NAME  = 'DummyFeatureName';
	@testVisible private final  String 				DUMMY_STEP_AS_STRING	   = 'Dummy step string';
	@testVisible private final  ZUKE_StepTypeEnum 	DUMMY_STEP_TYPE 		   = ZUKE_StepTypeEnum.GIVEN_STEP;
	@testVisible private final  List<String>		DUMMY_MATCHABLE_REGEX_LIST = new List<String> { '^' + DUMMY_STEP_AS_STRING + '$' };
	
	private Boolean isInitialized = false; 
	@testVisible private Boolean isInitialized() { return isInitialized; } 
	
	public String getTargetFeatureName()			{ return DUMMY_TARGET_FEATURE_NAME;  }
	public String getStepAsString()					{ return DUMMY_STEP_AS_STRING; 		 }
	public ZUKE_StepTypeEnum getType()				{ return DUMMY_STEP_TYPE; 			 }
	public List<String> getMatchableRegexList()		{ return DUMMY_MATCHABLE_REGEX_LIST; }
	public void initialize(String stepAsString)		{ isInitialized = true;				 }
	public boolean test(ZUKE_Scenario scenario)		{ return true; 			 			 } 	
}