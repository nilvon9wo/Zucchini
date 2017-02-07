public class ZUKE_UnimplementedStepException extends Exception
{
	public ZUKE_UnimplementedStepException(ZUKE_Step step, String methodName)
	{
		this(UTIL_ClassHelper.getName(step) + ':' + methodName + '() -- This placeholder MUST be replaced');
	}
}