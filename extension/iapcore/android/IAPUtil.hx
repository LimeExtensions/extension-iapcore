package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;

class IAPUtil
{
	public static function getFloatFromLong(longValue:Dynamic):Float
	{
		if (longValue != null)
		{
			final getFloatFromLongJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCoreUtil', 'getFloatFromLong', '(J)D');

			if (getFloatFromLongJNI != null)
				return getFloatFromLongJNI(longValue);
		}

		return 0.0;
	}

	public static function getStringArrayFromList(stringList:Dynamic):Array<String>
	{
		if (stringList != null)
		{
			final getStringArrayFromListJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/IAPCoreUtil', 'getStringArrayFromList',
				'(Ljava/util/List;)[Ljava/lang/String;');

			if (getStringArrayFromListJNI != null)
				return getStringArrayFromListJNI(stringList);
		}

		return [];
	}
}
