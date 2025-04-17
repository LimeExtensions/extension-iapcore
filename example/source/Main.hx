package;

#if android
import android.widget.Toast;
#end
import extension.iapcore.android.IAPAndroid;
import extension.iapcore.android.IAPProductDetails;
import extension.iapcore.android.IAPPurchase;
import extension.iapcore.android.IAPResponseCode;

class Main extends lime.app.Application
{
	public function new():Void
	{
		super();

		IAPAndroid.onLog.add(function(message:String):Void
		{
			logMessage(message);
		});

		IAPAndroid.onBillingSetupFinished.add(function(code:IAPResponseCode, message:String):Void
		{
			if (message != null && message.length > 0)
				logMessage('Setup finished with code "$code" "$message"!');
			else
				logMessage('Setup finished with code "$code"!');

			if (code == IAPResponseCode.OK)
			{
				IAPAndroid.queryPurchases();
				IAPAndroid.queryProductDetails(['test_product_1']);
			}
		});

		IAPAndroid.onBillingServiceDisconnected.add(function():Void
		{
			logMessage("Billing service disconnected!");
		});

		IAPAndroid.onProductDetailsResponse.add(function(code:IAPResponseCode, productDetails:Array<IAPProductDetails>):Void
		{
			logMessage('Product details responded with code "$code", $productDetails');
		});

		IAPAndroid.onQueryPurchasesResponse.add(function(code:IAPResponseCode, purchases:Array<IAPPurchase>):Void
		{
			logMessage('Query purchases responded with code "$code", $purchases');
		});

		IAPAndroid.onPurchasesUpdated.add(function(code:IAPResponseCode, purchases:Array<IAPPurchase>):Void
		{
			logMessage('Purchases updated response with code "$code", $purchases');
		});
	}

	public override function onWindowCreate():Void
	{
		IAPAndroid.init();
		IAPAndroid.startConnection();
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
