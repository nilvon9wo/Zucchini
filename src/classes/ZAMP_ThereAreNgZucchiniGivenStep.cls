/**
 *  This is a template to help test the "ZAMP_ZucchiniConsumptionFeature" feature.
 *  Specifically, it is to help test the step described by "There are 12 zucchini".
 *
 *  To use it, you must copy it to your Apex classes and make appropriate modifications.
 **/
/**
 *  This class CAN be renamed, 
 *  BUT the name must end in "Step"
 *  AND the class must implement ZUKE_Step.
 **/
@isTest
public class ZAMP_ThereAreNgZucchiniGivenStep implements ZUKE_Step
{
	// Custom instance variables, needed only for this step
	Integer originalNumberOfZucchini = null;

	/**
	 *  This method must return a value identical to the name of the corresponding static-resource feature-file.
	 *
	 *  The default return already matches the name of the resource at the time this file was created.
	 **/
	// @return String the feature name
	public String getTargetFeatureName() { return 'ZAMP_ZucchiniConsumptionFeature'; }


	/**
	 *  This method returns the value of stepAsString, mostly to be used for diagnostic purposes.
	 *
	 *  By default, this will be set in the initialize() method, allowing the value to be dynamic.
 	 **/
	private String stepAsString;
	public String getStepAsString() { return stepAsString; }


	/**
	 *  This method returns the step type, as indicated by a keyword within the scenario, preceding the step.
	 *
	 *  Zucchini does NOT do anything with this value,
	 *  but you SHOULD [at least consider it] when you create the test() implementation.
 	 **/
	// @return ZUKE_StepTypeEnum the step type
	public ZUKE_StepTypeEnum getType() { return ZUKE_StepTypeEnum.GIVEN_STEP; }


	/**
	 *  This method returns a list of regex expressions which will be used to match the step-As-String to this Step Class.
	 *
	 *  By default, this method returns only one string literal value, derived from the feature file.
	 *  BUT you should replace the literal value with an appropriate regex expression,
	 *  enabling this Step class to be recycled in different, yet reasonably similiar, scenarios.
	 *
	 *  In addition to changing the string literal to something more flexible,
	 *  you can ALSO include additional expressions which should be interpreted to mean the same thing.
	 **/
	// @return List<String> the list of regular expresions which can be used to invoke this Step.
	public List<String> getMatchableRegexList()
	{
		return new List<String>
		{
			// Original: '^There are 12 zucchini$'
			'^There are (\\d+) zucchini$',
			'^We have (\\d+) cucumber-like vegetables'
		};
	}

	/**
	 *  This method MUST prepare the Step instance for test execution.
	 *
	 *  If the expression "There are 12 zucchini" includes dynamic values,
	 *  you must inform SFDC/Zucchini how to extract and where to store them.
	 *
	 *  By default, this method will set the "stepAsString" value and then throw an exception.
 	 *  You MUST modify this method before Zucchini can process this Step.
	 **/
	public void initialize(String stepAsString)
	{
		this.stepAsString = stepAsString;
		
		Matcher matcher = ZUKE_StepInitializeHelper.getMatcher(this, stepAsString);
		this.originalNumberOfZucchini = Integer.valueOf(matcher.group(1)); 
	}


	/**
	 *  This method MUST implement the actual test to be executed.
	 *
	 *  If your step-as-string included dynamic values,
	 *  they should have already been extracted and stored during the initialize(String stepAsString) execution.
	 *
	 *  If your step requires communication with previous or following steps within the scenario,
	 *  you can (should) store and retrieve values from the scenarioValuesbyNameMap.
	 *
	 *  If the step fails for any reason, you should return false.
	 *  If the step throws almost any exception,
	 *  it will be caught and handled as if you returned false.
	 *
	 *  IMPORTANT NOTE: System.AssertionException is immediately FATAL and can NOT be caught.
	 *  As such, it can not be caught and handled and no further tests on the same Feature will execute.
	 *  To avoid such errors, you can implement your own comparison logic,
	 *  and (if appropriate) throw a ZUKE_AssetException instead.
	 **/
	 
	// @return Boolean does the step pass any and all tests?
	public  boolean test(ZUKE_Scenario scenario)
	{
		// Check that the instance has an acceptable value; otherwise fail the test.
		if (originalNumberOfZucchini < 0) 
		{ 
			throw new ZUKE_AssertException('The original number of Zucchini must be a natural number (i.e. a non-negative integer).'); 
		}

		// Create the Zucchini required for this test
		List<Zucchini__c> dummyZucchiniList = ZAMP_DummyZucchiniFactory.createList(originalNumberOfZucchini, TEST_DummyInsertModeEnum.REAL);
				
		// Save our variables so the other steps can get to then:
		Map<String, Object> scenarioValuesbyNameMap = scenario.getScenarioValuesbyNameMap(); 
							scenarioValuesbyNameMap.put('originalNumberOfZucchini', originalNumberOfZucchini);
		
		// If we want to keep it as a list, we need to create a Cache for it and somewhere to put it.
							scenarioValuesByNameMap.put('zucchiniCache', new ZAMP_ZucchiniTestingCache(dummyZucchiniList));
		
		return true;
	}



}