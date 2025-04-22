package extension.iapcore.android;

#if android
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
	public static final onBillingSetupFinished:Event<IAPResult->Void> = new Event<IAPResult->Void>();

	/** Event triggered when the billing service is disconnected. */
	public static final onBillingServiceDisconnected:Event<Void->Void> = new Event<Void->Void>();

	/** Event triggered when product details are received. */
	public static final onProductDetailsResponse:Event<IAPResult->Array<IAPProductDetails>->Void> = new Event<IAPResult->Array<IAPProductDetails>->Void>();

	/** Event triggered when the list of purchases is updated. */
	public static final onQueryPurchasesResponse:Event<IAPResult->Array<IAPPurchase>->Void> = new Event<IAPResult->Array<IAPPurchase>->Void>();

	/** Event triggered when a purchase is updated. */
	public static final onPurchasesUpdated:Event<IAPResult->Array<IAPPurchase>->Void> = new Event<IAPResult->Array<IAPPurchase>->Void>();

	/** Event triggered when a purchase is consumed. */
	public static final onConsumeResponse:Event<IAPResult->String->Void> = new Event<IAPResult->String->Void>();

	/** Event triggered when a purchase is acknowledged. */
	public static final onAcknowledgePurchaseResponse:Event<IAPResult->Void> = new Event<IAPResult->Void>();

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
	 * @return The result of the operation as an IAPResult.
	 */
	public static function launchPurchaseFlow(productDetails:IAPProductDetails, ?isOfferPersonalized:Bool = true):IAPResult
	{
		if (productDetails != null && productDetails.handle != null)
		{
			final launchPurchaseFlowJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'launchPurchaseFlow',
				'(Lcom/android/billingclient/api/ProductDetails;Z)Lcom/android/billingclient/api/BillingResult;');

			if (launchPurchaseFlowJNI != null)
				return new IAPResult(launchPurchaseFlowJNI(productDetails.handle, isOfferPersonalized));
		}

		return new IAPResult(null);
	}

	/**
	 * Consumes a purchase, making it available for repurchase.
	 * 
	 * @param purchaseToken The token that identifies the purchase to be consumed.
	 */
	public static function consumePurchase(purchaseToken:String):Void
	{
		final consumePurchaseJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'consumePurchase', '(Ljava/lang/String;)V');

		if (consumePurchaseJNI != null)
			consumePurchaseJNI(purchaseToken);
	}

	/**
	 * Acknowledges a purchase to confirm it has been granted to the user.
	 * 
	 * @param purchaseToken The token that identifies the purchase to be acknowledged.
	 */
	public static function acknowledgePurchase(purchaseToken:String):Void
	{
		final acknowledgePurchaseJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'acknowledgePurchase', '(Ljava/lang/String;)V');

		if (acknowledgePurchaseJNI != null)
			acknowledgePurchaseJNI(purchaseToken);
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
	public function onPurchasesUpdated(result:Dynamic, purchases:Dynamic):Void
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

			IAPAndroid.onPurchasesUpdated.dispatch(new IAPResult(result), purchasesArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onBillingSetupFinished(result:Dynamic):Void
	{
		if (IAPAndroid.onBillingSetupFinished != null)
			IAPAndroid.onBillingSetupFinished.dispatch(new IAPResult(result));
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
	public function onProductDetailsResponse(result:Dynamic, productDetailsList:Dynamic):Void
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

			IAPAndroid.onProductDetailsResponse.dispatch(new IAPResult(result), productDetailsArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onQueryPurchasesResponse(result:Dynamic, purchases:Dynamic):Void
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

			IAPAndroid.onQueryPurchasesResponse.dispatch(new IAPResult(result), purchasesArray);
		}
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onConsumeResponse(result:Dynamic, purchaseToken:String):Void
	{
		if (IAPAndroid.onConsumeResponse != null)
			IAPAndroid.onConsumeResponse.dispatch(new IAPResult(result), purchaseToken);
	}

	@:keep
	#if (lime >= "8.0.0")
	@:runOnMainThread
	#end
	public function onAcknowledgePurchaseResponse(result:Dynamic):Void
	{
		if (IAPAndroid.onAcknowledgePurchaseResponse != null)
			IAPAndroid.onAcknowledgePurchaseResponse.dispatch(new IAPResult(result));
	}
}
#end
