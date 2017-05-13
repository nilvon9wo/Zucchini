Feature: We need an extra Object called Object__c.

	Scenario: We could load the Object__c records into the system with 3 input fields(name, field 1, field 2)
	Given The Object is already created witg 2 custom fields
	When I try to load a record with name = TeestName, field 1= 'value1', field 2 = 'value2'
	Then 1 record should be loaded into the system with the givven values