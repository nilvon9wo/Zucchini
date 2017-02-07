@isTest
public class TEST_IntentionalNull 
{
	public static Boolean isInstance(Object currentObject)    { return (currentObject instanceOf TEST_IntentionalNull); }
	public static Boolean isNotInstance(Object currentObject) { return !isInstance(currentObject); 						}
}