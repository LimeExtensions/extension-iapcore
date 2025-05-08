package extension.iapcore.apple;

#if (ios || tvos)
/**
 * Represents an error that occurred during an in-app operation on iOS using StoreKit.
 */
class IAPError
{
	/**
	 * A human-readable message describing the error.
	 */
	public final message:String;

	/**
	 * The numeric error code associated with the failure.
	 */
	public final code:Int;

	@:allow(extension.iapcore.apple.IAPApple)
	@:allow(extension.iapcore.apple.IAPPurchase)
	private function new(message:String, code:Int):Void
	{
		this.message = message;
		this.code = code;
	}

	/**
	 * Returns a string representation of the `IAPError` object.
	 * 
	 * @return A string containing all the properties of the `IAPError` object.
	 */
	@:keep
	public function toString():String
	{
		return 'Error Code: $code, Description: $message';
	}
}
#end
