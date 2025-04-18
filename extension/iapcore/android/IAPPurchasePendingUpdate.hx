package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.system.JNI;

/**
 * Represents a pending change/update to the existing purchase.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/Purchase.PendingPurchaseUpdate
 */
class IAPPurchasePendingUpdate
{
	@:allow(extension.iapcore.android.IAPPurchase)
	private var handle:Dynamic;

	@:allow(extension.iapcore.android.IAPPurchase)
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	/** Returns the product ids associated with this pending transaction. */
	public function getProducts():Array<String>
	{
		if (handle != null)
		{
			final getProductsMemberJNI:Null<Dynamic> = JNICache.createMemberMethod("com/android/billingclient/api/Purchase$PendingPurchaseUpdate",
				'getProducts', '()Ljava/util/List;');

			if (getProductsMemberJNI != null)
			{
				final getProductsJNI:Null<Dynamic> = JNI.callMember(getProductsMemberJNI, handle, []);

				if (getProductsJNI != null)
					return IAPUtil.getStringArrayFromList(getProductsJNI);
			}
		}

		return [];
	}

	/** Returns a token that uniquely identifies this pending transaction. */
	public function getPurchaseToken():String
	{
		if (handle != null)
		{
			final getPurchaseTokenMemberJNI:Null<Dynamic> = JNICache.createMemberMethod("com/android/billingclient/api/Purchase$PendingPurchaseUpdate",
				'getPurchaseToken', '()Ljava/lang/String;');

			if (getPurchaseTokenMemberJNI != null)
			{
				final getPurchaseTokenJNI:Null<Dynamic> = JNI.callMember(getPurchaseTokenMemberJNI, handle, []);

				if (getPurchaseTokenJNI != null)
					return getPurchaseTokenJNI;
			}
		}

		return '';
	}
}
