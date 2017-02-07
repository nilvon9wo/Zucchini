public class UTIL_MapCastHelper 
{
    public static Map<Id, Profile> castStringMapToIdMap (Map<String, Profile> stringMap)
    {
    	Map<Id, Profile> idMap = new Map<Id, Profile>();
    	for (String key : stringMap.keySet()) { idMap.put ((Id) key, stringMap.get(key) ); }
    	return idMap;
    }   

    public static Map<Id, UserRole> castStringMapToIdMap (Map<String, UserRole> stringMap)
    {
    	Map<Id, UserRole> idMap = new Map<Id, UserRole>();
    	for (String key : stringMap.keySet()) { idMap.put ((Id) key, stringMap.get(key) ); }
    	return idMap;
    }
}