package org.haxe.extension;

import com.android.billingclient.api.AcknowledgePurchaseResponseListener;
import com.android.billingclient.api.AcknowledgePurchaseParams;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.PendingPurchasesParams;
import com.android.billingclient.api.ProductDetailsResponseListener;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.PurchasesResponseListener;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.android.billingclient.api.QueryPurchasesParams;
import java.util.ArrayList;
import java.util.List;
import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

/**
 * The IAPCore class provides functionality for integrating in-app purchases using the Google Play Billing Library.
 * 
 * It includes methods for initializing the billing client, starting the connection, and querying product details for in-app products.
 * 
 * @see https://developer.android.com/google/play/billing/integrate
 */
public class IAPCore extends Extension
{
	private static HaxeObject haxeObject = null;
	private static BillingClient billingClient = null;

	public static void init(HaxeObject object)
	{
		haxeObject = object;

		try
		{
			PurchasesUpdatedListener purchasesUpdatedListener = new PurchasesUpdatedListener()
			{
				@Override
				public void onPurchasesUpdated(BillingResult billingResult, List<Purchase> purchases)
				{
					if (haxeObject != null)
						haxeObject.call2("onPurchasesUpdated", billingResult, purchases != null ? purchases.toArray(new Purchase[0]) : new Purchase[0]);
				}
			};

			billingClient = BillingClient.newBuilder(mainContext)
					.enablePendingPurchases(PendingPurchasesParams.newBuilder().enableOneTimeProducts().build())
					.setListener(purchasesUpdatedListener)
					.build();
		}
		catch (Exception e)
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", e.getMessage());
		}
	}

	public static void startConnection()
	{
		if (billingClient == null)
			return;

		billingClient.startConnection(new BillingClientStateListener()
		{
			@Override
			public void onBillingSetupFinished(BillingResult billingResult)
			{
				if (haxeObject != null)
					haxeObject.call1("onBillingSetupFinished", billingResult);
			}

			@Override
			public void onBillingServiceDisconnected()
			{
				if (haxeObject != null)
					haxeObject.call0("onBillingServiceDisconnected");
			}
		});
	}

	public static int getConnectionState()
	{
		if (billingClient == null)
			return BillingClient.ConnectionState.DISCONNECTED;

		return billingClient.getConnectionState();
	}

	public static void endConnection()
	{
		if (billingClient != null && billingClient.isReady())
			billingClient.endConnection();
	}

	public static void queryProductDetails(final String[] productIds)
	{
		if (billingClient == null || !billingClient.isReady())
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", "Connection isnt ready or initialized!");

			return;
		}

		List<QueryProductDetailsParams.Product> productList = new ArrayList<>();

		for (String productId : productIds)
			productList.add(QueryProductDetailsParams.Product.newBuilder().setProductId(productId).setProductType(BillingClient.ProductType.INAPP).build());

		billingClient.queryProductDetailsAsync(QueryProductDetailsParams.newBuilder().setProductList(productList).build(), new ProductDetailsResponseListener()
		{
			@Override
			public void onProductDetailsResponse(BillingResult billingResult, List<ProductDetails> productDetailsList)
			{
				if (haxeObject != null)
					haxeObject.call2("onProductDetailsResponse", billingResult, productDetailsList != null ? productDetailsList.toArray(new ProductDetails[0]) : new ProductDetails[0]);
			}
		});
	}

	public static void queryPurchases()
	{
		if (billingClient == null || !billingClient.isReady())
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", "Connection isn't ready or initialized!");

			return;
		}

		billingClient.queryPurchasesAsync(QueryPurchasesParams.newBuilder().setProductType(BillingClient.ProductType.INAPP).build(), new PurchasesResponseListener()
		{
			@Override
			public void onQueryPurchasesResponse(BillingResult billingResult, List<Purchase> purchases)
			{
				if (haxeObject != null)
					haxeObject.call2("onQueryPurchasesResponse", billingResult, purchases != null ? purchases.toArray(new Purchase[0]) : new Purchase[0]);
			}
		});
	}

	public static BillingResult launchPurchaseFlow(final ProductDetails productDetails, final boolean isOfferPersonalized)
	{
		if (billingClient == null || !billingClient.isReady())
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", "Connection isnt ready or initialized!");

			return BillingResult.newBuilder().setResponseCode(BillingClient.BillingResponseCode.DEVELOPER_ERROR).build();
		}

		BillingFlowParams billingFlowParams = BillingFlowParams.newBuilder()
				.setIsOfferPersonalized(isOfferPersonalized)
				.setProductDetailsParamsList(List.of(BillingFlowParams.ProductDetailsParams.newBuilder().setProductDetails(productDetails).build()))
				.build();

		return billingClient.launchBillingFlow(mainActivity, billingFlowParams);
	}

	public static void consumePurchase(final String purchaseToken)
	{
		if (billingClient == null || !billingClient.isReady())
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", "Connection isn't ready or initialized!");

			return;
		}

		billingClient.consumeAsync(ConsumeParams.newBuilder().setPurchaseToken(purchaseToken).build(), new ConsumeResponseListener()
		{
			@Override
			public void onConsumeResponse(BillingResult billingResult, String purchaseToken)
			{
				if (haxeObject != null)
					haxeObject.call2("onConsumeResponse", billingResult, purchaseToken);
			}
		});
	}

	public static void acknowledgePurchase(final String purchaseToken)
	{
		if (billingClient == null || !billingClient.isReady())
		{
			if (haxeObject != null)
				haxeObject.call1("onLog", "Connection isn't ready or initialized!");

			return;
		}

		billingClient.acknowledgePurchase(AcknowledgePurchaseParams.newBuilder().setPurchaseToken(purchaseToken).build(), new AcknowledgePurchaseResponseListener()
		{
			@Override
			public void onAcknowledgePurchaseResponse(BillingResult billingResult)
			{
				if (haxeObject != null)
					haxeObject.call1("onAcknowledgePurchaseResponse", billingResult);
			}
		});
	}

	@Override
	public void onDestroy()
	{
		if (billingClient != null)
		{
			if (billingClient.isReady())
				billingClient.endConnection();

			billingClient = null;
		}

		super.onDestroy();
	}
}
