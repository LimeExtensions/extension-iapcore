package extension.iapcore.ios;

#if ios
/**
 * Information about a registered product in `App Store` Connect.
 * 
 * @see https://developer.apple.com/documentation/storekit/skproduct?language=objc
 */
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:headerInclude('iap_product.hpp')
class IAPProductDetails
{
	@:allow(extension.iapcore.ios.IAPIOS)
	private var handle:cpp.Pointer<IAPProduct>;

	@:allow(extension.iapcore.ios.IAPIOS)
	private function new(handle:cpp.Pointer<IAPProduct>):Void
	{
		this.handle = handle;

		cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(finalize));
	}

	/** Returns the product identifier. */
	public function getProductIdentifier():String
	{
		if (handle != null && handle.raw != null)
			return getProductIdentifierIAP(handle.raw);

		return '';
	}

	/** Returns the localized title. */
	public function getLocalizedTitle():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedTitleIAP(handle.raw);

		return '';
	}

	/** Returns the localized description. */
	public function getLocalizedDescription():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedDescriptionIAP(handle.raw);

		return '';
	}

	/** Returns the localized title. */
	public function getLocalizedPrice():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedPriceIAP(handle.raw);

		return '';
	}

	/** Releases the internal `IAPProduct` object, freeing up memory and retaining its associated resources. */
	public function release():Void
	{
		if (handle != null && handle.raw != null)
			releaseProductIAP(handle.raw);
	}

	private static function finalize(productDetails:IAPProductDetails):Void
	{
		productDetails.release();
	}

	@:native('IAP_GetProductIdentifier')
	@:noCompletion
	extern private static function getProductIdentifierIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedTitle')
	@:noCompletion
	extern private static function getLocalizedTitleIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedDescription')
	@:noCompletion
	extern private static function getLocalizedDescriptionIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedPrice')
	@:noCompletion
	extern private static function getLocalizedPriceIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_ReleaseProduct')
	@:noCompletion
	extern private static function releaseProductIAP(product:cpp.RawPointer<IAPProduct>):Void;
}

@:allow(extension.iapcore.ios.IAPIOS)
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:headerInclude('iap_product.hpp')
@:native('IAPProduct')
extern class IAPProduct {}
#end
