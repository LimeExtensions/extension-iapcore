#pragma once

#include "iap_product.hpp"
#include "iap_transaction.hpp"

typedef void (*OnProductsReceived)(IAPProduct** products, int count);
typedef void (*OnTransactionsUpdated)(IAPTransaction** transactions, int count);

/**
 * Initializes the in-app purchase system with the provided callbacks.
 * 
 * @param onProductsReceived Callback for received products.
 * @param onTransactionsUpdated Callback for updated transactions.
 */
void IAP_Init(OnProductsReceived onProductsReceived, OnTransactionsUpdated onTransactionsUpdated);

/**
 * Requests product information from the App Store for the given product identifiers.
 * 
 * @param productIdentifiers Array of product identifier strings.
 * @param count Number of product identifiers.
 */
void IAP_RequestProducts(const char** productIdentifiers, int count);

/**
 * Initiates a purchase for the specified product with optional simulation of "Ask to Buy" in the sandbox.
 * 
 * @param product The product to purchase.
 * @param simulateAskToBuy If true, simulates the "Ask to Buy" flow in the sandbox environment.
 * 
 * @note The simulatesAskToBuyInSandbox property, when set to YES, produces an "Ask to Buy" flow for this payment in the sandbox. This is useful for testing how your app handles transactions that require parental approval. Note that this simulation only works in the sandbox and requires appropriate test account configurations.
 * 
 * @see https://developer.apple.com/documentation/storekit/skpayment/simulatesasktobuyinsandbox?language=objc
 */
void IAP_PurchaseProduct(IAPProduct* product, bool simulateAskToBuy);

 /**
 * Finishes the specified transaction, removing it from the payment queue.
 * 
 * @param transaction The transaction to finish.
 */
void IAP_FinishTransaction(IAPTransaction* transaction);

/**
 * Initiates the restoration of previously completed purchases.
 */
void IAP_RestorePurchases(void);
