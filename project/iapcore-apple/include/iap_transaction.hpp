#pragma once

#ifdef IAPCORE_INTERNAL
#import <StoreKit/StoreKit.h>

struct IAPTransaction
{
    SKPaymentTransaction* transaction;
};
#endif

typedef struct IAPTransaction IAPTransaction;

/**
 * Retrieves the transaction identifier for a given IAPTransaction.
 *
 * @param transaction The IAPTransaction object from which the transaction identifier is fetched.
 * @return The transaction identifier string if the transaction is valid, otherwise `nullptr`.
 */
const char* IAP_GetTransactionIdentifier(IAPTransaction* transaction);

/**
 * Retrieves the transaction date for a given IAPTransaction.
 *
 * @param transaction The IAPTransaction object from which the transaction date is fetched.
 * @return The formatted transaction date string if the transaction is valid, otherwise `nullptr`.
 */
const char* IAP_GetTransactionDate(IAPTransaction* transaction);

/**
 * Retrieves the state of a given IAPTransaction.
 *
 * @param transaction The IAPTransaction object from which the transaction state is fetched.
 * @return The state of the transaction as an integer, or -1 if the transaction is invalid.
 */
int IAP_GetTransactionState(IAPTransaction* transaction);

/**
 * Retrieves the product identifier of the payment associated with a given IAPTransaction.
 *
 * @param transaction The IAPTransaction object from which the product identifier is fetched.
 * @return The product identifier string if the transaction is valid, otherwise `nullptr`.
 */
const char* IAP_GetTransactionPaymentProductIdentifier(IAPTransaction* transaction);

/**
 * Retrieves the quantity of the payment associated with a given IAPTransaction.
 *
 * @param transaction The IAPTransaction object from which the payment quantity is fetched.
 * @return The quantity of the payment, or -1 if the transaction is invalid.
 */
int IAP_GetTransactionPaymentQuantity(IAPTransaction* transaction);

/**
 * Releases an IAPTransaction object, freeing up memory and retaining its associated resources.
 *
 * @param transaction The IAPTransaction object to be released.
 */
void IAP_ReleaseTransaction(IAPTransaction* transaction);
