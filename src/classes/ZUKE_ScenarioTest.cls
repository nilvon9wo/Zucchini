@isTest
public class ZUKE_ScenarioTest 
{
	private static final User 	TEST_RUN_USER  	   = TEST_DummyUserFactory.createDefaultTestRunUser();

	private static void testGetFirstStepKeyWord(String firstKeyword)
	{ 
		// GIVEN
		String 		  dummyScenarioAsString = 'Dummy name ' + firstKeyword + ' Dummy 1st Step';
		
		// WHEN
		String result 			= null;
		Boolean exceptionCaught = false;
		System.runAs(TEST_RUN_USER) 
		{
			Test.startTest();
			{
				try { result = (new ZUKE_Scenario(dummyScenarioAsString)).getFirstStepKeyWord(); }
				catch (ZUKE_IncompleteScenarioException e) { exceptionCaught = true; }
			}
		}
		
		// THEN
		Set<String> validFirstKeywordSet = new Set<String>{'Given', 'When'};
		Boolean exceptionExpected = !validFirstKeywordSet.contains(firstKeyword); 
		System.assertEquals (exceptionExpected, exceptionCaught);
		if (!exceptionExpected)
		{
			System.assertEquals (firstKeyword, result);
		}
	}
	
	@isTest private static void testGetFirstStepKeyWord_given() { testGetFirstStepKeyWord('Given'); }
	@isTest private static void testGetFirstStepKeyWord_when()  { testGetFirstStepKeyWord('When' ); }
	@isTest private static void testGetFirstStepKeyWord_then()  { testGetFirstStepKeyWord('Then' ); }
	@isTest private static void testGetFirstStepKeyWord_none()  { testGetFirstStepKeyWord(''     ); }

	// ----------------------------------------------------------------------------------------------

