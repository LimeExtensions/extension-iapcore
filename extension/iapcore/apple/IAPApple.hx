package extension.iapcore.apple;

#if (ios || tvos)
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

	/**
	 * Initializes the in-app purchase system.
	 */
	public static function init():Void
	{
		initIAP(cpp.Callable.fromStaticFunction(onIAPProductsReceived), cpp.Callable.fromStaticFunction(onIAPTransactionsUpdated));
	}

	/**
	 * Requests product information from the `App Store` for the given product identifiers.
	 * 
	 * @param productIdentifiers Array of product identifier strings.
	 */
	public static function requestProducts(productIdentifiers:Array<String>):Void
	{
		var ptr:cpp.RawPointer<cpp.ConstCharStar> = untyped __cpp__('new const char *[{0}]', productIdentifiers.length);

		for (i in 0...productIdentifiers.length)
			ptr[i] = cpp.ConstCharStar.fromString(productIdentifiers[i]);

		requestProductsIAP(ptr, productIdentifiers.length);

		untyped __cpp__('delete[] {0}', ptr);
	}

	/**
	 * Initiates a purchase for the specified product with optional simulation of "Ask to Buy" in the sandbox.
	 * 
	 * @param product The product to purchase.
	 * @param simulateAskToBuy If true, simulates the "Ask to Buy" flow in the sandbox environment.
	 * 
	 * @note The simulatesAskToBuyInSandbox property, when set to YES, produces an "Ask to Buy" flow for this payment in the sandbox. This is useful for testing how your app handles transactions that require parental approval. Note that this simulation only works in the sandbox and requires appropriate test account configurations.
	 * 
	 * @see https://developer.apple.com/documentation/storekit/skpayment/simulatesasktobuyinsandbox?language=objc
	 */
	public static function purchaseProduct(product:IAPProductDetails, simulateAskToBuy:Bool = false):Void
	{
		if (product != null && product.handle != null && product.handle.raw != null)
			purchaseProductIAP(product.handle.raw, simulateAskToBuy);
	}

	/**
	 * Finishes the specified transaction, removing it from the payment queue.
	 * 
	 * @param transaction The transaction to finish.
	 */
	public static function finishPurchase(purchase:IAPPurchase):Void
	{
		if (purchase != null && purchase.handle != null && purchase.handle.raw != null)
			finishTransactionIAP(purchase.handle.raw);
	}

	/**
	 * Initiates the restoration of previously completed purchases.
	 */
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
	@:noCompletion
	extern private static function initIAP(onProductsReceived:OnProductsReceived, onTransactionsUpdated:OnTransactionsUpdated):Void;

	@:native('IAP_RequestProducts')
	@:noCompletion
	extern private static function requestProductsIAP(productIdentifiers:cpp.RawPointer<cpp.ConstCharStar>, count:Int):Void;

	@:native('IAP_PurchaseProduct')
	@:noCompletion
	extern private static function purchaseProductIAP(product:cpp.RawPointer<IAPProduct>, simulateAskToBuy:Bool):Void;

	@:native('IAP_FinishTransaction')
	@:noCompletion
	extern private static function finishTransactionIAP(transaction:cpp.RawPointer<IAPTransaction>):Void;

	@:native('IAP_RestorePurchases')
	@:noCompletion
	extern private static function restorePurchasesIAP():Void;
}

private typedef OnProductsReceived = cpp.Callable<(products:cpp.RawPointer<cpp.RawPointer<IAPProduct>>, count:Int) -> Void>;
private typedef OnTransactionsUpdated = cpp.Callable<(transactions:cpp.RawPointer<cpp.RawPointer<IAPTransaction>>, count:Int) -> Void>;
#end
