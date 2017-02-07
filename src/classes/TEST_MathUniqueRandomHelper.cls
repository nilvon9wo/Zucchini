@isTest
public class TEST_MathUniqueRandomHelper 
{
    public static final Integer MULTIPLIER = 2147483647;   

    private static Set<Integer> existingRandomKeySet = New Set<Integer>{};

	/* 
	 *  return unique (from parent class) a positive 0 < Double < 1 
	 */
    public static double getDouble()
    {
        Double uniqueKey = null;
        do{    uniqueKey = Math.Random();    }
        while(existingRandomKeySet.contains((Integer)(uniqueKey * MULTIPLIER)));             
        
        existingRandomKeySet.add((Integer)(uniqueKey * MULTIPLIER));
        return uniqueKey;
    }

    public static Integer getInteger()
    {
    	return (Integer) getDouble() * MULTIPLIER;
    }

}