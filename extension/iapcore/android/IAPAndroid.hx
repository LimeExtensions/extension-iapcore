package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.app.Event;

class IAPAndroid
{
	/** Logs messages for debugging purposes. */
	public static final onLog:Event<String->Void> = new Event<String->Void>();

	/** Triggered when the billing setup process is finished. */
	public static final onBillingSetupFinished:Event<IAPResponseCode->String->Void> = new Event<IAPResponseCode->String->Void>();

	/** Triggered when the billing service is disconnected. */
	public static final onBillingServiceDisconnected:Event<Void->Void> = new Event<Void->Void>();

	/** Triggered when product details are received. */
	public static final onProductDetailsResponse:Event<IAPResponseCode->Array<IAPProductDetails>->Void> = new Event<IAPResponseCode->Array<IAPProductDetails>->
		Void>();

	/** Triggered when purchases are updated. */
	public static final onQueryPurchasesResponse:Event<IAPResponseCode->Array<IAPPurchase>->Void> = new Event<IAPResponseCode->Array<IAPPurchase>->Void>();

	/** Triggered when purchases are updated. */
	public static final onPurchasesUpdated:Event<IAPResponseCode->Array<IAPPurchase>->Void> = new Event<IAPResponseCode->Array<IAPPurchase>->Void>();

	/** Triggered when a purchase consumption is completed. */
	public static final onConsumeResponse:Event<IAPResponseCode->String->Void> = new Event<IAPResponseCode->String->Void>();

	/** Triggered when a purchase acknowledgment is completed. */
	public static final onAcknowledgePurchaseResponse:Event<IAPResponseCode->Void> = new Event<IAPResponseCode->Void>();

	/**
	 * Initializes the in-app purchase system.
	 * 
	 * This function sets up the necessary connections and prepares the system for subsequent operations.
	 * 
	 * It should be called before any other in-app purchase operations.
	 */
	public static function init():Void
	{
		final initJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'init', '(Lorg/haxe/lime/HaxeObject;)V');

		if (initJNI != null)
			initJNI(new IAPAndroidCallbackObject());
	}

	/**
	 * Starts the connection to the billing service.
	 * 
	 * This function establishes a connection to the Google Play Billing service, enabling the app to perform in-app purchase operations.
	 * 
	 * It should be called before initiating any purchase flows.
	 */
	public static function startConnection():Void
	{
		final startConnectionJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'startConnection', '()V');

		if (startConnectionJNI != null)
			startConnectionJNI();
	}

	/**
	 * Ends the connection to the billing service.
	 * 
	 * This function terminates the connection to the Google Play Billing service.
	 * 
	 * It should be called when the app no longer needs to perform in-app purchase operations.
	 */
	public static function endConnection():Void
	{
		final endConnectionJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'endConnection', '()V');

		if (endConnectionJNI != null)
			endConnectionJNI();
	}

	/**
	 * Queries product details for a list of product IDs.
	 * 
	 * This function retrieves detailed information about the specified products, such as their titles, descriptions, and prices.
	 * 
	 * It should be called before initiating a purchase flow for any product.
	 * 
	 * @param productIds An array of product IDs to query.
	 */
	public static function queryProductDetails(productIds:Array<String>):Void
	{
		final queryProductDetailsJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'queryProductDetails', '([Ljava/lang/String;)V');

		if (queryProductDetailsJNI != null)
			queryProductDetailsJNI(productIds);
	}

	/**
	 * Queries existing purchases made by the user.
	 * 
	 * This function retrieves the list of purchases that the user has already made and are still owned.
	 * 
	 * Useful for restoring purchases or checking entitlement status.
	 */
	public static function queryPurchases():Void
	{
		final queryPurchasesJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCore', 'queryPurchases', '()V');

		if (queryPurchasesJNI != null)
			queryPurchasesJNI();
	}

	/**
	 * Initiates the Google Play Billing purchase flow for a specified product.
	 *
	 * @param productDetails The product details to be purchased. Must not be null and must have a valid handle.
	 * @param isOfferPersonalized Optional. Indicates whether the price is personalized for the user.
	 *                            Defaults to true. When set to true, and if the app is distributed in the European Union,
	 *                            the Google Play purchase screen will display a disclosure indicating that the price
	 *                            has been personalized using automated decision-making, in compliance with
	 *                            Article 6(1)(ea) of the EU Consumer Rights Directive 2011/83/EU.
	 *                            If set to false, no such disclosure will be shown.
	 *                            Refer to the [Android Developers documentation](https://developer.android.com/google/play/billing/integrate) for more details.
	 *
	 * @return An IAPResponseCode indicating the result of the operation. Returns DEVELOPER_ERROR if the product details are invalid or if the JNI method is not found.
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
	 * Consumes a given purchase.
	 * 
	 * This function marks an in-app product as consumed, making it available for repurchase.
	 * 
	 * It is typically used for consumable products like coins, lives, or other single-use items.
	 * 
	 * @param purchase The purchase object to consume.
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
	 * Acknowledges a given purchase.
	 * 
	 * This function is used to acknowledge a purchase, confirming that the item has been granted to the user.
	 * 
	 * Required for all non-consumable purchases and subscriptions within 3 days, or the purchase is automatically refunded.
	 * 
	 * @param purchase The purchase object to acknowledge.
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
