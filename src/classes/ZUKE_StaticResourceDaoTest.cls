@isTest
public class ZUKE_StaticResourceDaoTest 
{
	private static final User 	TEST_RUN_USER  	   = TEST_DummyUserFactory.createDefaultTestRunUser();

	@isTest private static void testGet()
	{ 
		// GIVEN
		String dummyResourceName = 'ZUKE_TestDummyFeature';
		
		ZUKE_StaticResourceDao targetStaticResourceDao = new ZUKE_StaticResourceDao(); 
		
		// WHEN
		StaticResource resultResource = null;
		System.runAs(TEST_RUN_USER)
		{
			Test.startTest();
			{
				resultResource = targetStaticResourceDao.get(dummyResourceName);
			}
		}
		
		// THEN
		System.assertEquals (dummyResourceName, resultResource.name);
	}

}