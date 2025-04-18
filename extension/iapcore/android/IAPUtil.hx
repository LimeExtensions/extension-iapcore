package extension.iapcore.android;

import extension.iapcore.android.util.JNICache;

/**
 * A utility class for handling JNI operations related to in-app purchases.
 */
class IAPUtil
{
	/**
	 * Converts a Java long value to a Haxe Float.
	 * 
	 * @param longValue The Java long value to convert.
	 * @return The converted Float value, or 0.0 if the input is null or the JNI method is not found.
	 */
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

	/**
	 * Converts a Java List of Strings to a Haxe Array of Strings.
	 * 
	 * @param stringList The Java List to convert.
	 * @return An Array of Strings, or an empty array if the input is null or the JNI method is not found.
	 */
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
