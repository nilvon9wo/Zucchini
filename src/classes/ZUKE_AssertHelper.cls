@isTest
public class ZUKE_AssertHelper 
{
	public static void assertInstanceOf (ZUKE_Step expectedStep, ZUKE_Step resultStep)
	{
			String expectedClassName = UTIL_ClassHelper.getName(expectedStep);
			String resultClassName 	 = UTIL_ClassHelper.getName(resultStep);
			System.assertEquals (expectedClassName, resultClassName);
	}
}