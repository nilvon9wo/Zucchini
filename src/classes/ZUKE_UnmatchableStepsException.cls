public class ZUKE_UnmatchableStepsException extends Exception
{
	private List<ZUKE_UnmatchableStepException> unmatchedStepExceptionList = null;
	public  List<ZUKE_UnmatchableStepException> getUnmatchedStepExceptionList() { return unmatchedStepExceptionList; }
	
	public ZUKE_UnmatchableStepsException(ZUKE_Feature feature, List<ZUKE_UnmatchableStepException> unmatchedStepExceptionList)
	{
		this(feature.getName() + ' has ' + unmatchedStepExceptionList.size() + ' unmatched steps.');
		this.unmatchedStepExceptionList = unmatchedStepExceptionList;
		debug();
	}
	
	@testVisible private void debug()
	{
		for (ZUKE_UnmatchableStepException unmatchedStepException : unmatchedStepExceptionList)
		{
			unmatchedStepException.debug();
		}
	}
}