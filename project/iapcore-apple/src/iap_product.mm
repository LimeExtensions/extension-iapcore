#import "iap_product.hpp"

#import <StoreKit/StoreKit.h>

struct IAPProduct
{
	SKProduct* product;
};

const char* IAP_GetProductIdentifier(IAPProduct* product)
{
	return product ? [product->product.productIdentifier UTF8String] : nullptr;
}

const char* IAP_GetLocalizedTitle(IAPProduct* product)
{
	return product ? [product->product.localizedTitle UTF8String] : nullptr;
}

const char* IAP_GetLocalizedDescription(IAPProduct* product)
{
	return product ? [product->product.localizedDescription UTF8String] : nullptr;
}

const char* IAP_GetLocalizedPrice(IAPProduct* product)
{
	if (product)
	{
		NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
		formatter.numberStyle = NSNumberFormatterCurrencyStyle;
		formatter.locale = product->product.priceLocale;
		return [[formatter stringFromNumber:product->product.price] UTF8String];
	}

	return nullptr;
}

void IAP_ReleaseProduct(IAPProduct* product)
{
	if (product)
	{
#if !__has_feature(objc_arc)
		[product->product release];
#endif

		delete product;
	}
}
