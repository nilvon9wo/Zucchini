/**
	Zuke (short for "Zucchini", as "Cuke" is to "Cucumber") is an attempt to build a BDD solution for the SFDC platform.
	
	
	PERCEIVED TECHNICAL CHALLENGES:
	
	1. SFDC's reflection abilities are much more limited than Ruby, Java, and other platforms.
	
	2. SFDC requires coverage for deployment, so BDD test execution should be counted towards coverage.
	
	3. SFDC testMethod execution can not create or modify records, files, etc., so it may be desirable to have an alternative method for running tests
		which can produce reports, etc.
	
	
	TODO LIST:
	
	1. Create a method for importing Feature files.
	2. Create a method for converting Feature files into testable Scenarios.
		a. Each Scenario can have multiple "Steps" (Givens, Whens, and Thens)
		b. It is desirable that the BDD solution will assist developers in creating appropriate tests to match the Feature files.
	3. Execute testable Scenarios.
	4. Enable reportable output.

**/
public class ZUKE_README { }