package extension.iapcore.android;

#if android
import extension.iapcore.android.IAPJNICache;
import lime.system.JNI;

/**
 * Represents the details of a one time product.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/ProductDetails
 */
class IAPProductDetails
{
	@:allow(extension.iapcore.android.IAPAndroid)
	private var handle:Dynamic;

	@:allow(extension.iapcore.android.IAPAndroid)
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	/** Returns the name of the product being sold. */
	public function getName():String
	{
		if (handle != null)
		{
			final getNameMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'getName',
				'()Ljava/lang/String;');

			if (getNameMemberJNI != null)
			{
				final getNameJNI:Null<Dynamic> = JNI.callMember(getNameMemberJNI, handle, []);

				if (getNameJNI != null)
					return getNameJNI;
			}
		}

		return '';
	}

	/** Returns the description of the product. */
	public function getDescription():String
	{
		if (handle != null)
		{
			final getDescriptionMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'getDescription',
				'()Ljava/lang/String;');

			if (getDescriptionMemberJNI != null)
			{
				final getDescriptionJNI:Null<Dynamic> = JNI.callMember(getDescriptionMemberJNI, handle, []);

				if (getDescriptionJNI != null)
					return getDescriptionJNI;
			}
		}

		return '';
	}

	/** Returns the offer details of a one-time purchase product. */
	public function getOneTimePurchaseOfferDetails():Null<IAPOneTimePurchaseOfferDetails>
	{
		if (handle != null)
		{
			final getOfferDetailsMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails',
				'getOneTimePurchaseOfferDetails', "()Lcom/android/billingclient/api/ProductDetails$OneTimePurchaseOfferDetails;");

			if (getOfferDetailsMemberJNI != null)
				return new IAPOneTimePurchaseOfferDetails(JNI.callMember(getOfferDetailsMemberJNI, handle, []));
		}

		return null;
	}

	/** Returns the product's Id. */
	public function getProductId():String
	{
		if (handle != null)
		{
			final getProductIdMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'getProductId',
				'()Ljava/lang/String;');

			if (getProductIdMemberJNI != null)
			{
				final getProductIdJNI:Null<Dynamic> = JNI.callMember(getProductIdMemberJNI, handle, []);

				if (getProductIdJNI != null)
					return getProductIdJNI;
			}
		}

		return '';
	}

	/** Returns the ProductType of the product. */
	public function getProductType():String
	{
		if (handle != null)
		{
			final getProductTypeMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'getProductType',
				'()Ljava/lang/String;');

			if (getProductTypeMemberJNI != null)
			{
				final getProductTypeJNI:Null<Dynamic> = JNI.callMember(getProductTypeMemberJNI, handle, []);

				if (getProductTypeJNI != null)
					return getProductTypeJNI;
			}
		}

		return '';
	}

	/** Returns the title of the product being sold. */
	public function getTitle():String
	{
		if (handle != null)
		{
			final getTitleMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'getTitle',
				'()Ljava/lang/String;');

			if (getTitleMemberJNI != null)
			{
				final getTitleJNI:Null<Dynamic> = JNI.callMember(getTitleMemberJNI, handle, []);

				if (getTitleJNI != null)
					return getTitleJNI;
			}
		}

		return '';
	}

	/** Returns the hash code of the product details object. */
	public function hashCode():Int
	{
		if (handle != null)
		{
			final hashCodeMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'hashCode', '()I');

			if (hashCodeMemberJNI != null)
			{
				final hashCodeJNI:Null<Dynamic> = JNI.callMember(hashCodeMemberJNI, handle, []);

				if (hashCodeJNI != null)
					return hashCodeJNI;
			}
		}

		return 0;
	}

	/** Returns the string representation of the product details object. */
	@:keep
	public function toString():String
	{
		if (handle != null)
		{
			final toStringMemberJNI:Null<Dynamic> = IAPJNICache.createMemberMethod('com/android/billingclient/api/ProductDetails', 'toString',
				'()Ljava/lang/String;');

			if (toStringMemberJNI != null)
			{
				final toStringJNI:Null<Dynamic> = JNI.callMember(toStringMemberJNI, handle, []);

				if (toStringJNI != null)
					return toStringJNI;
			}
		}

		return '';
	}
}
#end
