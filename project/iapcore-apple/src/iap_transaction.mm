#import "iap_transaction.hpp"

#import <StoreKit/StoreKit.h>

struct IAPTransaction
{
	SKPaymentTransaction* transaction;
};

const char* IAP_GetTransactionIdentifier(IAPTransaction* transaction)
{
	return transaction ? [transaction->transaction.transactionIdentifier UTF8String] : nullptr;
}

const char* IAP_GetTransactionDate(IAPTransaction* transaction)
{
	if (transaction && transaction->transaction.transactionDate)
	{
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		formatter.dateStyle = NSDateFormatterMediumStyle;
		formatter.timeStyle = NSDateFormatterMediumStyle;
		return [[formatter stringFromDate:transaction->transaction.transactionDate] UTF8String];
	}

	return nullptr;
}

int IAP_GetTransactionState(IAPTransaction* transaction)
{
	return transaction ? (int) transaction->transaction.transactionState : -1;
}

const char* IAP_GetTransactionPaymentProductIdentifier(IAPTransaction* transaction)
{
	return transaction ? [transaction->transaction.payment.productIdentifier UTF8String] : nullptr;
}

int IAP_GetTransactionPaymentQuantity(IAPTransaction* transaction)
{
	return transaction ? (int)transaction->transaction.payment.quantity : -1;
}

void IAP_ReleaseTransaction(IAPTransaction* transaction)
{
	if (transaction)
	{
#if !__has_feature(objc_arc)
		[transaction->transaction release];
#endif

		delete transaction;
	}
}
