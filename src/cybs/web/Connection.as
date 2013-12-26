

package cybs.web {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * 连接类的基类，实现了基本的http连接功能，具体的编码和解码方式交给子类实现
	 * @author yangweimin
	 *
	 */
	public class Connection extends EventDispatcher {
		private var callback:Function;
		private var url:String;
		private var errorCallback:Function;
		private var isParseResult:Boolean;
		private static var _gateWay:String;
		protected var isCompressed:Boolean;
		protected var dataFormat:String = URLLoaderDataFormat.TEXT;

		/**
		 * 连接的构造函数
		 * @param url 发送的url
		 * @param isCompressed 是否进行压缩
		 *
		 */
		public function Connection(url:String, isCompressed:Boolean = false) {
			this.url = url;
			this.isCompressed = isCompressed;
		}

		private function loaderHandler(event:Event):void {
			var loader:URLLoader;
			loader = event.target as URLLoader;
			this.removeLoaderHandler(loader);
			loader.close();
			try {
				var obj:Object = this.parseResult(event, loader);
			} catch (error:Error) {
				trace(this + error);
				if (this.errorCallback != null) {
					errorCallback(error);
				} else {
					throw error;
				}
				return;
			}
			if (this.callback != null) {
				this.callback(obj);
			}
			this.callback = null;
			this.errorCallback = null;
			this.url = null;
		}

		private function parseResult(event:Event, loader:URLLoader):Object {
			switch (event.type) {
				case Event.COMPLETE:
					return onComplete(loader);

				case IOErrorEvent.IO_ERROR:
					throw new Error("访问地址[" + url + "]时出错");
					return null;

				case SecurityErrorEvent.SECURITY_ERROR:
					throw new Error("Flash不能跨域访问");
					return null;

				default:
					return null;
			}
		}

		/**
		 * 对返回的数据进行解码，由子类重写决定解码方式
		 * @param data loader的data
		 * @return
		 *
		 */
		protected function decode(data:String):Object {
			throw new IllegalOperationError("抽象方法未被子类重写");
		}

		private function onComplete(loader:URLLoader):Object {
			trace("onComplete data:" + loader.data);
			var obj:Object;
			try {
				trace("isParseResult: " + isParseResult);
				if (isParseResult) {
					obj = this.decode(loader.data);
				} else {
					obj = loader.data;
				}
			} catch (error:Error) {
				throw new Error("解析返回对象发生错误：" + error.message);
				return null;
			}
			dispatchEvent(new ConnectionEvent(ConnectionEvent.ON_COMPLETE, obj));
			return obj;
		}

		/**
		 * 对发送的数据进行编码，由子类重写决定编码方式
		 * @param params
		 * @param cookie
		 * @return
		 *
		 */
		protected function encodeParameter(params:Object, cookie:String = null):Object {
			throw new IllegalOperationError("抽象方法未被子类重写");
		}

		private function addLoaderHandler(loader:URLLoader):void {
			loader.addEventListener(Event.COMPLETE, this.loaderHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.loaderHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderHandler);
		}

		private function removeLoaderHandler(loader:URLLoader):void {
			loader.removeEventListener(Event.COMPLETE, this.loaderHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, this.loaderHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.loaderHandler);
		}

		/**
		 * 向服务器端发起http请求连接
		 * @param params 发送的数据
		 * @param callback 返回后的回调函数，参数是解析后的对象实例
		 * @param errorCallback 错误回调函数，参数是Error实例
		 * @param method 请求方式，默认是get
		 * @param parseResult 是否对返回的结果进行解析
		 */
		final public function call(params:Object = null, callback:Function = null, errorCallback:Function = null, cookie:String = null, method:String = URLRequestMethod.GET, parseResult:Boolean = false):void {
			this.callback = callback;
			this.errorCallback = errorCallback;
			this.isParseResult = parseResult;
			var request:URLRequest = new URLRequest();
			//处理本来已有参数的url
			var index:int = url.indexOf("?");
			request.url = index == -1 ? url : url.substring(0, index);
			trace(request.url);
			var paramsStr:String = index == -1 ? null : url.substr(index + 1);
			trace("请求方式：" + method);
			request.method = method;
//			setHeaders(request);
			if (!params) {
				params = new URLVariables();
			}
			var urlParams:URLVariables = paramsStr ? new URLVariables(paramsStr) : null;
			for (var key:String in urlParams) {
				params[key] = urlParams[key];
			}
			
			request.data = this.encodeParameter(params, cookie);
			trace("发送的数据:" + request.data);
			addTimeStamp(request.data as URLVariables);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = dataFormat;
			this.addLoaderHandler(loader);
			loader.load(request);
		}

		private function addTimeStamp(variables:URLVariables):void {
			if (variables == null) {
				return;
			}
			var t:int = new Date().getTime();
			variables.ts = t.toString();
			trace("addTimeStamp:" + t);
		}

		/**
		 * 设置头信息(这一块很重要，有的不设置头信息就无法正确请求)
		 * @param request
		 *
		 */
		private function setHeaders(request:URLRequest):void {
			//设置头信息
			var accept:URLRequestHeader = new URLRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
			var acceptLanguage:URLRequestHeader = new URLRequestHeader("Accept-Language", "zh-cn,zh;q=0.5");
			var contentType:URLRequestHeader = new URLRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			request.requestHeaders.push(accept, acceptLanguage, contentType);
		}

	}
}
