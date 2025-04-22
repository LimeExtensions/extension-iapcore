package extension.iapcore.android;

#if android
/**
 * Possible response codes.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/BillingClient.BillingResponseCode
 */
enum abstract IAPResponseCode(Int) from Int to Int
{
	/**
	 * Success.
	 */
	final OK = 0;

	/**
	 * Transaction was canceled by the user.
	 */
	final USER_CANCELED = 1;

	/**
	 * The service is currently unavailable.
	 */
	final SERVICE_UNAVAILABLE = 2;

	/**
	 * A user billing error occurred during processing.
	 */
	final BILLING_UNAVAILABLE = 3;

	/**
	 * The requested product is not available for purchase.
	 */
	final ITEM_UNAVAILABLE = 4;

	/**
	 * Error resulting from incorrect usage of the API.
	 */
	final DEVELOPER_ERROR = 5;

	/**
	 * Fatal error during the API action.
	 */
	final ERROR = 6;

	/**
	 * The purchase failed because the item is already owned.
	 */
	final ITEM_ALREADY_OWNED = 7;

	/**
	 * Requested action on the item failed since it is not owned by the user.
	 */
	final ITEM_NOT_OWNED = 8;

	/**
	 * A network error occurred during the operation.
	 */
	final NETWORK_ERROR = 12;

	/**
	 * The requested feature is not supported by the Play Store on the current device.
	 */
	final FEATURE_NOT_SUPPORTED = -2;

	/**
	 * The app is not connected to the Play Store service via the Google Play Billing Library.
	 */
	final SERVICE_DISCONNECTED = -1;
}
#end
