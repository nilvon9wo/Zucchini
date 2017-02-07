@isTest
public class ZUKE_MockFeatureTestScenario extends ZUKE_Scenario  
{
	@testVisible private ZUKE_MockFeatureTestScenario(String scenarioAsString)
	{
		super(scenarioAsString);
	}

	@testVisible private Boolean result = null;
	
	public override boolean test()		
	{ 
		if (result == null) { throw new ZUKE_AssertException(); }
		return result;  
	} 	 
}