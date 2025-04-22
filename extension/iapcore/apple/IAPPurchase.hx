package extension.iapcore.apple;

#if (cpp && (ios || tvos))
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap.hpp')
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

	public function getTransactionIdentifier():String
	{
		if (handle != null && handle.raw != null)
			return getTransactionIdentifierIAP(handle.raw);

		return '';
	}

	public function getTransactionDate():String
	{
		if (handle != null && handle.raw != null)
			return getTransactionDateIAP(handle.raw);

		return '';
	}

	public function getTransactionState():IAPPurchaseState
	{
		if (handle != null && handle.raw != null)
			return getTransactionStateIAP(handle.raw);

		return IAPPurchaseState.FAILED;
	}

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
	extern public static function getTransactionIdentifierIAP(transaction:cpp.RawPointer<IAPTransaction>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionDate')
	extern public static function getTransactionDateIAP(transaction:cpp.RawPointer<IAPTransaction>):cpp.ConstCharStar;

	@:native('IAP_GetTransactionState')
	extern public static function getTransactionStateIAP(transaction:cpp.RawPointer<IAPTransaction>):Int;

	@:native('IAP_ReleaseTransaction')
	extern public static function releaseTransactionIAP(transaction:cpp.RawPointer<IAPTransaction>):Void;
}

@:allow(extension.iapcore.apple.IAPApple)
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap.hpp')
@:native('IAPTransaction')
extern class IAPTransaction {}
#end
