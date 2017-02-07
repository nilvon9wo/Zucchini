@isTest
private class ZUKE_StepInitializeHelperTest 
{
	private static final User TEST_RUN_USER = TEST_DummyUserFactory.createDefaultTestRunUser();
	
	private static void testGetMatcher(Boolean hasMatch)
	{
		// GIVEN
		ZUKE_MockStepTestStep dummyStep 	    = new ZUKE_MockStepTestStep();
		String	  dummyStepAsString = (hasMatch) ? dummyStep.DUMMY_STEP_AS_STRING : 'Some other step'; 

		// WHEN
		Matcher resultMatcher   = null;
		Boolean exceptionCaught = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { resultMatcher = ZUKE_StepInitializeHelper.getMatcher(dummyStep,dummyStepAsString);  }
				catch (ZUKE_UnmatchableStepException ex) { exceptionCaught = true; }
			}
		} 
		   
		// THEN
		System.assertEquals(hasMatch, !exceptionCaught);
		System.assertEquals(hasMatch, resultMatcher != null);
	}
	
	@isTest private static void testGetMatcher_matchless() { testGetMatcher(false); }
	@isTest private static void testGetMatcher_matched()   { testGetMatcher(true); }
	
}