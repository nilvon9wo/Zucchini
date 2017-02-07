public class UTIL_ProfileCache  
{
	private static Map<Id,Profile> 		PROFILES_BY_ID_CACHE		= null;
	private static Map<String,Profile>  PROFILES_BY_NAME_CACHE  	= null;
	
	public static final String ADMINISTRATOR = 'System Administrator';
	public static final String STANDARD_USER = 'Standard User';
	
	static  
	{
		if ((PROFILES_BY_ID_CACHE == null) || (PROFILES_BY_ID_CACHE.isEmpty()))  
		{
			Map<String,Map<String,Profile>> profileMapMap = makeProfileCaches(); 
 			    PROFILES_BY_ID_CACHE   	  = UTIL_MapCastHelper.castStringMapToIdMap(profileMapMap.get('byId'));   
				PROFILES_BY_NAME_CACHE    = profileMapMap.get('byName');
		}
	}

	public static Map<String,Map<String,Profile>>  makeProfileCaches() 
	{
		Map<String,Map<String,Profile>> profileMapMap = new Map<String,Map<String,Profile>>
		{
			'byId' 	 => new Map<String,Profile>(),
			'byName' => new Map<String,Profile>()
		};

	    for (Profile profile : [SELECT Id, Name FROM Profile]) 		
	    {  														
        	profileMapMap.get('byId').put(profile.id,Profile);	
        	profileMapMap.get('byName').put(profile.name,Profile);	
		}
		
		return profileMapMap;
	}
	
	public static Map<Id,Profile> 	   getProfilesByIdMap() 	{ return PROFILES_BY_ID_CACHE;   }
	public static Map<String, Profile> getProfilesByNameMap()   { return PROFILES_BY_NAME_CACHE; }

	public static Profile get (Id profileId)       		{ return PROFILES_BY_ID_CACHE.get(profileId);        }
	public static Profile get (String profileName) 		{ return PROFILES_BY_NAME_CACHE.get(profileName);    }

	public static Boolean isUserAdmin(Id profileId)     { return (PROFILES_BY_ID_CACHE.get(profileId).name == ADMINISTRATOR); }
	public static Boolean isUserAdmin() 				{ return isUserAdmin(UserInfo.getProfileId()); }
	public static Boolean isUserAdmin(Profile profile)	{ return isUserAdmin(profile.id); }
	public static Boolean isUserAdmin(User    user)		{ return isUserAdmin(user.profileId); }
}