@isTest
public class ZAMP_ZucchiniTestingCache 
{
	private List<Zucchini__c> zucchiniList;
	public  List<Zucchini__c> getZucchiniList() { return zucchiniList; }
	
	public ZAMP_ZucchiniTestingCache(List<Zucchini__c> zucchiniList)
	{
		this.zucchiniList = zucchiniList;
	}
}