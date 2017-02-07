public class ZAMP_ZucchiniConsumptionFeature 
{
	public static UTIL_ResultListWrapper eat(List<Zucchini__c> zucchiniList, Integer amount)
	{
		Integer zucchiniListSize = zucchiniList.size();
		if (amount > zucchiniListSize)
		{
			throw new ZAMP_ZucchiniOverConsumptionException('You can not eat more (' + amount + ') Zucchini than you have (' + zucchiniListSize + ' ).');
		}
		
		List<Zucchini__c> eatList = new List<Zucchini__c>();
		for (Integer i=1; i<=amount; i++)
		{
			eatList.add(zucchiniList[i-1]);
		}
		
		return eat(eatList);
	}
	
	public static UTIL_ResultListWrapper eat(List<Zucchini__c> zucchiniList)
	{
		return UTIL_SObjectDMLHelper.doDelete(zucchiniList);
	}
}