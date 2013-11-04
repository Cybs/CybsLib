package cybs.util {
	import flash.net.URLVariables;
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

		/**
		 * 获取url中的参数
		 * @param url
		 * @return
		 *
		 */
		public static function getUrlVariables(url:String):URLVariables {
			var index:int = url.indexOf("?");
			if (index == -1) {
				return null;
			}
			var params:String = url.substr(index + 1);
			var v:URLVariables = new URLVariables(params);
			return v;
		}

		/**
		 * 获取字符串真实长度（中文2，英文数字1）
		 * @param str
		 * @return
		 *
		 */
		public static function getStrSize(str:String):int {
			var realLength:int = 0, len:int = str.length, charCode:int = -1;
			for (var i:int = 0; i < len; i++) {
				charCode = str.charCodeAt(i);
				if (charCode >= 0 && charCode <= 128) {
					realLength += 1;
				} else {
					realLength += 2;
				}
			}
			return realLength;
		}

		/**
		 * 将超过指定长度字符串截断并且用字符代替截断部分
		 * @param str
		 * @param maxLen 最大长度（中文2，英文数字1）
		 * @param replace 替代字符，默认是"..."
		 * @return
		 *
		 */
		public static function cutStr(str:String, maxLen:int, replace:String = "..."):String {
			if (getStrSize(str) <= maxLen) {
				return str;
			}
			while (getStrSize(str + replace) > maxLen && str.length > 1) {
				str = str.slice(0, str.length - 2); //删除最后一个字符
			}
			if (str.length > 1) {
				return str + replace;
			}
			return str;
		}
	}
}
