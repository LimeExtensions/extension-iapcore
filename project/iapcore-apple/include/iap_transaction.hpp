#pragma once

typedef struct IAPTransaction IAPTransaction;

const char* IAP_GetTransactionIdentifier(IAPTransaction* transaction);
const char* IAP_GetTransactionDate(IAPTransaction* transaction);
int IAP_GetTransactionState(IAPTransaction* transaction);
void IAP_ReleaseTransaction(IAPTransaction* transaction);
