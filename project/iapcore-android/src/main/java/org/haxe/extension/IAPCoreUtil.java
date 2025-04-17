package org.haxe.extension;

import java.util.List;

public class IAPCoreUtil
{
	public static double getFloatFromLong(long longValue)
	{
		return (double) longValue;
	}

	public static String[] getStringArrayFromList(List<String> stringList)
	{
		return stringList != null ? stringList.toArray(new String[0]) : new String[0];
	}
}
