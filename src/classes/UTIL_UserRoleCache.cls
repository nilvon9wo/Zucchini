public class UTIL_UserRoleCache 
{
	@testVisible private static final Map<Id,UserRole> 	    USER_ROLES_BY_ID_CACHE				= null;
    @testVisible private static final Map<String,UserRole>  USER_ROLES_BY_DEVELOPER_NAME_CACHE  = null;
	
	public static final String CEO 			 = 'CEO';
	public static final String STANDARD_USER = 'CustomerSupportInternational';
	
	static  
	{
		if ((USER_ROLES_BY_ID_CACHE == null) || (USER_ROLES_BY_ID_CACHE.isEmpty()))  
		{ 
			Map<String,Map<String,UserRole>> userRoleMapMap = makeUserRoleCaches(); 
			USER_ROLES_BY_ID_CACHE 				= UTIL_MapCastHelper.castStringMapToIdMap(userRoleMapMap.get('byId')); 
			USER_ROLES_BY_DEVELOPER_NAME_CACHE 	= userRoleMapMap.get('byDevName');
		}
	}

	public static Map<String,Map<String,UserRole>> makeUserRoleCaches()
	{
		Map<String,Map<String,UserRole>> userRoleMapMap = new Map<String,Map<String,UserRole>>
		{
			'byId' 		=> new Map<String,UserRole>(),
			'byDevName' => new Map<String,UserRole>()
		};
	
	    for (UserRole UserRole : [SELECT id, name, developerName FROM UserRole]) 		
	    {  														
	        {													
	            userRoleMapMap.get('byId').put(UserRole.id,UserRole);	
	            userRoleMapMap.get('byDevName').put(UserRole.developerName,UserRole);	
	        }
	    }
	    return userRoleMapMap;
	}
	
	public static Map<Id,UserRole> 	    getUserRolesByIdMap() 	  	 { return USER_ROLES_BY_ID_CACHE;   	 }
	public static Map<String, UserRole> getUserRolesByDevNameMap()   { return USER_ROLES_BY_DEVELOPER_NAME_CACHE; }

	public static UserRole get (Id     UserRoleId)   				 { return USER_ROLES_BY_ID_CACHE.get(UserRoleId);         }
	public static UserRole get (String UserRoleName) 		  		 { return USER_ROLES_BY_DEVELOPER_NAME_CACHE.get(UserRoleName);     }
}