#pragma once

typedef struct IAPProduct IAPProduct;

const char* IAP_GetProductIdentifier(IAPProduct* product);
const char* IAP_GetLocalizedTitle(IAPProduct* product);
const char* IAP_GetLocalizedDescription(IAPProduct* product);
const char* IAP_GetLocalizedPrice(IAPProduct* product);
void IAP_ReleaseProduct(IAPProduct* product);
