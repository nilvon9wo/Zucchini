public virtual class ZUKE_StepDao 
{
	private static final Set<String> EXCLUDED_CLASS_SET = new Set<String>{ 'ZUKE_Step' };
	
	// ---------------------------------------------------	
	
	public virtual List<ZUKE_Step> getList() 
	{
		List<ApexClass> stepClassList = [SELECT name FROM ApexClass WHERE Name LIKE '%Step' AND Name NOT IN :EXCLUDED_CLASS_SET ];
		return buildStepList(stepClassList);
	}
	
	@testVisible private static List<ZUKE_Step> buildStepList(List<ApexClass> stepClassList)
	{
		List<ZUKE_Step> stepList = new List<ZUKE_Step>(); 
		for (ApexClass stepClass : stepClassList)
		{
			try { stepList.add(get(stepClass.name)); }
			catch (Exception e) 						// Classes which can't be cast ZUKE_Step will be ignored. 
			{ 
				System.debug(LoggingLevel.WARN, 'Class \'' + stepClass + '\' can not be cast to ZUKE_Step.'); 
			}
		}
		return stepList;
	}
	
	public static ZUKE_Step get(String stepClassName)
	{
		Type stepClassType = Type.forName(stepClassName);
		
		ZUKE_Step step          = (ZUKE_Step) stepClassType.newInstance();
		   return step;
	}
}