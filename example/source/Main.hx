package;

#if android
import extension.iapcore.android.IAPAndroid;
import extension.iapcore.android.IAPProductDetails;
import extension.iapcore.android.IAPPurchase;
import extension.iapcore.android.IAPPurchaseState;
import extension.iapcore.android.IAPResponseCode;
import extension.iapcore.android.IAPResult;
import android.widget.Toast;
#end

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		#if android
		IAPAndroid.onLog.add(function(message:String):Void
		{
			logMessage(message);
		});

		IAPAndroid.onBillingSetupFinished.add(function(result:IAPResult):Void
		{
			logMessage('Billing setup finished "$result"!');

			if (result.getResponseCode() == IAPResponseCode.OK)
			{
				IAPAndroid.queryPurchases();
				IAPAndroid.queryProductDetails(['test_product_1']);
			}
		});

		IAPAndroid.onBillingServiceDisconnected.add(function():Void
		{
			logMessage('Billing service disconnected!');
		});

		IAPAndroid.onProductDetailsResponse.add(function(result:IAPResult, productDetails:Array<IAPProductDetails>):Void
		{
			logMessage('Product details response "$result", $productDetails');
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
						logMessage('Already acknowledged: ${purchase.getPurchaseToken()}');
				}
				else
					logMessage('Purchase not completed: ${purchase.getPurchaseState()}');
			}
		}

		IAPAndroid.onQueryPurchasesResponse.add(function(result:IAPResult, purchases:Array<IAPPurchase>):Void
		{
			logMessage('Query purchases response "$result", $purchases');

			if (result.getResponseCode() == IAPResponseCode.OK)
				handlePurchases(purchases);
		});

		IAPAndroid.onPurchasesUpdated.add(function(result:IAPResult, purchases:Array<IAPPurchase>):Void
		{
			logMessage('Purchases updated response "$result", $purchases');

			if (result.getResponseCode() == IAPResponseCode.OK)
				handlePurchases(purchases);
		});

		IAPAndroid.onAcknowledgePurchaseResponse.add(function(result:IAPResult):Void
		{
			if (result.getResponseCode() == IAPResponseCode.OK)
				logMessage('Purchase acknowledged successfully!');
			else
				logMessage('Failed to acknowledge purchase: $result');
		});
		#elseif (ios || tvos)
		IAPApple.onProductDetailsReceived.add(function(products:Array<IAPProductDetails>):Void
		{
			if (products.length > 0)
			{
				logMessage('Product received: ${products[0].getLocalizedTitle()}');

				IAPApple.purchaseProduct(products[0]);
			}
		});
		IAPApple.onPurchasesUpdated.add(function(purchases:Array<IAPPurchase>):Void
		{
			for (purchase in purchases)
			{
				logMessage('Transaction ID: ${purchase.getTransactionIdentifier()}');
				logMessage('Transaction Date: ${purchase.getTransactionDate()}');
				logMessage('Transaction Payment Product ID: ${purchase.getPaymentProductIdentifier()}');

				switch (purchase.getTransactionState())
				{
					case IAPPurchaseState.PURCHASING:
						logMessage('Purchase is in progress.');
					case IAPPurchaseState.PURCHASED:
						logMessage('Purchase successful!');

						IAPApple.finishPurchase(purchase);
					case IAPPurchaseState.FAILED:
						logMessage('Purchase failed.');
					case IAPPurchaseState.RESTORED:
						logMessage('Purchase restored.');

						IAPApple.finishPurchase(purchase);
					case IAPPurchaseState.DEFERRED:
						logMessage('Purchase is deferred.');
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
		#elseif (ios || tvos)
		IAPApple.init();

		IAPApple.requestProducts(['com.example.app.product1', 'com.example.app.product2']);
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

	private static function logMessage(message:String):Void
	{
		#if android
		Toast.makeText(message, Toast.LENGTH_SHORT);
		#end

		Sys.println(message);
	}
}
