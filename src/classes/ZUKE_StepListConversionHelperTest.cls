@isTest
public class ZUKE_StepListConversionHelperTest 
{
	private static final User 			   TEST_RUN_USER       				= TEST_DummyUserFactory.createDefaultTestRunUser();

	private static final ZUKE_Step 		   DUMMY_STEP	        = new ZUKE_MockStepTestStep();
	private static final String			   DUMMY_FEATURE_NAME   = ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_TARGET_FEATURE_NAME;
	private static final String			   DUMMY_STEP_AS_STRING = ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_STEP_AS_STRING;
	private static final String 	       DUMMY_REGEX_STRING	= ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_MATCHABLE_REGEX_LIST[0];
	private static final ZUKE_StepTypeEnum DUMMY_STEP_TYPE      = ((ZUKE_MockStepTestStep) DUMMY_STEP).DUMMY_STEP_TYPE;
	private static final List<String>	   DUMMY_STEP_AS_STRING_LIST = new List<String>{ DUMMY_STEP_AS_STRING };

	private static final Map<ZUKE_StepTypeEnum, List<String>> DUMMY_STEP_AS_STRING_LIST_BY_STEP_TYPE_MAP = new Map<ZUKE_StepTypeEnum, List<String>>
	{
		 DUMMY_STEP_TYPE => DUMMY_STEP_AS_STRING_LIST
	};


	// -----------------------------------------------------------------------------------

