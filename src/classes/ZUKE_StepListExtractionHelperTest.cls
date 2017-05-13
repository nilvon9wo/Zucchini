@isTest
public class ZUKE_StepListExtractionHelperTest 
{
	private static final User 	TEST_RUN_USER  	   = TEST_DummyUserFactory.createDefaultTestRunUser();

	@isTest private static void testThrowMalformedScenerioException() 
	{
		// GIVEN
		String dummyErrorMessage = 'Dummy Error Message';
		String dummyScenario     = 'DummyScenario';
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(dummyScenario);
		
		// WHEN
		Boolean exceptionCaught = false;
		String  exceptionMessage = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { targetExtractionHelper.throwMalformedScenerioException(dummyErrorMessage); }
				catch (ZUKE_MalformedScenarioException e)
				{
					exceptionCaught  = true;
					exceptionMessage = e.getMessage(); 
				}
			}
		}
		
		// THEN
		System.assert (exceptionCaught);

		Set<String> expectedStringSet = new Set<String>{ dummyErrorMessage, dummyScenario };
		TEST_AssertHelper.resultContainsAll(expectedStringSet, exceptionMessage);
	}
	
	// --------------------------------------------------------------------------------------------------------------------	

	private static void testValidateKeywordCount(Boolean isRequired, Integer matchCount) 
	{
		// GIVEN
		String dummyKeyword = 'Dummy';
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		Boolean exceptionCaught  = false;
		String  exceptionMessage = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { targetExtractionHelper.validateKeywordCount (dummyKeyword, isRequired, matchCount); }
				catch (ZUKE_MalformedScenarioException e)
				{
					exceptionCaught  = true;
					exceptionMessage = e.getMessage();
				}
			}
		}
		
		// THEN
		Boolean exceptionExpected = ((matchCount == 0) && isRequired) || (matchCount > 1);
		System.assertEquals(exceptionExpected, exceptionCaught);
		if (exceptionExpected)
		{
			String expectedMessage = (matchCount > 1)
											? ('Scenario must NOT use keyword "' +  dummyKeyword  + '" more than once. ')
											: ('Scenario must use keyword "' +  dummyKeyword  + '" EXACTLY once. ');
			System.assert(exceptionMessage.contains(expectedMessage));
		}
	}
	
	@isTest private static void testValidateKeywordCount_notRequired_0() { testValidateKeywordCount(false, 0); }
	@isTest private static void testValidateKeywordCount_notRequired_1() { testValidateKeywordCount(false, 1); }
	@isTest private static void testValidateKeywordCount_notRequired_2() { testValidateKeywordCount(false, 2); }
	@isTest private static void testValidateKeywordCount_required_0()    { testValidateKeywordCount(true,  0); }
	@isTest private static void testValidateKeywordCount_required_1()    { testValidateKeywordCount(true,  1); }
	@isTest private static void testValidateKeywordCount_required_2()    { testValidateKeywordCount(true,  2); }
	
	// --------------------------------------------------------------------------------------------------------------------	

	private static void testCheckForKeywordAbuse(Boolean hasForbiddenSet, Boolean containsForbidden, Boolean hasNextKeyword) 
	{
		// GIVEN
		String		dummyForbiddenKeyWord	 = null;
		Set<String> dummyForbiddenKeywordSet = new Set<String>();
		if (hasForbiddenSet) 
		{ 
			dummyForbiddenKeyWord	 = 'Forbidden';
			dummyForbiddenKeywordSet.add(dummyForbiddenKeyWord);
		}

		String 		dummyStepsAsString       = (containsForbidden) ? ('This ' + dummyForbiddenKeyWord + ' is in this step') : 'Okay step'; 
		String 		dummyTargetKeyword       = 'Dummy Target';
		String 		dummyNextKeyword	     = (hasNextKeyword)    ? 'Dummy Next' : null;
		
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		Boolean exceptionCaught  = false;
		String  exceptionMessage = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { targetExtractionHelper.checkForKeywordAbuse(dummyStepsAsString, dummyTargetKeyword, dummyNextKeyword, dummyForbiddenKeywordSet); }
				catch (ZUKE_MalformedScenarioException e)
				{
					exceptionCaught  = true;
					exceptionMessage = e.getMessage();
				}
			}
		}
		
		// THEN
		Boolean exceptionExpected = hasForbiddenSet && containsForbidden;
		System.assertEquals(exceptionExpected, exceptionCaught);
		if (exceptionExpected)
		{
			Set<String> expectedStringSet = new Set<String>{ 'It is forbidden to use keyword "' + dummyForbiddenKeyWord  + '" after "' +  dummyTargetKeyword + '"' };
			if (hasNextKeyword) { expectedStringSet.add(' and before "' + dummyNextKeyword + '"'); }
			TEST_AssertHelper.resultContainsAll(expectedStringSet, exceptionMessage);
		}
	}
	
	@isTest private static void testCheckForKeywordAbuse_nothingForbidden()      				{ testCheckForKeywordAbuse(false, false, false); }
	@isTest private static void testCheckForKeywordAbuse_forbiddenNotContained() 				{ testCheckForKeywordAbuse(true,  false, false); }
	@isTest private static void testCheckForKeywordAbuse_forbiddenContained_noNextKeyword()    	{ testCheckForKeywordAbuse(true,  true,  false); }
	@isTest private static void testCheckForKeywordAbuse_forbiddenContained_beforeNextKeyword() { testCheckForKeywordAbuse(true,  true,  true ); }

	// --------------------------------------------------------------------------------------------------------------------	

	private static void testExtractStepsAsString(Integer numberOfTargetKeywordMatches, Boolean isRequired, Boolean hasNextKeyword, Boolean containsNextKeyword, Boolean containsForbiddenWord) 
	{
		// GIVEN
		String  	dummyTargetKeyword 		  = 'Target';
		String  	dummyNextKeyword   		  = (hasNextKeyword) ? 'Next' : null;
		
		String		dummyForbiddenKeyword     = 'Forbidden';
		Set<String> dummyForbiddenKeywordSet  = new Set<String>{dummyForbiddenKeyword};

		String 	    dummyStepAsString	      = 'Dummy Step';
		String 		dummyScenarioString       = createDummyScenario(
													dummyTargetKeyword, numberOfTargetKeywordMatches,
													dummyStepAsString,
													dummyForbiddenKeyword, containsForbiddenWord, 
													dummyNextKeyword, hasNextKeyword, containsNextKeyword
												 );

		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(dummyScenarioString);
		
		// WHEN
		String  resultStepAsString = null;
		Boolean exceptionCaught    = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { resultStepAsString = targetExtractionHelper.extractStepsAsString(dummyTargetKeyword, isRequired, dummyNextKeyword, dummyForbiddenKeywordSet); }
				catch (ZUKE_MalformedScenarioException e) 
				{ 
					exceptionCaught = true; 
				}
			}
		}
		
		// THEN
		Boolean exceptionExpected = (((numberOfTargetKeywordMatches == 0) && isRequired) || (numberOfTargetKeywordMatches == 2) || containsForbiddenWord);
		System.assertEquals (exceptionExpected, exceptionCaught);
		
		if (!exceptionExpected)
		{
			String dummyExpectedStep = (numberOfTargetKeywordMatches == 1)
										? dummyStepAsString
										: null; 
			System.assertEquals (dummyExpectedStep, resultStepAsString); 
		}
	}
	
	private static String createDummyScenario(
												String dummyTargetKeyword, Integer numberOfTargetKeywordMatches,
												String dummyStepAsString,
												String dummyForbiddenKeyword, Boolean containsForbiddenWord, 
												String dummyNextKeyword, Boolean hasNextKeyword, Boolean containsNextKeyword
											 )
	{
		String      dummyScenarioString = 'Dummy Scenario';
		if (numberOfTargetKeywordMatches > 0)
		{
			for (Integer i = 1; i <= numberOfTargetKeywordMatches; i++) { dummyScenarioString += dummyTargetKeyword + ' ';    }
		}															
																	  	  dummyScenarioString += dummyStepAsString;
		if (containsForbiddenWord) 				   						{ dummyScenarioString += dummyForbiddenKeyword + ' '; }
		if (hasNextKeyword && containsNextKeyword) 						{ dummyScenarioString += dummyNextKeyword + ' '; 	  }
		return dummyScenarioString;
	}

	@isTest private static void testExtractStepsAsString_targetNotMatchedAndNotRequired() 		   { testExtractStepsAsString(0, false, false, false, false); }
	@isTest private static void testExtractStepsAsString_targetNotMatchedAndRequired() 		 	   { testExtractStepsAsString(0, true , false, false, false); }
	@isTest private static void testExtractStepsAsString_targetMatchedContainingForbiddenKeyword() { testExtractStepsAsString(1, true , true,  true,  true ); }
	@isTest private static void testExtractStepsAsString_targetMatchedTwice() 					   { testExtractStepsAsString(2, false, true,  true,  false); }
	@isTest private static void testExtractStepsAsString_targetMatchedWithoutNextKeyword() 	  	   { testExtractStepsAsString(1, false, false, false, false); }
	@isTest private static void testExtractStepsAsString_targetMatchedWithNextKeyword() 	  	   { testExtractStepsAsString(1, true , true,  false, false); }
	@isTest private static void testExtractStepsAsString_targetMatchedContainingNextKeyword() 	   { testExtractStepsAsString(1, false, true,  true,  false); }

	// --------------------------------------------------------------------------------------------------------------------	
	 
	private static void testSelectBeforeKeyword(Boolean hasKeyword)		
	{
		// GIVEN
		String dummyKeyword				   	= 'Dummy Keyword'; 		 
		String dummyStep1AsString 			= 'Dummy Remaining Step';
		String dummyStep2AsString 			= 'Some Other Step';
		String dummyRemainingStepsAsString	= dummyStep1AsString + ((hasKeyword) ? (' ' + dummyKeyword + ' ' + dummyStep2AsString) : '');

		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		Map<String, String> resultStepByPositionMap = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepByPositionMap = targetExtractionHelper.splitBeforeKeyword (dummyRemainingStepsAsString, dummyKeyword);
			}
		}
		
		// THEN
		System.assertEquals(dummyStep1AsString					    , resultStepByPositionMap.get('before'));
		System.assertEquals((hasKeyword) ? dummyStep2AsString : null, resultStepByPositionMap.get('after'));
	}
	
	@isTest private static void testSelectBeforeKeyword_noKeyword()  { testSelectBeforeKeyword(false); }
	@isTest private static void testSelectBeforeKeyword_hasKeyword() { testSelectBeforeKeyword(true);  }

	// --------------------------------------------------------------------------------------------------------------------	

	@isTest private static void testBuildStepDivisionMap_beforeAndAfterStrings() 
	{
		// GIVEN
		String dummyBefore = 'Before';
		String dummyAfter = 'After';

		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		Map<String, String> resultDivisionMap = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				 resultDivisionMap = targetExtractionHelper.buildStepDivisionMap(dummyBefore, dummyAfter);
			}
		}
		
		// THEN
		System.assertEquals(dummyBefore, resultDivisionMap.get('before'));
		System.assertEquals(dummyAfter,  resultDivisionMap.get('after'));
	}

	// --------------------------------------------------------------------------------------------------------------------	

	private static void testBuildStepDivisionMap_remainingStepAsString(String dummy1stConjunction, String dummy2ndConjunction) 
	{
		// GIVEN
		Boolean has1stConjunction = (!String.isBlank(dummy1stConjunction));
		Boolean has2ndConjunction = (!String.isBlank(dummy2ndConjunction));
		
		String dummyStep1AsString 			= 'Dummy 1st Step';
		String dummyStep2AsString 			= (!String.isBlank(dummy1stConjunction)) ? 'Dummy 2nd Step' : null;
		String dummyStep3AsString 			= (!String.isBlank(dummy2ndConjunction)) ? 'Dummy 3nd Step' : null;
		
		String dummyPostConjunctionSteps	= ((has1stConjunction) ? dummyStep2AsString : '')
											+ ((has2ndConjunction) ? (' ' + dummy2ndConjunction + ' ' + dummyStep3AsString) : '');
		
		String dummyRemainingStepsAsString	= dummyStep1AsString 
												+ ((has1stConjunction) ? (' ' + dummy1stConjunction + ' ' + dummyPostConjunctionSteps) : '');
		
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		Map<String, String> resultDivisionMap = null;
		Boolean exceptionCaught = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { resultDivisionMap = targetExtractionHelper.buildStepDivisionMap(dummyRemainingStepsAsString); }
				catch (ZUKE_MalformedScenarioException e) { exceptionCaught = true; }
			}
		}
		
		// THEN
		Boolean exceptionExpected  = (new Set<String>{dummy1stConjunction, dummy2ndConjunction}).contains('Or');
		System.assertEquals (exceptionExpected, exceptionCaught);
		if (!exceptionExpected)
		{
			System.assertEquals(dummyStep1AsString, 	    							 resultDivisionMap.get('before'));
			System.assertEquals((has1stConjunction) ? dummyPostConjunctionSteps : null,  resultDivisionMap.get('after'));
		}
	}
	
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_bothNull() 	{ testBuildStepDivisionMap_remainingStepAsString( null, null  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_and()  		{ testBuildStepDivisionMap_remainingStepAsString('And', null  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_bothAnd()    { testBuildStepDivisionMap_remainingStepAsString('And', 'And' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_andAndBut()  { testBuildStepDivisionMap_remainingStepAsString('And', 'But' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_andAndOr()   { testBuildStepDivisionMap_remainingStepAsString('And', 'Or'  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_but()  		{ testBuildStepDivisionMap_remainingStepAsString('But', null  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_butAndAnd()  { testBuildStepDivisionMap_remainingStepAsString('But', 'And' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_bothBut()  	{ testBuildStepDivisionMap_remainingStepAsString('But', 'But' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_butAndOr()   { testBuildStepDivisionMap_remainingStepAsString('But', 'Or'  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_or()  		{ testBuildStepDivisionMap_remainingStepAsString('Or',  null  ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_orAndAnd()   { testBuildStepDivisionMap_remainingStepAsString('Or',  'And' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_orAndBut()   { testBuildStepDivisionMap_remainingStepAsString('Or',  'But' ); }
	@isTest private static void testBuildStepDivisionMap_remainingStepAsString_bothOr()  	{ testBuildStepDivisionMap_remainingStepAsString('Or',  'Or'  ); }
	
	// --------------------------------------------------------------------------------------------------------------------	

	private static void testExtractStepsAsStringList(Integer numberOfSteps) 
	{
		// GIVEN
		List<String> dummyStepsAsStringList = new List<String>();
		String		 dummyStepsAsString     = '';
		if (numberOfSteps > 0)
		{
			for (Integer i=1; i<=numberOfSteps; i++)
			{
				String dummyStep = 'Dummy Step ' + i;
				dummyStepsAsStringList.add(dummyStep);
				dummyStepsAsString += dummyStep +  ( (i<numberOfSteps) ? ' And ' : '' );
			}
		}
		
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(null);
		
		// WHEN
		List<String> resultStepAsStringList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepAsStringList = targetExtractionHelper.extractStepsAsStringList(dummyStepsAsString);
			}
		}
		
		// THEN
		if (numberOfSteps > 0)
		{
			System.assertEquals(numberOfSteps, resultStepAsStringList.size());
			for (Integer i=1; i<=numberOfSteps; i++)
			{
				System.assertEquals (dummyStepsAsStringList[i-1], resultStepAsStringList[i-1]);
			}			
		}
		else { System.assertEquals(null, resultStepAsStringList); }
	}
	
	@isTest private static void testExtractStepsAsStringList_1step()  { testExtractStepsAsStringList(1); }
	@isTest private static void testExtractStepsAsStringList_2steps() { testExtractStepsAsStringList(2); }
	@isTest private static void testExtractStepsAsStringList_0steps() { testExtractStepsAsStringList(0); }

	// --------------------------------------------------------------------------------------------------------------------	

	@isTest private static void testPutStepsAsString() 
	{
		// GIVEN
		Map<ZUKE_StepTypeEnum, List<String>> dummyStepAsStringListByStepTypeMap = new Map<ZUKE_StepTypeEnum, List<String>>();
		
		ZUKE_StepTypeEnum 					 dummyStepType 						= ZUKE_StepTypeEnum.GIVEN_STEP;
		String 								 dummyTargetKeyword 				= 'Given';
		Boolean 							 dummyIsRequired 					= false;
		String 								 dummyNextKeyword 					= 'When';
		Set<String> 						 dummyForbiddenKeywordSet 			= new Set<String>{'Then'};
		
		String 								 dummyTargetStep 					= 'Dummy Target Step';
		
		String								 dummyScenario						= 'Scenario: Dummy Scenario'
																					+ dummyTargetKeyword + ' ' + dummyTargetStep + '\n'
																					+ dummyNextKeyword   + ' Some other step\n'
																					+ 'Then some final step\n';
		
		ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(dummyScenario);
		
		// WHEN
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				targetExtractionHelper.putStepsAsString(dummyStepAsStringListByStepTypeMap, dummyStepType, dummyTargetKeyword, dummyIsRequired, dummyNextKeyword, dummyForbiddenKeywordSet);
			}
		}
		
		// THEN
		assertMappedStep (dummyStepType, dummyTargetStep, dummyStepAsStringListByStepTypeMap);
	}
	
	// --------------------------------------------------------------------------------------------------------------------	

	private static void testBuildStepListMap(Boolean isStaticTest) 
	{
		// GIVEN
		Map<ZUKE_StepTypeEnum, List<String>> dummyStepAsStringListByStepTypeMap = new Map<ZUKE_StepTypeEnum, List<String>>();
		
		String 								 dummyGivenStep 				= 'Dummy Assumption Step';
		String 								 dummyWhenStep 					= 'Dummy Action Step';
		String 								 dummyThenStep 					= 'Dummy Assertion Step';
		
		String								 dummyScenario						= 'Scenario: Dummy Scenario'
																					+ 'Given ' + dummyGivenStep + '\n'
																					+ 'When '  + dummyWhenStep + '\n'
																					+ 'Then '  + dummyThenStep + '\n';
		
		// WHEN
		Map<ZUKE_StepTypeEnum, List<String>> resultStringListByStepTypeMap = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				if (isStaticTest)
				{
					resultStringListByStepTypeMap = ZUKE_StepListExtractionHelper.buildStepListByStepTypeMap(dummyScenario);
				}
				else
				{
					ZUKE_StepListExtractionHelper targetExtractionHelper = new ZUKE_StepListExtractionHelper(dummyScenario);
					resultStringListByStepTypeMap = targetExtractionHelper.doBuildStepListByStepTypeMap();
				}
			}
		}
		
		// THEN
		assertMappedStep (ZUKE_StepTypeEnum.GIVEN_STEP, dummyGivenStep, resultStringListByStepTypeMap);
		assertMappedStep (ZUKE_StepTypeEnum.WHEN_STEP,  dummyWhenStep, resultStringListByStepTypeMap);
		assertMappedStep (ZUKE_StepTypeEnum.THEN_STEP,  dummyThenStep, resultStringListByStepTypeMap);
	}

	@isTest private static void testBuildStepListMap_instance() { testBuildStepListMap(false); }
	@isTest private static void testBuildStepListMap_static()   { testBuildStepListMap(true);  }

	// --------------------------------------------------------------------------------------------------------------------	
	
	private static void assertMappedStep (ZUKE_StepTypeEnum stepType, String expectedStringAsStep, Map<ZUKE_StepTypeEnum, List<String>> resultStringListByStepTypeMap)
	{
		System.assert(resultStringListByStepTypeMap.containsKey(stepType));
		System.assertEquals(expectedStringAsStep, resultStringListByStepTypeMap.get(stepType)[0]);
	}
	
}