package extension.iapcore.apple;

#if (cpp && (ios || tvos))
import extension.iapcore.apple.IAPProductDetails;
import extension.iapcore.apple.IAPPurchase;
import haxe.MainLoop;
import lime.app.Event;

@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-apple/Build.xml" />')
@:headerInclude('iap.hpp')
class IAPApple
{
	public static final onProductDetailsReceived:Event<Array<IAPProductDetails>->Void> = new Event<Array<IAPProductDetails>->Void>();
	public static final onPurchasesUpdated:Event<Array<IAPPurchase>->Void> = new Event<Array<IAPPurchase>->Void>();

	public static function init():Void
	{
		initIAP(cpp.Callable.fromStaticFunction(onIAPProductsReceived), cpp.Callable.fromStaticFunction(onIAPTransactionsUpdated));
	}

	public static function requestProducts(productIdentifiers:Array<String>):Void
	{
		var ptr:cpp.RawPointer<cpp.ConstCharStar> = untyped __cpp__('new const char *[{0}]', productIdentifiers.length);

		for (i in 0...productIdentifiers.length)
			ptr[i] = cpp.ConstCharStar.fromString(productIdentifiers[i]);

		requestProductsIAP(ptr, productIdentifiers.length);

		untyped __cpp__('delete[] {0}', ptr);
	}

	public static function purchaseProduct(product:IAPProductDetails):Void
	{
		if (product != null && product.handle != null && product.handle.raw != null)
			purchaseProductIAP(product.handle.raw);
	}

	public static function restorePurchases():Void
	{
		restorePurchasesIAP();
	}

	@:noCompletion
	private static function onIAPProductsReceived(nativeProducts:cpp.RawPointer<cpp.RawPointer<IAPProduct>>, count:Int):Void
	{
		MainLoop.runInMainThread(function():Void
		{
			final products:Array<IAPProductDetails> = [];

			for (i in 0...count)
				products.push(new IAPProductDetails(cpp.Pointer.fromRaw(nativeProducts[i])));

			onProductDetailsReceived.dispatch(products);
		});
	}

	@:noCompletion
	private static function onIAPTransactionsUpdated(nativeTransactions:cpp.RawPointer<cpp.RawPointer<IAPTransaction>>, count:Int):Void
	{
		MainLoop.runInMainThread(function():Void
		{
			final purchases:Array<IAPPurchase> = [];

			for (i in 0...count)
				purchases.push(new IAPPurchase(cpp.Pointer.fromRaw(nativeTransactions[i])));

			onPurchasesUpdated.dispatch(purchases);
		});
	}

	@:native('IAP_Init')
	extern public static function initIAP(onProductsReceived:cpp.Callable<(products:cpp.RawPointer<cpp.RawPointer<IAPProduct>>, count:Int) -> Void>,
		onTransactionsUpdated:cpp.Callable<(transactions:cpp.RawPointer<cpp.RawPointer<IAPTransaction>>, count:Int) -> Void>):Void;

	@:native('IAP_RequestProducts')
	extern public static function requestProductsIAP(productIdentifiers:cpp.RawPointer<cpp.ConstCharStar>, count:Int):Void;

	@:native('IAP_PurchaseProduct')
	extern public static function purchaseProductIAP(product:cpp.RawPointer<IAPProduct>):Void;

	@:native('IAP_RestorePurchases')
	extern public static function restorePurchasesIAP():Void;
}
#end
