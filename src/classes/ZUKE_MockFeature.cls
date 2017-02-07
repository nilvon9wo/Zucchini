@isTest
public class ZUKE_MockFeature extends ZUKE_Feature  
{
	public ZUKE_MockFeature(String staticResourceName)
	{
		super(staticResourceName);
	}
	
	public ZUKE_MockFeature(String name, List<ZUKE_Scenario> scenarioList) 
	{ 
		super(name, scenarioList); 
	}
	
	@testVisible private override void addToScenarioList(String scenarioString)
	{
		scenarioList.add(new ZUKE_Scenario(scenarioString));
	}
}