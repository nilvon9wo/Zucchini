public virtual class ZUKE_StaticResourceDao 
{
	public virtual StaticResource get(String staticResourceName)
	{
		return [SELECT name, body FROM StaticResource WHERE name = :staticResourceName ];
	}
}