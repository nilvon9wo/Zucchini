@isTest
private class ZUKE_UnimplementedStepExceptionTest 
{
	private static final User TEST_RUN_USER = TEST_DummyUserFactory.createDefaultTestRunUser();
	
	@isTest private static void testConstructor()
	{
		// GIVEN
		ZUKE_Step dummyStep 	  = new ZUKE_MockStepTestStep();
		String	  dummyMethodName = 'DummyMethodName'; 

		// WHEN
		String exceptionMessage = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { throw new ZUKE_UnimplementedStepException(dummyStep, dummyMethodName);   }
				catch (ZUKE_UnimplementedStepException ex) { exceptionMessage = ex.getMessage(); }
			}
		} 
		   
		// THEN
		Set<String> expectedStringSet = new Set<String>{'ZUKE_MockStepTestStep', dummyMethodName}; 
		TEST_AssertHelper.resultContainsAll(expectedStringSet, exceptionMessage);
	}
}