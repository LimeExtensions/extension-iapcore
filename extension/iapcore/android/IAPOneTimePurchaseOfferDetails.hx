package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.system.JNI;

/**
 * Represents the offer details to buy an one-time purchase product.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/ProductDetails.OneTimePurchaseOfferDetails
 */
class IAPOneTimePurchaseOfferDetails
{
	private var handle:Dynamic;

	@:allow(extension.iapcore.android.IAPProductDetails)
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	/** Returns formatted price for the payment, including its currency sign. */
	public function getFormattedPrice():String
	{
		if (handle != null)
		{
			final getFormattedPriceMemberJNI:Null<Dynamic> = JNICache.createMemberMethod("com/android/billingclient/api/ProductDetails$OneTimePurchaseOfferDetails",
				'getFormattedPrice', '()Ljava/lang/String;');

			if (getFormattedPriceMemberJNI != null)
			{
				final getFormattedPriceJNI:Null<Dynamic> = JNI.callMember(getFormattedPriceMemberJNI, handle, []);

				if (getFormattedPriceJNI != null)
					return getFormattedPriceJNI;
			}
		}

		return '';
	}

	/** Returns the price for the payment in micro-units, where 1,000,000 micro-units equal one unit of the currency. */
	public function getPriceAmountMicros():Float
	{
		if (handle != null)
		{
			final getPriceAmountMicrosMemberJNI:Null<Dynamic> = JNICache.createMemberMethod("com/android/billingclient/api/ProductDetails$OneTimePurchaseOfferDetails",
				'getPriceAmountMicros', '()J');

			if (getPriceAmountMicrosMemberJNI != null)
			{
				final getPriceAmountMicrosJNI:Null<Dynamic> = JNI.callMember(getPriceAmountMicrosMemberJNI, handle, []);

				if (getPriceAmountMicrosJNI != null)
					return IAPUtil.getFloatFromLong(getPriceAmountMicrosJNI);
			}
		}

		return 0.0;
	}

	/** Returns the description of the product. */
	public function getPriceCurrencyCode():String
	{
		if (handle != null)
		{
			final getPriceCurrencyCodeMemberJNI:Null<Dynamic> = JNICache.createMemberMethod("com/android/billingclient/api/ProductDetails$OneTimePurchaseOfferDetails",
				'getPriceCurrencyCode', '()Ljava/lang/String;');

			if (getPriceCurrencyCodeMemberJNI != null)
			{
				final getPriceCurrencyCodeJNI:Null<Dynamic> = JNI.callMember(getPriceCurrencyCodeMemberJNI, handle, []);

				if (getPriceCurrencyCodeJNI != null)
					return getPriceCurrencyCodeJNI;
			}
		}

		return '';
	}
}
