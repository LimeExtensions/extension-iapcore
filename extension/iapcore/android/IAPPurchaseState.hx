package extension.iapcore.android;

/**
 * Represents the states of a purchase.
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
