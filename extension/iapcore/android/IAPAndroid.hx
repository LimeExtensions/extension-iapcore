package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.app.Event;

/**
 * A class for managing in-app purchases on Android using Google Play Billing.
 */
class IAPAndroid
{
	/** Event for logging debug messages. */
	public static final onLog:Event<String->Void> = new Event<String->Void>();

	/** Event triggered when the billing setup is complete. */
	public static final onBillingSetupFinished:Event<IAPResponseCode->String->Void> = new Event<IAPResponseCode->String->Void>();

	/** Event triggered when the billing service is disconnected. */
	public static final onBillingServiceDisconnected:Event<Void->Void> = new Event<Void->Void>();

	/** Event triggered when product details are received. */
	public static final onProductDetailsResponse:Event<IAPResponseCode->Array<IAPProductDetails>->Void> = new Event<IAPResponseCode->Array<IAPProductDetails>->
		Void>();

	/** Event triggered when the list of purchases is updated. */
	public static final onQueryPurchasesResponse:Event<IAPResponseCode->Array<IAPPurchase>->Void> = new Event<IAPResponseCode->Array<IAPPurchase>->Void>();

	/** Event triggered when a purchase is updated. */
	public static final onPurchasesUpdated:Event<IAPResponseCode->Array<IAPPurchase>->Void> = new Event<IAPResponseCode->Array<IAPPurchase>->Void>();

	/** Event triggered when a purchase is consumed. */
	public static final onConsumeResponse:Event<IAPResponseCode->String->Void> = new Event<IAPResponseCode->String->Void>();

	/** Event triggered when a purchase is acknowledged. */
	public static final onAcknowledgePurchaseResponse:Event<IAPResponseCode->Void> = new Event<IAPResponseCode->Void>();

	/**
	 * Initializes the billing system. Call this before using any other methods.
	 */
	public static function init():Void
	{
		final initJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'init', '(Lorg/haxe/lime/HaxeObject;)V');

		if (initJNI != null)
			initJNI(new IAPAndroidCallbackObject());
	}

	/**
	 * Starts the connection to the billing service.
	 */
	public static function startConnection():Void
	{
		final startConnectionJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'startConnection', '()V');

		if (startConnectionJNI != null)
			startConnectionJNI();
	}

	/**
	 * Gets the current connection state of the billing service.
	 * 
	 * @return The connection state as an IAPConnectionState.
	 */
	public static function getConnectionState():IAPConnectionState
	{
		final getConnectionStateJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'getConnectionState', '()I');

		if (getConnectionStateJNI != null)
			return getConnectionStateJNI();

		return IAPConnectionState.DISCONNECTED;
	}

	/**
	 * Ends the connection to the billing service.
	 */
	public static function endConnection():Void
	{
		final endConnectionJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'endConnection', '()V');

		if (endConnectionJNI != null)
			endConnectionJNI();
	}

	/**
	 * Queries details for a list of products.
	 * 
	 * @param productIds The IDs of the products to query.
	 */
	public static function queryProductDetails(productIds:Array<String>):Void
	{
		final queryProductDetailsJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'queryProductDetails', '([Ljava/lang/String;)V');

		if (queryProductDetailsJNI != null)
			queryProductDetailsJNI(productIds);
	}

	/**
	 * Queries the list of purchases made by the user.
	 */
	public static function queryPurchases():Void
	{
		final queryPurchasesJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'queryPurchases', '()V');

		if (queryPurchasesJNI != null)
			queryPurchasesJNI();
	}

	/**
	 * Starts the purchase flow for a product.
	 * 
	 * @param productDetails The details of the product to purchase.
	 * @param isOfferPersonalized Whether the price is personalized for the user (default is true).
	 * @return The result of the operation as an IAPResponseCode.
	 */
	public static function launchPurchaseFlow(productDetails:IAPProductDetails, ?isOfferPersonalized:Bool = true):IAPResponseCode
	{
		if (productDetails != null && productDetails.handle != null)
		{
			final launchPurchaseFlowJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'launchPurchaseFlow',
				'(Lcom/android/billingclient/api/ProductDetails;Z)I');

			if (launchPurchaseFlowJNI != null)
				return launchPurchaseFlowJNI(productDetails.handle, isOfferPersonalized);
		}

		return IAPResponseCode.DEVELOPER_ERROR;
	}

	/**
	 * Consumes a purchase, making it available for repurchase.
	 * 
	 * @param purchase The purchase to consume.
	 */
	public static function consumePurchase(purchase:IAPPurchase):Void
	{
		if (purchase != null && purchase.handle != null)
		{
			final consumePurchaseJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'consumePurchase',
				'(Lcom/android/billingclient/api/Purchase;)V');

			if (consumePurchaseJNI != null)
				consumePurchaseJNI(purchase.handle);
		}
	}

	/**
	 * Acknowledges a purchase to confirm it has been granted to the user.
	 * 
	 * @param purchase The purchase to acknowledge.
	 */
	public static function acknowledgePurchase(purchase:IAPPurchase):Void
	{
		if (purchase != null && purchase.handle != null)
		{
			final acknowledgePurchaseJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'acknowledgePurchase',
				'(Lcom/android/billingclient/api/Purchase;)V');

			if (acknowledgePurchaseJNI != null)
				acknowledgePurchaseJNI(purchase.handle);
		}
	}
}

