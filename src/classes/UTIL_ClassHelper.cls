public class UTIL_ClassHelper 
{
	public static String getName (Object currentObject)
	{
		return (String.valueOf(currentObject)).split(':')[0];
	}
}