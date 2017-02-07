@isTest
public class ZUKE_StepTemplateHelperTest 
{
	private static final User 			   TEST_RUN_USER       				= TEST_DummyUserFactory.createDefaultTestRunUser();
	
	private static final String 		   DUMMY_FEATURE_NAME				= 'DummyFeatureName';
	private static final String 		   DUMMY_MISSING_STEP				= 'Dummy Missing Step';
	private static final String 		   DUMMY_PROPOSED_STEP_CLASS_NAME	= 'DummyClassStepName';
	private static final ZUKE_StepTypeEnum DUMMY_STEP_TYPE  			    = ZUKE_StepTypeEnum.GIVEN_STEP; 
	private static final String			   DUMMY_STEP_TYPE_AS_STRING  	    = String.valueOf(DUMMY_STEP_TYPE); 
	
	static
	{
		ZUKE_DummyZucchiniSettingFactory.create(TEST_DummyInsertModeEnum.REAL);
	}
	
	private static void testCreateProposedClassName(Integer classNameLength) 				  					  				
	{
		// GIVEN
		String someCharacter = 'd';
		String dummyMissingStep = '';
		for (Integer i=1; i<=classNameLength; i++) { dummyMissingStep += someCharacter; }
		
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createProposedClassName(dummyMissingStep);
			}
		}
		
		// THEN
		String expectedName =  (
									(classNameLength <= 36)
										? dummyMissingStep
										: dummyMissingStep.subString(0,36)
							   ) + 'Step';
			   expectedName = someCharacter.toUpperCase() + expectedName.subString(1);			   
		   
		System.assertEquals(expectedName, result);
	}
	
	@isTest private static void testCreateProposedClassName_01() { testCreateProposedClassName(01); }
	@isTest private static void testCreateProposedClassName_35() { testCreateProposedClassName(35); }
	@isTest private static void testCreateProposedClassName_36() { testCreateProposedClassName(36); }
	@isTest private static void testCreateProposedClassName_37() { testCreateProposedClassName(37); }
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateHeaderComment() 			  					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateHeaderComment(DUMMY_FEATURE_NAME, DUMMY_MISSING_STEP);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{DUMMY_FEATURE_NAME, DUMMY_MISSING_STEP};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	} 
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void createTemplateClassStart()  			  					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateClassStart(DUMMY_PROPOSED_STEP_CLASS_NAME);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'public class ' + DUMMY_PROPOSED_STEP_CLASS_NAME + ' implements ZUKE_Step\n', '{'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateGetTargetFeatureName()  	  					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateGetTargetFeatureName(DUMMY_FEATURE_NAME);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tpublic String getTargetFeatureName() { return \'' + DUMMY_FEATURE_NAME + '\'; }\n'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateGetStepAsString()  		  					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateGetStepAsString(DUMMY_MISSING_STEP);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tprivate String stepAsString;\n', '\tpublic String getStepAsString() { return stepAsString; }\n'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------

	@isTest private static void testCreateTemplateGetType()    					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateGetType(DUMMY_STEP_TYPE);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tpublic ZUKE_StepTypeEnum getType() { return ZUKE_StepTypeEnum.' + DUMMY_STEP_TYPE_AS_STRING +'; }\n'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}

	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateGetMatchableRegexList()    					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateGetMatchableRegexList(DUMMY_MISSING_STEP);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tpublic List<String> getMatchableRegexList()\n', '\t\t\t\'^' + DUMMY_MISSING_STEP + '$\'\n'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateInitialize()
	{  			  					  				
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateInitialize(DUMMY_MISSING_STEP);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tpublic void initialize(String stepAsString)\n', '\t\tthis.stepAsString = stepAsString;\n', 'This placeholder MUST be replaced', 'throw new ZUKE_UnimplementedStepException(this,\'initialize\');'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}		
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateTest()  					  				
	{  			  					  				
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateTest();
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'\tpublic  boolean test(ZUKE_Scenario scenario)\n', 'This placeholder MUST be replaced', 'throw new ZUKE_UnimplementedStepException(this,\'test\');'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}		
	
	// -----------------------------------------------------------------------------------------
	
	@isTest private static void testCreateTemplateClassEnd()  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateClassEnd();
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{'}'};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------

	@isTest private static void testCreateTemplateContent()  				  					  				
	{ 
		// WHEN
		String result = '';
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				result = ZUKE_StepTemplateHelper.createTemplateContent(DUMMY_PROPOSED_STEP_CLASS_NAME, DUMMY_FEATURE_NAME, DUMMY_STEP_TYPE, DUMMY_MISSING_STEP);
			}
		}
		   
		// THEN
		Set<String> expectedResultSet = new Set<String>{DUMMY_PROPOSED_STEP_CLASS_NAME, DUMMY_FEATURE_NAME, DUMMY_STEP_TYPE_AS_STRING, DUMMY_MISSING_STEP};
		TEST_AssertHelper.resultContainsAll(expectedResultSet, result);
	}
	
	// -----------------------------------------------------------------------------------------

	@isTest private static void testCreateTemplateDocument()  				  					  				
	{
		// WHEN
		Document templateDocument = null; 
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				templateDocument = ZUKE_StepTemplateHelper.createTemplateDocument(DUMMY_FEATURE_NAME, DUMMY_STEP_TYPE, DUMMY_MISSING_STEP); 
			}
		}
		   
		// THEN
		System.assert((Boolean) TEST_MockFieldHelper.getMockField(templateDocument, 'Insert:isSuccess'));
		
		// List<Document> documentList = [SELECT id FROM Document WHERE folderId =: ZUKE_StepTemplateHelper.ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID];	
		// System.assertEquals(1, documentList.size());  
	}
	

}