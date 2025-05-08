#define IAPCORE_INTERNAL

#import "iap_product.hpp"
#import "iap_transaction.hpp"
#import "iap_core.hpp"

#import <StoreKit/StoreKit.h>

static const IAPCallbacks* gIAPCallbacks = nullptr;

@interface IAPDelegate : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPDelegate

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response
{
	if (gIAPCallbacks && gIAPCallbacks->onProductsReceived)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			IAPProduct** wrapped = nullptr;

			if (response.products.count > 0)
			{
				wrapped = (IAPProduct**) malloc(sizeof(IAPProduct*) * response.products.count);

				for (int i = 0; i < response.products.count; ++i)
				{
					IAPProduct* p = new IAPProduct();
					p->product = response.products[i];

#if !__has_feature(objc_arc)
					[p->product retain];
#endif

					wrapped[i] = p;
				}
			}

			gIAPCallbacks->onProductsReceived(wrapped, response.products.count);

			if (wrapped)
				free(wrapped);
		});
	}
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
	if (gIAPCallbacks && gIAPCallbacks->onProductsFailed)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			gIAPCallbacks->onProductsFailed([error.localizedDescription UTF8String], (int) error.code);
		});
	}
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray<SKPaymentTransaction*>*)transactions
{
	if (gIAPCallbacks && gIAPCallbacks->onTransactionsUpdated)
	{
		dispatch_async(dispatch_get_main_queue(), ^
		{
			IAPTransaction** wrapped = nullptr;

			if (transactions.count > 0)
			{
				wrapped = (IAPTransaction**) malloc(sizeof(IAPTransaction*) * transactions.count);

				for (int i = 0; i < transactions.count; ++i)
				{
					IAPTransaction* t = new IAPTransaction();
					t->transaction = transactions[i];

#if !__has_feature(objc_arc)
					[t->transaction retain];
#endif

					wrapped[i] = t;
				}
			}

			gIAPCallbacks->onTransactionsUpdated(wrapped, transactions.count);

			if (wrapped)
				free(wrapped);
		});
	}
}

@end

static IAPDelegate* iapDelegate = nil;

void IAP_Init(const IAPCallbacks* callbacks)
{
	gIAPCallbacks = callbacks;

	dispatch_async(dispatch_get_main_queue(), ^
	{
		if (!iapDelegate)
		{
			iapDelegate = [IAPDelegate new];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:iapDelegate];
		}
	});
}

void IAP_RequestProducts(const char** productIdentifiers, size_t count)
{
	NSMutableArray<NSString *> *productIdentifiersArray = [NSMutableArray array];

	for (size_t i = 0; i < count; ++i)
		[productIdentifiersArray addObject:[NSString stringWithUTF8String:productIdentifiers[i]]];

	dispatch_async(dispatch_get_main_queue(), ^{
		SKProductsRequest* request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdentifiersArray]];
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

bool IAP_CanMakePurchases(void)
{
	return [SKPaymentQueue canMakePayments] ? true : false;
}
