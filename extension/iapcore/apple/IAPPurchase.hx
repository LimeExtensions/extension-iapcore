package extension.iapcore.apple;

#if (ios || tvos)
/**
 * An object in the payment queue.
 * 
 * @see https://developer.apple.com/documentation/storekit/skpaymenttransaction?language=objc
 */
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap_transaction.hpp')
class IAPPurchase
{
	@:allow(extension.iapcore.apple.IAPApple)
	private var handle:cpp.Pointer<IAPTransaction>;

	@:allow(extension.iapcore.apple.IAPApple)
	private function new(handle:cpp.Pointer<IAPTransaction>):Void
	{
		this.handle = handle;

		cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(finalize));
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

	private static function finalize(purchase:IAPPurchase):Void
	{
		purchase.release();
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

@:allow(extension.iapcore.apple.IAPApple)
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap_transaction.hpp')
@:native('IAPTransaction')
extern class IAPTransaction {}
#end
