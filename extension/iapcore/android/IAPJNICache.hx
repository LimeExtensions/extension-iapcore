package extension.iapcore.android;

#if android
import lime.system.JNI;

/**
 * A utility class for caching JNI method and field references.
 */
class IAPJNICache
{
	@:noCompletion
	private static var staticMethodCache:Map<String, Dynamic> = [];

	@:noCompletion
	private static var memberMethodCache:Map<String, Dynamic> = [];

	/**
	 * Retrieves or creates a cached static method reference.
	 * 
	 * @param className The name of the Java class containing the method.
	 * @param methodName The name of the method.
	 * @param signature The method signature in JNI format.
	 * @param cache Whether to cache the result (default true).
	 * @return A dynamic reference to the static method.
	 */
	public static function createStaticMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		@:privateAccess
		className = JNI.transformClassName(className);

		final key:String = '$className::$methodName::$signature';

		if (cache && !staticMethodCache.exists(key))
			staticMethodCache.set(key, JNI.createStaticMethod(className, methodName, signature));
		else if (!cache)
			return JNI.createStaticMethod(className, methodName, signature);

		return staticMethodCache.get(key);
	}

	/**
	 * Retrieves or creates a cached member method reference.
	 * 
	 * @param className The name of the Java class containing the method.
	 * @param methodName The name of the method.
	 * @param signature The method signature in JNI format.
	 * @param cache Whether to cache the result (default true).
	 * @return A dynamic reference to the member method.
	 */
	public static function createMemberMethod(className:String, methodName:String, signature:String, cache:Bool = true):Null<Dynamic>
	{
		@:privateAccess
		className = JNI.transformClassName(className);

		final key:String = '$className::$methodName::$signature';

		if (cache && !memberMethodCache.exists(key))
			memberMethodCache.set(key, JNI.createMemberMethod(className, methodName, signature));
		else if (!cache)
			return JNI.createMemberMethod(className, methodName, signature);

		return memberMethodCache.get(key);
	}
}
#end
