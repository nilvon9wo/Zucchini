@isTest
public class ZUKE_MatchableStepCacheTest 
{
	private static final User 				TEST_RUN_USER       		= TEST_DummyUserFactory.createDefaultTestRunUser();

	private static final ZUKE_Step 			DUMMY_STEP					= new ZUKE_MockStepTestStep();
	private static final ZUKE_StepTypeEnum  DUMMY_STEP_TYPE				= ZUKE_StepTypeEnum.GIVEN_STEP;
	private static final String 			DUMMY_TARGET_FEATURE_NAME	= ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_TARGET_FEATURE_NAME; 
	private static final String				DUMMY_STEP_AS_STRING		= ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_STEP_AS_STRING;
	private static final String 			DUMMY_REGEX_STRING			= ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_MATCHABLE_REGEX_LIST[0];

	// ----------------------------------------------------------------------------------------

	private static void testBuildStepByRegexMap(Boolean hasRegexString)
	{
		// GIVEN
		Map<String, ZUKE_Step> DUMMY_STEPByRegexMap		= new Map<String, ZUKE_Step>();
		if (hasRegexString) { DUMMY_STEPByRegexMap.put(DUMMY_REGEX_STRING, DUMMY_STEP); }
		
		// WHEN
		Boolean exceptionCaught = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { ZUKE_MatchableStepCache.buildStepByRegexMap(DUMMY_STEPByRegexMap, DUMMY_TARGET_FEATURE_NAME, DUMMY_STEP); }
				catch (ZUKE_DuplicateStepRegexException e) { exceptionCaught = true; }
			}
		}
		
		// THEN
		System.assertEquals(hasRegexString, exceptionCaught);
		if (!hasRegexString)
		{
			System.assert(DUMMY_STEPByRegexMap.containsKey(DUMMY_REGEX_STRING));
			System.assertEquals(DUMMY_STEPByRegexMap.get(DUMMY_REGEX_STRING), DUMMY_STEP);
		}
	}

	@isTest private static void testBuildStepByRegexMap_newString() 	 	  { testBuildStepByRegexMap(false); }
	@isTest private static void testBuildStepByRegexMap_StringAlreadyMapped() { testBuildStepByRegexMap(true);  }
	
	// ----------------------------------------------------------------------------------------
	
	private static void testBuildStepByRegexByFeatureTypeMap(Boolean hasFeatureTypeString)
	{
		// GIVEN
		Map<String, Map<String, ZUKE_Step>> seedStepByRegexStringByFeatureTypeMap = new Map<String, Map<String, ZUKE_Step>>();
		String 							    dummyfeatureTypeName =  DUMMY_TARGET_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE); 
		if (hasFeatureTypeString) { seedStepByRegexStringByFeatureTypeMap.put(dummyfeatureTypeName, new Map<String, ZUKE_Step>()); }
		
		// WHEN
		Map<String, Map<String, ZUKE_Step>> resultStepByRegexStringByFeatureTypeMap = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{ 
				ZUKE_MatchableStepCache targetCache = new ZUKE_MatchableStepCache();
				resultStepByRegexStringByFeatureTypeMap = targetCache.buildStepByRegexByFeatureTypeNameMap(new MockStepDao(), seedStepByRegexStringByFeatureTypeMap);
			}
		}
		
		// THEN
		System.assert(resultStepByRegexStringByFeatureTypeMap.containsKey(dummyfeatureTypeName));
		
		Map<String, ZUKE_Step> resultStepByRegexString = resultStepByRegexStringByFeatureTypeMap.get(dummyfeatureTypeName); 
		ZUKE_Step			   resultStep			   = resultStepByRegexString.get(DUMMY_REGEX_STRING); 
		ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
		
	}
	
	@isTest private static void testBuildStepByRegexByFeatureTypeMap_newFeature() 			{ testBuildStepByRegexByFeatureTypeMap(false); }
	@isTest private static void testBuildStepByRegexByFeatureTypeMap_featureAlreadyMapped() { testBuildStepByRegexByFeatureTypeMap(true);  }
	
	// ----------------------------------------------------------------------------------------
	
	private static void testGetStepByRegexByFeatureMap(Boolean isAlreadyPopulated) 
	{ 
		// GIVEN
		ZUKE_MatchableStepCache.zukeStepDao = new MockStepDao();
		
		String    dummyFeatureType = 'AlreadyPopulatedFeature';
		String    dummyRegex       = 'AlreadyPopulatedRegex';
		ZUKE_Step dummyStep        = new MockExtraStep();
		
		if (isAlreadyPopulated)
		{
			ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
			{
				dummyFeatureType => new Map<String, ZUKE_Step>{ dummyRegex => dummyStep }
			};
		}
		
		// WHEN
		Map<String, Map<String, ZUKE_Step>> resultStepByRegexByFeatureMap = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepByRegexByFeatureMap = ZUKE_MatchableStepCache.getStepByRegexByFeatureTypeMap();
			}
		}
		
		// THEN
		String    expectedFeatureType = (isAlreadyPopulated) ? dummyFeatureType : (DUMMY_TARGET_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE));
		System.assert(resultStepByRegexByFeatureMap.containsKey(expectedFeatureType));

		String    expectedRegex       = (isAlreadyPopulated) ? dummyRegex       : DUMMY_REGEX_STRING;
		System.assert(resultStepByRegexByFeatureMap.get(expectedFeatureType).containsKey(expectedRegex));

		ZUKE_Step 			   expectedStep		       = (isAlreadyPopulated) ? dummyStep        : DUMMY_STEP;
		Map<String, ZUKE_Step> resultStepByRegexString = resultStepByRegexByFeatureMap.get(expectedFeatureType); 
		ZUKE_Step			   resultStep			   = resultStepByRegexString.get(expectedRegex); 
		ZUKE_AssertHelper.assertInstanceOf(expectedStep, resultStep);
	}

	@isTest private static void testGetStepByRegexByFeatureMap_notPopulated() 	  { testGetStepByRegexByFeatureMap(false); }
	@isTest private static void testGetStepByRegexByFeatureMap_alreadyPopulated() { testGetStepByRegexByFeatureMap(true);  }

	// ----------------------------------------------------------------------------------------

	private static void testGet_stepMapAndStepAsString(Integer numberOfMatches)
	{
		// GIVEN
		String dummyMapped1stStepString = (numberOfMatches > 0) ? DUMMY_REGEX_STRING 		: 'Other Step';
		String dummyMapped2ndStepString	= (numberOfMatches > 1) ? '.*' 						: 'Yet Another Step';
		
		Map<String, ZUKE_Step> dummyStepByRegexMap = new Map<String, ZUKE_Step>
		{
			dummyMapped1stStepString => DUMMY_STEP,
			dummyMapped2ndStepString => new MockExtraStep()
		};
		
		// WHEN
		ZUKE_Step resultStep      = null;
		Boolean   exceptionCaught = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try { resultStep = ZUKE_MatchableStepCache.get(dummyStepByRegexMap, DUMMY_STEP_AS_STRING); }
				catch (ZUKE_DuplicateStepRegexException e) { exceptionCaught = true; }
			}
		}

		// THEN
		System.assertEquals (numberOfMatches > 1, exceptionCaught);
		
		if (numberOfMatches == 0) { System.assertEquals (null, resultStep); }
		else if (!exceptionCaught) { ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep); }
	}

	@isTest private static void testGet_stepMapAndStepAsString_oneMatch()   { testGet_stepMapAndStepAsString(1); }
	@isTest private static void testGet_stepMapAndStepAsString_noMatch()    { testGet_stepMapAndStepAsString(0); }
	@isTest private static void testGet_stepMapAndStepAsString_twoMatches() { testGet_stepMapAndStepAsString(2); }

	// ----------------------------------------------------------------------------------------
	 
	@isTest private static void testInitializeStep()
	{
		// WHEN
		ZUKE_Step resultStep = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStep = ZUKE_MatchableStepCache.initializeStep(DUMMY_STEP, DUMMY_STEP_AS_STRING);
			}
		}
		
		// THEN
		ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
		System.assert ( ((ZUKE_MockStepTestStep) resultStep).isInitialized());
	}
	

	// ----------------------------------------------------------------------------------------
	 
	private static void testGet_FeatureTypeAndStepAsString(Boolean hasFeature)
	{
		// GIVEN
		String dummyMappedFeature	= (hasFeature) 			? (DUMMY_TARGET_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE)) : 'OtherFeature';
		
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			dummyMappedFeature => new Map<String, ZUKE_Step> { DUMMY_REGEX_STRING => DUMMY_STEP }
		};
		
		// WHEN
		ZUKE_Step resultStep = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStep = ZUKE_MatchableStepCache.get(DUMMY_TARGET_FEATURE_NAME, DUMMY_STEP_TYPE, DUMMY_STEP_AS_STRING);
			}
		}

		// THEN
		if (!hasFeature) { System.assertEquals (null, resultStep); }
		else
		{
			ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
			System.assert ( ((ZUKE_MockStepTestStep) resultStep).isInitialized());
		}
	}

	@isTest private static void testGet_FeatureTypeAndStepAsString_noSuchFeature()  { testGet_FeatureTypeAndStepAsString(false); }
	@isTest private static void testGet_FeatureTypeAndStepAsString_hasFeature() 	{ testGet_FeatureTypeAndStepAsString(true);  }

	// =======================================================================================
	 
    private class MockStepDao extends ZUKE_StepDao
    {
		public override List<ZUKE_Step> getList()  
		{
			return new List<ZUKE_Step>
			{
				new ZUKE_MockStepTestStep()
			};
		}
    }

	// ----------------------------------------------------------------------------------------

	private class MockExtraStep implements ZUKE_Step
	{
		public String getTargetFeatureName()			{ return null;  }
		public String getStepAsString()					{ return null;  }
		public ZUKE_StepTypeEnum getType()				{ return null;  }
		public List<String> getMatchableRegexList()		{ return null;  }
		public void initialize(String stepAsString)		{}
		public boolean test(ZUKE_Scenario scenario)		{ return null;  } 	
	}
}