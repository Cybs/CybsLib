package cybs.web
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * @author yangweimin
	 * 创建时间：2013-5-3 上午11:13:48
	 * 
	 */
	public class Ajax
	{
		public function Ajax()
		{
		}
		
		/**
		 * 通过 HTTP 请求加载远程数据
		 * @param url
		 * @param data 发送的数据，可以是Object对象，键值对字符串，或JSON字符串
		 * @param onSuccess 返回后的回调函数，参数是解析后的对象实例
		 * @param method 默认是get方式
		 * @param onFail 错误回调函数，参数是Error实例
		 * @param isParseResult 是否对返回的结果进行解析
		 * 
		 */
		public static function ajax(url:String, data:* = null, onSuccess:Function = null, method:String = URLRequestMethod.GET, onFail:Function = null, isParseResult:Boolean = true):void {
			var connection:Connection = new JSONConnection(url);
			connection.call(data, onSuccess, onFail, null, method, isParseResult);
		}
		
		/**
		 * 通过 HTTP加载网络上的图片
		 * @param url
		 * @param onSuccess 加载成功的回调函数，onSuccess(bitmap:Bitmap)
		 * @param onFail 参数onFail(e:Event)
		 * 
		 */
		public static function loadImage(url:String, onSuccess:Function, onFail:Function = null):void {
			if (url == null || onSuccess == null) {
				return;
			}
			function onUrlComplete(e1:Event):void {
				loader.loadBytes(urlLoader.data); //不直接用Loader.load，因为url不是直接指向原始最终地址，中间会重定向，导致安全沙箱错误
			};
			function onUrlIOError(e2:IOErrorEvent):void {
				trace(e2);
				removeAllEvents();
				if (onFail != null) {
					onFail(e2);
				}
			};
			function onUrlSecurityError(e3:SecurityErrorEvent):void {
				trace(e3);
				removeAllEvents();
				if (onFail != null) {
					onFail(e3);
				}
			};
			
			function onComplete(e1:Event):void {
				removeAllEvents();
				onSuccess(loader.content);
			};
			function onIOError(e2:IOErrorEvent):void {
				trace(e2);
				removeAllEvents();
				if (onFail != null) {
					onFail(e2);
				}
			};
			function onSecurityError(e3:SecurityErrorEvent):void {
				trace(e3);
				removeAllEvents();
				if (onFail != null) {
					onFail(e3);
				}
			};
			
			function removeAllEvents():void {
				urlLoader.removeEventListener(Event.COMPLETE, onUrlComplete);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUrlIOError);
				urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlSecurityError);
				
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
			
			function addAllEvents():void {
				urlLoader.addEventListener(Event.COMPLETE, onUrlComplete);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlIOError);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlSecurityError);
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			}
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest(url);
			
			addAllEvents();
			urlLoader.load(request);
		}
	}
}