public class UTIL_StringHelper 
{
	public static String removeSpecialCharacters(String target)
	{
		String specialChars = '~|!|@|#|$|%|^|&|*|_|+|=|<|>|?';
		for(Integer i=0; i<specialChars.split('|').size(); i++)
		{
			target = target.replace(specialChars.split('|')[i],'');
		}
		return target;
	}
	
	public static String convertToCamelCase(String target)
	{
		String camelCase = '';
		for(String subtarget : target.trim().split(' '))
		{
			camelCase += subtarget.substring(0,1).toUpperCase() + subtarget.substring(1).toLowerCase();
		}
		return camelCase;
	}


}