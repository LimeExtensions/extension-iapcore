package extension.iapcore.ios;

#if ios
/**
 * Values representing the state of a transaction.
 * 
 * @see https://developer.apple.com/documentation/storekit/skpaymenttransactionstate?language=objc
 */
enum abstract IAPPurchaseState(Int) from Int to Int
{
	/**
	 * A transaction that is being processed by the `App Store`.
	 */
	final PURCHASING = 0;

	/**
	 * A successfully processed transaction.
	 */
	final PURCHASED = 1;

	/**
	 * A failed transaction.
	 */
	final FAILED = 2;

	/**
	 * A transaction that restores content previously purchased by the user.
	 */
	final RESTORED = 3;

	/**
	 * A transaction that is in the queue, but its final status is pending external action such as "Ask to Buy".
	 */
	final DEFERRED = 4;
}
#end
