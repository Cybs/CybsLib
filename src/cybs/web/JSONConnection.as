

package cybs.web {
	import com.adobe.serialization.json.JSON;

	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;

	/**
	 * JSON编码方式的连接类
	 * @author yangweimin
	 *
	 */
	public class JSONConnection extends Connection {
		public function JSONConnection(url:String, isCompressed:Boolean = false) {
			super(url, isCompressed);
			this.dataFormat = URLLoaderDataFormat.TEXT;
		}

		override protected function encodeParameter(params:Object, cookie:String = null):Object {
			trace("传入参数：\n" + params2String(params));
			var variables:URLVariables;
			if (params is String) {
				trace("参数是字符串");
				try {
					trace("尝试解析JSON字符串:" + params);
					var jsonObj:Object = com.adobe.serialization.json.JSON.decode(params as String);
					variables = parseObj2Var(jsonObj);
				} catch (e:Error) { //非JSON格式
					trace("参数是键值字符串");
					variables = new URLVariables(params as String);
				}
			} else {
				trace("参数是对象");
				variables = parseObj2Var(params);
			}
			if (cookie) {
				variables.cookie = cookie;
			}
			return variables;
		}

		private function parseObj2Var(obj:Object):URLVariables {
			var variables:URLVariables = new URLVariables();
			for (var key:String in obj) {

				variables[key] = obj[key];
			}
			return variables;
		}

		private function params2String(params:Object):String {
			if (params is String) {
				return params as String;
			}
			var str:String = "{\n";
			for (var key:String in params) {
				str += key + ":" + params[key] + "\n";
			}
			str += "}";
			return str;
		}

		override protected function decode(data:String):Object {
			if (data.indexOf("{") != 0 && data.lastIndexOf("}") != data.length - 1) {
				return data;
			}
			var obj:Object = com.adobe.serialization.json.JSON.decode(data);
			return obj;
		}
	}
}
