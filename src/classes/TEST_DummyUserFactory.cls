@isTest
public class TEST_DummyUserFactory 
{ 
    private static final String ADMINISTRATOR    = UTIL_ProfileCache.ADMINISTRATOR;   
    private static final Id     ADMINISTRATOR_ID = UTIL_ProfileCache.get(ADMINISTRATOR).id;

    public  static final User SETUP_DATA_CREATION_USER = [  SELECT id FROM User WHERE (isActive = TRUE) AND (profileId = :ADMINISTRATOR_ID) ORDER BY CreatedDate LIMIT 1 ];

    private static User testRunUser = null; 
    
    public static List<User> createList (List<Map<String,Object>> testValuesByFieldNameMapList, TEST_DummyInsertModeEnum insertMode)
    {
        return (List<User>) TEST_AbstractDummyFactory.createList(getPrototype(), testValuesByFieldNameMapList, insertMode, true); 
    } 
 
    // -----------------------------------------------------------------------------------------------------------------
        
    public static User create (Map<String,Object> testValuesByFieldNameMap, TEST_DummyInsertModeEnum insertMode)
    {
        return createList (new List<Map<String,Object>>{ testValuesByFieldNameMap} , insertMode)[0]; 
    } 

    public static User create (TEST_DummyInsertModeEnum insertMode) { return create (new Map<String,Object>(), insertMode);                    }
    public static User create ()                                    { return create (new Map<String,Object>(), TEST_DummyInsertModeEnum.NONE); }

    // -----------------------------------------------------------------------------------------------------------------
 
    private static User getPrototype() 
    {
        
        TEST_UniqueHelper uniqueHelper = new TEST_UniqueHelper('Dummy User');  
                   String uniqueString     = uniqueHelper.getString();
                   String uniqueSpaceless  = uniqueHelper.getSpaceless();
        
        return new User( 
                            lastName          = uniqueString,
                            alias             = uniqueSpaceless.left(1)+uniqueSpaceless.right(7), 
                            email             = uniqueSpaceless + '@runas.example.com',
                            username          = uniqueSpaceless + '@runas.example.com', 
                            communityNickname = uniqueSpaceless,  
                            languageLocaleKey = 'en_US',
                            localeSidKey      = 'en_US',
                            emailEncodingKey  = 'UTF-8',
                            timeZoneSidKey    = 'Europe/Berlin',
                            isActive          = true,
                            profileId         = UTIL_ProfileCache.get(UTIL_ProfileCache.STANDARD_USER).id,
                            userRoleId        = UTIL_UserRoleCache.get(UTIL_UserRoleCache.STANDARD_USER).id
             );
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    
    public static User createDefaultTestRunUser() 
    {
        if (testRunUser == null)
        {
            testRunUser = create(new Map<String,Object>{'profileId' => ADMINISTRATOR_ID}, TEST_DummyInsertModeEnum.REAL); 
        }
        return testRunUser;
    }
}