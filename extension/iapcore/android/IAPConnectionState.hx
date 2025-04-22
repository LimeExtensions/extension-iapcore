package extension.iapcore.android;

#if android
/**
 * Connection state of billing client.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/BillingClient.ConnectionState
 */
enum abstract IAPConnectionState(Int) from Int to Int
{
	/**
	 * This client was already closed and shouldn't be used again.
	 */
	final CLOSED = 3;

	/**
	 * This client is currently connected to billing service.
	 */
	final CONNECTED = 2;

	/**
	 * This client is currently in process of connecting to billing service.
	 */
	final CONNECTING = 1;

	/**
	 * This client was not yet connected to billing service or was already closed.
	 */
	final DISCONNECTED = 0;
}
#end
