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

void IAP_ReleaseTransaction(IAPTransaction* transaction)
{
	if (transaction)
	{
		[transaction->transaction release];

		delete transaction;
	}
}
