public class ZUKE_StepTemplateHelper 
{
	@testVisible private static final Id ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID;
	 
	static
	{
		if (ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID == null)
		{
			Zucchini_Setting__c zucchiniSetting = Zucchini_Setting__c.getInstance();
			ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID = zucchiniSetting.Step_Class_Template_Folder_Id__c;
			
			if (ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID == null)
			{
				throw new ZUKE_StepTemplateFolderNotSetException('Zucchini_Setting__r.Step_Class_Template_Folder_Id__c must be set to a Document folder Id.');	
			}
		}
	}
	
	public static Document createTemplateDocument(String featureName, ZUKE_StepTypeEnum stepType, String missingStep)
	{
		String proposedClassName = createProposedClassName(missingStep);
		
		Document newStepClassTemplate = new Document();
				 newStepClassTemplate.name = proposedClassName;
				 newStepClassTemplate.body = Blob.valueOf(createTemplateContent(proposedClassName, featureName, stepType, missingStep));
				 newStepClassTemplate.contentType = 'text/plain';
				 newStepClassTemplate.type = 'cls';
				 newStepClassTemplate.folderId = ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID;

		  UTIL_SObjectDMLHelper.doInsert(newStepClassTemplate);		  				 
  		  
  		  System.debug(LoggingLevel.INFO, 'Requested template will be found in your Zucchine Step Class Template Folder, Id = ' + ZUCCHINI_STEP_CLASS_TEMPLATE_FOLDER_ID);
  		  
  		  return newStepClassTemplate;
	}

	// --------------------------------------------------------------------------------------------
	
	@testVisible private static String createProposedClassName(String missingStep)
	{
		String className = UTIL_StringHelper.removeSpecialCharacters(missingStep);
			   className = UTIL_StringHelper.convertToCamelCase(className);
		
		if (className.length() > 36) { className = className.subString(0,36); }
		
		return className + 'Step';
	}
	
	// --------------------------------------------------------------------------------------------
	
	@testVisible private static String createTemplateContent(String proposedClassName, String featureName, ZUKE_StepTypeEnum stepType, String missingStep)
	{
		String newTemplate =   createTemplateHeaderComment(featureName, missingStep)
							 + createTemplateClassStart(proposedClassName)
							 + createTemplateGetTargetFeatureName(featureName)
							 + createTemplateGetStepAsString(missingStep)
							 + createTemplateGetType(stepType)
							 + createTemplateGetMatchableRegexList(missingStep)
							 + createTemplateInitialize(missingStep)
							 + createTemplateTest()
							 + createTemplateClassEnd();
			   					 
		return newTemplate;
	}
	
	@testVisible private static String createTemplateHeaderComment(String featureName, String missingStep)
	{
		return  '/**\n'
			+	' *  This is a template to help test the "' + featureName + '" feature.\n'
			+	' *  Specifically, it is to help test the step described by "' + missingStep + '".\n'
			+ 	' *\n'
			+ 	' *  To use it, you must copy it to your Apex classes and make appropriate modifications.\n'
			+	' **/\n';
	}	

	@testVisible private static String createTemplateClassStart(String proposedClassName)
	{
		return  '/**\n'
			+	' *  This class CAN be renamed, \n'
			+	' *  BUT the name must end in "Step"\n'
			+ 	' *  AND the class must implement ZUKE_Step.\n'
			+	' **/\n'
			+   '@isTest'
			+   'public class ' + proposedClassName + ' implements ZUKE_Step\n'
			+   '{\n\n'
			+   '\n'
			+   '\t// Custom instance variables, needed only for this step\n'
			+   '\n';
	}

	@testVisible private static String createTemplateGetTargetFeatureName(String featureName)
	{
		return  '\t/**\n'
			+	'\t *  This method must return a value identical to the name of the corresponding static-resource feature-file.\n'
			+   '\t *\n'
			+	'\t *  The default return already matches the name of the resource at the time this file was created.\n'
			+	'\t **/\n'
			+	'\t// @return String the feature name\n'
			+   '\tpublic String getTargetFeatureName() { return \'' + featureName + '\'; }\n'
			+   '\n\n';
	}

	@testVisible private static String createTemplateGetStepAsString(String missingStep)
	{
		return  '\t/**\n'
			+	'\t *  This method returns the value of stepAsString, mostly to be used for diagnostic purposes.\n'
			+   '\t *\n'
			+	'\t *  By default, this will be set in the initialize() method, allowing the value to be dynamic.\n '
			+	'\t **/\n'
			+   '\tprivate String stepAsString;\n'
			+   '\tpublic String getStepAsString() { return stepAsString; }\n'
			+   '\n\n';
	}
	
