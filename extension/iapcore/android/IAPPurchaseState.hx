package extension.iapcore.android;

#if android
/**
 * Possible purchase states.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/Purchase.PendingPurchaseUpdate
 */
enum abstract IAPPurchaseState(Int) from Int to Int
{
    /**
     * Purchase is pending and not yet completed to be processed by your app.
     */
    final PENDING = 2;

    /**
     * Purchase is completed.
     */
    final PURCHASED = 1;

    /**
     * Purchase with unknown state.
     */
    final UNSPECIFIED_STATE = 0;
}
#end
