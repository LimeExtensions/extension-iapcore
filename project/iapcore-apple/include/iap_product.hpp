#pragma once

#ifdef IAPCORE_INTERNAL
#import <StoreKit/StoreKit.h>

struct IAPProduct
{
    SKProduct* product;
};
#endif

typedef struct IAPProduct IAPProduct;

/**
 * Retrieves the product identifier for a given IAPProduct.
 *
 * @param product The IAPProduct object from which the identifier is fetched.
 * @return The product identifier string if the product is valid, otherwise `nullptr`.
 */
const char* IAP_GetProductIdentifier(IAPProduct* product);

/**
 * Retrieves the localized title for a given IAPProduct.
 *
 * @param product The IAPProduct object from which the title is fetched.
 * @return The localized title string if the product is valid, otherwise `nullptr`.
 */
const char* IAP_GetLocalizedTitle(IAPProduct* product);

/**
 * Retrieves the localized description for a given IAPProduct.
 *
 * @param product The IAPProduct object from which the description is fetched.
 * @return The localized description string if the product is valid, otherwise `nullptr`.
 */
const char* IAP_GetLocalizedDescription(IAPProduct* product);

/**
 * Retrieves the localized price for a given IAPProduct.
 *
 * @param product The IAPProduct object from which the price is fetched.
 * @return The localized price string if the product is valid, otherwise `nullptr`.
 */
const char* IAP_GetLocalizedPrice(IAPProduct* product);

/**
 * Releases an IAPProduct object, freeing up memory and retaining its associated resources.
 *
 * @param product The IAPProduct object to be released.
 */
void IAP_ReleaseProduct(IAPProduct* product);