	private static void testSetName(Boolean containsNewline) 
	{ 
		// GIVEN
		String		  dummyName				= 'Dummy Name';
		String 		  dummyScenarioAsString = dummyName + (containsNewline ? '\n Some comments' : ' ') + 'Given Dummy 1st Step';
		
		ZUKE_Scenario targetScenario = new ZUKE_Scenario(dummyScenarioAsString);
		
		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				targetScenario.setName(dummyScenarioAsString);
			}
		}
		
		// THEN
		System.assertEquals (dummyName, targetScenario.name);
	} 
	
	@isTest private static void testSetName_noNewline()  { testSetName(false); }
	@isTest private static void testSetName_hasNewline() { testSetName(true ); }

	// ----------------------------------------------------------------------------------------------

	@isTest private static void testGetScenarioValuesbyNameMap()
	{
		//GIVEN
		String dummyKey    = 'Dummy Key';
		String dummyObject = 'Dummy Object';
		ZUKE_Scenario targetScenario = new ZUKE_Scenario(null); 
					  targetScenario.scenarioValuesbyNameMap 	= new Map<String, Object>
					  {
					  	dummyKey => dummyObject
					  };
					  
		// WHEN
		Map<String, Object> resultScenarioValuesbyNameMap = null; 	  
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultScenarioValuesbyNameMap = targetScenario.getScenarioValuesbyNameMap();
			}
		}
		
		// THEN
		System.assert(resultScenarioValuesbyNameMap.containsKey(dummyKey));
		System.assertEquals(dummyObject, resultScenarioValuesbyNameMap.get(dummyKey));
	}
	
	// ----------------------------------------------------------------------------------------------
	 
	private static void testTest(Boolean hasStep, Boolean testPasses)
	{ 
		// GIVEN
		String        dummyFeatureName = 'DummyFeature';
		ZUKE_Scenario targetScenario = new ZUKE_Scenario(null);
					  targetScenario.feature  = new ZUKE_Feature(dummyFeatureName, null);
					  targetScenario.stepList = new List<ZUKE_Step>();
		
		if (hasStep)
		{
			ZUKE_Step     mockStep       = new ZUKE_MockScenarioTestStep();
			((ZUKE_MockScenarioTestStep) mockStep).result = testPasses;
			targetScenario.stepList.add(mockStep);
		}
		
		// WHEN
		Boolean result           = false;
		Boolean exceptionCaught  = false;
		String  exceptionMessage = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { result = targetScenario.test(); }
				catch (ZUKE_ScenarioTestFailureException ex)
				{
					exceptionCaught  = true;
					exceptionMessage = ex.getMessage(); 
				}
			}
		}
		
		// THEN
		Boolean exceptionExpected = (testPasses == null);
		Boolean expectedResult = (!hasStep) || ((testPasses != null) && testPasses);
		if (expectedResult == true) { System.assert(result); }
		else
		{
			System.assert(exceptionCaught);
			Set<String> expectedStringSet = new Set<String>
			{
				'Failure executing test ',
				dummyFeatureName,
				targetScenario.stepList[0].getStepAsString()
			};
			if (exceptionExpected) { expectedStringSet.add('ZUKE_AssertException'); }
			TEST_AssertHelper.resultContainsAll (expectedStringSet, exceptionMessage);
		}
		
	} 


	@isTest private static void testTest_noStep()        { testTest(false, false); }
	@isTest private static void testTest_failingStep()   { testTest(true,  false); }
	@isTest private static void testTest_passingStep()   { testTest(true,  true ); }
	@isTest private static void testTest_exceptingStep() { testTest(true,  null ); }

	// ----------------------------------------------------------------------------------------------

	@isTest private static void testConstructor()
	{
		// GIVEN
		String       dummyFeatureName	   = 'DummyFeature';
		ZUKE_Feature dummyFeature 		   = new ZUKE_Feature(dummyFeatureName, null);
		
		String		 dummyScenarioName	   = 'Dummy Scenario';
		String 		 dummyGivenStep 	   = 'Dummy Assumption Step';
		String 		 dummyWhenStep 		   = 'Dummy Action Step';
		String 		 dummyThenStep 		   = 'Dummy Assertion Step';
		String		 dummyScenarioAsString = dummyScenarioName + '\n'
												+ 'Some Comment\n'
										   		+ 'Given ' + dummyGivenStep + '\n'
										   		+ 'When '  + dummyWhenStep + '\n'
										   		+ 'Then '  + dummyThenStep + '\n';
										   		
		ZUKE_MockGivenStep mockGivenStep = new ZUKE_MockGivenStep();
		ZUKE_MockWhenStep  mockWhenStep  = new ZUKE_MockWhenStep();
		ZUKE_MockThenStep  mockThenStep  = new ZUKE_MockThenStep();
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			(dummyFeatureName + '::' + String.valueOf(ZUKE_StepTypeEnum.GIVEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				'^' + dummyGivenStep + '$' => mockGivenStep 
			},
			(dummyFeatureName + '::' + String.valueOf(ZUKE_StepTypeEnum.WHEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				'^' + dummyWhenStep + '$'  => mockWhenStep 
			},
			(dummyFeatureName + '::' + String.valueOf(ZUKE_StepTypeEnum.THEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				'^' + dummyThenStep + '$'  => mockThenStep 
			}
		};
										   			
		// WHEN
		ZUKE_Scenario resultScenario = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultScenario = new ZUKE_Scenario(dummyFeature, dummyScenarioAsString);		
			}
		}
		
		// THEN
		System.assertEquals(dummyFeature, 				  resultScenario.feature);
		System.assertEquals(dummyScenarioAsString, 		  resultScenario.scenarioAsString);
		System.assertEquals(dummyScenarioName, 			  resultScenario.name);
		
		System.assertEquals(3,                      	  resultScenario.stepList.size());
		ZUKE_AssertHelper.assertInstanceOf(mockGivenStep, resultScenario.stepList[0]);
		ZUKE_AssertHelper.assertInstanceOf(mockWhenStep,  resultScenario.stepList[1]);
		ZUKE_AssertHelper.assertInstanceOf(mockThenStep,  resultScenario.stepList[2]);
	}
}