package extension.iapcore.ios;

#if ios
/**
 * An object in the payment queue.
 * 
 * @see https://developer.apple.com/documentation/storekit/skpaymenttransaction?language=objc
 */
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:headerInclude('iap_transaction.hpp')
class IAPPurchase
{
	@:allow(extension.iapcore.ios.IAPIOS)
	private var handle:cpp.Pointer<IAPTransaction>;

	@:allow(extension.iapcore.ios.IAPIOS)
	private function new(handle:cpp.Pointer<IAPTransaction>):Void
	{
		this.handle = handle;
	}

	/** Returns the transaction identifier. */
	public function getTransactionIdentifier():String
	{
		if (handle != null && handle.raw != null)
			return getTransactionIdentifierIAP(handle.raw);

		return '';
	}

	/** Returns the transaction date. */
	public function getTransactionDate():String
	{
		if (handle != null && handle.raw != null)
			return getTransactionDateIAP(handle.raw);

		return '';
	}

	/** Returns the transaction state. */
	public function getTransactionState():IAPPurchaseState
	{
		if (handle != null && handle.raw != null)
			return getTransactionStateIAP(handle.raw);

		return IAPPurchaseState.FAILED;
	}

	/** Returns the transaction error, if any. */
	public function getTransactionError():IAPError
	{
		var message:String = 'Unknown transaction error.';
		var code:Int = -1;

		if (handle != null && handle.raw != null)
			message = getTransactionErrorIAP(handle.raw, cpp.Pointer.addressOf(code).raw);

		return new IAPError(message, code);
	}

	/** Returns the product identifier of the payment. */
	public function getPaymentProductIdentifier():String
	{
		if (handle != null && handle.raw != null)
			return getTransactionPaymentProductIdentifierIAP(handle.raw);

		return '';
	}

	/** Returns the quantity of the payment. */
	public function getPaymentQuantity():IAPPurchaseState
	{
		if (handle != null && handle.raw != null)
			return getTransactionPaymentQuantityIAP(handle.raw);

		return -1;
	}

	/** Releases the internal `IAPTransaction` object, freeing up memory and retaining its associated resources. */
	public function release():Void
	{
		if (handle != null && handle.raw != null)
			releaseTransactionIAP(handle.raw);
	}

	@:native('IAP_GetTransactionIdentifier')
	@:noCompletion
	extern private static function getTransactionIdentifierIAP(transaction:cpp.RawPointer<IAPTransaction>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionDate')
	@:noCompletion
	extern private static function getTransactionDateIAP(transaction:cpp.RawPointer<IAPTransaction>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionState')
	@:noCompletion
	extern private static function getTransactionStateIAP(transaction:cpp.RawPointer<IAPTransaction>):Int;

	@:native('IAP_GetTransactionError')
	@:noCompletion
	extern private static function getTransactionErrorIAP(transaction:cpp.RawPointer<IAPTransaction>, outCode:cpp.RawPointer<Int>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionPaymentProductIdentifier')
	@:noCompletion
	extern private static function getTransactionPaymentProductIdentifierIAP(transaction:cpp.RawPointer<IAPTransaction>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionPaymentQuantity')
	@:noCompletion
	extern private static function getTransactionPaymentQuantityIAP(transaction:cpp.RawPointer<IAPTransaction>):Int;

	@:native('IAP_ReleaseTransaction')
	@:noCompletion
	extern private static function releaseTransactionIAP(transaction:cpp.RawPointer<IAPTransaction>):Void;
}

@:allow(extension.iapcore.ios.IAPIOS)
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:include('iap_transaction.hpp')
@:native('IAPTransaction')
extern class IAPTransaction {}
#end
