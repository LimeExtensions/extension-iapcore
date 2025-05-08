package;

#if android
import extension.iapcore.android.IAPAndroid;
import extension.iapcore.android.IAPProductDetails;
import extension.iapcore.android.IAPPurchase;
import extension.iapcore.android.IAPPurchaseState;
import extension.iapcore.android.IAPResponseCode;
import extension.iapcore.android.IAPResult;
#elseif ios
import extension.iapcore.ios.IAPError;
import extension.iapcore.ios.IAPIOS;
import extension.iapcore.ios.IAPProductDetails;
import extension.iapcore.ios.IAPPurchase;
import extension.iapcore.ios.IAPPurchaseState;
#end

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		#if android
		IAPAndroid.onLog.add(function(message:String):Void
		{
			trace(message);
		});

		IAPAndroid.onBillingSetupFinished.add(function(result:IAPResult):Void
		{
			trace('Billing setup finished "$result"!');

			if (result.getResponseCode() == IAPResponseCode.OK)
			{
				IAPAndroid.queryPurchases();
				IAPAndroid.queryProductDetails(['test_product_1']);
			}
		});

		IAPAndroid.onBillingServiceDisconnected.add(function():Void
		{
			trace('Billing service disconnected!');
		});

		IAPAndroid.onProductDetailsResponse.add(function(result:IAPResult, productDetails:Array<IAPProductDetails>):Void
		{
			trace('Product details response "$result", $productDetails.');
		});

		function handlePurchases(purchases:Array<IAPPurchase>):Void
		{
			for (purchase in purchases)
			{
				if (purchase.getPurchaseState() == IAPPurchaseState.PURCHASED)
				{
					if (!purchase.isAcknowledged())
						IAPAndroid.acknowledgePurchase(purchase.getPurchaseToken());
					else
						trace('Already acknowledged: ${purchase.getPurchaseToken()}.');
				}
				else
					trace('Purchase not completed: ${purchase.getPurchaseState()}.');
			}
		}

		IAPAndroid.onQueryPurchasesResponse.add(function(result:IAPResult, purchases:Array<IAPPurchase>):Void
		{
			trace('Query purchases response "$result", $purchases.');

			if (result.getResponseCode() == IAPResponseCode.OK)
				handlePurchases(purchases);
		});

		IAPAndroid.onPurchasesUpdated.add(function(result:IAPResult, purchases:Array<IAPPurchase>):Void
		{
			trace('Purchases updated response "$result", $purchases.');

			if (result.getResponseCode() == IAPResponseCode.OK)
				handlePurchases(purchases);
		});

		IAPAndroid.onAcknowledgePurchaseResponse.add(function(result:IAPResult):Void
		{
			if (result.getResponseCode() == IAPResponseCode.OK)
				trace('Purchase acknowledged successfully!');
			else
				trace('Failed to acknowledge purchase: $result.');
		});
		#elseif ios
		IAPIOS.onProductDetailsReceived.add(function(products:Array<IAPProductDetails>):Void
		{
			if (products.length > 0)
			{
				trace('Product received: ${products[0].getLocalizedTitle()}.');

				IAPIOS.purchaseProduct(products[0]);
			}
		});

		IAPIOS.onProductDetailsFailed.add(function(error:IAPError):Void
		{
			trace('Product details error: $error.');
		});

		IAPIOS.onPurchasesUpdated.add(function(purchases:Array<IAPPurchase>):Void
		{
			for (purchase in purchases)
			{
				trace('Transaction ID: ${purchase.getTransactionIdentifier()}.');
				trace('Transaction Date: ${purchase.getTransactionDate()}.');
				trace('Transaction Payment Product ID: ${purchase.getPaymentProductIdentifier()}.');

				switch (purchase.getTransactionState())
				{
					case IAPPurchaseState.PURCHASING:
						trace('Purchase is in progress.');
					case IAPPurchaseState.PURCHASED:
						trace('Purchase successful!');

						IAPIOS.finishPurchase(purchase);
					case IAPPurchaseState.FAILED:
						trace('Purchase failed: ${purchase.getTransactionError()}.');
					case IAPPurchaseState.RESTORED:
						trace('Purchase restored.');

						IAPIOS.finishPurchase(purchase);
					case IAPPurchaseState.DEFERRED:
						trace('Purchase is deferred.');
				}
			}
		});
		#end
	}

	public override function onWindowCreate():Void
	{
		#if android
		IAPAndroid.init();

		IAPAndroid.startConnection();
		#elseif ios
		IAPIOS.init();

		IAPIOS.requestProducts(['com.example.app.product1', 'com.example.app.product2']);
		#end
	}

	public override function render(context:lime.graphics.RenderContext):Void
	{
		switch (context.type)
		{
			case CAIRO:
				context.cairo.setSourceRGB(0.75, 1, 0);
				context.cairo.paint();
			case CANVAS:
				context.canvas2D.fillStyle = '#BFFF00';
				context.canvas2D.fillRect(0, 0, window.width, window.height);
			case DOM:
				context.dom.style.backgroundColor = '#BFFF00';
			case FLASH:
				context.flash.graphics.beginFill(0xBFFF00);
				context.flash.graphics.drawRect(0, 0, window.width, window.height);
			case OPENGL | OPENGLES | WEBGL:
				context.webgl.clearColor(0.75, 1, 0, 1);
				context.webgl.clear(context.webgl.COLOR_BUFFER_BIT);
			default:
		}
	}
}