	private static void testConvert_string(Boolean isMatchableStep) 
	{
		// GIVEN
		String dummyMappedRegex	= (isMatchableStep) ? DUMMY_REGEX_STRING  : 'OtherRegex';
		
		String featureTypeKey = DUMMY_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE);
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			featureTypeKey => new Map<String, ZUKE_Step> { dummyMappedRegex => DUMMY_STEP }
		};

		ZUKE_StepListConversionHelper targetConversionHelper = new ZUKE_StepListConversionHelper(DUMMY_FEATURE_NAME, DUMMY_STEP_AS_STRING_LIST_BY_STEP_TYPE_MAP);
		
		// WHEN
		ZUKE_Step resultStep = null;
		Boolean   exceptionCaught = false;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				try {  resultStep = targetConversionHelper.convert(DUMMY_STEP_TYPE, DUMMY_STEP_AS_STRING); }
				catch (ZUKE_UnmatchableStepException e) { exceptionCaught = true; } 
			}
		}
		
		// THEN
		System.assertEquals(!isMatchableStep, exceptionCaught);
		if (isMatchableStep)
		{
			ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
			System.assert ( ((ZUKE_MockStepTestStep) resultStep).isInitialized());
		}
	}

	@isTest private static void testConvert_string_unmatchable() { testConvert_string(false); }
	@isTest private static void testConvert_string_matchabe()    { testConvert_string(true ); }

	// -----------------------------------------------------------------------------------

	private static void testConvert_typeAndStepList(Boolean isMatchableStep)
	{
		// GIVEN
		String dummyMappedRegex	= (isMatchableStep) ? DUMMY_REGEX_STRING  : 'OtherRegex';
		
		String featureTypeKey = DUMMY_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE);
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			featureTypeKey => new Map<String, ZUKE_Step> { dummyMappedRegex => DUMMY_STEP }
		};

		ZUKE_StepListConversionHelper targetConversionHelper = new ZUKE_StepListConversionHelper(DUMMY_FEATURE_NAME, DUMMY_STEP_AS_STRING_LIST_BY_STEP_TYPE_MAP);
		
		// WHEN
		List<ZUKE_Step> resultStepList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepList = targetConversionHelper.convert(DUMMY_STEP_TYPE, DUMMY_STEP_AS_STRING_LIST);
			}
		}
		
		// THEN
		System.assertEquals((isMatchableStep)?1:0, resultStepList.size());
		if (isMatchableStep)
		{
			ZUKE_Step resultStep = resultStepList[0];
			ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
			System.assert ( ((ZUKE_MockStepTestStep) resultStep).isInitialized());
		}
	}
	
	@isTest private static void testConvert_typeAndStepList_unmatchable() { testConvert_typeAndStepList(false); }
	@isTest private static void testConvert_typeAndStepList_matchable()   { testConvert_typeAndStepList(true ); }

	// -----------------------------------------------------------------------------------
	
	@isTest private static void testConvert_mappedStepTypes()
	{
		// GIVEN
		ZUKE_MockGivenStep mockGivenStep = new ZUKE_MockGivenStep();
		ZUKE_MockWhenStep  mockWhenStep  = new ZUKE_MockWhenStep();
		ZUKE_MockThenStep  mockThenStep  = new ZUKE_MockThenStep();
		
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			(DUMMY_FEATURE_NAME + '::' + String.valueOf(ZUKE_StepTypeEnum.GIVEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				mockGivenStep.getMatchableRegexList()[0] => mockGivenStep 
			},
			(DUMMY_FEATURE_NAME + '::' + String.valueOf(ZUKE_StepTypeEnum.WHEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				mockWhenStep.getMatchableRegexList()[0]  => mockWhenStep 
			},
			(DUMMY_FEATURE_NAME + '::' + String.valueOf(ZUKE_StepTypeEnum.THEN_STEP)) => new Map<String, ZUKE_Step> 
			{ 
				mockThenStep.getMatchableRegexList()[0]  => mockThenStep 
			}
		};

		Map<ZUKE_StepTypeEnum, List<String>> dummyStepAsStringListByStepTypeMap = new Map<ZUKE_StepTypeEnum, List<String>>
		{
			 ZUKE_StepTypeEnum.GIVEN_STEP => new List<String>{'Given'},
			 ZUKE_StepTypeEnum.WHEN_STEP  => new List<String>{'When' },
			 ZUKE_StepTypeEnum.THEN_STEP  => new List<String>{'Then' }
		};

		ZUKE_StepListConversionHelper targetConversionHelper = new ZUKE_StepListConversionHelper(DUMMY_FEATURE_NAME, dummyStepAsStringListByStepTypeMap);
		
		List<ZUKE_Step> resultStepList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepList = targetConversionHelper.convert();
			}
		}
		
		// THEN
		System.assertEquals(3, resultStepList.size());
		
		Boolean includesGivenStep = false;
		Boolean includesWhenStep  = false;
		Boolean includesThenStep  = false;
		
		for (ZUKE_Step step : resultStepList)
		{
			String className = UTIL_ClassHelper.getName(step);
			if (className == 'ZUKE_MockGivenStep') { includesGivenStep = true; } 
			if (className == 'ZUKE_MockWhenStep')  { includesWhenStep = true; } 
			if (className == 'ZUKE_MockThenStep')  { includesThenStep = true; } 
		}
		  
		System.assert(includesGivenStep);
		System.assert(includesWhenStep);
		System.assert(includesThenStep);
	}

	// -----------------------------------------------------------------------------------

	@isTest private static void testConvertStringMapToStepList()
	{
		// GIVEN
		String featureTypeKey = DUMMY_FEATURE_NAME + '::' + String.valueOf(DUMMY_STEP_TYPE);
		ZUKE_MatchableStepCache.stepByRegexByFeatureTypeMapSingleton = new Map<String, Map<String, ZUKE_Step>>
		{
			featureTypeKey => new Map<String, ZUKE_Step> { DUMMY_REGEX_STRING => DUMMY_STEP }
		};

		List<ZUKE_Step> resultStepList = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultStepList = ZUKE_StepListConversionHelper.convertStringMapToStepList(DUMMY_FEATURE_NAME, DUMMY_STEP_AS_STRING_LIST_BY_STEP_TYPE_MAP);
			}
		}
		
		// THEN
		System.assertEquals(1, resultStepList.size());
		ZUKE_Step resultStep = resultStepList[0];
		ZUKE_AssertHelper.assertInstanceOf(DUMMY_STEP, resultStep);
		System.assert ( ((ZUKE_MockStepTestStep) resultStep).isInitialized());
	}
}