#import "iap_product.hpp"
#import "iap_transaction.hpp"
#import "iap_core.hpp"

#import <StoreKit/StoreKit.h>

static OnProductsReceived gOnProductsReceived = nullptr;
static OnTransactionsUpdated gOnTransactionsUpdated = nullptr;

@interface IAPDelegate : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPDelegate

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	if (gOnProductsReceived)
	{
		IAPProduct** wrapped = (IAPProduct**) malloc(sizeof(IAPProduct*) * response.products.count);

		for (int i = 0; i < response.products.count; ++i)
		{
			IAPProduct* p = new IAPProduct();

			p->product = response.products[i];

#if !__has_feature(objc_arc)
			[p->product retain];
#endif

			wrapped[i] = p;
		}

		gOnProductsReceived(wrapped, (int) response.products.count);

		free(wrapped);
	}
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray<SKPaymentTransaction*>*)transactions
{
	if (gOnTransactionsUpdated)
	{
		IAPTransaction** wrapped = (IAPTransaction**) malloc(sizeof(IAPTransaction*) * transactions.count);

		for (int i = 0; i < transactions.count; ++i)
		{
			IAPTransaction* t = new IAPTransaction();

			t->transaction = transactions[i];

#if !__has_feature(objc_arc)
            [t->transaction retain];
#endif

			wrapped[i] = t;
		}

		gOnTransactionsUpdated(wrapped, (int) transactions.count);

		free(wrapped);
	}
}

@end

static IAPDelegate* iapDelegate = nil;

void IAP_Init(OnProductsReceived onProductsReceived, OnTransactionsUpdated onTransactionsUpdated)
{
	gOnProductsReceived = onProductsReceived;
	gOnTransactionsUpdated = onTransactionsUpdated;

	dispatch_async(dispatch_get_main_queue(), ^
	{
		if (!iapDelegate)
		{
			iapDelegate = [IAPDelegate new];

			[[SKPaymentQueue defaultQueue] addTransactionObserver:iapDelegate];
		}
	});
}

void IAP_RequestProducts(const char** productIdentifiers, int count)
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		NSMutableSet* ids = [NSMutableSet set];

		for (int i = 0; i < count; ++i)
			[ids addObject:[NSString stringWithUTF8String:productIdentifiers[i]]];

		SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
		request.delegate = iapDelegate;
		[request start];
	});
}

void IAP_PurchaseProduct(IAPProduct* product, bool simulateAskToBuy)
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		if (product && product->product)
		{
			SKMutablePayment* payment = [SKMutablePayment paymentWithProduct:product->product];
			payment.simulatesAskToBuyInSandbox = simulateAskToBuy ? YES : NO;
			[[SKPaymentQueue defaultQueue] addPayment:payment];
		}
	});
}

void IAP_FinishTransaction(IAPTransaction* transaction)
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		if (transaction && transaction->transaction)
		{
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction->transaction];
		}
	});
}

void IAP_RestorePurchases(void)
{
	dispatch_async(dispatch_get_main_queue(), ^
	{
		[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
	});
}
