package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.system.JNI;

/**
 * Represents an in-app billing purchase.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/Purchase
 */
class IAPPurchase
{
	@:allow(extension.iapcore.android.IAPAndroid)
	private var handle:Dynamic;

	@:allow(extension.iapcore.android.IAPAndroid)
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	/** Returns the payload specified when the purchase was acknowledged or consumed. */
	public function getDeveloperPayload():String
	{
		if (handle != null)
		{
			final getDeveloperPayloadMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getDeveloperPayload',
				'()Ljava/lang/String;');

			if (getDeveloperPayloadMemberJNI != null)
			{
				final getDeveloperPayloadJNI:Null<Dynamic> = JNI.callMember(getDeveloperPayloadMemberJNI, handle, []);

				if (getDeveloperPayloadJNI != null)
					return getDeveloperPayloadJNI;
			}
		}

		return '';
	}

	/** Returns a unique order identifier for the transaction. */
	public function getOrderId():String
	{
		if (handle != null)
		{
			final getOrderIdMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getOrderId',
				'()Ljava/lang/String;');

			if (getOrderIdMemberJNI != null)
			{
				final getOrderIdJNI:Null<Dynamic> = JNI.callMember(getOrderIdMemberJNI, handle, []);

				if (getOrderIdJNI != null)
					return getOrderIdJNI;
			}
		}

		return '';
	}

	/** Returns a String in JSON format that contains details about the purchase order. */
	public function getOriginalJson():String
	{
		if (handle != null)
		{
			final getOriginalJsonMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getOriginalJson',
				'()Ljava/lang/String;');

			if (getOriginalJsonMemberJNI != null)
			{
				final getOriginalJsonJNI:Null<Dynamic> = JNI.callMember(getOriginalJsonMemberJNI, handle, []);

				if (getOriginalJsonJNI != null)
					return getOriginalJsonJNI;
			}
		}

		return '';
	}

	/** Returns the application package from which the purchase originated. */
	public function getPackageName():String
	{
		if (handle != null)
		{
			final getPackageNameMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getPackageName',
				'()Ljava/lang/String;');

			if (getPackageNameMemberJNI != null)
			{
				final getPackageNameJNI:Null<Dynamic> = JNI.callMember(getPackageNameMemberJNI, handle, []);

				if (getPackageNameJNI != null)
					return getPackageNameJNI;
			}
		}

		return '';
	}

	/** Returns the PendingPurchaseUpdate for an uncommitted transaction. */
	public function getPendingPurchaseUpdate():Null<IAPPurchasePendingUpdate>
	{
		if (handle != null)
		{
			final getPendingPurchaseUpdateMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase',
				'getPendingPurchaseUpdate', "()Lcom/android/billingclient/api/Purchase$PendingPurchaseUpdate;");

			if (getPendingPurchaseUpdateMemberJNI != null)
			{
				final getPendingPurchaseUpdateJNI:Null<Dynamic> = JNI.callMember(getPendingPurchaseUpdateMemberJNI, handle, []);

				if (getPendingPurchaseUpdateJNI != null)
					return new IAPPurchasePendingUpdate(getPendingPurchaseUpdateJNI);
			}
		}

		return null;
	}

	/** Returns the product Ids. */
	public function getProducts():Array<String>
	{
		if (handle != null)
		{
			final getProductsMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getProducts',
				'()Ljava/util/List;');

			if (getProductsMemberJNI != null)
			{
				final getProductsJNI:Null<Dynamic> = JNI.callMember(getProductsMemberJNI, handle, []);

				if (getProductsJNI != null)
					return IAPUtil.getStringArrayFromList(getProductsJNI);
			}
		}

		return [];
	}

	/** Returns one of PurchaseState indicating the state of the purchase. */
	public function getPurchaseState():IAPPurchaseState
	{
		if (handle != null)
		{
			final getPurchaseStateMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getPurchaseState', '()I');

			if (getPurchaseStateMemberJNI != null)
			{
				final getPurchaseStateJNI:Null<Dynamic> = JNI.callMember(getPurchaseStateMemberJNI, handle, []);

				if (getPurchaseStateJNI != null)
					return getPurchaseStateJNI;
			}
		}

		return IAPPurchaseState.UNSPECIFIED_STATE;
	}

	/** Returns the time the product was purchased, in milliseconds since the epoch (Jan 1, 1970). */
	public function getPurchaseTime():Float
	{
		if (handle != null)
		{
			final getPurchaseTimeMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getPurchaseTime', '()J');

			if (getPurchaseTimeMemberJNI != null)
			{
				final getPurchaseTimeJNI:Null<Dynamic> = JNI.callMember(getPurchaseTimeMemberJNI, handle, []);

				if (getPurchaseTimeJNI != null)
					return IAPUtil.getFloatFromLong(getPurchaseTimeJNI);
			}
		}

		return 0.0;
	}

	/** Returns a token that uniquely identifies a purchase for a given item and user pair. */
	public function getPurchaseToken():String
	{
		if (handle != null)
		{
			final getPurchaseTokenMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getPurchaseToken',
				'()Ljava/lang/String;');

			if (getPurchaseTokenMemberJNI != null)
			{
				final getPurchaseTokenJNI:Null<Dynamic> = JNI.callMember(getPurchaseTokenMemberJNI, handle, []);

				if (getPurchaseTokenJNI != null)
					return getPurchaseTokenJNI;
			}
		}

		return '';
	}

	/** Returns the quantity of the purchased product. */
	public function getQuantity():Int
	{
		if (handle != null)
		{
			final getQuantityMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getQuantity', '()I');

			if (getQuantityMemberJNI != null)
			{
				final getQuantityJNI:Null<Dynamic> = JNI.callMember(getQuantityMemberJNI, handle, []);

				if (getQuantityJNI != null)
					return getQuantityJNI;
			}
		}

		return 0;
	}

	/** Returns String containing the signature of the purchase data that was signed with the private key of the developer. */
	public function getSignature():String
	{
		if (handle != null)
		{
			final getSignatureMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'getSignature',
				'()Ljava/lang/String;');

			if (getSignatureMemberJNI != null)
			{
				final getSignatureJNI:Null<Dynamic> = JNI.callMember(getSignatureMemberJNI, handle, []);

				if (getSignatureJNI != null)
					return getSignatureJNI;
			}
		}

		return '';
	}

	/** Indicates whether the purchase has been acknowledged. */
	public function isAcknowledged():Bool
	{
		if (handle != null)
		{
			final isAcknowledgedMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'isAcknowledged', '()Z');

			if (isAcknowledgedMemberJNI != null)
			{
				final isAcknowledgedJNI:Null<Dynamic> = JNI.callMember(isAcknowledgedMemberJNI, handle, []);

				if (isAcknowledgedJNI != null)
					return isAcknowledgedJNI;
			}
		}

		return false;
	}

	/** Returns the hash code of the purchase object. */
	public function hashCode():Int
	{
		if (handle != null)
		{
			final hashCodeMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'hashCode', '()I');

			if (hashCodeMemberJNI != null)
			{
				final hashCodeJNI:Null<Dynamic> = JNI.callMember(hashCodeMemberJNI, handle, []);

				if (hashCodeJNI != null)
					return hashCodeJNI;
			}
		}

		return 0;
	}

	/** Returns the string representation of the purchase object. */
	@:keep
	public function toString():String
	{
		if (handle != null)
		{
			final toStringMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/Purchase', 'toString', '()Ljava/lang/String;');

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
