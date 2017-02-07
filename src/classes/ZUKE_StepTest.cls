@isTest
public class ZUKE_StepTest 
{
	private static final User 			    TEST_RUN_USER   = TEST_DummyUserFactory.createDefaultTestRunUser();
	private static final ZUKE_MockStepTestStep TARGET_STEP		= new ZUKE_MockStepTestStep();
	
	@isTest private static void testGetTargetFeatureName() 				  					  				
	{
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = TARGET_STEP.getTargetFeatureName();
			}
		}
		
		// THEN
		System.assertEquals(TARGET_STEP.DUMMY_TARGET_FEATURE_NAME, result); 
	} 
	
	@isTest private static void testGetStepAsString() 				  					  				
	{
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = TARGET_STEP.getStepAsString();
			}
		}
		
		// THEN
		System.assertEquals(TARGET_STEP.DUMMY_STEP_AS_STRING, result);
	}
	
	@isTest private static void testGetType() 				  					  				
	{
		// WHEN
		ZUKE_StepTypeEnum result = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = TARGET_STEP.getType();
			}
		}
		
		// THEN
		System.assertEquals(TARGET_STEP.DUMMY_STEP_TYPE, result);
	}
	
	@isTest private static void testGetMatchableRegexList() 				  					  				
	{
		// WHEN
		List<String> resultList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultList = TARGET_STEP.getMatchableRegexList();
			}
		}
		
		// THEN
		System.assertEquals(TARGET_STEP.DUMMY_MATCHABLE_REGEX_LIST[0], resultList[0]);
	}

	@isTest private static void testInitialize() 				  					  				
	{
		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				TARGET_STEP.initialize(null);
			}
		}
		
		// THEN
		System.assert(TARGET_STEP.isInitialized());
	}

	@isTest private static void testTest() 				  					  				
	{
		// WHEN
		Boolean result = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = TARGET_STEP.test(null);
			}
		}
		
		// THEN
		System.assert(result);
	}

	
}