@isTest
private class ZUKE_FeatureTest 
{
	private static final User 	TEST_RUN_USER = TEST_DummyUserFactory.createDefaultTestRunUser();

	@isTest private static void testGetName()
	{ 
		// GIVEN
		String 	     dummyName     = 'DummyFeature';
		ZUKE_Feature targetFeature = new ZUKE_Feature(dummyName, null);
		
		// WHEN
		String resultName = null;
		System.runAs(TEST_RUN_USER)
			{
			Test.startTest();
			{
				resultName = targetFeature.getName();
			}
		}
		
		// THEN
		System.assertEquals(dummyName, resultName);
	}
	
	// -----------------------------------------------------------
	
	private static void testGetScenarioCount(Integer scenarioCount)
	{ 
		// GIVEN
		String dummyFeatureString = createDummyFeatureString(scenarioCount, 'Dummy Scenario as String ');

		ZUKE_Feature targetFeature = new ZUKE_Feature('DummyFeature', null);
					 targetFeature.featureAsString = dummyFeatureString; 
		
		// WHEN
		Integer resultCount = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultCount = targetFeature.getScenarioCount();
			}
		}
		
		// THEN
		System.assertEquals(scenarioCount, resultCount);
	}
	@isTest private static void testGetScenarioCount_0() { testGetScenarioCount(0); }
	@isTest private static void testGetScenarioCount_1() { testGetScenarioCount(1); }
	@isTest private static void testGetScenarioCount_2() { testGetScenarioCount(2); }

	// -----------------------------------------------------------
	
	@isTest private static void testAddToScenarioList()
	{ 
		// GIVEN
		String       dummyFeatureName	   = 'DummyFeature';
		ZUKE_Feature dummyFeature 		   = new ZUKE_Feature(dummyFeatureName, null);
					 dummyFeature.scenarioList = new List<ZUKE_Scenario>();
	
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
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				dummyFeature.addToScenarioList(dummyScenarioAsString);
			}
	}
	
		// THEN
		ZUKE_Scenario resultScenario = dummyFeature.scenarioList[0];
		System.assertEquals(dummyFeature, 				  resultScenario.feature);
		System.assertEquals(dummyScenarioAsString, 		  resultScenario.scenarioAsString);
		System.assertEquals(dummyScenarioName, 			  resultScenario.name);
		
		System.assertEquals(3,                      	  resultScenario.stepList.size());
		ZUKE_AssertHelper.assertInstanceOf(mockGivenStep, resultScenario.stepList[0]);
		ZUKE_AssertHelper.assertInstanceOf(mockWhenStep,  resultScenario.stepList[1]);
		ZUKE_AssertHelper.assertInstanceOf(mockThenStep,  resultScenario.stepList[2]);
	}
	
	// -----------------------------------------------------------

	private static void testBuildScenarioList_withCount(Integer scenarioCount)
	{ 
		// GIVEN
		String dummyScenarioTest  = 'Dummy Scenario as String ';
		String dummyFeatureString = createDummyFeatureString(scenarioCount, dummyScenarioTest);

		ZUKE_MockFeature targetFeature = new ZUKE_MockFeature('DummyFeature', null);
					 targetFeature.featureAsString = dummyFeatureString; 
		
		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				targetFeature.buildScenarioList(scenarioCount);
			}
		}
		
		// THEN
		System.assertEquals(scenarioCount, targetFeature.scenarioList.size());
		if (scenarioCount > 0)
		{
			System.assertEquals(scenarioCount, targetFeature.scenarioList.size());
			for (Integer i=1; i<=scenarioCount; i++)
			{
				System.assertEquals((dummyScenarioTest+i).trim(), (targetFeature.scenarioList[i-1].getScenarioAsString()).trim());
			}
		}
	}
	
	@isTest private static void testBuildScenarioList_withCount_0() { testBuildScenarioList_withCount(0); }
	@isTest private static void testBuildScenarioList_withCount_1() { testBuildScenarioList_withCount(1); }
	@isTest private static void testBuildScenarioList_withCount_2() { testBuildScenarioList_withCount(2); }
	
	// -----------------------------------------------------------

	private static void testBuildScenarioList(Boolean hasFeatureContents, Boolean hasScenario)
	{ 
		// GIVEN
		String dummyScenarioTest  = 'Dummy Scenario as String ';
		String dummyFeatureString = (hasFeatureContents) 
										? createDummyFeatureString((hasScenario) ? 1 : 0, dummyScenarioTest)
										: null;

		String dummyFeatureName = 'DummyFeature';
		ZUKE_MockFeature targetFeature = new ZUKE_MockFeature(dummyFeatureName, null);
					 targetFeature.featureAsString = dummyFeatureString; 
		
		// WHEN
		Boolean exceptionCaught  = false;
		String  exceptionMessage = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { targetFeature.buildScenarioList(); }
				catch (ZUKE_IncompleteFeatureException ex)
				{
					exceptionCaught  = true;
					exceptionMessage = ex.getMessage();
				}
			}
		}
		
		// THEN
		System.assertEquals(hasFeatureContents && hasScenario, !exceptionCaught);
		if (hasScenario)
		{
			System.assertEquals(1, targetFeature.scenarioList.size());
			System.assertEquals((dummyScenarioTest+1).trim(), (targetFeature.scenarioList[0].getScenarioAsString()).trim());
		}
		else
		{
			String expectedMessage = 'Feature named "' + dummyFeatureName + '" ' 
										+ ( 
											(hasFeatureContents)
												? 'requires at least one Scenario.'
												: 'must not be blank.'
										  );
			System.assert(exceptionMessage.contains(expectedMessage));
		}
	}

	@isTest private static void testBuildScenarioList_noContents()  { testBuildScenarioList(false, false); }
	@isTest private static void testBuildScenarioList_noScenario()  { testBuildScenarioList(true,  false); }
	@isTest private static void testBuildScenarioList_hasScenario() { testBuildScenarioList(true,  true ); }

	// -----------------------------------------------------------

	@isTest private static void testConvert()
	{ 
		// GIVEN
		String dummyScenarioTest  = 'Dummy Scenario as String ';
		String dummyFeatureString = createDummyFeatureString(1, dummyScenarioTest);
		Blob   dummyFeatureBlob   = Blob.valueOf(dummyFeatureString);

		String dummyFeatureName = 'DummyFeature';
		ZUKE_MockFeature targetFeature = new ZUKE_MockFeature(dummyFeatureName, null);
		
		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				targetFeature.convert(dummyFeatureBlob);
	}
		}
		
		// THEN
		System.assertEquals(1, targetFeature.scenarioList.size());
		System.assertEquals((dummyScenarioTest+1).trim(), (targetFeature.scenarioList[0].getScenarioAsString()).trim());
	}
	
	// -----------------------------------------------------------

	@isTest private static void testConstructor_staticResource()
	{ 
		// GIVEN
		String dummyScenarioTest  = 'Dummy Scenario as String ';
		String dummyFeatureString = createDummyFeatureString(1, dummyScenarioTest);
		
		MockStaticResourceDao1 mockStaticResourceDao = new MockStaticResourceDao1();
							  mockStaticResourceDao.dummyBodyBlob = Blob.valueOf(dummyFeatureString);

		ZUKE_Feature.staticResourceDao = mockStaticResourceDao;

		String dummyFeatureName = 'DummyFeature';

		// WHEN
		ZUKE_Feature resultFeature = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultFeature = new ZUKE_MockFeature(dummyFeatureName); 
			}
		}
		
		// THEN
		System.assertEquals(1, resultFeature.scenarioList.size());
		System.assertEquals((dummyScenarioTest+1).trim(), (resultFeature.scenarioList[0].getScenarioAsString()).trim());
	}

	// -----------------------------------------------------------

	private static void testTest(Boolean testPasses)
	{ 
		// GIVEN
		String       dummyFeatureName = 'DummyFeature';
		
		ZUKE_MockFeatureTestScenario mockScenario = new ZUKE_MockFeatureTestScenario(null);
									  mockScenario.result = testPasses;
		
		ZUKE_Feature targetFeature 		        = new ZUKE_Feature(dummyFeatureName, null);
					 targetFeature.scenarioList = new List<ZUKE_Scenario>{ mockScenario };
		
		// WHEN
		Boolean result           = false;
		List<ZUKE_FeatureTestFailureException> resultFailureExceptionList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { result = targetFeature.test(); } 
				catch (ZUKE_FeatureTestFailuresException ex) { resultFailureExceptionList = ex.getTestFailureExceptionList(); }
			}
		}
		
		// THEN
		Boolean exceptionExpected = (testPasses == null);
		Boolean expectedResult = ((testPasses != null) && testPasses);
		if (expectedResult == true) { System.assert(result); }
		else
		{
		    Boolean exceptionCaught = !resultFailureExceptionList.isEmpty();
			System.assert(exceptionCaught);
			Set<String> expectedStringSet = new Set<String>
			{
				'Failure executing test ',
				dummyFeatureName
			};
			
			String exceptionMessage = resultFailureExceptionList[0].getMessage();
			if (exceptionExpected) { expectedStringSet.add('ZUKE_AssertException'); }
			TEST_AssertHelper.resultContainsAll (expectedStringSet, exceptionMessage);
		}
		
	} 

	@isTest private static void testTest_failingScenario()   { testTest(false); }
	@isTest private static void testTest_passingScenario()   { testTest(true ); }
	@isTest private static void testTest_exceptingScenario() { testTest(null ); }
	
	// -----------------------------------------------------------
	
	@isTest private static void testTest_string()
	{ 
		// GIVEN
		String       dummyFeatureName = 'DummyFeature';
		ZUKE_Feature.staticResourceDao = new MockStaticResourceDao2();
		
		// WHEN
		Boolean result			= false;
		Boolean exceptionCaught = false;
		Integer unmatchedSteps  = 0;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { result = ZUKE_Feature.test(dummyFeatureName); }
				catch (ZUKE_UnmatchableStepsException ex) 
				{ 
					exceptionCaught = true;
					unmatchedSteps = ex.getUnmatchedStepExceptionList().size(); 
				}  
			}
		} 
		   
		// THEN 
		System.assert (exceptionCaught); 
		System.assertEquals (2, unmatchedSteps);
	}
	
	// -----------------------------------------------------------
	
	private static String createDummyFeatureString(Integer scenarioCount, String dummyScenarioText)
	{
		String dummyFeatureString = 'Dummy Comments \n';
		if (scenarioCount > 0)
		{
			for (Integer i=1; i<=scenarioCount; i++)
			{
				 dummyFeatureString += ZUKE_Scenario.SCENARIO_KEYWORD + dummyScenarioText + i + '\n';
			}
		}
		return dummyFeatureString;		
	}

	// -----------------------------------------------------------

	private class MockStaticResourceDao1 extends ZUKE_StaticResourceDao 
	{
		Blob dummyBodyBlob = null;

		public override StaticResource get(String staticResourceName)
		{
			return new StaticResource(
							name = staticResourceName,
							body = dummyBodyBlob
						);
		}
	}

	// ------------------------------------------------------------------------------------------------------

	private class MockStaticResourceDao2 extends ZUKE_StaticResourceDao 
	{
		String dummyScenarioTest  = 'Dummy Scenario as String ';
		String dummyFeatureString = ZUKE_Scenario.SCENARIO_KEYWORD + 'Dummy Scenario\n'  
								    + 'When I do a dummy action step\n'
									+ 'Then I get a dummy assertion result step';
		
		Blob dummyBodyBlob = Blob.valueOf(dummyFeatureString);

		public override StaticResource get(String staticResourceName)
		{
			return new StaticResource(
							name = staticResourceName,
							body = dummyBodyBlob
						);
		}
	}


}