@:noCompletion
private class IAPAndroidCallbackObject #if (lime >= "8.0.0") implements lime.system.JNI.JNISafety #end
{
	public function new():Void {}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onLog(log:String):Void
	{
		if (IAPAndroid.onLog != null)
			IAPAndroid.onLog.dispatch(log);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onPurchasesUpdated(code:IAPResponseCode, purchases:Dynamic):Void
	{
		if (IAPAndroid.onPurchasesUpdated != null)
		{
			final purchasesArray:Array<IAPPurchase> = [];

			{
				final nativePurchasesList:Null<Array<Dynamic>> = cast(purchases, Array<Dynamic>);

				if (nativePurchasesList != null)
				{
					for (purchase in nativePurchasesList)
						purchasesArray.push(new IAPPurchase(purchase));
				}
			}

			IAPAndroid.onPurchasesUpdated.dispatch(code, purchasesArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onBillingSetupFinished(code:IAPResponseCode, message:String):Void
	{
		if (IAPAndroid.onBillingSetupFinished != null)
			IAPAndroid.onBillingSetupFinished.dispatch(code, message);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onBillingServiceDisconnected():Void
	{
		if (IAPAndroid.onBillingServiceDisconnected != null)
			IAPAndroid.onBillingServiceDisconnected.dispatch();
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onProductDetailsResponse(code:IAPResponseCode, productDetailsList:Dynamic):Void
	{
		if (IAPAndroid.onProductDetailsResponse != null)
		{
			final productDetailsArray:Array<IAPProductDetails> = [];

			{
				final nativeProductDetailsList:Null<Array<Dynamic>> = cast(productDetailsList, Array<Dynamic>);

				if (nativeProductDetailsList != null)
				{
					for (productDetails in nativeProductDetailsList)
						productDetailsArray.push(new IAPProductDetails(productDetails));
				}
			}

			IAPAndroid.onProductDetailsResponse.dispatch(code, productDetailsArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onQueryPurchasesResponse(code:IAPResponseCode, purchases:Dynamic):Void
	{
		if (IAPAndroid.onQueryPurchasesResponse != null)
		{
			final purchasesArray:Array<IAPPurchase> = [];

			{
				final nativePurchasesList:Null<Array<Dynamic>> = cast(purchases, Array<Dynamic>);

				if (nativePurchasesList != null)
				{
					for (purchase in nativePurchasesList)
						purchasesArray.push(new IAPPurchase(purchase));
				}
			}

			IAPAndroid.onQueryPurchasesResponse.dispatch(code, purchasesArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onConsumeResponse(code:IAPResponseCode, purchaseToken:String):Void
	{
		if (IAPAndroid.onConsumeResponse != null)
			IAPAndroid.onConsumeResponse.dispatch(code, purchaseToken);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onAcknowledgePurchaseResponse(code:IAPResponseCode):Void
	{
		if (IAPAndroid.onAcknowledgePurchaseResponse != null)
			IAPAndroid.onAcknowledgePurchaseResponse.dispatch(code);
	}
}
