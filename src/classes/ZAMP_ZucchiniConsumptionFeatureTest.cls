/**
	 *  PREREQUITES:
	 *		1. Set Zucchini_Settings__r.Step_Class_Template_Folder_Id__c
	 *			This should be set to the FolderId of a Document folder, so Zucchini can create template Steps.
	 *
	 *		2. Create a Feature file using the Gherkin language.
	 *			Note: Only the basic syntax is currently supported.
	 *			(e.g. Scenario Outlines, Tables, and PyStrings are NOT supported).
	 *			
	 *		3. Upload your Feature file as a Static Resource.
	 *			(Uploading to Documents or other storage mediums is NOT supported).	 
	 **/

@isTest
private class ZAMP_ZucchiniConsumptionFeatureTest 
{
	 
	/**
	 *  STEP 1: Write a testMethod which will attempt to test the Static Resource, such as:
	 **/

	@isTest private static void testZucchiniConsumptionFeature() 
	{
		ZUKE_Feature.test('ZAMP_ZucchiniConsumptionFeature');	// The parameter is the Static Resource's name, NOT necessarily the original file name.
	}

	/**
	 *  	Depending upon the existing state of your development, this will probably FAIL, throwing a ZUKE_UnmatchableStepsException,
	 *	    so:
	 **/
	
	/**
	 *	STEP 2: Extract relevent error and debug information from the Debug Log.
	 *		RECOMMENDED: Copy the Debug log from Force.com IDE to Notepad++ and clean it.
	 *		@ see: http://stackoverflow.com/questions/10303279/how-to-get-just-the-system-debug-output-when-executing-code
	 *	
	 *		Your log should look like this:
	 
10:02:50.335 (2335685395)|USER_DEBUG|[17]|ERROR|!!!!! Step "There are 12 zucchini" can not be matched for "ZAMP_ZucchiniConsumptionFeature::GIVEN_STEP". 
10:02:50.335 (2335769023)|USER_DEBUG|[18]|DEBUG|***** To create a template class, anonymously execute:  ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.GIVEN_STEP, 'There are 12 zucchini');
10:02:50.335 (2335828670)|USER_DEBUG|[17]|ERROR|!!!!! Step "I eat 5 zucchini" can not be matched for "ZAMP_ZucchiniConsumptionFeature::WHEN_STEP". 
10:02:50.335 (2335878668)|USER_DEBUG|[18]|DEBUG|***** To create a template class, anonymously execute:  ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.WHEN_STEP, 'I eat 5 zucchini');
10:02:50.335 (2335932880)|USER_DEBUG|[17]|ERROR|!!!!! Step "I should have 7 zucchini" can not be matched for "ZAMP_ZucchiniConsumptionFeature::THEN_STEP". 
10:02:50.335 (2335981106)|USER_DEBUG|[18]|DEBUG|***** To create a template class, anonymously execute:  ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.THEN_STEP, 'I should have 7 zucchini');
	 
	*
	**/

	/**
	 *	STEP 3: Generate the ZUKE_Step templates.
	 *		Anonymously execute the following code:	
	 
	// Parameters:							StaticResource.name					Step Type					 Step as String 
	ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.GIVEN_STEP, 'There are 12 zucchini');
	ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.WHEN_STEP,  'I eat 5 zucchini');
	ZUKE_StepTemplateHelper.createTemplateDocument('ZAMP_ZucchiniConsumptionFeature',  ZUKE_StepTypeEnum.THEN_STEP,  'I should have 7 zucchini');

	 *		Notes:
	 *			1. The Static Resource name MUST be an EXACT match
	 *			2. ZUKE_StepTypeEnum must be one of the three above values, EXACTLY.
	 *			3. The Step as String will create a template which EXACTLY matches for this String, 
	 *					but you can modify this either before or after you've added the templates to your Apex Classes.
	 **/ 
				 
	/**
	 *	STEP 4: Download your new classes from the specied Zuke Step Template Folder (e.g. 'ZUKE_StepClassTemplates')
	 *			(See PREREQUITE #1.)
	 *			To download using Google Chrome, right click on each "View", select "Save link as..." and complete the dialogs provided.
	 *
	 *			In this instance, we have three new Apex Classes:
	 *				1. ThereAre12ZucchiniStep.cls
	 *				2. IEat5ZucchiniStep.cls
	 *				3. IShouldHave7ZucchiniStep.cls
	 **/
	
	/** 
	 *	STEP 5: Rename, Edit, and Upload your new Apex Classes:
	 *			You can (and probably should) rename your classes, but there are three important rules:
	 *				1. Your class name MUST have 40 characters or less.	(SFDC Requirement)
	 *				2. Your class name MUST match your file name. (SFDC Requirement)
	 *				3. Your class name MUST end with "Step" (Zucchini Requirement)
	 *
	 *			In this instance, I will rename these:
	 *				1. ThereAre12ZucchiniStep.cls			==> ZAMP_ThereAreNgZucchiniGivenStep.cls
	 *				2. IEat5ZucchiniStep.cls				==> ZAMP_IEatNwZucchiniWhenStep.cls
	 *				3. IShouldHave7ZucchiniStep.cls			==> ZAMP_IShouldHaveNtZucchiniThenStep.cls
	 **/

	/** 
	 *	STEP 6: Edit your Step classes.  See templates and sample Step classes for further tips and instructions.
	 **/

	/** 
	 *	STEP 7: Develop your solution until your tests pass.
	 **/
	 
}