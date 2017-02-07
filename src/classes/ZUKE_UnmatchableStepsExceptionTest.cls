@isTest
public class ZUKE_UnmatchableStepsExceptionTest 
{
	private static final User TEST_RUN_USER = TEST_DummyUserFactory.createDefaultTestRunUser();
	
	@isTest private static void testGetUnmatchedStepExceptionList()
	{
		// GIVEN
		ZUKE_Feature 						dummyFeature	           		= new ZUKE_Feature('DummyFeature', null);
		List<ZUKE_UnmatchableStepException> dummyUnmatchedStepExceptionList = new List<ZUKE_UnmatchableStepException>
		{
			new ZUKE_UnmatchableStepException()
		};

		ZUKE_UnmatchableStepsException targetUnmatchableStepsException = new ZUKE_UnmatchableStepsException(dummyFeature, dummyUnmatchedStepExceptionList);

		// WHEN
		List<ZUKE_UnmatchableStepException> resultUnmatchedStepExceptionList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultUnmatchedStepExceptionList = targetUnmatchableStepsException.getUnmatchedStepExceptionList();
			}
		} 
		   
		// THEN
		System.assertEquals(dummyUnmatchedStepExceptionList, resultUnmatchedStepExceptionList); 
	}
	
	// -----------------------------------------------------------------------------------
	
	@isTest private static void testDebug()
	{
		// GIVEN
		ZUKE_Feature 						dummyFeature	           		= new ZUKE_Feature('DummyFeature', null);
		List<ZUKE_UnmatchableStepException> dummyUnmatchedStepExceptionList = new List<ZUKE_UnmatchableStepException>
		{
			new ZUKE_UnmatchableStepException()
		};

		ZUKE_UnmatchableStepsException targetUnmatchableStepsException = new ZUKE_UnmatchableStepsException(dummyFeature, dummyUnmatchedStepExceptionList);

		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				targetUnmatchableStepsException.debug();
			}
		} 
		   
		// THEN
		// There is NOTHING we can check for here. 
	}
}