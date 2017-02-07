@isTest
public class ZUKE_StepDaoTest 
{
	private static final User TEST_RUN_USER   = TEST_DummyUserFactory.createDefaultTestRunUser();
	
	@isTest private static void testGet() 
	{
		// GIVEN
		String dummyStepClassName = 'ZUKE_MockStepTestStep';
		 
		// WHEN
		ZUKE_Step resultStep = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStep = ZUKE_StepDao.get(dummyStepClassName);
			}
		}
		
		// THEN
		System.assert(resultStep instanceOf ZUKE_MockStepTestStep);  
	}
	
	// -----------------------------------------------------------------------
	
	private static void buildStepList(Boolean canBeCast)
	{
		// GIVEN
		String    dummyStepClassName = (canBeCast) ? 'ZUKE_MockStepTestStep' : 'InvalidStep';
		ApexClass dummyApexClass     = new ApexClass (name = dummyStepClassName);
		 
		// WHEN
		List<ZUKE_Step> resultStepList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepList = ZUKE_StepDao.buildStepList(new List<ApexClass>{ dummyApexClass });
			}
		}
		
		// THEN
		System.assertEquals ((canBeCast)?1:0, resultStepList.size());
		if (canBeCast) { System.assert(resultStepList[0] instanceOf ZUKE_MockStepTestStep); }  
	}

	@isTest private static void buildStepList_cantBeCast() { buildStepList(false); }
	@isTest private static void buildStepList_canBeCast()  { buildStepList(true);  }
	
	// -----------------------------------------------------------------------
	
	@isTest private static void testGetList() 
	{
		// WHEN
		List<ZUKE_Step> resultStepList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepList = (new ZUKE_StepDao()).getList();
			}
		}
		
		// THEN
		Boolean includesTestDummyStep = false;
		Boolean includesStepInterface = false;
		
		for (ZUKE_Step step : resultStepList)
		{
			String className = UTIL_ClassHelper.getName(step);
			if (className == 'ZUKE_MockStepTestStep') { includesTestDummyStep = true; } 
			if (className == 'ZUKE_Step') 		   { includesStepInterface = true; } 
		}
		  
		System.assert(includesTestDummyStep);
		System.assert(!includesStepInterface);
	}
}