Feature: Zucchini Consumption
	This is a sample feature file, to prove and demonstrate the functionality of the Zucchini BDD solution.
	
	Scenario: Eat 5 out of 12
		This is my first scenario, composed before I wrote any test or production code.
		Given There are 12 zucchini
  		When I eat 5 zucchini
  		Then I should have 7 zucchini
  		
  	Scenario: Try to eat 5 out of 3
  		This is my second scenario, which should reuse some (but not all) of my original steps.
		Given There are 3 zucchini
  		When I try to eat 5 zucchini
  		Then I should get an overconsumption exception
  		