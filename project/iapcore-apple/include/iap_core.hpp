#pragma once

#include "iap_product.hpp"
#include "iap_transaction.hpp"

typedef void (*OnProductsReceived)(IAPProduct** products, int count);
typedef void (*OnTransactionsUpdated)(IAPTransaction** transactions, int count);

void IAP_Init(OnProductsReceived onProductsReceived, OnTransactionsUpdated onTransactionsUpdated);
void IAP_RequestProducts(const char** productIdentifiers, int count);
void IAP_PurchaseProduct(IAPProduct* product);
void IAP_RestorePurchases(void);
