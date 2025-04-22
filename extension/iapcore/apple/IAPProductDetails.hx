package extension.iapcore.apple;

#if (cpp && (ios || tvos))
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap.hpp')
class IAPProductDetails
{
	@:allow(extension.iapcore.apple.IAPApple)
	private var handle:cpp.Pointer<IAPProduct>;

	@:allow(extension.iapcore.apple.IAPApple)
	private function new(handle:cpp.Pointer<IAPProduct>):Void
	{
		this.handle = handle;

		cpp.vm.Gc.setFinalizer(this, cpp.Function.fromStaticFunction(finalize));
	}

	public function getProductIdentifier():String
	{
		if (handle != null && handle.raw != null)
			return getProductIdentifierIAP(handle.raw);

		return '';
	}

	public function getLocalizedTitle():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedTitleIAP(handle.raw);

		return '';
	}

	public function getLocalizedDescription():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedDescriptionIAP(handle.raw);

		return '';
	}

	public function getLocalizedPrice():String
	{
		if (handle != null && handle.raw != null)
			return getLocalizedPriceIAP(handle.raw);

		return '';
	}

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
	extern public static function getProductIdentifierIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedTitle')
	extern public static function getLocalizedTitleIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedDescription')
	extern public static function getLocalizedDescriptionIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_GetLocalizedPrice')
	extern public static function getLocalizedPriceIAP(product:cpp.RawPointer<IAPProduct>):cpp.ConstCharStar;

	@:native('IAP_ReleaseProduct')
	extern public static function releaseProductIAP(product:cpp.RawPointer<IAPProduct>):Void;
}

@:allow(extension.iapcore.apple.IAPApple)
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap.hpp')
@:native('IAPProduct')
extern class IAPProduct {}
#end
