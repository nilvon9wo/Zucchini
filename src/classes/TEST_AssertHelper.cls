@isTest
public class TEST_AssertHelper 
{
	public static void resultContainsAll (Set<String> expectedStringSet, String resultString)
	{
		for (String expectedString : expectedStringSet)
		{
			System.assert(resultString.contains(expectedString));
		}
	}
}