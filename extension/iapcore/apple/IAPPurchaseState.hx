package extension.iapcore.apple;

#if (cpp && (ios || tvos))
enum abstract IAPPurchaseState(Int) from Int to Int
{
	final PURCHASING = 0;
	final PURCHASED = 1;
	final FAILED = 2;
	final RESTORED = 3;
	final DEFERRED = 4;
}
#end
