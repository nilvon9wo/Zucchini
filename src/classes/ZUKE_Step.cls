public interface ZUKE_Step 
{
	String getTargetFeatureName();
	String getStepAsString();
	ZUKE_StepTypeEnum getType();
	List<String> getMatchableRegexList();
	void initialize(String stepAsString);
	boolean test(ZUKE_Scenario scenario); 
}