	@testVisible private static String createTemplateGetType(ZUKE_StepTypeEnum stepType)
	{
		return  '\t/**\n'
			+	'\t *  This method returns the step type, as indicated by a keyword within the scenario, preceding the step.\n'
			+   '\t *\n'
			+	'\t *  Zucchini does NOT do anything with this value,\n'
			+	'\t *  but you SHOULD [at least consider it] when you create the test() implementation.\n '
			+	'\t **/\n'
			+	'\t// @return ZUKE_StepTypeEnum the step type\n'
			+   '\tpublic ZUKE_StepTypeEnum getType() { return ZUKE_StepTypeEnum.' + String.valueOf(stepType) +'; }\n'
			+   '\n\n';
	}

	@testVisible private static String createTemplateGetMatchableRegexList(String missingStep)
	{
		return  '\t/**\n'
			+	'\t *  This method returns a list of regex expressions which will be used to match the step-As-String to this Step Class.\n'
			+   '\t *\n'
			+	'\t *  By default, this method returns only one string literal value, derived from the feature file.\n'
			+   '\t *  BUT you should replace the literal value with an appropriate regex expression,\n'
			+   '\t *  enabling this Step class to be recycled in different, yet reasonably similiar, scenarios.\n'
			+   '\t *\n'
			+	'\t *  In addition to changing the string literal to something more flexible,\n'
			+	'\t *  you can ALSO include additional expressions which should be interpreted to mean the same thing.\n'
			+	'\t **/\n'
			+	'\t// @return List<String> the list of regular expresions which can be used to invoke this Step.\n'
			+   '\tpublic List<String> getMatchableRegexList()\n'
			+   '\t{\n'
			+   '\t\treturn new List<String>\n'
			+   '\t\t{\n'
			+	'\t\t\t\'^' + missingStep + '$\'\n'
			+   '\t\t};\n'
			+   '\t}\n'
			+   '\n\n';
	}

	@testVisible private static String createTemplateInitialize(String missingStep)
	{
		return  '\t/**\n'
			+	'\t *  This method MUST prepare the Step instance for test execution.\n'
			+   '\t *\n'
			+	'\t *  If the expression "' + missingStep + '" includes dynamic values,\n'
			+	'\t *  you must inform SFDC/Zucchini how to extract and where to store them.\n'
			+   '\t *\n'
			+	'\t *  By default, this method will set the "stepAsString" value and then throw an exception.\n '
			+	'\t *  You MUST modify this method before Zucchini can process this Step.\n'
			+	'\t **/\n'
			+   '\tpublic void initialize(String stepAsString)\n'
			+   '\t{\n'
			+   '\t\tthis.stepAsString = stepAsString;\n'
			+	'\n'
			+	'\t// This placeholder MUST be replaced.\n'
			+   '\t\tthrow new ZUKE_UnimplementedStepException(this,\'initialize\');\n'
			+   '\t}\n'
			+   '\n\n';
	}

	@testVisible private static String createTemplateTest()
	{
		return  '\t/**\n'
			+	'\t *  This method MUST implement the actual test to be executed.\n'
			+   '\t *\n'
			+	'\t *  If your step-as-string included dynamic values,\n'
			+	'\t *  they should have already been extracted and stored during the initialize(String stepAsString) execution.\n'
			+   '\t *\n'
			+	'\t *  If your step requires communication with previous or following steps within the scenario,\n'
			+	'\t *  you can (should) store and retrieve values from the scenarioValuesbyNameMap.\n'
			+   '\t *\n'
			+   '\t *  If the step fails for any reason, you should return false.\n'
			+	'\t *  If the step throws almost any exception,\n'
			+	'\t *  it will be caught and handled as if you returned false.'
			+   '\t *\n'
			+   '\t *  IMPORTANT NOTE: System.AssertionException is immediately FATAL and can NOT be caught.\n'
			+   '\t *  As such, it can not be caught and handled and no further tests on the same Feature will execute.\n'
			+	'\t *  To avoid such errors, you can implement your own comparison logic,\n'
			+	'\t *  and (if appropriate) throw a ZUKE_AssetException instead.\n'
			+	'\t **/\n'
			+	'\t// @return Boolean does the step pass any and all tests?\n'
			+   '\tpublic  boolean test(ZUKE_Scenario scenario)\n'
			+   '\t{\n'
			+ 	'\t\tMap<String, Object> scenarioValuesbyNameMap = scenario.getScenarioValuesbyNameMap(); \n'
			+	'\n'
			+	'\t// This placeholder MUST be replaced.\n'
			+   '\t\tthrow new ZUKE_UnimplementedStepException(this,\'test\');\n'
			+   '\t}\n'
			+   '\n\n';
	}
	
	
	@testVisible private static String createTemplateClassEnd()
	{
		return '\n}\n';
	}

	// --------------------------------------------------------------------------------------------
	
}