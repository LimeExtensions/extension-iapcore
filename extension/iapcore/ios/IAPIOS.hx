package extension.iapcore.ios;

#if ios
import extension.iapcore.ios.IAPProductDetails;
import extension.iapcore.ios.IAPPurchase;
import lime.app.Event;

/**
 * A class for managing in-app purchases on iOS Devices using StoreKit.
 */
@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:headerInclude('iap_core.hpp')
class IAPIOS
{
	/** Event triggered when product details are successfully received from the App Store. */
	public static final onProductDetailsReceived:Event<Array<IAPProductDetails>->Void> = new Event<Array<IAPProductDetails>->Void>();

	/** Event triggered when retrieving product details from the App Store fails. */
	public static final onProductDetailsFailed:Event<IAPError->Void> = new Event<IAPError->Void>();

	/** Event triggered when in-app purchase transactions are updated. */
	public static final onPurchasesUpdated:Event<Array<IAPPurchase>->Void> = new Event<Array<IAPPurchase>->Void>();

	/**
	 * Initializes the in-app purchase system.
	 */
	public static function init():Void
	{
		final callbacks:IAPCallbacks = new IAPCallbacks();
		callbacks.onProductsReceived = cpp.Callable.fromStaticFunction(onIAPProductsReceived);
		callbacks.onProductsFailed = cpp.Callable.fromStaticFunction(onIAPProductsFailed);
		callbacks.onTransactionsUpdated = cpp.Callable.fromStaticFunction(onIAPTransactionsUpdated);
		initIAP(cpp.RawConstPointer.addressOf(callbacks));
	}

	/**
	 * Requests product information from the `App Store` for the given product identifiers.
	 * 
	 * @param productIdentifiers Array of product identifier strings.
	 */
	public static function requestProducts(productIdentifiers:Array<String>):Void
	{
		if (productIdentifiers != null && productIdentifiers.length > 0)
		{
			final ptr:cpp.RawPointer<cpp.ConstCharStar> = untyped __cpp__('new const char *[{0}]', productIdentifiers.length);

			for (i in 0...productIdentifiers.length)
				ptr[i] = cpp.ConstCharStar.fromString(productIdentifiers[i]);

			requestProductsIAP(ptr, productIdentifiers.length);

			untyped __cpp__('delete[] {0}', ptr);
		}
	}

	/**
	 * Initiates a purchase for the specified product with optional simulation of "Ask to Buy" in the sandbox.
	 * 
	 * @param product The product to purchase.
	 * @param simulateAskToBuy If true, simulates the "Ask to Buy" flow in the sandbox environment.
	 * 
	 * The `simulatesAskToBuyInSandbox` property, when set to YES, produces an "Ask to Buy" flow for this payment in the sandbox.
	 * This is useful for testing how your app handles transactions that require parental approval.
	 * Note that this simulation only works in the sandbox and requires appropriate test account configurations.
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

	/**
	 * Checks whether the device can make purchases.
	 * 
	 * @return `true` if the device can make purchases, otherwise `false`.
	 */
	public static function canMakePurchases():Bool
	{
		return canMakePurchasesIAP();
	}

	@:noCompletion
	private static function onIAPProductsReceived(nativeProducts:cpp.RawPointer<cpp.RawPointer<IAPProduct>>, count:cpp.SizeT):Void
	{
		final products:Array<IAPProductDetails> = [];

		if (nativeProducts != null)
		{
			for (i in 0...count)
				products.push(new IAPProductDetails(cpp.Pointer.fromRaw(nativeProducts[i])));
		}

		onProductDetailsReceived.dispatch(products);
	}

	@:noCompletion
	private static function onIAPProductsFailed(message:cpp.ConstCharStar, code:Int):Void
	{
		onProductDetailsFailed.dispatch(new IAPError((message : String), code));
	}

	@:noCompletion
	private static function onIAPTransactionsUpdated(nativeTransactions:cpp.RawPointer<cpp.RawPointer<IAPTransaction>>, count:cpp.SizeT):Void
	{
		final purchases:Array<IAPPurchase> = [];

		if (nativeTransactions != null)
		{
			for (i in 0...count)
				purchases.push(new IAPPurchase(cpp.Pointer.fromRaw(nativeTransactions[i])));
		}

		onPurchasesUpdated.dispatch(purchases);
	}

	@:native('IAP_Init')
	@:noCompletion
	extern private static function initIAP(callbacks:cpp.RawConstPointer<IAPCallbacks>):Void;

	@:native('IAP_RequestProducts')
	@:noCompletion
	extern private static function requestProductsIAP(productIdentifiers:cpp.RawPointer<cpp.ConstCharStar>, count:cpp.SizeT):Void;

	@:native('IAP_PurchaseProduct')
	@:noCompletion
	extern private static function purchaseProductIAP(product:cpp.RawPointer<IAPProduct>, simulateAskToBuy:Bool):Void;

	@:native('IAP_FinishTransaction')
	@:noCompletion
	extern private static function finishTransactionIAP(transaction:cpp.RawPointer<IAPTransaction>):Void;

	@:native('IAP_RestorePurchases')
	@:noCompletion
	extern private static function restorePurchasesIAP():Void;

	@:native('IAP_CanMakePurchases')
	@:noCompletion
	extern private static function canMakePurchasesIAP():Bool;
}

@:buildXml('<include name="${haxelib:extension-iapcore}/project/iapcore-ios/Build.xml" />')
@:include('iap_core.hpp')
@:structAccess
@:native('IAPCallbacks')
extern class IAPCallbacks
{
	function new():Void;

	var onProductsReceived:cpp.Callable<(products:cpp.RawPointer<cpp.RawPointer<IAPProduct>>, count:cpp.SizeT) -> Void>;
	var onProductsFailed:cpp.Callable<(message:cpp.ConstCharStar, code:Int) -> Void>;
	var onTransactionsUpdated:cpp.Callable<(transactions:cpp.RawPointer<cpp.RawPointer<IAPTransaction>>, count:cpp.SizeT) -> Void>;
}
#end
