package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;
import lime.system.JNI;

/**
 * Params containing the response code and the debug message from In-app Billing API response.
 * 
 * @see https://developer.android.com/reference/com/android/billingclient/api/BillingResult
 */
class IAPResult
{
	@:allow(extension.iapcore.android.IAPAndroid)
	private var handle:Dynamic;

	@:allow(extension.iapcore.android.IAPAndroid)
	private function new(handle:Dynamic):Void
	{
		this.handle = handle;
	}

	/** Debug message returned in In-app Billing API calls. */
	public function getDebugMessage():String
	{
		if (handle != null)
		{
			final getDebugMessageMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/BillingResult', 'getDebugMessage',
				'()Ljava/lang/String;');

			if (getDebugMessageMemberJNI != null)
			{
				final debugMessage:Null<Dynamic> = JNI.callMember(getDebugMessageMemberJNI, handle, []);

				if (debugMessage != null)
					return debugMessage;
			}
		}

		return '';
	}

	/** Response code returned in In-app Billing API calls. */
	public function getResponseCode():IAPResponseCode
	{
		if (handle != null)
		{
			final getResponseCodeMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/BillingResult', 'getResponseCode', '()I');

			if (getResponseCodeMemberJNI != null)
			{
				final responseCode:Null<Dynamic> = JNI.callMember(getResponseCodeMemberJNI, handle, []);

				if (responseCode != null)
					return responseCode;
			}
		}

		return IAPResponseCode.DEVELOPER_ERROR;
	}

	/** Returns the string representation of the result object. */
	@:keep
	public function toString():String
	{
		if (handle != null)
		{
			final toStringMemberJNI:Null<Dynamic> = JNICache.createMemberMethod('com/android/billingclient/api/BillingResult', 'toString',
				'()Ljava/lang/String;');

			if (toStringMemberJNI != null)
			{
				final resultString:Null<Dynamic> = JNI.callMember(toStringMemberJNI, handle, []);

				if (resultString != null)
					return resultString;
			}
		}

		return 'Response Code: DEVELOPER_ERROR, Debug Message: ';
	}
}
