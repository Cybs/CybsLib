package cybs.util {
	import flash.utils.ByteArray;

	/**
	 * @author yangweimin
	 * 创建时间：2013-6-5 下午5:13:10
	 *
	 */
	public class StringUtil {
		public function StringUtil() {
		}

		public static function encodeGB2312(str:String, isUri:Boolean = false):String {
			return encodeStr(str, "gb2312", isUri);
		}

		public static function encodeBIG5(str:String, isUri:Boolean = false):String {
			return encodeStr(str, "big5", isUri);
		}

		public static function encodeGBK(str:String, isUri:Boolean = false):String {
			return encodeStr(str, "gbk", isUri);
		}

		private static function encodeStr(str:String, charset:String, isUri:Boolean = false):String {
			var result:String = "";
			var byte:ByteArray = new ByteArray();
			byte.writeMultiByte(str, charset);
			for (var i:int; i < byte.length; i++) {
				if (isUri) {
					result += escape(String.fromCharCode(byte[i]));
				} else {
					result += String.fromCharCode(byte[i]);
				}
			}
			return result;
		}
	}
}
