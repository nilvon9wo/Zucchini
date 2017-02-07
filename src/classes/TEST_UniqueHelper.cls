@isTest
public class TEST_UniqueHelper 
{
    private Integer uniqueInt;
    public  Integer getInteger() { return uniqueInt; }
    
    private String  uniqueString;
    public  String  getString() { return uniqueString; }
    
    private String  uniqueSpaceless;
    public  String  getSpaceless() { return uniqueSpaceless; }
    
    /** 
    * @description  Constructor, which selects and sets an Integer and a corresponding String.
    * @param        String what : A value which can be included in the unique String to help identify it.
    **/
    public TEST_UniqueHelper (String what)
    {
        this.uniqueInt       = random();
        this.uniqueString    = what + ' ' + this.uniqueInt;
        this.uniqueSpaceless = this.uniqueString.deleteWhitespace(); 
    }
    
    /** 
    * @description  Default Constructor, which selects and sets an Integer and a corresponding String.
    **/
    public TEST_UniqueHelper () { this('Unique'); }
    
    public static Integer random() { return ((Integer) (TEST_MathUniqueRandomHelper.getInteger() * 2147483647)); }

}